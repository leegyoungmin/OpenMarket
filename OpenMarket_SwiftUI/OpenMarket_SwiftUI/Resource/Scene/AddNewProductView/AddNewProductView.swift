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
            
            TextField("상품가격", text: $price)
            
            TextField("할인 금액", text: $discountedPrice)
            
            TextField("재고 수량", text: $stock)
            
            TextEditor(text: $description)
                .frame(height: 200)
        }
        .textFieldStyle(ProductInformationFieldStyle())
        .padding(10)
        .navigationTitle("물품 등록")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension AddNewProductView {
    struct ProductInformationFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(15)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
    }
}


struct AddNewProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewProductView()
    }
}
