// Baisc Half Lambert shader

Shader "Dongwon/Basic/HalfLamberted Bumped Diffuse" {
Properties {
	_HalfLambert ("Half Lambert", Range(1, 5)) = 1
	_MainCol ("Base Color", Color) = (1, 1, 1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 250

CGPROGRAM
#pragma surface surf HalfLambert noforwardadd dualforward

sampler2D _MainTex;
sampler2D _BumpMap;
fixed _HalfLambert;
fixed4 _MainCol;

struct Input {
	float2 uv_MainTex;
};

fixed4 LightingHalfLambert (SurfaceOutput s, fixed3 lightDir, fixed atten) {
		  
		  fixed NL = dot (s.Normal, lightDir);
		  fixed diff = pow((NL * 0.5 + 0.5), _HalfLambert);
		  
		  fixed4 c;
		  c.rgb = s.Albedo * _MainCol.rgb * _LightColor0.rgb * (diff * atten * 2);
		  c.a = s.Alpha;
		  return c;
		}
		
void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = c.rgb;
	o.Alpha = c.a;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
}
ENDCG  
}

FallBack "Mobile/Diffuse"
}