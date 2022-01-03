//
//  PIXCustom.swift
//  PixelKit
//
//  Created by Anton Heestand on 2019-08-30.
//

import RenderKit
import Resolution
import Metal
import PixelColor

open class PIXCustom: PIXContent, NODECustom, CustomRenderDelegate {
    
    var customModel: PixelCustomModel {
        get { customModel as! PixelCustomModel }
        set { customModel = newValue }
    }
    
    override open var shaderName: String { return "contentResourcePIX" }
    
    // MARK: - Public Properties
    
    @LiveResolution("resolution") public var resolution: Resolution = ._128
    
    @available(*, deprecated, renamed: "backgroundColor")
    public var bgColor: PixelColor {
        get { backgroundColor }
        set { backgroundColor = newValue }
    }
    @LiveColor("backgroundColor") public var backgroundColor: PixelColor = .black
    
    public override var liveList: [LiveWrap] {
        [_backgroundColor, _resolution] + super.liveList
    }
    
    override open var values: [Floatable] { return [backgroundColor] }
    
    // MARK: - Life Cycle -
    
    init(model: PixelCustomModel) {
        self.resolution = model.resolution
        super.init(model: model)
        setupCustom()
    }
    
    @available(*, deprecated)
    public init(at resolution: Resolution = .auto, name: String, typeName: String) {
        self.resolution = resolution
        super.init(name: name, typeName: typeName)
        setupCustom()
    }
    
    public required init(at resolution: Resolution) {
        fatalError("please use init(model:)")
    }
    
    // MARK: - Live Model
    
    override func modelUpdateLive() {
        super.modelUpdateLive()
        
        resolution = customModel.resolution
        backgroundColor = customModel.backgroundColor
    }
    
    override func liveUpdateModel() {
        super.liveUpdateModel()
        
        customModel.resolution = resolution
        customModel.backgroundColor = backgroundColor
    }
    
    // MARK: - Setup
    
    func setupCustom() {
        customRenderDelegate = self
        customRenderActive = true
        applyResolution { [weak self] in
            self?.render()
        }
    }
    
    public func customRender(_ texture: MTLTexture, with commandBuffer: MTLCommandBuffer) -> MTLTexture? { return nil }
    
}
