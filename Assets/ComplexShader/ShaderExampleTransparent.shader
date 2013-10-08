Shader "gloops/ShaderExample Transparent" 
{
	Properties
	{
		//SLIB_DIFFUSE
		_MainCol ("Base Color", Color) = (1, 1, 1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		//SLIB_NORMAL
		//_BumpMap ("Normal Map", 2D) = "bump" {}
		
		//SLIB_SPECULAR
		//_SpecCol ("Specular Color", Color) = (1, 1, 1)
		//_SpecPow ("Specular Power", Range (0.03, 1)) = 0.078125
		//_SpecTex ("Specular Texture (RGB), Glossiness (A)" ,2D) = "white"{}
		
		//SLIB_RIMLIGHT
		//_RimCol ("RimLight Color", Color) = (0.26,0.19,0.16,0.0)
      	//_RimPow ("RimLight Power", Range(0.5,8.0)) = 3.0
      	//_RimMul ("RimLight Multiplier", Range (1, 1.5)) = 1.0
      	
      	//SLIB_IBL
      	//_Exposure ("Exposure", Range (0.03, 1)) = 0.078125
      	//_CubeIBL ("Lighting Lookup", CUBE) = "" {}
      	
      	//SLIB_REFLECTION
      	_Cube ("Reflection", CUBE) = "" {}
      	 
      	//SLIB_HALFLAMBERT
      	//_HalfLambert ("HalfLambert", Range (0.0, 5.0)) = 5.0
      	
      	//SLIB_BRDF
      	//_BRDF ("BRDF", 2D) = "white" {}
	}
	
	SubShader  
	{
		
		Tags 
		{ 
			//Set render queue to transparent
			"Queue"="Transparent"
			"RenderType"="Transparent"
		}
		
		LOD 200
		//diffuse LOD 200
		//diffuse-spec LOD 250
		//bumped-diffuse, spec 350
		//bumped-spec 400
		
		CGPROGRAM
		#pragma target gles
		//Add alpha
		#pragma surface SLibSurf SLibFrag alpha
		
		//Lighting Model
		#define SLIB_LAMBERT
		//#define SLIB_HALFLAMBERT
		//#define SLIB_UNLIT
			
		//Shading Components 
		#define SLIB_DIFFUSE
		//#define SLIB_DIFFUSE_TEXONLY
		#define SLIB_REFLECTION
		//#define SLIB_NORMAL
		//#define SLIB_SPECULAR
		//#define SLIB_SPECULAR_noteX
		//#define SLIB_RIMLIGHT
		//#define SLIB_IBL
		//#define SLIB_BRDF
		
		//Include
		#include "SLibInput.cginc"
		#include "SLibFrag.cginc"
		#include "SLibSurf.cginc"
		ENDCG
	}
	 
	FallBack "Diffuse"
}
