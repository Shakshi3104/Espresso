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
public enum DepthType: String, CaseIterable {
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
public extension DepthDataProcessor {
    // convert AVDepthData.depthDataMap to UIImage?
    func uiImage(orientation: UIImage.Orientation, depthType: DepthType = .depth) -> UIImage? {
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
}
// MARK: - DepthDataProcessor for macOS
#elseif os(macOS)
public extension DepthDataProcessor {
    // convert AVDepthData.depthDataMap to NSImage
    func nsImage(depthType: DepthType = .depth) -> NSImage? {
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

// MARK: - Type alias: DepthDataProcessor as Espresso
public typealias Espresso = DepthDataProcessor
