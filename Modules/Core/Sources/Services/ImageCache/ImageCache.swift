//
//  ImageCache.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import UIKit
import Combine

public protocol ImageCacheProtocol {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

public final class ImageCache: ImageCacheProtocol {
    private let cache = NSCache<NSURL, UIImage>()
    private let session = URLSession.shared
    
    public init() { }
    
    public func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return Just(cachedImage).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .handleEvents(receiveOutput: { [weak self] image in
                if let image = image {
                    self?.cache.setObject(image, forKey: url as NSURL)
                }
            })
            .catch { _ in Just(nil) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
