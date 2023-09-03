//
//  DepthCameraPIX.metal
//  PixelKit
//
//  Created by Anton Heestand on 2018-07-31.
//  Open Source - MIT License
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut{
    float4 position [[position]];
    float2 texCoord;
};

struct Uniforms {
    float flipX;
};


