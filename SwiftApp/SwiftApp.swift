//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

enum DefaultsKey: String, CaseIterable {
    case counter
    case password
    case username
}

class SwiftApp {
    struct FontStyle: Equatable {
        let name: String
        let size: CGFloat
        
        static let defaultStyle = Self(name: "HelveticaNeue", size: 18)
    }
    
    init(_ window: UIWindow, rootScreen: Screen) {
        self.window = window
        updateStyles()
        let vc = TableViewController(rootScreen.modelClosure(app: self))
        window.rootViewController = rootScreen.embedInNavController ? UINavigationController(rootViewController: vc) : vc
        window.makeKeyAndVisible()
        
        Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.needsReload {
                self.topViewController?.loadModel()
                self.needsReload = false
            }
        }
    }
   
    private let window: UIWindow
    
    var style: FontStyle = .defaultStyle {
        didSet {
            guard style != oldValue else { return }
            updateStyles()
            setNeedsReload()
        }
    }
    var smallStyle = TextStyle()
    var defaultStyle = TextStyle()
    var largeStyle = TextStyle()
    var hugeStyle = TextStyle()
    var counterStyle = TextStyle()
    var modelStyle = Style()
    var minusImage = UIImage()
    var plusImage = UIImage()
    
    private func updateStyles() {
        let name = self.style.name, size = self.style.size
        let smallFont = UIFont(name: name, size: size * 0.86)
        let defaultFont = UIFont(name: name, size: size)
        let largeFont = UIFont(name: name, size: size * 1.2)
        let hugeFont = UIFont(name: name, size: size * 1.6)
        
        smallStyle = .init(color: .gray, font: smallFont)
        defaultStyle = .init(font: defaultFont)
        largeStyle = .init(font: largeFont)
        hugeStyle = .init(font: hugeFont, alignment: .center)
        counterStyle = .init(font: largeFont, alignment: .center)
        modelStyle = .init(text: defaultStyle)
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: .medium)
        minusImage = UIImage(
            systemName: "minus.circle",
            withConfiguration: config
        ) ?? UIImage()
        plusImage = UIImage(
            systemName: "plus.circle",
            withConfiguration: config
        ) ?? UIImage()
    }
    func getDefaultsItem(_ key: DefaultsKey) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    func setDefaultsItem(_ key: DefaultsKey, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
        setNeedsReload()
    }
    
    private var topViewController: TableViewController? {
        if let nc = window.rootViewController as? UINavigationController,
            let vc = nc.topViewController as? TableViewController {
            return vc
        } else if let vc = window.rootViewController as? TableViewController {
            return vc
        } else {
            return nil
        }
    }
    
    private var needsReload = false
    private func setNeedsReload() {
        needsReload = true
    }
    
    func push(_ screen: Screen) {
        guard let nc = window.rootViewController as? UINavigationController
        else {
            return
        }
        let vc = TableViewController(screen.modelClosure(app: self))
        nc.pushViewController(vc, animated: true)
    }
}
