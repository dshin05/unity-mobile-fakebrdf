// BRDF Based Bobile Shader
// -Cubemap Reflection
// -Lookup Table for complex lighting
Shader "Dongwon/BRDF/1. Basic/Reflfective"
{
	Properties 
	{
		//_HalfLambert ("HalfLambert", Range (0.3, 3.0)) = 0.5
		_MainCol ("Base Color", Color) = (0.25, 0.25, 0.25)
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_Ramp ("Ramp", 2D) = "white" {}
		_Cube ("Reflection", CUBE) = "" {}
		//_BumpMap ("Bumpmap", 2D) = "bump" {} //Cannot use Bump
		_RimColor ("Ref Color", Color) = (1,1,1,0.0)
		_Shininess ("Ref Shininess", Range (0.03, 1)) = 0.078125
        _RimPower ("Ref IOR", Range(0.5,8.0)) = 3.0
        _RimMultiply ("Ref Multiplier", Range(1.0,2.0)) = 1.0
	}
	
	SubShader 
	{
	
	Tags { "RenderType" = "Opaque" }
	
	CGPROGRAM
	#pragma surface surf MobileHL noambient
	
	struct Input 
	{
		fixed2 uv_MainTex;
		fixed3 viewDir;
		fixed3 worldRefl;
		INTERNAL_DATA
	};
	
	struct SurfaceOutputMobileHL
	{
		fixed3 Albedo;
		fixed3 Normal;
		fixed Emission;
		fixed Specular;
		fixed Gloss;
		fixed Alpha;
		fixed3 Refl;
		fixed3 RimLight;
	};
	
	sampler2D _MainTex;
	//sampler2D _BumpMap;
	sampler2D _Ramp;
	samplerCUBE _Cube;
	fixed4 _MainCol;
	fixed _Shininess;
	fixed4 _RimColor;
    fixed _RimPower;
    fixed _RimMultiply;
    //fixed _HalfLambert;
	
	inline fixed4 LightingMobileHL (SurfaceOutputMobileHL s, fixed3 lightDir, fixed3 viewDir, fixed atten)
	{
		fixed3 light = (_LightColor0.rgb * atten * 2);
		
		//Calculate Vectors
			//for Diffuse
			fixed nl = max (0, dot(s.Normal, lightDir));
			fixed ne = max (0, dot(s.Normal, viewDir));
		
			//for Sepcular
			fixed3 h = normalize ( lightDir + viewDir ); 
			fixed nh = max (0, dot (s.Normal, h)); 		
		
		//Composition
			//Half-Lamberted Diffuse
			//fixed diff = pow((nl * 0.5 + 0.5), _HalfLambert);
			
			//Ramp Shading
			fixed3 ramp = tex2D (_Ramp, fixed2(ne, nl)).rgb;
			
			//Simple Specular(use diffuse map's alpha channel as specular power)
			//tuned for metalic specular
			fixed3 spec = pow (nh, _Shininess * 64) * _MainCol.a * s.Alpha * _RimColor.rgb;
			
			//Reflection(fake IOR using frensel)
			fixed3 refl = s.Refl  * s.Alpha;
		
			//RimLight
			
			fixed4 c;
		
		c.rgb = ((s.Albedo * _MainCol.rgb) + spec + (refl * s.RimLight) * ramp) * light;
		return c;
	}
				
	void surf (Input IN, inout SurfaceOutputMobileHL o) 
	{
		fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
		o.Albedo = tex.rgb;
		o.Alpha = tex.a;
		
		//o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_MainTex));
		
		fixed rim = _RimMultiply - saturate(dot (normalize(IN.viewDir), o.Normal));
		o.Refl = (texCUBE (_Cube, IN.worldRefl).rgb);
		o.RimLight = _RimColor.rgb * pow (rim, _RimPower); 
	}
	
	ENDCG
	
	} 
	
    Fallback "Diffuse"
    
}