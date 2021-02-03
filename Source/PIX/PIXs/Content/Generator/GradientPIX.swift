//
//  GradientPIX.swift
//  PixelKit
//
//  Created by Anton Heestand on 2018-08-09.
//  Open Source - MIT License
//


import RenderKit
import CoreGraphics
import PixelColor

public struct ColorStep: Floatable {
    public var step: CGFloat
    public var color: PixelColor
    public init(_ step: CGFloat, _ color: PixelColor) {
        self.step = step
        self.color = color
    }
    public var floats: [CGFloat] {
        [step, color.red, color.green, color.blue, color.alpha]
    }
}
extension Array: Floatable where Element == ColorStep {
    public var floats: [CGFloat] { flatMap(\.floats) }
}

final public class GradientPIX: PIXGenerator, BodyViewRepresentable {
    
    override public var shaderName: String { return "contentGeneratorGradientPIX" }
    
    public var bodyView: UINSView { pixView }
    
    // MARK: - Public Types
    
    public enum Direction: String, Codable, CaseIterable, Floatable {
        case horizontal
        case vertical
        case radial
        case angle
        var index: Int {
            switch self {
            case .horizontal: return 0
            case .vertical: return 1
            case .radial: return 2
            case .angle: return 3
            }
        }
        public var floats: [CGFloat] { [CGFloat(index)] }
    }
    
    // MARK: - Public Properties
    
    @Live public var direction: Direction = .vertical
    @Live public var scale: CGFloat = 1.0
    @Live public var offset: CGFloat = 0.0
    @Live public var position: CGPoint = .zero
    @Live public var extendRamp: ExtendMode = .hold
    @Live public var colorSteps: [ColorStep] = [ColorStep(0.0, .black), ColorStep(1.0, .white)]
    
    // MARK: - Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_direction, _scale, _offset, _position, _extendRamp, _colorSteps]
    }
    
    override public var values: [Floatable] {
        return [direction, scale, offset, position, position, extendRamp]
    }

    override public var uniformArray: [[CGFloat]] {
        colorSteps.map(\.floats)
    }
    
    public override var uniforms: [CGFloat] {
        return [CGFloat(direction.index), scale, offset, position.x, position.y, CGFloat(extendRamp.index)]
    }
    
    // MARK: - Life Cycle
    
    public required init(at resolution: Resolution = .auto(render: PixelKit.main.render)) {
        super.init(at: resolution, name: "Gradient", typeName: "pix-content-generator-gradient")
    }
    public convenience init(at resolution: Resolution = .auto(render: PixelKit.main.render),
                            direction: Direction = .vertical,
                            colorSteps: [ColorStep] = [ColorStep(0.0, .black), ColorStep(1.0, .white)]) {
        self.init(at: resolution)
        self.direction = direction
        self.colorSteps = colorSteps
    }
    
    // MARK: - Property Funcs
    
    public func pixScale(_ value: CGFloat) -> GradientPIX {
        scale = value
        return self
    }
    
    public func pixOffset(_ value: CGFloat) -> GradientPIX {
        offset = value
        return self
    }
    
    public func pixPosition(x: CGFloat = 0.0, y: CGFloat = 0.0) -> GradientPIX {
        position = CGPoint(x: x, y: y)
        return self
    }
    
    public func pixExtendRamp(_ value: ExtendMode) -> GradientPIX {
        extendRamp = value
        return self
    }
    
}

public extension NODEOut {
    
    func pixGradientMap(from firstColor: PixelColor, to lastColor: PixelColor) -> LookupPIX {
        let lookupPix = LookupPIX()
        lookupPix.name = "gradientMap:lookup"
        lookupPix.inputA = self as? PIX & NODEOut
        let resolution: Resolution = PixelKit.main.render.bits == ._8 ? ._256 : ._8192
        let gradientPix = GradientPIX(at: .custom(w: resolution.w, h: 1))
        gradientPix.name = "gradientMap:gradient"
        gradientPix.colorSteps = [ColorStep(0.0, firstColor), ColorStep(1.0, lastColor)]
        lookupPix.inputB = gradientPix
        return lookupPix
    }
    
}
