// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

#ifndef MARMOSET_CORE_CGINC
#define MARMOSET_CORE_CGINC
#define INV_2PI 0.15915494309189533576888376337251

//Color-correction
half3 toLinearApprox3(half3 c){ return c*c; }
half3 toLinear3(half3 c)      { return pow(c,2.2); }
half  toLinearFast1(half  c)  { half  c2 = c*c; return dot(half2(0.7532,0.2468),half2(c2,c*c2)); }
half3 toLinearFast3(half3 c)  { half3 c2 = c*c; return 0.7532*c2 + 0.2468*c*c2; }

half  toGammaApprox1(half c)	  { return sqrt(c); }
half3 toGammaApprox3(half3 c) { return sqrt(c); }
half  toGamma1(half c)		  { return pow(c,0.454545); }
half3 toGamma3(half3 c)		  { return pow(c,0.454545); }
half  toGammaFast1(half c)	{
	c = 1.0 - c;
	half c2 = c*c;
	half3 c16 = half3(c2*c2,c2,c);	//^4
	c16.x *= c16.x;					//^8
	c16.x *= c16.x;					//^16
	c16 = half3(1.0,1.0,1.0)-c16;
	return dot(half3(0.326999,0.249006,0.423995),c16);
}
half3 toGammaFast3(half3 c) {
	half3 one = half3(1.0,1.0,1.0);
	c = one - c;
	half3 c2 = c*c;
	half3 c16 = c2*c2;	//^4
	c16 *= c16;			//^8
	c16 *= c16;			//^16
	return  0.326999*(one-c16) + 0.249006*(one-c2) + 0.423995*(one-c);
}

float3 mulVec3( float4x4 m, float3 v ) {
	return m[0].xyz*v.x + (m[1].xyz*v.y + (m[2].xyz*v.z));
}

float3 mulVec3( float3x3 m, float3 v ) {
	return m[0].xyz*v.x + (m[1].xyz*v.y + (m[2].xyz*v.z));
}

float3 mulPoint3( float4x4 m, float3 p ) {
	return m[0].xyz*p.x + (m[1].xyz*p.y + (m[2].xyz*p.z + m[3].xyz));
}

half3 fromRGBM(half4 c)  {
	#ifdef MARMO_LINEAR
	//pull RGB is pulled to linear space by sRGB sampling, alpha must be in linear space before use
	return c.rgb * toLinearFast1(c.a);
	#else 
	//leave RGB*A in gamma space, gamma correction is disabled
	return c.rgb * c.a;
	#endif
}

half3 diffCubeLookup(samplerCUBE diffCube, float3 worldNormal) {
	half4 diff = texCUBE(diffCube, worldNormal);
	return fromRGBM(diff);
}

half3 specCubeLookup(samplerCUBE specCube, float3 worldRefl) {
	half4 spec = texCUBE(specCube, worldRefl);
	return fromRGBM(spec);
}

half3 glossCubeLookup(samplerCUBE specCube, float3 worldRefl, float glossLod) {
	half4 lookup = half4(worldRefl,glossLod);
	half4 spec = texCUBElod(specCube, lookup);
	return fromRGBM(spec);
}

half glossLOD(half glossMap, half shininess) {
	glossMap = 1.0-glossMap;
	glossMap = 1.0-glossMap*glossMap;
	//half lod = lerp(7.0, 8.0-_Shininess, spec.a);
	return 7.0 + glossMap - shininess*glossMap;
}

half glossExponent(half glossLod) {
	return pow(2.0, 8.0-glossLod);
}

//returns 1/spec. function integral
float specEnergyScalar(float gloss) {
	return gloss*INV_2PI + 2.0*INV_2PI;
}

half splineFresnel(float3 N, float3 E, half specIntensity, half fresnel) {
	half factor = 1.0-saturate(dot(N,E));
	half factor3 = factor*factor*factor;
	
	//a spline between 1, factor, and factor^3
	half3 p = half3(1.0, factor, factor3);
	half2 t = half2(1.0-fresnel,fresnel);
	p.x = dot(p.xy,t);
	p.y = dot(p.yz,t);
	factor = 0.05  + 0.95 * dot(p.xy,t);
	factor *= specIntensity;
	#ifndef MARMO_LINEAR
	//if gamma correction is disabled, fresnel*specInt needs to be applied in gamma-space
	factor = toGammaApprox1(factor);
	#endif
	return factor;
}

half fastFresnel(float3 N, float3 E, half specIntensity, half fresnel) {
	#ifdef MARMO_LINEAR
		half factor = 1.0-saturate(dot(N,E));
		factor *= factor*factor;
		return specIntensity * lerp(1.0, factor, fresnel*0.95);
	#else
		half factor = 1.0-saturate(dot(N,E));
		factor *= factor*factor;
		return specIntensity * lerp(1.0, factor, fresnel*0.9);
	#endif
}
#endif