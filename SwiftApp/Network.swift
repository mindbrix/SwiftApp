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
        let key = NSNumber(value: request.hashValue)
        
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
    
    func get<T>(_ type: T.Type, from url: URL?) -> T? where T : Decodable {
        guard let url = url
        else { return nil }
        
        let request = URLRequest(url: url)
        let key = request.hashValue

        if let object = objectCache[key] as? T {
            return object
        } else {
            URLSession.shared.dataTask(
                with: request,
                completionHandler: { [weak self] data, response, error in
                    if let self = self, let data = data {
                        do {
                            let object = try JSONDecoder().decode(type, from: data)
                            self.objectCache[key] = object
                            DispatchQueue.main.async {
                                self.onDidUpdate?()
                            }
                        } catch {
                            print(error)
                            if let string = String(data: data, encoding: .utf8) {
                                print(string)
                            }
                        }
                    }
            }).resume()
            return nil
        }
    }
    
    private var objectCache: [Int: Any] = [:]
    private var imageCache: NSCache<NSNumber, UIImage> = .init()
}
