half4 LightingSLibFrag( SLibOutput s, half3 lightDir, half3 viewDir, half atten ) 
{
	
	half3 frag;
	frag = s.Albedo;
	
	//Lighting Calculation
	
	//Unlit
		#ifdef SLIB_UNLIT
			//do nothing ;) 
		#endif
		
	//HalfLambert
		#ifdef SLIB_HALFLAMBERT
			half NdotL = pow(dot(s.Normal, lightDir) * 0.5 + 0.5, _HalfLambert);
			frag = frag * NdotL * _LightColor0.rgb * atten * 2;
		#endif
		
	//Lambertian
		#ifdef SLIB_LAMBERT
			//or just use original lambertian
			half NdotL = max(0, dot(s.Normal, lightDir));
			frag = frag * NdotL * _LightColor0.rgb * atten * 2;
		#endif
	
	//IBL
		#ifdef SLIB_IBL
			//Add world-normal cubemap to diffuse lighting
			frag = (frag + s.IBL * _Exposure) * _LightColor0.rgb * atten * 2;
		#endif
				
	//Specular Calculation
		#ifdef SLIB_SPECULAR
			half3 h = normalize ( lightDir + viewDir ); 
			half nh = max (0, dot (s.Normal, h));
			
			half3 spec = s.Specular * pow (nh, _SpecPow * 64 * s.Gloss) * _SpecCol.rgb;
			spec = _LightColor0.rgb * spec;
			
			frag = frag + spec;
		#endif
		
		//Without specular lookup texture
		#ifdef SLIB_SPECULAR_NOTEX
			half3 h = normalize ( lightDir + viewDir ); 
			half nh = max (0, dot (s.Normal, h));
			
			half3 spec = pow (nh, _SpecPow * 64) * _SpecCol.rgb;
			spec = _LightColor0.rgb * spec;
			
			frag = frag + spec;
		#endif
		
	
	//Reflection	
		#ifdef SLIB_REFLECTION
			frag = frag + s.Reflection * _LightColor0.rgb; //internal, required for the WorldReflVector macro
		#endif
		
	//Rim Light	
		#ifdef SLIB_RIMLIGHT
			frag = frag + s.RimLight * _LightColor0.rgb;;
		#endif
		
	//BRDF Calculation
		#ifdef SLIB_BRDF
			half ne = max (0, dot(s.Normal, viewDir));
			frag = tex2D (_BRDF, half2(ne, frag)).rgb;
		#endif

		
	half4 c;
	c.rgb = frag;
	c.a = s.Alpha;

	return c;
}