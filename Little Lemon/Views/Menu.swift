//
//  Menu.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI
import os

struct Menu: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var searchText: String = ""
    @State private var showCancelButton: Bool = false
    
    @State var showSections: Set<MenuCategory> = Set(MenuCategory.allCases)
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Hero()
                .padding(.top)
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("ORDER FOR DELIVERY!")
                        .font(.sectionTitle)
                    Image("Delivery van")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("search", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        print("onCommit")
                    }).foregroundColor(.primary)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 8)
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                
                HStack {
                    
                    ForEach(MenuCategory.allCases, id: \.id) { category in
                        
                        Toggle(isOn: Binding(get: { self.showSections.contains(category) },
                                             set: { on in
                            if on {showSections.insert(category)}
                            else {showSections.remove(category)} }))
                        {
                            Text(category.description).font(.sectionCategory)
                        }.toggleStyle(.button)
                        
                    }
                    
                }
            }
            .padding()
            
            List {
                
                ForEach(MenuCategory.allCases, id: \.id) { category in
                    
                    if showSections.contains(category) {
                        
                        Section {
                            FetchedObjects(
                                predicate: buildFilterPredicate(category: category),
                                sortDescriptors: buildSortDescriptors())
                            { (dishes: [Dish]) in
                                ForEach(dishes, id: \.id) { dish in
                                    MenuEntry(dish: dish)
                                }
                            }
                        } header: {
                            HStack {
                                Text(category.description)
                                    .font(.subTitle)
                                    .foregroundColor(.secondary1)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
                        }
                        
                        
                    }
                }
                
            }
            .listStyle(.plain)
            
            
        }.onAppear() {
            
            // For some reason, asynchronously loading the data crashes my XCode preview. Works fine in Simulator
            guard !isRunningInPreview else { return }
            
            Task {
                do {
                    try await loadRemoteMenuData()
                } catch {
                    os_log(.error, "Failed to load menu items: %@", error.localizedDescription)
                }
            }
        }
    }
    
    func buildFilterPredicate(category: MenuCategory) -> NSPredicate {
        
        let categoriesPredicate = NSPredicate(format: "category == %@", category.rawValue)
        
        if searchText.isEmpty {
            return categoriesPredicate
        }
        
        return NSCompoundPredicate(type: .and, subpredicates: [
            categoriesPredicate,
            NSPredicate(format: "title CONTAINS[cd] %@ or desc CONTAINS[cd] %@", searchText, searchText)
        ])
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare))
        ]
    }
    
    func loadRemoteMenuData() async throws {
        
        let request = URLRequest(url: MenuItem.sourceURL)
        
        // No need to keep re-loading the menu contents every time the view is displayed, so we check if there are Dishes in the database already
        // A more robust implementation might keep track of a timestamp and check for updates after a certain time period.
        // The rationale is that restaurants do change their menus, but it would be unusual for them to do it more than once a day
        guard try Dish.countAll(inContext: viewContext) == 0 else {
            return
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let menuItems = try JSONDecoder().decode(Array<MenuItem>.self, from: data)
        
        os_log(.debug, "Loading menu items")
        
        try Dish.removeAll(inContext: viewContext)
        
        for menuItem in menuItems {
            let _ = menuItem.createDish(inContext: viewContext)
        }
        
        try viewContext.save()
        os_log(.debug, "Loaded %d menu items", menuItems.count)
        
    }
    
    
}

#Preview {
    Menu()
}
