Shader "Hidden/NewImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 Swirl(sampler2D tex, inout float2 uv) {
                float radius = _ScreenParams.x;
                float2 center = float2(_ScreenParams.x, _ScreenParams.y);
                float2 texSize = float2(_ScreenParams.x / 0.5, _ScreenParams.y / 0.5);
                float2 tc = uv * texSize;
                tc -= center;
                float dist = length(tc)*2;
                float angle = sin(_Time.y * 1.1);
                if (dist < radius)
                {
                    float percent = (radius - dist) / radius;
                    float theta = percent * percent * angle * 28.0;
                    float s = sin(theta);
                    float c = cos(theta);
                    tc = float2(dot(tc, float2(c, -s)), dot(tc, float2(s, c)));
                }
                tc += center;
                
                return tex2D(tex, tc / texSize);
            }

            fixed4 frag (v2f i) : SV_Target
            {
			    fixed4 c = Swirl(_MainTex, i.uv);
                return c;
            }
            ENDCG
        }
    }
}
