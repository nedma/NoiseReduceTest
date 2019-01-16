Shader "Test/Checkerboard"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_CheckerboardSize("CheckerboardSize", Range(0, 20)) = 2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			int _CheckerboardSize;

			float3 checker(in float u, in float v)
			{
				float fmodResult = fmod(floor(_CheckerboardSize * u) + floor(_CheckerboardSize * v), 2.0);

				// sign: Returns -1 if x is less than zero; 0 if x equals zero; and 1 if x is greater than zero.
				float fin = max(sign(fmodResult), 0.0);
				return fin;
			}

			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);



				col.rgb *= checker(i.uv.x, i.uv.y);

				return col;
			}
			ENDCG
		}
	}
}
