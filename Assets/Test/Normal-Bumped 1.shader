Shader "Dongwon/MatcapTest" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_MatCap ("MatCap (RGB)", 2D) = "white" {}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 300

CGPROGRAM
#pragma surface surf Lambert vertex:vert 

sampler2D _MainTex;
sampler2D _BumpMap;
sampler2D _MatCap;
fixed4 _Color;

struct Input {
	//float2 uv_MainTex;
	float2 uv_BumpMap;
	half2 uv_MainTex : TEXCOORD0;
	float2 matcapUV;
};

void vert (inout appdata_full v, out Input o)
		{
			o.matcapUV = float2(dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal),dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal)) * 0.5 + 0.5;
		}
		
void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	half2 capCoord = half2(dot(i.c0, normals), dot(i.c1, normals));
					float4 mc = tex2D(_MatCap, capCoord*0.5+0.5);
	o.Albedo = c.rgb * mc  * 2.0;
	o.Alpha = c.a;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
}
ENDCG  
}

FallBack "Diffuse"
}
