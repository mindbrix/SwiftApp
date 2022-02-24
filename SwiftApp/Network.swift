//
//  Network.swift
//  SwiftApp
//
//  Created by Nigel Barber on 24/02/2022.
//

import Foundation

class Network {
    var onDidUpdate: (() -> Void)?
    
    func getURL(_ url: URL?) -> Data? {
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.onDidUpdate?()
                        })
                    }
            }).resume()
            return nil
        }
    }
    
    private var cache: [URLRequest: Data] = [:]
}
