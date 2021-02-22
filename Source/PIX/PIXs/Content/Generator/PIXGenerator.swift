//
//  PIXGenerator.swift
//  PixelKit
//
//  Created by Anton Heestand on 2018-08-16.
//  Open Source - MIT License
//

import CoreGraphics
import MetalKit
import PixelColor
import RenderKit

open class PIXGenerator: PIXContent, NODEGenerator, NODEResolution {
    
    var _resolution: Resolution
    public var resolution: Resolution {
        set { _resolution = newValue; applyResolution { self.setNeedsRender() } }
        get { return _resolution * PIXGenerator.globalResMultiplier }
    }
    public static var globalResMultiplier: CGFloat = 1
    
    public var premultiply: Bool = true { didSet { setNeedsRender() } }
    override open var shaderNeedsAspect: Bool { return true }
    
    public var tileResolution: Resolution { pixelKit.tileResolution }
    public var tileTextures: [[MTLTexture]]?
    
    @available(*, deprecated, renamed: "backgroundColor")
    public var bgColor: PixelColor {
        get { backgroundColor }
        set { backgroundColor = newValue }
    }
    @Live public var backgroundColor: PixelColor = .black
    @Live public var color: PixelColor = .white
    
    open override var liveList: [LiveWrap] {
        [_backgroundColor, _color]
    }
    
    public required init(at resolution: Resolution = .auto(render: PixelKit.main.render)) {
        fatalError("please use init(at:name:typeName:)")
    }
    
    public init(at resolution: Resolution = .auto(render: PixelKit.main.render), name: String, typeName: String) {
        _resolution = resolution
        super.init(name: name, typeName: typeName)
        applyResolution { self.setNeedsRender() }
    }
    
    // MARK: - Property Funcs
    
    public func pixResolution(_ value: Resolution) -> PIXGenerator {
        resolution = value
        return self
    }
    
    public func pixColor(_ value: PixelColor) -> PIXGenerator {
        color = value
        return self
    }
    
    public func pixBackgroundColor(_ value: PixelColor) -> PIXGenerator {
        backgroundColor = value
        return self
    }
    
}
