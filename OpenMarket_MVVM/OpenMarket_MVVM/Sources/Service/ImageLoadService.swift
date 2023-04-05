//
//  ImageLoadService.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

protocol ImageLoadServicing {
    var imageLoadRepository: ImageLoadable { get }
    func loadImageData(path: String) -> AnyPublisher<Data, Never>
}

final class ImageLoadService: ImageLoadServicing {
    var imageLoadTask: Cancellable?
    var imageLoadRepository: ImageLoadable
    
    init(imageLoadRepository: ImageLoadable = ImageLoader()) {
        self.imageLoadRepository = imageLoadRepository
    }
    
    func loadImageData(path: String) -> AnyPublisher<Data, Never> {
        return imageLoadRepository
            .fetchImage(imagePath: path)
            .replaceError(with: Data())
            .eraseToAnyPublisher()
    }
}
