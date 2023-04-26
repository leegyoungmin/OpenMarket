//
//  FloatingActionButton.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct FloatingActionButton<ImageView: View>: ViewModifier {
  enum ActionCase {
    case navigate
    case custom
  }
  
  let actionCase: ActionCase
  let color: Color
  let action: (() -> Void)?
  let image: () -> ImageView
  
  init(
    color: Color,
    actionCase: ActionCase,
    action: (() -> Void)?,
    image: @escaping () -> ImageView
  ) {
    self.actionCase = actionCase
    self.color = color
    self.action = action
    self.image = image
  }
  
  private let size: CGFloat = 60
  private let margin: CGFloat = 15
  
  func body(content: Content) -> some View {
    GeometryReader { geometry in
      ZStack {
        Color.clear
        content
        actionButton(geometry)
      }
    }
  }
  
  @ViewBuilder private func actionButton(_ geometry: GeometryProxy) -> some View {
    image()
      .imageScale(.large)
      .frame(width: size, height: size)
      .background(Circle().fill(color))
      .shadow(radius: 2)
      .offset(
        x: (geometry.size.width - size) / 2 - margin,
        y: (geometry.size.height - size) / 2 - margin
      )
      .onTapGesture {
        if actionCase == .custom,
           let action = action {
          action()
        }
      }
  }
}

extension View {
  func floatingActionButton<ImageView: View>(
    color: Color,
    image: @escaping () -> ImageView,
    action: @escaping () -> Void
  ) -> some View {
    self.modifier(
      FloatingActionButton(
        color: color,
        actionCase: .custom,
        action: action,
        image: image
      )
    )
  }
  
  func navigateFloatingButton<Destination: View, ImageView: View>(
    color: Color,
    destination: @escaping () -> Destination,
    image: @escaping () -> ImageView
  ) -> some View {
    self.modifier(
      FloatingActionButton(color: color, actionCase: .navigate, action: nil) {
        NavigationLink {
          destination()
        } label: {
          image()
        }
      }
    )
  }
}
