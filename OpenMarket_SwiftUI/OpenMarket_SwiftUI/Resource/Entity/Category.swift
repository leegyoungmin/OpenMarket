//
//  Category.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

enum Category: Int, CaseIterable, CustomStringConvertible {
  case clothes
  case digital
  case furniture
  case sports
  case game
  
  var imageName: String {
    get {
      switch self {
      case .clothes:
        return "man"
        
      case .digital:
        return "iPhone"
        
      case .furniture:
        return "sofa"
        
      case .sports:
        return "running"
        
      case .game:
        return "game"
      }
    }
  }
  
  var description: String {
    get {
      switch self {
      case .clothes:
        return "의류"
      case .digital:
        return "디지털"
      case .furniture:
        return "가구"
        
      case .sports:
        return "스포츠"
        
      case .game:
        return "게이밍"
      }
    }
  }
}
