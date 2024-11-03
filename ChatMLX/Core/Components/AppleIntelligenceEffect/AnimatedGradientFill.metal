//
// AnimatedGradientFill.metal
// Inferno https://github.com/twostraws/Inferno/blob/main/Sources/Inferno/Shaders/Transformation/AnimatedGradientFill.metal
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 animatedGradientFill(float2 position, half4 color, float2 size, float time) {
    half2 uv = half2(position / size) * 2.0h - 1.0h;
    half angle = atan2(uv.y, uv.x) + time;
    half3 sinValues = abs(sin(half3(angle, angle + 2.0h, angle + 4.0h)));
    return half4(sinValues, 1.0h) * color.a;
}
