//
//  Network.swift
//  SwiftApp
//
//  Created by Nigel Barber on 24/02/2022.
//

import Foundation
import UIKit


class Network {
    var onDidUpdate: (() -> Void)?
    
    func getImage(_ url: URL?) -> UIImage? {
        guard let url = url
        else { return nil }

        let request = URLRequest(url: url)
        let key = NSNumber.init(value: request.hashValue)
        
        if let cached = imageCache.object(forKey: key) {
            return cached
        } else {
            URLSession.shared.dataTask(
                with: request,
                completionHandler: { [weak self] data, response, error in
                    if let self = self, let data = data, let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: key)
                        DispatchQueue.main.async {
                            self.onDidUpdate?()
                        }
                    }
            }).resume()
            return nil
        }
    }
    
    func getData(_ url: URL?) -> Data? {
        guard let url = url
        else { return nil }

        let request = URLRequest(url: url)
        
        if let data = cache[request] {
            return data
        } else {
            URLSession.shared.dataTask(
                with: request,
                completionHandler: { [weak self] data, response, error in
                    if let data = data, let self = self {
                        self.cache[request] = data
                        DispatchQueue.main.async {
                            self.onDidUpdate?()
                        }
                    }
            }).resume()
            return nil
        }
    }
    
    private var imageCache: NSCache<NSNumber, UIImage> = .init()
    private var cache: [URLRequest: Data] = [:]
}
