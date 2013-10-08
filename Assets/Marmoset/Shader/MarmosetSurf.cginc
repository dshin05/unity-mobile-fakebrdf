// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

#ifndef MARMOSET_SURF_CGINC
#define MARMOSET_SURF_CGINC

void MarmosetSurf(Input IN, inout MarmosetOutput OUT) {
	#define uv_diff IN.uv_MainTex
	#define uv_spec IN.uv_MainTex
	#define uv_bump IN.uv_MainTex
	#define uv_glow IN.uv_MainTex

	//DIFFUSE
	#if defined(MARMO_DIFFUSE_DIRECT) || defined(MARMO_DIFFUSE_IBL)
		half4 diff = tex2D( _MainTex, uv_diff );
		diff *= _Color;
		//camera exposure is built into OUT.Albedo
		diff.rgb *= _ExposureIBL.w;
		OUT.Albedo = diff.rgb;
		OUT.Alpha = diff.a;
		#ifdef MARMO_PREMULT_ALPHA
			OUT.Albedo *= diff.a;
		#endif
	#else
		OUT.Albedo = half3(0.0,0.0,0.0);
		OUT.Alpha = 1.0;
	#endif
	
	//NORMALS
	#ifdef MARMO_NORMALMAP
		float3 N = UnpackNormal(tex2D(_BumpMap,uv_bump));
		#ifdef MARMO_HQ
			N = normalize(N);
		#endif
		OUT.Normal = N; //N is in tangent-space
	#else
		//OUT.Normal is not modified when not normalmapping
		float3 N = OUT.Normal; //N is in world-space
		#ifdef MARMO_HQ
			N = normalize(N);
		#endif
	#endif
	
	//SPECULAR
	#if defined(MARMO_SPECULAR_DIRECT) || defined(MARMO_SPECULAR_IBL)
		half4 spec = tex2D(_SpecTex, uv_spec);
		float3 E = IN.viewDir; //E is in whatever space N is
		#ifdef MARMO_HQ
			E = normalize(E);
			half fresnel = splineFresnel(N, E, _SpecInt, _Fresnel);
		#else
			half fresnel = fastFresnel(N, E, _SpecInt, _Fresnel);		
		#endif
		
		//camera exposure is built into OUT.Specular
		spec.rgb *= _SpecColor.rgb * fresnel * _ExposureIBL.w;
		OUT.Specular = spec.rgb;
		half glossLod = glossLOD(spec.a, _Shininess);
		OUT.Gloss = glossExponent(glossLod);
		//conserve energy by dividing out specular integral
		OUT.Specular *= specEnergyScalar(OUT.Gloss);
	#endif
	
	//SPECULAR IBL
	#ifdef MARMO_SPECULAR_IBL
		#ifdef MARMO_NORMALMAP
			float3 R = WorldReflectionVector(IN, OUT.Normal);
		#else 
			float3 R = IN.worldRefl;
		#endif
		#ifdef MARMO_SKY_ROTATION
			R = mulVec3(_SkyMatrix,R); //per-fragment matrix multiply, expensive
		#endif
		#ifdef MARMO_MIP_GLOSS
			half3 specIBL = glossCubeLookup(_SpecCubeIBL, R, glossLod);
		#else
			half3 specIBL = specCubeLookup(_SpecCubeIBL, R)*spec.a;
		#endif
		OUT.Emission += specIBL.rgb * spec.rgb * _ExposureIBL.y;
	#endif
	
	//DIFFUSE IBL
	#ifdef MARMO_DIFFUSE_IBL
		N = WorldNormalVector(IN,N); //N is in world-space
		#ifdef MARMO_SKY_ROTATION
			N = mulVec3(_SkyMatrix,N); //per-fragment matrix multiply, expensive
		#endif
		half3 diffIBL = diffCubeLookup(_DiffCubeIBL, N);
		OUT.Emission += diffIBL * diff.rgb * _ExposureIBL.x;
	#endif
	
	
	//GLOW
	#ifdef MARMO_GLOW
		half4 glow = tex2D(_Illum, uv_glow);
		glow.rgb *= _GlowColor.rgb;
		glow.rgb *= _GlowStrength;
		glow.a *= _EmissionLM;
		glow.rgb += OUT.Albedo * glow.a;
		OUT.Emission += glow.rgb * _ExposureIBL.w;
	#endif
}

#endif