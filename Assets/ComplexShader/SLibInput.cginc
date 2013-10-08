
#ifdef SLIB_DIFFUSE
	half4 _MainCol;
	sampler2D _MainTex;
#else
	half4 _MainCol;
#endif

#ifdef SLIB_DIFFUSE_TEXONLY
	sampler2D _MainTex;
#endif

#ifdef SLIB_NORMAL
	sampler2D _BumpMap;
#endif

#ifdef SLIB_SPECULAR
	half4 _SpecCol;
	half _SpecPow; 
	sampler2D _SpecTex;
#endif

#ifdef SLIB_SPECULAR_NOTEX
	half4 _SpecCol;
	half _SpecPow;
#endif

#ifdef SLIB_RIMLIGHT
	half4 _RimCol;
	half _RimPow;
	half _RimMul;
#endif

#ifdef SLIB_REFLECTION
	samplerCUBE _Cube;
#endif

#ifdef SLIB_IBL
	half _Exposure;
	samplerCUBE _CubeIBL;
#endif

#ifdef SLIB_HALFLAMBERT
	half _HalfLambert;
#endif

#ifdef SLIB_BRDF
	sampler2D _BRDF;
#endif

struct Input {
	float2 uv_MainTex;
	
	#ifdef SLIB_IBL
		float3 worldNormal; //internal, required for the WorldNormalVector macro
	#endif
	
		float3 viewDir;
	
	#ifdef SLIB_REFLECTION
		float3 worldRefl; //internal, required for the WorldReflVector macro
	#endif
	INTERNAL_DATA
};

struct SLibOutput {
	half3 Albedo;	//diffuse map RGB
	half Alpha;		//diffuse map A
	half3 Normal;	//world-space normal
	half3 Emission;	//contains IBL contribution
	
	#ifdef SLIB_SPECULAR
		half3 Specular;	//contains RGB specular map
		half Gloss;		//specular exponent
	#else
		half Specular;	//required by Unity
	#endif
	
	#ifdef SLIB_RIMLIGHT
		half3 RimLight;
	#endif
	
	#ifdef SLIB_REFLECTION
		half3 Reflection;
	#endif
	
	#ifdef SLIB_IBL
		half3 IBL;
	#endif
};