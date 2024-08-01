//
//  DishDetail.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import SwiftUI

struct DishDetail: View {
    
    let dish: DishProtocol
    
    @State var desiredAmount = 1
    
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
                    
                    Stepper("", value: $desiredAmount).onChange(of: desiredAmount) { oldValue, newValue in
                        if newValue < 1 {
                            desiredAmount = 1
                        }
                    }.fixedSize()
                    
                    Text(desiredAmount, format: .number)
                        .font(.subTitle).bold()
                        .frame(width: 20)
                        .padding()
                        
                    Button("Add to Cart") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .layoutPriority(1)
                    
                    
                }.frame(maxWidth: .infinity)
                
            }
        }
    }
}

#Preview {
    DishDetail(dish: PreviewDish(title: "Greek Salad",
                                 image: "https://www.w8wjb.com/littlelemon/images/food-greek-salad.jpg",
                                 price: 10.0,
                                 desc: "Crisp cucumbers, juicy tomatoes, tangy olives, and creamy feta cheese, all dressed in a zesty vinaigrette.",
                                 category: "starters"))
}
