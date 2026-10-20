
Shader "Custom/GamingColor"
{
    Properties
    {
        _Frequency ("”g‚Ì×‚©‚³", Float) = 10
        _Speed ("F‚Ì•Ï‰»‘¬“x", Float) = 2
        _Amplitude ("”g‚Ì‘å‚«‚³", Float) = 1
        _RainbowSpeed ("“øF‚Ì•Ï‰»‘¬“x", Float) = 1
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
                float _Frequency;
                float _Speed;
                float _Amplitude;
                float _RainbowSpeed;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            Varyings vert(Attributes v)
            {
                Varyings o;

                o.positionHCS =
                    TransformObjectToHClip(v.positionOS.xyz);

                o.uv = v.uv;

                return o;
            }

            half4 frag(Varyings i) : SV_Target
            {
                // ”g‚ğŒvZ
                float wave = sin(
                    (i.uv.x + i.uv.y * _Amplitude)
                    * _Frequency
                    - _Time.y * _Speed
                );

                // ”g‚Ì’l‚ğ0`1‚É•ÏŠ·
                float t = wave * 0.5 + 0.5;

                // UVÀ•W‚ÆŠÔ‚©‚ç“øF‚ÌˆÊ‘Š‚ğŒvZ
                float hue = frac(
                    t + _Time.y * _RainbowSpeed
                );

                // OŠpŠÖ”‚ÅRGB‚ğ¶¬
                float3 col = 0.5 + 0.5 * cos(
                    6.2831853 * (
                        hue + float3(0.0, 0.666667, 0.333333)
                    )
                );

                return half4(col, 1.0);
            }

            ENDHLSL
        }
    }
}
