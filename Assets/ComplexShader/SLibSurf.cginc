void SLibSurf(Input IN, inout SLibOutput o) 
{
	
	//Diffuse Mapping
	#ifdef SLIB_DIFFUSE
		half4 d = tex2D(_MainTex, IN.uv_MainTex);
		o.Albedo = d.rgb * _MainCol.rgb;
		o.Alpha = d.a * _MainCol.a;
	#else
		o.Albedo = _MainCol.rgb;
		o.Alpha = _MainCol.a;
	#endif
	
	//Normal Mapping
	#ifdef SLIB_NORMAL
		o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
	#endif 
	
	//Specular Mapping
	#ifdef SLIB_SPECULAR
		half4 s = tex2D(_SpecTex, IN.uv_MainTex);
		o.Specular = s.rgb;
		o.Gloss = s.a;
	#else
		o.Specular = _MainCol.a;
	#endif
	
	//Rim Lighting
	#ifdef SLIB_RIMLIGHT
		half rim = _RimMul - saturate(dot(normalize(IN.viewDir), o.Normal));
        o.RimLight = _RimCol.rgb * pow (rim, _RimPow);
	#endif
	
	#ifdef SLIB_REFLECTION
		float3 worldRefl = WorldReflectionVector (IN, o.Normal);
		o.Reflection = texCUBE(_Cube, worldRefl).rgb;
	#endif
	
	#ifdef SLIB_IBL
		float3 worldNormal = WorldNormalVector (IN, o.Normal);
		o.IBL = texCUBE(_CubeIBL, worldNormal).rgb;
	#endif
}