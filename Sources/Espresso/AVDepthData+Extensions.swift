//
//  AVDepthData+Extensions.swift
//  
//
//  Created by MacBook Pro M1 on 2021/11/17.
//

import AVFoundation
import CoreImage

// MARK: AVDepthData extensions - convert depth or disparity
extension AVDepthData {
    // convert to AVDepthData (kCVPixelFormatType_DisparityFloat32)
    public var asDisparityFloat32: AVDepthData {
        var convertedDepthData: AVDepthData
        
        if self.depthDataType != kCVPixelFormatType_DisparityFloat32 {
            convertedDepthData = self.converting(toDepthDataType: kCVPixelFormatType_DisparityFloat32)
        } else {
            convertedDepthData = self
        }
        
        return convertedDepthData
    }
    
    // convert to AVDepthData (kCVPixelFormatType_DepthFloat32)
    public var asDepthFloat32: AVDepthData {
        var convertedDepthData: AVDepthData
        
        if self.depthDataType != kCVPixelFormatType_DepthFloat32 {
            convertedDepthData = self.converting(toDepthDataType: kCVPixelFormatType_DepthFloat32)
        } else {
            convertedDepthData = self
        }
        
        return convertedDepthData
    }
}

// MARK: AVDepthData extensions - load from URL or Data via CIImage
extension AVDepthData {
    // load AVDepthData? from URL via CIImage
    public static func fromURL(_ url: URL) -> AVDepthData? {
        let ciImage = CIImage(contentsOf: url,
                              options: [CIImageOption.auxiliaryDepth: true,
                                        CIImageOption.applyOrientationProperty: true])
        
        guard let ciImage = ciImage else { return nil }
        
        let exifDictionary = ciImage.properties
        print(exifDictionary)
        
        return ciImage.depthData
    }
    
    // load AVDepthData? from Data via CIImage
    public static func fromData(_ data: Data) -> AVDepthData? {
        let ciImage = CIImage(data: data,
                              options: [CIImageOption.auxiliaryDepth: true,
                                        CIImageOption.applyOrientationProperty: true])
        guard let ciImage = ciImage else { return nil }
        
        let exifDictionary = ciImage.properties
        print(exifDictionary)
        
        return ciImage.depthData
    }
}
