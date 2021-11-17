import AVFoundation

// refer to https://qiita.com/codelynx/items/9551d8382f4a47fad6c7
#if os(iOS)
import UIKit
typealias XImage = UIImage
#elseif os(macOS)
import Cocoa
typealias XImage = NSImage
#endif

/// Depth type
enum DepthType: String, CaseIterable {
    case depth
    case disparity
}

// MARK: - DepthDataProcessor
public class DepthDataProcessor {
    var depthImage: XImage?
    var dispariyImage: XImage?
    
    var depthData: AVDepthData
    
    public init(_ depthData: AVDepthData) {
        self.depthData = depthData
    }
}

// MARK: - DepthDataProcessor for iOS
#if os(iOS)
extension DepthDataProcessor {
    // convert AVDepthData.depthDataMap to UIImage?
    public func uiImage(orientation: UIImage.Orientation, depthType: DepthType = .depth) -> UIImage? {
        // if depth data's UIImage is not nil
        if depthType == .depth && depthImage != nil {
            print("🎛 depth cache")
            return depthImage
        }
        
        if depthType == .disparity && dispariyImage != nil {
            print("🎛 disparity cache")
            return dispariyImage
        }
        
        // MARK: -
        var convertedDepthData: AVDepthData
        
        // Convert AVDepthData as `depthType`
        switch depthType {
        case .depth:
            convertedDepthData = depthData.asDepthFloat32
        case .disparity:
            convertedDepthData = depthData.asDisparityFloat32
        }
        
        // Convert AVDepthData.depthDataMap to UIImage
        let normaizedDepthMap = convertedDepthData.depthDataMap.normalize()
        let depthDataImage = normaizedDepthMap.uiImage(orientation: orientation)
        
        // cache
        switch depthType {
        case .depth:
            self.depthImage = depthDataImage
        case .disparity:
            self.dispariyImage = depthDataImage
        }
        
        return depthDataImage
    }
    
    // save depth data image to photo library
    public func saveToPhotoLibrary(depthType: DepthType = .depth) {
        var uiImage: UIImage?
        
        switch depthType {
        case .depth:
            uiImage = depthImage
        case .disparity:
            uiImage = dispariyImage
        }
        
        guard let uiImage = uiImage else {
            print("🎛 No depth data image")
            return
        }
        
        // write to photo library
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
}
// MARK: - DepthDataProcessor for macOS
#elseif os(macOS)
extension DepthDataProcessor {
    
    // convert AVDepthData.depthDataMap to NSImage
    public func nsImage(depthType: DepthType = .depth) -> NSImage? {
        // if depth data's NSImage is not nil
        if depthType == .depth && depthImage != nil {
            print("🎛 depth cache")
            return depthImage
        }
        
        if depthType == .disparity && dispariyImage != nil {
            print("🎛 disparity cache")
            return dispariyImage
        }
        
        // MARK: -
        var convertedDepthData: AVDepthData
        
        // Convert AVDepthData as `depthType`
        switch depthType {
        case .depth:
            convertedDepthData = depthData.asDepthFloat32
        case .disparity:
            convertedDepthData = depthData.asDisparityFloat32
        }
        
        // Convert AVDepthData.depthDataMap to NSImage
        let normaizedDepthMap = convertedDepthData.depthDataMap.normalize()
        let depthDataImage = normaizedDepthMap.nsImage()
        
        // cache
        switch depthType {
        case .depth:
            self.depthImage = depthDataImage
        case .disparity:
            self.dispariyImage = depthDataImage
        }
        
        return depthDataImage
    }
}
#endif
