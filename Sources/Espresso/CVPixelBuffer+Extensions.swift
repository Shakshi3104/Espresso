//
//  CVPixelBuffer+Extensions.swift
//  
//
//  Created by MacBook Pro M1 on 2021/11/17.
//

import CoreVideo
import CoreImage

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension CVPixelBuffer {
    // normalize CVPixelBuffer
    // refer to https://www.raywenderlich.com/8246240-image-depth-maps-tutorial-for-ios-getting-started
    func normalize() -> CVPixelBuffer {
        let cvPixelBuffer = self
                
        let width = CVPixelBufferGetWidth(cvPixelBuffer)
        let height = CVPixelBufferGetHeight(cvPixelBuffer)
        
        CVPixelBufferLockBaseAddress(cvPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(cvPixelBuffer), to: UnsafeMutablePointer<Float>.self)
        
        var minPixel: Float = 1.0
        var maxPixel: Float = 0.0
        
        for y in stride(from: 0, to: height, by: 1) {
          for x in stride(from: 0, to: width, by: 1) {
            let pixel = floatBuffer[y * width + x]
            minPixel = min(pixel, minPixel)
            maxPixel = max(pixel, maxPixel)
          }
        }
        
        let range = maxPixel - minPixel
        for y in stride(from: 0, to: height, by: 1) {
          for x in stride(from: 0, to: width, by: 1) {
            let pixel = floatBuffer[y * width + x]
            floatBuffer[y * width + x] = (pixel - minPixel) / range
          }
        }
        
        CVPixelBufferUnlockBaseAddress(cvPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return cvPixelBuffer
    }
    
    #if canImport(UIKit)
    // convert CVPixelBuffer to UIImage
    func uiImage(orientation: UIImage.Orientation) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: self)
        let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent)
        guard let image = cgImage else { return nil }
        let uiImage = UIImage(cgImage: image, scale: 0, orientation: orientation)
        return uiImage
    }
    #elseif canImport(AppKit)
    // convert CVPixelBuffer to NSImage
    // refer to https://qiita.com/Kyome/items/87b771e13695a6fba99e
    func nsImage() -> NSImage {
        let ciImage = CIImage(cvPixelBuffer: self)
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
    #endif
}
