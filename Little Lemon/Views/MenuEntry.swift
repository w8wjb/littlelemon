//
//  MenuEntry.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import SwiftUI

struct MenuEntry: View {

    var dish: DishProtocol
    
    var body: some View {
                
        NavigationLink {
            DishDetail(dish: dish)
                .padding(.top)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.white, for: .navigationBar)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Image("Logo")
                        }
                    }

                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: Cart()) {
                            Image(systemName: "cart.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .mask(Circle())
                                .padding()
                        }
                    }
                    
                    
                })

        } label: {
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(dish.title ?? "")
                        .font(.cardTitle)
                    if let desc = dish.desc {
                        Text(desc)
                            .font(.paragraphText)
                            .foregroundColor(.highlightDark)
                    }
                    
                    Text(dish.price.formatted(.currency(code: "USD")))
                        .font(.highlightText)
                        .foregroundColor(.primary1)
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
}

#Preview {
    MenuEntry(dish: PreviewDish(title: "Greek Salad",
                                image: "https://www.w8wjb.com/littlelemon/images/food-greek-salad.jpg",
                                price: 10.0,
                                desc: "Crisp cucumbers, juicy tomatoes, tangy olives, and creamy feta cheese, all dressed in a zesty vinaigrette.",
                                category: "starters"))
}
