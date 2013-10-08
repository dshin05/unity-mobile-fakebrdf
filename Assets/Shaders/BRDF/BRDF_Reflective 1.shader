// BRDF Based Bobile Shader
// -Cubemap Reflection
// -Lookup Table for complex lighting
Shader "Dongwon/IBL/Test"
{
	Properties 
	{
		_HalfLambert ("HalfLambert", Range (0.3, 13.0)) = 0.5
		_MainCol ("Base Color", Color) = (0.25, 0.25, 0.25)
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_Ramp ("Ramp", 2D) = "white" {}
		_Cube ("Reflection", CUBE) = "" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {} //Cannot use Bump
		_RimColor ("Ref Color", Color) = (1,1,1,0.0)
		_Shininess ("Ref Shininess", Range (0.03, 1)) = 0.078125
        _RimPower ("Ref IOR", Range(0.5,8.0)) = 3.0
        _RimMultiply ("Ref Multiplier", Range(1.0,2.0)) = 1.0
	}
	
	SubShader 
	{
	
	Tags { "RenderType" = "Opaque" }
	
	CGPROGRAM
	#pragma surface surf MobileHL
	
	struct Input 
	{
		half2 uv_MainTex;
		half3 viewDir;
		half3 worldRefl;
		half3 worldNormal;
		INTERNAL_DATA
	};
	
	struct SurfaceOutputMobileHL
	{
		half3 Albedo;
		half3 Normal;
		half Emission;
		half Specular;
		half Gloss;
		half Alpha;
		half3 Refl;
		half3 RimLight;
	};
	
	sampler2D _MainTex;
	sampler2D _BumpMap;
	//sampler2D _Ramp;
	samplerCUBE _Cube;
	half4 _MainCol;
	half _Shininess;
	half4 _RimColor;
    half _RimPower;
    half _RimMultiply;
    half _HalfLambert;
	
	inline half4 LightingMobileHL (SurfaceOutputMobileHL s, half3 lightDir, half3 viewDir, half atten)
	{
		half3 light = (atten * 2);
		
		//Calculate Vectors
			//for Diffuse
			half nl = max (0, dot(s.Normal, lightDir));
			half ne = max (0, dot(s.Normal, viewDir));
		
			//for Sepcular
			//half3 h = normalize ( lightDir + viewDir ); 
			//half nh = max (0, dot (s.Normal, h)); 		
		
		//Composition
			//Half-Lamberted Diffuse
			half diff = pow((nl * 0.5 + 0.5), _HalfLambert);
			
			//Ramp Shading
			//half3 ramp = tex2D (_Ramp, half2(ne, nl)).rgb;
			
			//Simple Specular(use diffuse map's alpha channel as specular power)
			//tuned for metalic specular
			//half3 spec = pow (nh, _Shininess * 64);
			
			//Reflection(fake IOR using frensel)
			half3 refl = s.Refl;
		
			//RimLight
			
			half4 c;
		
		c.rgb = _MainCol.rgb * diff * light + (s.Refl * _LightColor0.rgb);
		//((s.Albedo * _MainCol.rgb ) + (_LightColor0.rgb * (spec + refl * s.RimLight) ) * _RimColor.rgb * s.Alpha )  * ramp * light;
		c.a = s.Alpha;
		return c;
	}
				
	void surf (Input IN, inout SurfaceOutputMobileHL o) 
	{
		half4 tex = tex2D(_MainTex, IN.uv_MainTex);
		o.Albedo = tex.rgb;
		o.Alpha = tex.a;
		
		o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_MainTex));
		
		half rim = _RimMultiply - saturate(dot (normalize(IN.viewDir), o.Normal));
		o.Refl = (texCUBE (_Cube, IN.worldNormal).rgb);
		o.RimLight = _RimColor.rgb * pow (rim, _RimPower); 
	}
	
	ENDCG
	
	} 
	
    Fallback "Diffuse"
    
}