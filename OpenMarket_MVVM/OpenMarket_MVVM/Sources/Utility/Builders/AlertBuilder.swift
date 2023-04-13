//
//  AlertBuilder.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol AlertBuilder {
    var alert: UIAlertController { get }
    
    func setTitle(with title: String) -> AlertBuilder
    func setMessage(with message: String) -> AlertBuilder
    func setAction(
        title: String,
        style: UIAlertAction.Style,
        completion: ((UIAlertAction) -> Void)?
    ) -> AlertBuilder
    func addTextField() -> AlertBuilder
    
    func generate() -> UIAlertController
}

final class AlertConcreteBuilder: AlertBuilder {
    var alert: UIAlertController = UIAlertController()
    
    init(style: UIAlertController.Style) {
        self.alert = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    func setTitle(with title: String) -> AlertBuilder {
        alert.title = title
        
        return self
    }
    
    func setMessage(with message: String) -> AlertBuilder {
        alert.message = message
        
        return self
    }
    
    func setAction(
        title: String,
        style: UIAlertAction.Style,
        completion: ((UIAlertAction) -> Void)? = nil
    ) -> AlertBuilder {
        let alertAction = UIAlertAction(title: title, style: style, handler: completion)
        alert.addAction(alertAction)
        
        return self
    }
    
    func addTextField() -> AlertBuilder {
        alert.addTextField {
            $0.placeholder = Constants.textFieldPlaceholder
        }
        
        return self
    }
    
    func generate() -> UIAlertController {
        return alert
    }
}

extension AlertConcreteBuilder {
    enum Constants {
        static let textFieldPlaceholder: String = "비밀번호를 입력해주세요."
    }
}
