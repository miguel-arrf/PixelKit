//
//  KaleidoscopePIX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-18.
//  Open Source - MIT License
//


import RenderKit

public class KaleidoscopePIX: PIXSingleEffect {
    
    override open var shaderName: String { return "effectSingleKaleidoscopePIX" }
    
    // MARK: - Public Properties
    
    public var divisions: LiveInt = LiveInt(12, min: 1, max: 24)
    public var mirror: LiveBool = true
    public var rotation: CGFloat = CGFloat(0.0, min: -0.5, max: 0.5)
    public var position: CGPoint = .zero
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [divisions, mirror, rotation, position]
    }
    
    public required init() {
        super.init(name: "Kaleidoscope", typeName: "pix-effect-single-kaleidoscope")
        extend = .mirror
    }
    
}

public extension NODEOut {
    
    func _kaleidoscope(divisions: LiveInt = 12, mirror: LiveBool = true) -> KaleidoscopePIX {
        let kaleidoscopePix = KaleidoscopePIX()
        kaleidoscopePix.name = ":kaleidoscope:"
        kaleidoscopePix.input = self as? PIX & NODEOut
        kaleidoscopePix.divisions = divisions
        kaleidoscopePix.mirror = mirror
        return kaleidoscopePix
    }
    
}
