// BRDF Based Bobile Shader
// -Normal Mapping
// -Lookup Table for complex lighting


Shader "Dongwon/BRDF/2. HalfLamberted/Bumped Specular" 
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
	#pragma surface surf MobileBRDF
	
	sampler2D _MainTex;
	sampler2D _BumpMap;
	sampler2D _BRDF;
	fixed _Shininess;
	fixed4 _MainCol;
	float _HalfLambert;
	
	inline fixed4 LightingMobileBRDF (SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
	{
	
	//fixed3 light = ( * );
		
	//Calculate Vectors
		//Lambert
		fixed nl = dot(s.Normal, lightDir);
		fixed ne = max (0, dot(s.Normal, viewDir));
		
		//Simple Specular Vector
		fixed3 h = normalize ( lightDir + viewDir );
		fixed nh = max (0, dot (s.Normal, h)); 
		
		//HalfLambert
		fixed diff = pow((nl * 0.5 + 0.5), _HalfLambert);
		
	//BRDF
		fixed3 BRDF = tex2D (_BRDF, fixed2(ne, diff)).rgb;
		fixed3 spec = pow (nh, _Shininess * 128) * _MainCol.a * s.Alpha;
		
	//Composition
		fixed3 BRDFComp = (s.Albedo * _MainCol.rgb * BRDF); 
		
		fixed4 c;
		c.rgb = (BRDFComp + _LightColor0.rgb * spec) * (atten * 2);
		c.a = _MainCol.a;
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
		o.Alpha = _MainCol.a;
		o.Normal = UnpackNormal (tex2D(_BumpMap, IN.uv_MainTex));
	}
	
	ENDCG
	
	}

	FallBack "Mobile/VertexLit"
}
