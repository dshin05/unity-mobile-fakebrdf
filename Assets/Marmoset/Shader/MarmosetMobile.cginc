// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

#ifdef SHADER_API_D3D11_9X
	//texCUBElod not supported
	#undef MARMO_MIP_GLOSS
	
	//nothing fancy
	#ifdef MARMO_HQ 
	#undef MARMO_HQ
	#endif
#endif

//rules for mobile shader permutations				
#ifdef SHADER_API_MOBILE
	//no sRGB sampling
	#ifdef MARMO_LINEAR 
		#undef MARMO_LINEAR
		#define MARMO_GAMMA
	#endif
	
	//nothing fancy
	#ifdef MARMO_HQ 
	#undef MARMO_HQ
	#endif
	
	#ifdef MARMO_SKY_ROTATION 
	#undef MARMO_SKY_ROTATION
	#endif
	
	//texCUBElod is broken in Unity's iOS as of Unity 4.1, you may have to disable it here
	#ifdef MARMO_MIP_GLOSS
	//#undef MARMO_MIP_GLOSS
	#endif
#endif