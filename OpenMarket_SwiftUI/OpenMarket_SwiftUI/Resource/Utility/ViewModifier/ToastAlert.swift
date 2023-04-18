//
//  ToastAlert.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ToastAlert: ViewModifier {
  static let short: TimeInterval = 2
  static let long: TimeInterval = 3.5
  
  @Binding var isShowing: Bool
  let message: String
  let configure: Configuration
  let completion: () -> Void
  
  func body(content: Content) -> some View {
    ZStack {
      content
      toastView
    }
  }
  
  private var toastView: some View {
    VStack {
      Spacer()
      
      if isShowing {
        Group {
          Text(message)
            .multilineTextAlignment(.center)
            .foregroundColor(configure.textColor)
            .font(configure.font)
            .padding(8)
        }
        .background(configure.backgroundColor)
        .cornerRadius(8)
        .onTapGesture {
          isShowing = false
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + configure.duration) {
            isShowing = false
            completion()
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 18)
    .animation(configure.animation, value: isShowing)
    .transition(configure.transition)
  }
  
  struct Configuration {
    let textColor: Color
    let font: Font
    let backgroundColor: Color
    let duration: TimeInterval
    let transition: AnyTransition
    let animation: Animation
    
    init(
      textColor: Color = .white,
      font: Font = .system(size: 14),
      backgroundColor: Color = .black.opacity(0.4),
      duration: TimeInterval = ToastAlert.short,
      transition: AnyTransition = .opacity,
      animation: Animation = .linear(duration: 0.3)
    ) {
      self.textColor = textColor
      self.font = font
      self.backgroundColor = backgroundColor
      self.duration = duration
      self.transition = transition
      self.animation = animation
    }
  }
}

extension View {
  func toast(
    message: String,
    isShowing: Binding<Bool>,
    configuration: ToastAlert.Configuration = ToastAlert.Configuration(),
    completion: @escaping () -> Void
  ) -> some View {
    self.modifier(
      ToastAlert(
        isShowing: isShowing,
        message: message,
        configure: configuration,
        completion: completion
      )
    )
  }
}
