//
//  DetailProductInfoScrollView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct DetailProductInfoScrollView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var viewModel: DetailProductViewModel
  @State private var isPresentTextFieldAlert = false
  
  var body: some View {
    GeometryReader { proxy in
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 10) {
          PagingBannerView(items: viewModel.detailProduct.imagesInformation)
          
          productNameView
          
          productPriceView
          
          Text(viewModel.detailProduct.description)
            .multilineTextAlignment(.leading)
            .foregroundColor(.secondary)
            .padding(.top, 22)
        }
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("상품 상세")
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Menu {
              NavigationLink {
                UploadProductView(
                  viewModel: AddNewProductViewModel(
                    with: viewModel.detailProduct
                  )
                )
                .onDisappear {
                  viewModel.shouldDismiss.toggle()
                }
              } label: {
                Label("수정", systemImage: "pencil.circle.fill")
              }
              
              Button(role: .destructive) {
                isPresentTextFieldAlert.toggle()
              } label: {
                Label("삭제", systemImage: "trash.circle.fill")
              }
            } label: {
              Label("더보기", systemImage: "ellipsis")
                .rotationEffect(.degrees(90))
            }
          }
        }
        .alert("삭제 알림", isPresented: $isPresentTextFieldAlert) {
          TextField("비밀번호", text: $viewModel.secretCode)
          
          Button("확인", role: .destructive) {
            if viewModel.secretCode.isEmpty { return }
            viewModel.removeItem()
          }
          
          Button("취소", role: .cancel, action: { })
          
        } message: {
          Text("정말 삭제 하시겠습니까? 삭제 후에는 되돌릴 수 없습니다.")
        }
        .onReceive(viewModel.$shouldDismiss) { shouldDismiss in
          if shouldDismiss {
            dismiss.callAsFunction()
          }
        }
      }
      .padding(.bottom, proxy.frame(in: .global).width * 0.2)
      .background(Color(uiColor: .secondarySystemFill))
    }
  }
}

// MARK: Child Views
private extension DetailProductInfoScrollView {
  var productNameView: some View {
    HStack(alignment: .bottom) {
      Text(viewModel.detailProduct.name)
        .font(.system(size: 22, weight: .bold, design: .default))
      
      Spacer()
      
      Text("남은 수량 : \(viewModel.detailProduct.stock.description)")
        .font(.system(size: 16, weight: .regular, design: .rounded))
        .foregroundColor(.accentColor)
    }
  }
  
  var productPriceView: some View {
    HStack {
      VStack(alignment: .leading) {
        if viewModel.detailProduct.discountedPrice != 0 {
          Text(viewModel.detailProduct.price.convertCurrencyValue(with: viewModel.detailProduct.currency.rawValue))
            .strikethrough()
        }
        Text(viewModel.detailProduct.bargainPrice.convertCurrencyValue(with: viewModel.detailProduct.currency.rawValue))
      }
      
      Spacer()
    }
    .foregroundColor(Color.secondary)
    .font(.system(size: 20, weight: .medium))
  }
}

private extension DetailProductInfoScrollView {
  
}
