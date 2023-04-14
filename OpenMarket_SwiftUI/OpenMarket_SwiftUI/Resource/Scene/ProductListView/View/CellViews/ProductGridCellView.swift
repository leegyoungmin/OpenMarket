//
//  ProductGridCellView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ProductGridCellView: View {
    let product: Product
    var body: some View {
        VStack {
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
            
            Text("Mac Book Pro")
                .font(.title3)
                .bold()
            
            Text("USD 2,500").strikethrough().foregroundColor(.red)
            + Text("\nUSD 2,000")
            
            Text("잔여 수량 : \(148)")
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
