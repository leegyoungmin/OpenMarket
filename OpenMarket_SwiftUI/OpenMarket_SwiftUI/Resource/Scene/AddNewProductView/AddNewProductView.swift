//
//  AddNewProductView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import PhotosUI

struct AddNewProductView: View {
    @StateObject private var viewModel: AddNewProductViewModel
    @State private var selectedImage: PhotosPickerItem? = nil
    
    init(viewModel: AddNewProductViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images
                    ) {
                        cameraInputButtonView
                    }
                    
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        let data = viewModel.images[index]
                        ProductRegisterImageView(index: index, data: data)
                            .environmentObject(viewModel)
                    }
                }
            }
            
            productInformationSection
        }
        .padding(10)
        .navigationTitle("물품 등록")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedImage) { newImage in
            Task {
                if let data = try? await newImage?.loadTransferable(type: Data.self) {
                    viewModel.updateImage(with: data)
                }
            }
        }
        
    }
}

private extension AddNewProductView {
    var cameraInputButtonView: some View {
        VStack {
            Image(systemName: "camera.circle")
                .font(.largeTitle)
            
            Text("\(viewModel.images.count) / 5")
                .font(.caption)
        }
        .frame(width: 80, height: 80)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.ultraThinMaterial, lineWidth: 2)
        }
        .padding(5)
    }
    
    var productInformationSection: some View {
        VStack(spacing: 20) {
            TextField("상품명", text: $viewModel.name)
            
            HStack {
                Picker("", selection: $viewModel.selectedCurrency) {
                    ForEach(Currency.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.menu)
                
                TextField("상품가격", text: $viewModel.price)
                    .keyboardType(.decimalPad)
            }
            
            TextField("할인 금액", text: $viewModel.discountedPrice)
                .keyboardType(.decimalPad)
            
            TextField("재고 수량", text: $viewModel.stock)
                .keyboardType(.numberPad)
            
            TextEditor(text: $viewModel.description)
                .frame(height: 200)
        }
        .textFieldStyle(ProductInformationFieldStyle())
        .padding(5)
    }
    
    struct ProductRegisterImageView: View {
        @EnvironmentObject var viewModel: AddNewProductViewModel
        let index: Int
        let data: Data
        
        var cancelButton: some View {
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            viewModel.deleteImage(to: index)
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .background(.white)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
            .offset(x: 10, y: -5)
        }
        
        var body: some View {
            if let image = UIImage(data: data) {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80, alignment: .center)
                        .cornerRadius(12)
                    
                    cancelButton
                }
                .padding(5)
            }
        }
    }
    
    struct ProductInformationFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            VStack {
                configuration
                
                Divider()
            }
        }
    }
}


struct AddNewProductView_Previews: PreviewProvider {
    static let viewModel = AddNewProductViewModel()
    
    static var previews: some View {
        AddNewProductView(viewModel: viewModel)
    }
}
