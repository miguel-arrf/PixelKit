//
//  FlarePIX.swift
//  PixelKit
//
//  Created by Anton Heestand on 2019-03-25.
//  Copyright © 2019 Hexagons. All rights reserved.
//


import RenderKit
import Foundation

public class FlarePIX: PIXSingleEffect {
    
    override open var shaderName: String { return "effectSingleFlarePIX" }
    
    override public var shaderNeedsAspect: Bool { return true }
    
    // MARK: - Public Properties
    
    public var scale: CGFloat = 0.25
    public var count: LiveInt = LiveInt(6, min: 3, max: 12)
    public var angle: CGFloat = 0.25
    public var threshold: CGFloat = 0.95
    public var brightness: CGFloat = CGFloat(1.0, max: 2.0)
    public var gamma: CGFloat = 0.25
    public var color: PXColor = .orange
    public var rayRes: LiveInt = LiveInt(32, min: 8, max: 64)
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [scale, count, angle, threshold, brightness, gamma, color, rayRes]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init(name: "Flare", typeName: "pix-effect-single-flare")
    }
    
}

public extension NODEOut {
    
    func _flare() -> FlarePIX {
        let flarePix = FlarePIX()
        flarePix.name = ":flare:"
        flarePix.input = self as? PIX & NODEOut
        return flarePix
    }
    
}
