Shader "Unlit/BlackHole"
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

            // Built-in properties
            sampler2D _MainTex;   float4 _MainTex_TexelSize;

            // Global access to uv data
            static v2f vertex_output;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv =  v.uv;
                return o;
            }

            float3 rotateY(float3 p, float ang)
            {
                float s = sin(ang);
                float c = cos(ang);
                return float3(c*p.x+s*p.z, p.y, -s*p.x+c*p.z);
            }

            float4 frag (v2f __vertex_output) : SV_Target
            {
                float2 uv = __vertex_output.uv/_ScreenParams.xy*2.-1.;
                uv.x *= _ScreenParams.x/_ScreenParams.y;
                
                float type = clamp(-sin(_Time.y+0.2)*8., -1., 1.);
                
                float a = _Time.y/3.;
                float3 ray = rotateY(float3(0., 0., -3.), a);
                float3 rv = rotateY(normalize(float3(uv.x, uv.y, 1.)), a);
                
                float3 em = 0.;
                bool hit = false;
                
                for (int i = 0;i<1000; i++)
                {
                    float st = length(ray)*0.01;
                    ray += normalize(rv)*st;
                    if (length(ray)<1.)
                    {
                        hit = true;
                        break;
                    }
                    
                    rv += -normalize(ray)*-type/exp(dot(ray, ray))*st;
                    em += st*smoothstep(1.5, 1.2, length(ray))*0.2;
                }
                
                float3 col = hit ? ((float3)type*0.5+0.5) : tex2D(_MainTex, normalize(rv)).rgb*0.8;
                col += float3(0.3, 0., 1.)*max(em-0.1, 0.);

                return float4(col, 1.);
            }
            ENDCG   
        }
    }
}
