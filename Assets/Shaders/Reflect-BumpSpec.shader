Shader "Reflective/Bumped Specular test" {
Properties {
	_HalfLambert ("HalfLambert", Range (0.3, 15.0)) = 0.5
	_MainCol ("Main Color", Color) = (1,1,1,1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_MainTex ("Base (RGB) RefStrGloss (A)", 2D) = "white" {}
	_Ramp ("Ramp", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "" { TexGen CubeReflect }
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_RimColor ("Ref Color", Color) = (1,1,1,0.0)
	_RimPower ("Ref IOR", Range(0.5,8.0)) = 3.0
    _RimMultiply ("Ref Multiplier", Range(1.0,2.0)) = 1.0
}

SubShader {
	Tags { "RenderType"="Opaque" }
	
	CGPROGRAM
	#pragma surface surf MetalBumped
	#pragma target 3.0

	sampler2D _MainTex;
	sampler2D _BumpMap;
	samplerCUBE _Cube;
	sampler2D _Ramp;

	fixed4 _MainCol;
	fixed4 _RimColor;
	fixed _Shininess;
	fixed _RimPower;
    fixed _RimMultiply;
    fixed _HalfLambert;
    
	struct Input 
	{
		float2 uv_MainTex;
		float2 uv_BumpMap;
		float3 worldRefl;
		fixed3 viewDir;
		INTERNAL_DATA
	};

	struct SurfaceOutputMetalBumped
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

	inline fixed4 LightingMetalBumped (SurfaceOutputMetalBumped s, fixed3 lightDir, fixed3 viewDir, fixed atten)
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
			fixed diff = pow((nl * 0.5 + 0.5), _HalfLambert) * light;
			
			//Ramp Shading
			fixed3 ramp = tex2D (_Ramp, fixed2(ne, diff)).rgb;
			
			//Simple Specular(use diffuse map's alpha channel as specular power)
			//tuned for metalic specular
			fixed3 spec = pow (nh, _Shininess * 64) * _MainCol.a;
		
			//RimLight
			
			fixed4 c;
		
		c.rgb = ((s.Albedo * _MainCol.rgb) + (s.Refl+ spec) * s.RimLight * s.Alpha) * ramp * light;
		return c;
	}

void surf (Input IN, inout SurfaceOutputMetalBumped o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
		o.Albedo = tex.rgb;
		o.Alpha = tex.a;
		
		o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_MainTex));
		
		fixed rim = _RimMultiply - saturate(dot (normalize(IN.viewDir), o.Normal));
		float3 worldRefl = WorldReflectionVector (IN, o.Normal);
		o.Refl = (texCUBE (_Cube, worldRefl).rgb);
		o.RimLight = _RimColor.rgb * pow (rim, _RimPower); 
}
ENDCG
}

FallBack "Reflective/Bumped Diffuse"
}
