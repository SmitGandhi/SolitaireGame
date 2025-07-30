//
//  UIImage+Extension.swift
//  Solitaire
//
//  Created by Smit Gandhi on 30/07/25.
//

import UIKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

extension UIImage {
    static func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("GIF not found: \(name)")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }

        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: true,
            kCGImageSourceTypeIdentifierHint: UTType.gif.identifier as CFString
        ]
        guard let source = CGImageSourceCreateWithData(imageData as CFData, options as CFDictionary) else { return nil }

        var images: [UIImage] = []
        var duration: Double = 0

        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
                duration += 0.1
            }
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }
}
