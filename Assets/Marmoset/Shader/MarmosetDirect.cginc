// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

#ifndef MARMOSET_DIRECT_CGINC
#define MARMOSET_DIRECT_CGINC

half4 LightingMarmosetDirect( MarmosetOutput s, half3 lightDir, half3 viewDir, half atten ) {
	half4 frag = half4(0.0,0.0,0.0,1.0);
	
	#if defined(MARMO_DIFFUSE_DIRECT) || defined(MARMO_SPECULAR_DIRECT)
		half3 L = lightDir;
		half3 N = s.Normal;
		#ifdef MARMO_HQ
			L = normalize(L);
		#endif
	#endif
		
	#ifdef MARMO_DIFFUSE_DIRECT
		half dp = dot(N,L);
		dp = saturate(dp);
		half3 diff = (atten * 2.0 * dp) * s.Albedo.rgb; //*2.0 to match Unity
		frag.rgb = diff * _LightColor0.rgb;
		frag.a = s.Alpha;
	#endif
	
	#ifdef MARMO_SPECULAR_DIRECT
		half3 E = viewDir;
		half3 H = normalize(E+L);
		float specRefl = saturate(dot(N,H));
		half3 spec = pow(specRefl, s.Gloss);
		#ifdef MARMO_DIFFUSE_DIRECT
			spec *= saturate(10.0*dp);	//self-shadowing blinn
		#else
			spec *= saturate(10.0*dot(N,L));
		#endif
		spec *= _LightColor0.rgb;
		spec *= atten;
		spec *= 0.5; //match unity
		frag.rgb += spec*s.Specular;
	#endif

	return frag;
}

#endif