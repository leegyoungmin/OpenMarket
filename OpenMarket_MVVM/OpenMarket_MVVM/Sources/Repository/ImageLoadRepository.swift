//
//  ImageLoadRepository.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

protocol ImageLoadable: AnyObject {
    var imageLoadTask: Cancellable? { get }
    func fetchImage(imagePath: String) -> AnyPublisher<Data, Error>
    func cancel()
}

final class ImageLoader: ImageLoadable {
    var imageLoadTask: Cancellable?
    
    func fetchImage(imagePath: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: imagePath) else {
            return Fail(error: ImageLoadError.invalidURL).eraseToAnyPublisher()
        }
        let task = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(\.data)
            .eraseToAnyPublisher()
        
        return task
    }
    
    func cancel() {
        imageLoadTask?.cancel()
    }
}

extension ImageLoader {
    enum ImageLoadError: Error {
        case invalidURL
    }
}
