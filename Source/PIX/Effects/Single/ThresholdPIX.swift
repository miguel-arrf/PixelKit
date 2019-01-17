//
//  ThresholdPIX.swift
//  Pixels
//
//  Created by Hexagons on 2018-08-17.
//  Open Source - MIT License
//
import CoreGraphics//x

public class ThresholdPIX: PIXSingleEffect {
    
    override open var shader: String { return "effectSingleThresholdPIX" }
    
    // MARK: - Public Properties
    
    public var threshold: LiveFloat = 0.5
    public var smooth: LiveBool = true
    var _smoothness: CGFloat = 0
    public var smoothness: LiveFloat {
        set {
            _smoothness = newValue.value
            setNeedsRender()
        }
        get {
            return LiveFloat({ () -> (CGFloat) in
                guard self.smooth.value else { return 0.0 }
                return max(self._smoothness, 1.0 / pow(2.0, CGFloat(Pixels.main.bits.rawValue)))
            })
        }
    }
    
    // MARK: - Property Helpers
    
    override var liveValues: [LiveValue] {
        return [threshold, smoothness]
    }
    
//    enum EdgeCodingKeys: String, CodingKey {
//        case threshold; case smoothness
//    }
    
//    open override var uniforms: [CGFloat] {
//        return [threshold, smoothness]
//    }
    
//    // MARK: - JSON
//
//    required convenience init(from decoder: Decoder) throws {
//        self.init()
//        let container = try decoder.container(keyedBy: EdgeCodingKeys.self)
//        threshold = try container.decode(CGFloat.self, forKey: .threshold)
//        smoothness = try container.decode(CGFloat.self, forKey: .smoothness)
//        setNeedsRender()
//    }
//
//    public override func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: EdgeCodingKeys.self)
//        try container.encode(threshold, forKey: .threshold)
//        try container.encode(smoothness, forKey: .smoothness)
//    }
    
}

public extension PIXOut {
    
    func _threshold(at threshold: LiveFloat = 0.5) -> ThresholdPIX {
        let thresholdPix = ThresholdPIX()
        thresholdPix.name = ":threshold:"
        thresholdPix.inPix = self as? PIX & PIXOut
        thresholdPix.threshold = threshold
        return thresholdPix
    }
    
}
