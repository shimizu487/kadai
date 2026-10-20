
Shader "Custom/SineWave"
{
    Properties
    {
        _Color1 ("”g‚ÌF1", Color) = (0, 0.8, 1, 1)
        _Color2 ("”g‚ÌF2", Color) = (0.1, 0, 0.5, 1)
        _Frequency ("”g‚Ì×‚©‚³", Float) = 10
        _Speed ("”g‚Ì‘¬“x", Float) = 2
        _Amplitude ("”g‚Ì‘å‚«‚³", Float) = 1
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
                float4 _Color1;
                float4 _Color2;
                float _Frequency;
                float _Speed;
                float _Amplitude;
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
                // UVÀ•W‚ÆŠÔ‚©‚ç”g‚ğŒvZ
                float wave = sin(
                    (i.uv.x + i.uv.y * _Amplitude)
                    * _Frequency
                    - _Time.y * _Speed
                );

                // ”g‚Ì’l‚ğ0`1‚É•ÏŠ·
                float t = wave * 0.5 + 0.5;

                // 2F‚ğ”g‚Ì’l‚Å¬‚º‚é
                half4 col = lerp(_Color1, _Color2, t);

                return col;
            }

            ENDHLSL
        }
    }
}
