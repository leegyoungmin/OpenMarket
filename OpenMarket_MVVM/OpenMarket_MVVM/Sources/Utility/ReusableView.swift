//
//  ReusableView.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

extension ReusableView {
    static var identifier: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionViewCell: ReusableView { }
extension UITableViewCell: ReusableView { }
