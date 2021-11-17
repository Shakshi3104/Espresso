import XCTest
@testable import Espresso
import AVFoundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

final class EspressoTests: XCTestCase {
    func testEspressoInitAVDepthDataViaCIImage() {
        let url = Bundle.module.url(forResource: "SoftCream", withExtension: "heic")
        if let url = url {
            let depthData = AVDepthData.fromURL(url)
            XCTAssertNotNil(depthData)
        }
    }
    
    func testEspressoBrewDepthDataImage() {
        let url = Bundle.module.url(forResource: "SoftCream", withExtension: "heic")
        guard let url = url else {
            return
        }
        let depthData = AVDepthData.fromURL(url)
        XCTAssertNotNil(depthData)
        
        guard let depthData = depthData else {
            return
        }
        
        let processor = DepthDataProcessor(depthData)
        #if os(iOS)
        let uiImage = UIImage(named: "SoftCream", in: Bundle.module, compatibleWith: nil)
        guard let uiImage = uiImage else {
            return
        }
        let depthImage = processor.uiImage(orientation: uiImage.imageOrientation, depthType: .depth)
        XCTAssertNotNil(depthImage)
        #elseif os(macOS)
        let depthImage = processor.nsImage(depthType: .depth)
        XCTAssertNotNil(depthImage)
        #endif
    }
    
    func testEspresso() {
        let url = Bundle.module.url(forResource: "SoftCream", withExtension: "heic")
        guard let url = url else {
            return
        }
        let depthData = AVDepthData.fromURL(url)
        XCTAssertNotNil(depthData)
        
        guard let depthData = depthData else {
            return
        }
        
        let espresso = Espresso(depthData)
        #if os(iOS)
        let uiImage = UIImage(named: "SoftCream", in: Bundle.module, compatibleWith: nil)
        guard let uiImage = uiImage else {
            return
        }
        let depthImage = espresso.uiImage(orientation: uiImage.imageOrientation, depthType: .depth)
        XCTAssertNotNil(depthImage)
        #elseif os(macOS)
        let depthImage = espresso.nsImage(depthType: .depth)
        XCTAssertNotNil(depthImage)
        #endif
    }
}
