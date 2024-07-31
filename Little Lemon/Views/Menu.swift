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
    
    @State var showSections: Set<MenuCategory> = Set(MenuCategory.allCases)
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                
                
                Header()
                    .padding([.bottom])
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Little Lemon")
                        .font(.displayTitle)
                        .foregroundColor(.primary2)
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Grand Rapids")
                                .font(.subTitle)
                                .foregroundColor(.white)

                            
                            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.leadText)
                                .foregroundColor(.white)
                        }
                        
                        Image("Hero image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding()
                    }
                    
                    TextField("Search", text: $searchText)
                        .padding([.leading, .trailing], 16)
                        .padding([.top, .bottom], 8)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding([.bottom, .trailing])
                        
                }
                .padding([.leading])
                .background(Color.primary1)
                
                HStack {
                    Text("ORDER FOR DELIVERY!")
                        .font(.sectionTitle)
                    Image("Delivery van")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                }.padding()
                
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
                    
                }.padding([.leading])
                
                FetchedObjects(predicate: buildFilterPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List {
                        ForEach(dishes, id: \.id) { dish in
                            HStack(alignment: .top) {
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dish.title ?? "")
                                    if let desc = dish.desc {
                                        Text(desc)
                                            .font(.paragraphText)
                                            .foregroundColor(.highlightDark)
                                    }
                                    
//                                    Spacer()
                                    
                                    Text(dish.price.formatted(.currency(code: "USD")))
                                }
                                
                                Spacer()
                                
                                AsyncCachedImage(url: URL(string: dish.image ?? "")) { image in
                                    image.resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.top, 8)
            }
            
            
            
        }.onAppear() {
            
            // For some reason, loading the data crashes my XCode preview. Works fine in Simulator
            guard !isRunningInPreview else { return }
            
            Task {
                do {
                    try await getMenuData()
                } catch {
                    os_log(.error, "Failed to load menu items: %@", error.localizedDescription)
                }
            }
        }
    }
    
    func buildFilterPredicate() -> NSPredicate {
        
        let categories = showSections.map { $0.rawValue }
        let categoriesPredicate = NSPredicate(format: "category in %@", categories)
        
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
    
    func getMenuData() async throws {
        
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
            
            let newDish = Dish(context: viewContext)
            newDish.title = menuItem.title
            newDish.price = menuItem.price
            newDish.desc = menuItem.desc
            newDish.category = menuItem.category
            newDish.image = menuItem.image
            
        }
        
        try viewContext.save()
        os_log(.debug, "Loaded %d menu items", menuItems.count)
        
    }
    
}

#Preview {
    Menu()
}
