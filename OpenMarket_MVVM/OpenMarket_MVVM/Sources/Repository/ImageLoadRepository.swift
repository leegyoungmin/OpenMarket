//
//  ImageLoadRepository.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

protocol ImageLoadable: AnyObject {
    func fetchImage(imagePath: String) -> AnyPublisher<Data, Error>
}

final class ImageLoader: ImageLoadable {
    func fetchImage(imagePath: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: imagePath) else {
            return Fail(error: ImageLoadError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(\.data)
            .eraseToAnyPublisher()
    }
}

extension ImageLoader {
    enum ImageLoadError: Error {
        case invalidURL
    }
}
