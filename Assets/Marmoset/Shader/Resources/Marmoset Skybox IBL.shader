// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Hidden/Marmoset/Skybox IBL" {
Properties {
	//_SkyCubeIBL ("Cubemap", Cube) = "white" {}
}

SubShader {
	Tags { "Queue"="Background" "RenderType"="Background" }
	Cull Off ZWrite Off Fog { Mode Off }

	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		//gamma-correct sampling permutations
		#pragma multi_compile MARMO_LINEAR MARMO_GAMMA
				
		#define MARMO_HQ
		
		#ifndef SHADER_API_GLES
			#define MARMO_SKY_ROTATION
		#endif
		
		#include "UnityCG.cginc"
		
		#include "../MarmosetMobile.cginc"
		#include "../MarmosetCore.cginc"

		samplerCUBE _SkyCubeIBL;
		half4 		_ExposureIBL;
		float4x4	_SkyMatrix;
		
		struct appdata_t {
			float4 vertex : POSITION;
			float4 texcoord : TEXCOORD0;
		};

		struct v2f {
			float4 vertex : POSITION;
			float4 texcoord : TEXCOORD0;
		};

		v2f vert (appdata_t v)
		{
			v2f o;
			o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
			#ifdef MARMO_SKY_ROTATION
			o.texcoord.xyz = mulVec3(_SkyMatrix, v.texcoord.xyz);
			#else
			o.texcoord.xyz = v.texcoord.xyz;
			#endif
			return o;
		}

		half4 frag (v2f i) : COLOR
		{
			half4 col = texCUBE(_SkyCubeIBL, i.texcoord);
			col.rgb = fromRGBM(col)*_ExposureIBL.z;
			col.a = 1.0;
			return col;
		}
		ENDCG 
	}
} 	


SubShader {
	Tags { "Queue"="Background" "RenderType"="Background" }
	Cull Off ZWrite Off Fog { Mode Off }
	Color [_Tint]
	Pass {
		SetTexture [_Tex] { combine texture +- primary, texture * primary }
	}
}

Fallback Off

}
