Shader "Custom/HueShader"
{
    Properties
    {
        _Hue ("êFëä", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
        }

        Pass
        {
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float _Hue;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
            };

            Varyings vert(Attributes v)
            {
                Varyings o;
                o.positionHCS =
                    TransformObjectToHClip(v.positionOS.xyz);
                return o;
            }

            // HSVÇ©ÇÁRGBÇ÷ÇÃïœä∑
            float3 HSVtoRGB(float3 c)
            {
                float3 p = abs(
                    frac(c.xxx + float3(0, 2.0 / 3.0, 1.0 / 3.0))
                    * 6.0 - 3.0
                );

                return c.z * lerp(
                    float3(1, 1, 1),
                    saturate(p - 1.0),
                    c.y
                );
            }

            half4 frag(Varyings i) : SV_Target
            {
                float3 hsv = float3(_Hue, 1.0, 1.0);
                float3 rgb = HSVtoRGB(hsv);

                return half4(rgb, 1.0);
            }

            ENDHLSL
        }
    }
}