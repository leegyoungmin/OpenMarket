//
//  PhotoPicker.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
  let configuration: PHPickerConfiguration
  @Binding var isPresent: Bool
  let onComplete: (UIImage) -> ()
  
  func makeUIViewController(context: Context) -> PHPickerViewController {
    let controller = PHPickerViewController(configuration: configuration)
    controller.delegate = context.coordinator
    return controller
  }
  
  func updateUIViewController(
    _ uiViewController: PHPickerViewController,
    context: Context
  ) { }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }
  
  class Coordinator: PHPickerViewControllerDelegate {
    private let parent: PhotoPicker
    
    init(parent: PhotoPicker) {
      self.parent = parent
    }
    
    func picker(
      _ picker: PHPickerViewController,
      didFinishPicking results: [PHPickerResult]
    ) {
      parent.isPresent.toggle()
      
      let itemProvider = results.first?.itemProvider
      
      if let itemProvider = itemProvider,
         itemProvider.canLoadObject(ofClass: UIImage.self) {
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
          if let image = image as? UIImage {
            DispatchQueue.main.async {
              self.parent.onComplete(image)
            }
          }
        }
      } else {
        return
      }
    }
  }
}
