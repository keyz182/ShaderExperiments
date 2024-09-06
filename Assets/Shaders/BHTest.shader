shader "Unlit/BHTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UVCenterOffset("UVCenterOffset", Vector) = (0,0,0,0)
		_Rad("Radius", Range(0, 10)) = 1
		_BlackR1("black_r1", Range(0, 1)) = 0.05
		_BlackR2("black_r2", Range(0, 1)) = 0.15
    }

        SubShader
    {
       Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100

        GrabPass{ "_GrabTexture" }

        Pass
            {
                ZTest On
                ZWrite Off
                Blend One Zero
                Lighting Off
                Fog{ Mode Off }
 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 uv2 : TEXCOORD1;
                float4 uv3 : TEXCOORD2;
            };

            struct v2f
            {
                //our vertex position after projection
                float4 vertex : SV_POSITION;

                float2 uv_MainTex : TEXCOORD0;
                float4 GrabTexUV : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _GrabTexture;
            uniform float _Rad;
            
		    uniform float _BlackR1;
		    uniform float _BlackR2;
            
            half _Magnification;
            float4 _UVCenterOffset;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.uv_MainTex = v.uv;
                //the UV coordinate of our object's center on the GrabTexture
                // float4 uv_center = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0, 0, 0, 1)));
                float4 uv_center = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0, 0, 0, 1)));

                uv_center += _UVCenterOffset;
                //the vector from uv_center to our UV coordinate on the GrabTexture
                float4 uv_diff = ComputeGrabScreenPos(o.vertex) - uv_center;
                o.GrabTexUV = uv_center + uv_diff;
                return o;
            }

            fixed4 frag(v2f i) : COLOR
            {
                //fixed4 mainTex = tex2D(_MainTex, i.uv_MainTex);
                //fixed4 bg = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabTexUV));
                fixed4 c;
                
                float _dist = length(ObjSpaceViewDir(i.GrabTexUV));
                
			    float aspectRatio = _ScreenParams.x / _ScreenParams.y;
			    float2 balanced = i.uv_MainTex - i.GrabTexUV;
			    balanced.x *= aspectRatio;
			    float distance = length(balanced);
			    float2 balanced_n = balanced / distance;

                float2 pos = i.GrabTexUV;
				pos.x = pos.x * _ScreenParams.x;
				pos.y = pos.y * _ScreenParams.y;
				float scaled = distance * _dist / _Rad;
				float3 rayDirection = float3(0, 0, 1);
				float3 surfaceNormal = normalize(float3(balanced_n, scaled * scaled));
				float3 newBeam = refract(rayDirection, surfaceNormal, 0.38);
				float2 offset = float2(newBeam.x, newBeam.y) * 200;
                float2 newPos = pos +  offset;
				c = tex2D(_GrabTexture, newPos / _ScreenParams);
				c *= length(newBeam);
				c.a = 1.0f;

                if(_BlackR1 < distance && distance < _BlackR2)
                {
                    c = c * (distance - _BlackR1) / (_BlackR2 - _BlackR1);
                }

                if(distance < _BlackR1)
                {
                    c = float4(0,0,0,0);
                }
                
                return c;
            }
            ENDCG
        }
    }
}