//
//  UIImage+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    convenience init?(base64: String?) {
        guard let base64 = base64 else { return nil }
        guard let dataDecoded: Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else { return nil }
        self.init(data: dataDecoded, scale: 1.0)
    }
    
    static func getVideoThumbnailFrom(url : URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMake(value: 1, timescale: 60)
        let img: CGImage
        do {
            try img = assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg: UIImage = UIImage(cgImage: img)
            return frameImg
        } catch { }
        return nil
    }
    
    static func getByteArrayFrom(data: Data) -> NSMutableArray {
        let count = data.count / MemoryLayout<UInt8>.size
        var bytes = [UInt8](repeating: 0, count: count)
        data.copyBytes(to: &bytes, count: count)
        let byteArray: NSMutableArray = NSMutableArray()
        for i in 0..<count {
            byteArray.add(NSNumber(value: bytes[i]))
        }
        return byteArray
    }
    
    func getByteArray() -> NSMutableArray? {
        if let data = self.jpegData(compressionQuality: 1.0) {
            return UIImage.getByteArrayFrom(data: data)
        }
        return nil
    }
    
    func renderOriginal() -> UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    func renderTemplate() -> UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    func resizeTo(width: CGFloat) -> UIImage? {
        let image = self
        let scale = width / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeTo(size: CGSize) -> UIImage? {
        let image = self
        let width = size.width
        let height = size.height
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeTo(percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizeTo(sizeMb: Double) -> UIImage? {
        guard let imageData = pngData() else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1024.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1024.0 * sizeMb { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resizeTo(percentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        return resizingImage
    }
    
    func scalingAndCroppingFor(size: CGSize) -> UIImage? {
        let sourceImage = self
        var newImage: UIImage? = nil
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = size.width
        let targetHeight = size.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if !imageSize.equalTo(size) {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor { scaleFactor = widthFactor }
            else { scaleFactor = heightFactor }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        UIGraphicsBeginImageContext(size) // this will crop
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        //pop the context to get back to the default
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func rotateBy(degrees: CGFloat) -> UIImage {
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
