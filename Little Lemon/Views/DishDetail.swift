//
//  DishDetail.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import SwiftUI
import os

struct DishDetail: View {
    
    let dish: Dish
    
    @EnvironmentObject var orderModel: OrderModel
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject private var nav: NavigationStateManager
    
    @State var desiredQuantity = 1
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                AsyncCachedImage(url: URL(string: dish.image ?? "")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .aspectRatio(contentMode: .fit)
                    
                }
                
                Text(dish.title ?? "")
                    .font(.subTitle)
                    .foregroundColor(.primary2)
                    .frame(maxWidth: .infinity)
                    .background(.primary1)
                
                if let desc = dish.desc {
                    Text(desc)
                        .font(.paragraphText)
                        .foregroundColor(.highlightDark)
                        .padding()
                }
                
                Text(dish.price.formatted(.currency(code: "USD")))
                    .font(.sectionTitle)
                    .foregroundColor(.primary1)
                    .padding()
                
                Spacer()
                
                
                HStack {
                    
                    Stepper("", value: $desiredQuantity).onChange(of: desiredQuantity) { oldValue, newValue in
                        if newValue < 1 {
                            desiredQuantity = 1
                        }
                    }.fixedSize()
                    
                    Text(desiredQuantity, format: .number)
                        .font(.subTitle).bold()
                        .frame(width: 20)
                        .padding()
                    
                    Button("Add to Cart") {
                        
                        do {
                            try orderModel.addDish(dish, quantity: desiredQuantity, inContext: viewContext)
                            nav.switchToOrder()
                            
                        } catch {
                            os_log(.error, "Failed to add add dish to order: %@", error.localizedDescription)
                        }
                        
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .layoutPriority(1)
                    
                    
                }.frame(maxWidth: .infinity)
                
            } .padding(.top)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.white, for: .navigationBar)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Image("Logo")
                        }
                    }
                    
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(value: NavDestination.order) {
                            Image(systemName: "cart.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .mask(Circle())
                                .padding()
                        }
                    }
                    
                    
                })
        }
    }
}
//
//#Preview {
//    DishDetail(dish: PreviewDish(title: "Greek Salad",
//                                 image: "https://www.w8wjb.com/littlelemon/images/food-greek-salad.jpg",
//                                 price: 10.0,
//                                 desc: "Crisp cucumbers, juicy tomatoes, tangy olives, and creamy feta cheese, all dressed in a zesty vinaigrette.",
//                                 category: "starters"))
//}
