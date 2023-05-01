//
//  ImageListScrollView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import PhotosUI

struct ImageListScrollView: View {
  @EnvironmentObject var viewModel: UploadProductViewModel
  @State private var selectedImage: PhotosPickerItem? = nil
  
  var body: some View {
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
  }
}

private extension ImageListScrollView {
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
  
  struct ProductRegisterImageView: View {
    @EnvironmentObject var viewModel: UploadProductViewModel
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
}
