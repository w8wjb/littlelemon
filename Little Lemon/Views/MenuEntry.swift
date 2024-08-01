//
//  MenuEntry.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import SwiftUI

struct MenuEntry: View {

    var dish: Dish
    
    var body: some View {
                
        NavigationLink(value: NavDestination.dishDetail(dish)) {
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

//#Preview {
//    MenuEntry(dish: PreviewDish(title: "Greek Salad",
//                                image: "https://www.w8wjb.com/littlelemon/images/food-greek-salad.jpg",
//                                price: 10.0,
//                                desc: "Crisp cucumbers, juicy tomatoes, tangy olives, and creamy feta cheese, all dressed in a zesty vinaigrette.",
//                                category: "starters"))
//}
