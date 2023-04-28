//
//  AddNewProductView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import PhotosUI

struct UploadProductView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var viewModel: AddNewProductViewModel
  
  @State private var isPresentToast: Bool = false
  
  init(viewModel: AddNewProductViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationStack {
      ZStack {
        VStack {
          ImageListScrollView()
            .frame(height: 90)
            .environmentObject(viewModel)
          
          productInformationForm
        }
        
        if isPresentToast {
          ProgressView()
            .progressViewStyle(.circular)
        }
      }
      .navigationTitle(viewModel.viewStyle == .create ? "물품 등록" : "물품 수정")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: dismiss.callAsFunction) {
            Text("취소")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          saveButton
        }
      }
    }
    .padding(16)
    .onReceive(viewModel.successUpload) { isSuccess in
      isPresentToast = true
    }
    .disabled(isPresentToast)
    .toast(
      message: "정상적으로 업로드 되었습니다.",
      isShowing: $isPresentToast
    ) {
      dismiss()
    }
    .alert(isPresented: $viewModel.isPresentErrorAlert, error: viewModel.alertState) { error in
      Button {
        viewModel.isPresentErrorAlert = false
      } label: {
        Text("확인")
      }
    } message: { error in
      Text(error.description)
    }
  }
}


private extension UploadProductView {
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
    }
    .textFieldStyle(ProductInformationFieldStyle())
    .padding(5)
  }
  
  var saveButton: some View {
    Button {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
      )
      
      if viewModel.viewStyle == .create {
        viewModel.uploadProduct()
      } else if viewModel.viewStyle == .modify {
        viewModel.modifyProduct()
      }
      
    } label: {
      Text(viewModel.viewStyle == .create ? "등록" : "수정")
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

struct UploadView_Previews: PreviewProvider {
  static var previews: some View {
    UploadProductView(viewModel: AddNewProductViewModel())
      .environmentObject(AddNewProductViewModel())
  }
}
