//
//  Network.swift
//  SwiftApp
//
//  Created by Nigel Barber on 24/02/2022.
//

import Foundation
import UIKit


class Network {
    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self
            else { return }
            
            let now = Date()
            for (key, expiryDate) in self.keyExpiryDates {
                if expiryDate < now {
                    self.imageCache.removeObject(forKey: NSNumber(value: key))
                    self.objectCache.removeValue(forKey: key)
                    self.keyExpiryDates.removeValue(forKey: key)
                }
            }
        })
    }
    
    var onDidUpdate: (() -> Void)?
    
    func getImage(_ url: URL?, ttl: TimeInterval = oneHour) -> UIImage? {
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
                        DispatchQueue.main.async {
                            self.imageCache.setObject(image, forKey: key)
                            self.keyExpiryDates[key.intValue] = Date(timeIntervalSinceNow: ttl)
                            self.onDidUpdate?()
                        }
                    }
            }).resume()
            return nil
        }
    }
    
    func get<T>(_ url: URL?, ttl: TimeInterval = oneHour) -> T? where T : Decodable {
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
                            let object = try JSONDecoder().decode(T.self, from: data)
                            DispatchQueue.main.async {
                                self.objectCache[key] = object
                                self.keyExpiryDates[key] = Date(timeIntervalSinceNow: ttl)
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
    
    private var keyExpiryDates: [Int: Date] = [:]
    private var objectCache: [Int: Any] = [:]
    private var imageCache: NSCache<NSNumber, UIImage> = .init()
    
    static let oneHour: TimeInterval = 3600
}
