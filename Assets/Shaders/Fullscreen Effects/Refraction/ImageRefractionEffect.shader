// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'
// Upgrade NOTE: replaced 'texRECT' with 'tex2D'

Shader "Image Effects/Refraction"
{
	Properties
	{
		_SpeedStrength ("Speed (XY), Strength (ZW)", Vector) = (1, 1, 1, 1)
		_RefractTexTiling ("Refraction Tilefac", Float) = 1
		_RefractTex ("Refraction (RG), Colormask (B)", 2D) = "bump" {}
		_Color ("Color (RGB)", Color) = (1, 1, 1, 1)
		_MainTex ("Base (RGB) DON`T TOUCH IT! :)", RECT) = "white" {}
	}

	SubShader
	{
		Pass
		{
			ZTest Always Cull Off ZWrite Off

			Fog{Mode off}
			
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _RefractTex;
			uniform float4 _SpeedStrength;
			uniform float _RefractTexTiling;
			uniform float4 _Color;

			float4 frag (v2f_img i) : COLOR
			{
				float2 refrtc = float2(i.uv.x, i.uv.y)*_RefractTexTiling;
				float4 refract = tex2D(_RefractTex, refrtc+_SpeedStrength.xy*_Time.x);
				refract.rg = refract.rg*2.0-1.0;
				
				float4 original = tex2D(_MainTex, i.uv+refract.rg*_SpeedStrength.zw);
				
				float4 output = lerp(original, original*_Color, refract.b);
				output.a = original.a;
				
				return output;
			}
			ENDCG
		}
	}
	Fallback off
}