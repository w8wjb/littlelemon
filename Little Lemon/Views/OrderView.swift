//
//  Cart.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import SwiftUI

struct OrderView: View {
    
    @EnvironmentObject var orderModel: OrderModel
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var nav: NavigationStateManager
    
    @State var selectedLineItems = Set<LineItem>()
    
    @State var editMode: EditMode = .inactive
    
    @State var isThankYouPresented = false
    
    @FetchRequest(
        entity: LineItem.entity(),
        sortDescriptors: [],
        animation: .default)
    private var lineItems: FetchedResults<LineItem>
    
    var body: some View {
        
        VStack {
            
            List {
                ForEach(lineItems, id: \.self) { lineItem in
                    OrderLineItem(lineItem: lineItem)
                }
                .onDelete { indexes in
                    
                    for index in indexes {
                        let item = lineItems[index]
                        viewContext.delete(item)
                    }
                }
                
            }
            .toolbar { EditButton() }
            .overlay(Group {
                if lineItems.isEmpty {
                    Text("There are no items in your cart yet")
                }
            })
            .environment(\.editMode, $editMode)
            
            
            HStack {
                Text("Total:")
                Text(lineItems.map({ $0.toDish!.price * Double($0.quantity) }).reduce(0, +), format: .currency(code: "USD"))
                
            }.font(.subTitle)
            
            Button {
                lineItems.forEach { viewContext.delete($0) }
                isThankYouPresented.toggle()
                
            } label: {
                Text("Submit Order")
            }
            .buttonStyle(.borderedProminent)
            .alert(isPresented: $isThankYouPresented) {
                Alert(title: Text("Order Submitted"),
                      message: Text("Thank you for your business"),
                      dismissButton: .cancel(Text("Okay"), action: {
                    nav.popToRoot()
                }))
            }
            
            
            
        }.padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.white, for: .navigationBar)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Image("Logo")
                    }
                }
            })
    }
}

#Preview {
    OrderView()
}
