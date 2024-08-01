//
//  OrderLineItem.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import SwiftUI

struct OrderLineItem: View {
    
    let lineItem: LineItem
    
    var body: some View {
        if let dish = lineItem.toDish {
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(dish.title ?? "")
                        .font(.cardTitle)
                        .padding(.bottom, 10)

                    HStack {
                        Text(lineItem.quantity, format: .number)
                        Text("×")
                        Text(dish.price.formatted(.currency(code: "USD")))
                    }
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
//    OrderLineItem()
//}
