//
//  ProductGridCellView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ProductGridCellView: View {
    let product: Product
    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: 150, height: 150)
                    .background(.thickMaterial)
                    .cornerRadius(12)
            }
            
            Text(product.name)
                .font(.title3)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            VStack {
                if product.isDiscounted {
                    Text(product.priceDescription)
                        .strikethrough()
                        .foregroundColor(.red)
                        .lineLimit(1)
                }
                
                Text(product.bargainPriceDescription)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(5)
            
            Text("잔여 수량 : \(148)")
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black)
        }
    }
}

struct ProductGridCellView_Previews: PreviewProvider {
    static let mockProduct = Product.mockData
    static var previews: some View {
        ProductGridCellView(product: mockProduct)
            .previewLayout(.sizeThatFits)
    }
}
