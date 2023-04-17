//
//  AddNewProductView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct AddNewProductView: View {
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var discountedPrice: String = ""
    @State private var stock: String = ""
    @State private var description: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<5, id: \.self) { _ in
                        Button {
                            print("Tapped")
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 130, height: 130)
                                .background(.thickMaterial)
                        }
                        .cornerRadius(12)
                    }
                }
            }
            
            TextField("상품명", text: $name)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            
            TextField("상품가격", text: $price)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            
            TextField("할인 금액", text: $discountedPrice)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            
            TextField("재고 수량", text: $stock)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            
            TextEditor(text: $description)
                .frame(height: 200)
        }
        .padding(10)
        .navigationTitle("물품 등록")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct AddNewProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewProductView()
    }
}
