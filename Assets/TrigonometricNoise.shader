
Shader "Custom/TrigonometricNoise"
{
    Properties
    {
        _ColorA ("ノイズの色1", Color) = (0.02, 0.02, 0.08, 5)
        _ColorB ("ノイズの色2", Color) = (10, 50, 10, 1)
        _Scale ("ノイズの細かさ", Range(1, 30)) = 8
        _Speed ("変化速度", Range(0, 5)) = 3
        _Contrast ("ノイズのコントラスト", Range(0.01, 0.5)) = 0.15
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
                float4 _ColorA;
                float4 _ColorB;
                float _Scale;
                float _Speed;
                float _Contrast;
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
                float2 p = i.uv * _Scale;
                float time = _Time.y * _Speed;

                // 波1：横方向の変化
                float n1 = sin(
                    p.x * 1.7
                    + sin(p.y * 1.3 + time) * 1.4
                );

                // 波2：縦方向の変化
                float n2 = cos(
                    p.y * 2.1
                    - cos(p.x * 1.1 - time * 0.7) * 1.3
                );

                // 波3：斜め方向の変化
                float n3 = sin(
                    (p.x + p.y) * 2.4
                    + sin(p.x * 0.7 - p.y * 1.8 + time)
                    * 1.5
                );

                // 複数の三角関数を合成
                float noise = (n1 + n2 + n3) / 3.0;

                // -1～1 を 0～1 に変換
                float value = noise * 0.5 + 0.5;

                // コントラストを調整
                value = smoothstep(
                    0.5 - _Contrast,
                    0.5 + _Contrast,
                    value
                );

                // ノイズの値を色に変換
                float3 color = lerp(
                    _ColorA.rgb,
                    _ColorB.rgb,
                    value
                );

                return half4(color, 1.0);
            }

            ENDHLSL
        }
    }
}