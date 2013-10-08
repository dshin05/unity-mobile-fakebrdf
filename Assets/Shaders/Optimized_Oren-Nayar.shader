// BRDF Based Bobile Shader
// -Normal Mapping
// -Lookup Table for complex lighting


Shader "Dongwon/Optimized Oren-Nayar" 
{

	Properties 
	{
		_HalfLambert ("HalfLambert", Range (0.0, 5.0)) = 5.0
		_MainCol ("Base Color", Color) = (1, 1, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_BRDF ("BRDF", 2D) = "white" {}
	}
	
	
	SubShader 
	{ 
		Tags { "RenderType"="Opaque" }
		LOD 250
		
	CGPROGRAM
	#pragma surface surf MobileBRDF noforwardadd dualforward
	
	sampler2D _MainTex;
	sampler2D _BumpMap;
	sampler2D _BRDF;
	fixed _Shininess;
	fixed4 _MainCol;
	float _HalfLambert;
	
	inline fixed4 LightingMobileBRDF (SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
	{
	
	fixed3 light = (_LightColor0.rgb * atten * 2);
		
	//Calculate Vectors
		//Lambert
		fixed nl = dot(s.Normal, lightDir);
		fixed ne = dot(s.Normal, viewDir);
		fixed result = saturate(nl);
		fixed soft_rim = saturate(1 - ne / 2);
		fixed fakey = pow(1-result*soft_rim, 2);
		fixed fakey_magic = 0.62;
		
		fakey = fakey_magic - fakey * fakey_magic;
		fixed fakey_comp = lerp(result, fakey, 1 - _Shininess);
		
		//Simple Specular Vector
		fixed3 h = normalize ( lightDir + viewDir );
		fixed nh = max (0, dot (s.Normal, h)); 
		
		//HalfLambert
		fixed diff = pow((nl * 0.5 + 0.5), _HalfLambert) * light;
		
	//BRDF
		fixed3 BRDF = tex2D (_BRDF, fixed2(ne, diff)).rgb;
		fixed3 spec = pow (nh, _Shininess * 128) * _MainCol.a * s.Alpha;
		
	//Composition
		fixed3 BRDFComp = (s.Albedo * _MainCol.rgb * BRDF); 
		
		
		
		fixed4 c;
		c.rgb = fakey_comp + spec;
		// (BRDFComp + spec) * light;
		//( (BRDFComp) + (LUT * spec) ) ;
		c.a = 0.0;
		return c;
	}
		
	
	struct Input 
	{
		float2 uv_MainTex;
		float3 viewDir;
	};
	
	
	void surf (Input IN, inout SurfaceOutput o) {
		fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
		o.Albedo = tex.rgb;
		o.Alpha = tex.a;
		o.Normal = UnpackNormal (tex2D(_BumpMap, IN.uv_MainTex));
	}
	
	ENDCG
	
	}

	FallBack "Mobile/VertexLit"
}
