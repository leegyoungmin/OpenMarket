//
//  AddNewProductView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import PhotosUI

struct AddNewProductView: View {
  @Environment(\.dismiss) var dismiss
  @Binding var isSuccessUpload: Bool
  @StateObject private var viewModel: AddNewProductViewModel
  @State private var selectedImage: PhotosPickerItem? = nil
  @State private var isPresentToast: Bool = false
  
  init(isSuccessUpload: Binding<Bool>, viewModel: AddNewProductViewModel) {
    self._isSuccessUpload = isSuccessUpload
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    ZStack {
      ScrollView(.vertical, showsIndicators: false) {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            if viewModel.viewStyle == .create {
              PhotosPicker(
                selection: $selectedImage,
                matching: .images
              ) {
                cameraInputButtonView
              }
            }
            
            ForEach(viewModel.images.indices, id: \.self) { index in
              let data = viewModel.images[index]
              ProductRegisterImageView(index: index, data: data)
                .environmentObject(viewModel)
            }
          }
        }
        
        productInformationForm
      }
      
      if isPresentToast {
        ProgressView()
          .progressViewStyle(.circular)
      }
    }
    .padding(10)
    .navigationTitle("물품 등록")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
          )
          viewModel.uploadProduct()
        } label: {
          Text("등록")
        }
      }
    }
    .onChange(of: selectedImage) { newImage in
      Task {
        if let data = try? await newImage?.loadTransferable(type: Data.self) {
          viewModel.updateImage(with: data)
        }
      }
    }
    .onReceive(viewModel.successUpload) { isSuccess in
      isSuccessUpload = true
      isPresentToast = true
    }
    .disabled(isPresentToast)
    .alert(
      "등록 에러",
      isPresented: Binding(
        get: { viewModel.alertState != nil },
        set: { _ in viewModel.alertState = nil }
      ),
      presenting: viewModel.alertState
    ) { _ in
      Button("확인", action: { })
    } message: { alertState in
      Text(alertState.description)
    }
    .toast(
      message: "정상적으로 업로드 되었습니다.",
      isShowing: $isPresentToast
    ) {
      dismiss()
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
  
  var productInformationForm: some View {
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
            .scaledToFit()
            .frame(width: 80, height: 80, alignment: .center)
            .cornerRadius(12)
          
          cancelButton
            .disabled(viewModel.viewStyle == .modify)
            .opacity(viewModel.viewStyle == .modify ? 0 : 1)
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
    AddNewProductView(isSuccessUpload: .constant(true), viewModel: viewModel)
  }
}
