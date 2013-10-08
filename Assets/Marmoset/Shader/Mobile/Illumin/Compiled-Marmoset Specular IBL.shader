// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Mobile/Self-Illumin/Specular IBL" {
	Properties {
		_Color   ("Diffuse Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecInt ("Specular Intensity", Float) = 1.0
		_Shininess ("Specular Sharpness", Range(2.0,8.0)) = 4.0
		_Fresnel ("Fresnel Strength", Range(0.0,1.0)) = 0.0
		_MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
		_SpecTex ("Specular(RGB) Gloss(A)", 2D) = "white" {}
		_GlowColor ("Glow Color", Color) = (1,1,1,1)
		_EmissionLM ("Glow Strength", Float) = 1.0
		_Illum ("Glow Color(RGB) Mask(A)", 2D) = "white" {}
		//slots for custom lighting cubemaps
		_DiffCubeIBL ("Custom Diffuse Cube", Cube) = "black" {}
		_SpecCubeIBL ("Custom Specular Cube", Cube) = "black" {}
	}
	
	SubShader {
		Tags {
			"Queue"="Geometry"
			"RenderType"="Opaque"
		}
		LOD 250
		//diffuse LOD 200
		//diffuse-spec LOD 250
		//bumped-diffuse, spec 350
		//bumped-spec 400
		
		//mac stuff
			
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 9
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = ((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y))));
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 spec_3;
  vec4 diff_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_3.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - tmpvar_8));
  vec4 tmpvar_10;
  tmpvar_10 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_12.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_12.w * (_EmissionLM * _ExposureIBL.w));
  vec4 frag_13;
  float tmpvar_14;
  tmpvar_14 = clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0);
  frag_13.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_14)) * diff_4.xyz);
  frag_13.w = diff_4.w;
  frag_13.xyz = (frag_13.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((normalize(xlv_TEXCOORD3) + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_9)) * clamp ((10.0 * tmpvar_14), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec_3.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_4.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 shlight_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w));
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_8 - (2.0 * (dot (tmpvar_1, tmpvar_8) * tmpvar_1))));
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_1);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (tmpvar_1 * unity_Scale.w));
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_14;
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  shlight_2 = tmpvar_16;
  tmpvar_6 = shlight_2;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_2 = xlv_TEXCOORD4;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_3, xlv_TEXCOORD3), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess_18;
  shininess_18 = _Shininess;
  tmpvar_17 = ((7.0 + spec_7.w) - (shininess_18 * spec_7.w));
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - tmpvar_17));
  highp float glossLod_20;
  glossLod_20 = tmpvar_17;
  mediump vec4 spec_21;
  mediump vec4 lookup_22;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = tmpvar_4;
  tmpvar_23.w = glossLod_20;
  lookup_22 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup_22.xyz, lookup_22.w);
  spec_21 = tmpvar_24;
  highp float gloss_25;
  gloss_25 = tmpvar_19;
  highp vec3 tmpvar_26;
  tmpvar_26 = (spec_7.xyz * ((gloss_25 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_3);
  diff_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_33;
  lightDir_33 = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir_34;
  viewDir_34 = tmpvar_32;
  mediump vec3 spec_35;
  highp float specRefl_36;
  mediump vec4 frag_37;
  mediump float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_2, lightDir_33), 0.0, 1.0);
  frag_37.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_38)) * diff_8.xyz);
  frag_37.w = diff_8.w;
  mediump float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_2, normalize((viewDir_34 + lightDir_33))), 0.0, 1.0);
  specRefl_36 = tmpvar_39;
  highp vec3 tmpvar_40;
  tmpvar_40 = vec3(pow (specRefl_36, tmpvar_19));
  spec_35 = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = (((spec_35 * clamp ((10.0 * tmpvar_38), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_35 = tmpvar_41;
  frag_37.xyz = (frag_37.xyz + (tmpvar_41 * tmpvar_5));
  c_1 = frag_37;
  mediump vec3 tmpvar_42;
  tmpvar_42 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = (c_1.xyz + (((((spec_21.xyz * spec_21.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_43;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 spec_3;
  vec4 diff_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_3.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  vec4 tmpvar_8;
  tmpvar_8 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w)));
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_10.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_10.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  c_1.xyz = (diff_4.xyz * ((8.0 * tmpvar_11.w) * tmpvar_11.xyz));
  c_1.w = diff_4.w;
  c_1.xyz = (c_1.xyz + (((((tmpvar_8.xyz * tmpvar_8.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_9.xyz * tmpvar_9.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - ((_World2Object * tmpvar_4).xyz * unity_Scale.w));
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (tmpvar_5 - (2.0 * (dot (tmpvar_1, tmpvar_5) * tmpvar_1))));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_1);
  tmpvar_3 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec2 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  mediump vec4 glow_4;
  mediump vec4 spec_5;
  mediump vec4 diff_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_6 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (diff_6 * _Color);
  diff_6 = tmpvar_8;
  diff_6.xyz = (diff_6.xyz * _ExposureIBL.w);
  mediump float tmpvar_9;
  tmpvar_9 = diff_6.w;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_10;
  mediump float specIntensity_11;
  specIntensity_11 = _SpecInt;
  mediump float fresnel_12;
  fresnel_12 = _Fresnel;
  mediump float factor_13;
  highp float tmpvar_14;
  tmpvar_14 = (1.0 - clamp (dot (tmpvar_2, xlv_TEXCOORD3), 0.0, 1.0));
  factor_13 = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = (factor_13 * (factor_13 * factor_13));
  factor_13 = tmpvar_15;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_11 * mix (1.0, tmpvar_15, (fresnel_12 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_16;
  mediump float shininess_17;
  shininess_17 = _Shininess;
  tmpvar_16 = ((7.0 + spec_5.w) - (shininess_17 * spec_5.w));
  highp float glossLod_18;
  glossLod_18 = tmpvar_16;
  mediump vec4 spec_19;
  mediump vec4 lookup_20;
  highp vec4 tmpvar_21;
  tmpvar_21.xyz = tmpvar_3;
  tmpvar_21.w = glossLod_18;
  lookup_20 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCubeLod (_SpecCubeIBL, lookup_20.xyz, lookup_20.w);
  spec_19 = tmpvar_22;
  mediump vec4 diff_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_DiffCubeIBL, tmpvar_2);
  diff_23 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_4 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (glow_4.xyz * _GlowColor.xyz);
  glow_4.xyz = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (glow_4.w * (_EmissionLM * _ExposureIBL.w));
  glow_4.w = tmpvar_27;
  lowp vec3 tmpvar_28;
  tmpvar_28 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  mediump vec3 tmpvar_29;
  tmpvar_29 = (diff_6.xyz * tmpvar_28);
  c_1.xyz = tmpvar_29;
  c_1.w = tmpvar_9;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (c_1.xyz + (((((spec_19.xyz * spec_19.w) * spec_5.xyz) * _ExposureIBL.y) + (((diff_23.xyz * diff_23.w) * diff_6.xyz) * _ExposureIBL.x)) + (glow_4.xyz * glow_4.w)));
  c_1.xyz = tmpvar_30;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  vec3 x2_9;
  vec3 x1_10;
  x1_10.x = dot (unity_SHAr, tmpvar_8);
  x1_10.y = dot (unity_SHAg, tmpvar_8);
  x1_10.z = dot (unity_SHAb, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_9.x = dot (unity_SHBr, tmpvar_11);
  x2_9.y = dot (unity_SHBg, tmpvar_11);
  x2_9.z = dot (unity_SHBb, tmpvar_11);
  vec4 o_12;
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_1 * 0.5);
  vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_13.x;
  tmpvar_14.y = (tmpvar_13.y * _ProjectionParams.x);
  o_12.xy = (tmpvar_14 + tmpvar_13.w);
  o_12.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = ((x1_10 + x2_9) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
  xlv_TEXCOORD6 = o_12;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 spec_3;
  vec4 diff_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_3.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - tmpvar_8));
  vec4 tmpvar_10;
  tmpvar_10 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_12.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_12.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  vec4 frag_14;
  float tmpvar_15;
  tmpvar_15 = clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0);
  frag_14.xyz = ((_LightColor0.xyz * ((tmpvar_13.x * 2.0) * tmpvar_15)) * diff_4.xyz);
  frag_14.w = diff_4.w;
  frag_14.xyz = (frag_14.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((normalize(xlv_TEXCOORD3) + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_9)) * clamp ((10.0 * tmpvar_15), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_13.x) * 0.5) * (spec_3.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  c_1.w = frag_14.w;
  c_1.xyz = (frag_14.xyz + (diff_4.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 shlight_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w));
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_8 - (2.0 * (dot (tmpvar_1, tmpvar_8) * tmpvar_1))));
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_1);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (tmpvar_1 * unity_Scale.w));
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_14;
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  shlight_2 = tmpvar_16;
  tmpvar_6 = shlight_2;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec4 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_2 = xlv_TEXCOORD4;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_3, xlv_TEXCOORD3), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess_18;
  shininess_18 = _Shininess;
  tmpvar_17 = ((7.0 + spec_7.w) - (shininess_18 * spec_7.w));
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - tmpvar_17));
  highp float glossLod_20;
  glossLod_20 = tmpvar_17;
  mediump vec4 spec_21;
  mediump vec4 lookup_22;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = tmpvar_4;
  tmpvar_23.w = glossLod_20;
  lookup_22 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup_22.xyz, lookup_22.w);
  spec_21 = tmpvar_24;
  highp float gloss_25;
  gloss_25 = tmpvar_19;
  highp vec3 tmpvar_26;
  tmpvar_26 = (spec_7.xyz * ((gloss_25 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_3);
  diff_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_31;
  lowp float tmpvar_32;
  mediump float lightShadowDataX_33;
  highp float dist_34;
  lowp float tmpvar_35;
  tmpvar_35 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x;
  dist_34 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = _LightShadowData.x;
  lightShadowDataX_33 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = max (float((dist_34 > (xlv_TEXCOORD6.z / xlv_TEXCOORD6.w))), lightShadowDataX_33);
  tmpvar_32 = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_39;
  lightDir_39 = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir_40;
  viewDir_40 = tmpvar_38;
  mediump float atten_41;
  atten_41 = tmpvar_32;
  mediump vec3 spec_42;
  highp float specRefl_43;
  mediump vec4 frag_44;
  mediump float tmpvar_45;
  tmpvar_45 = clamp (dot (tmpvar_2, lightDir_39), 0.0, 1.0);
  frag_44.xyz = ((_LightColor0.xyz * ((atten_41 * 2.0) * tmpvar_45)) * diff_8.xyz);
  frag_44.w = diff_8.w;
  mediump float tmpvar_46;
  tmpvar_46 = clamp (dot (tmpvar_2, normalize((viewDir_40 + lightDir_39))), 0.0, 1.0);
  specRefl_43 = tmpvar_46;
  highp vec3 tmpvar_47;
  tmpvar_47 = vec3(pow (specRefl_43, tmpvar_19));
  spec_42 = tmpvar_47;
  mediump vec3 tmpvar_48;
  tmpvar_48 = ((((spec_42 * clamp ((10.0 * tmpvar_45), 0.0, 1.0)) * _LightColor0.xyz) * atten_41) * 0.5);
  spec_42 = tmpvar_48;
  frag_44.xyz = (frag_44.xyz + (tmpvar_48 * tmpvar_5));
  c_1 = frag_44;
  mediump vec3 tmpvar_49;
  tmpvar_49 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_49;
  mediump vec3 tmpvar_50;
  tmpvar_50 = (c_1.xyz + (((((spec_21.xyz * spec_21.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_50;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec4 o_6;
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_1 * 0.5);
  vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_6;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 spec_3;
  vec4 diff_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_3.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  vec4 tmpvar_8;
  tmpvar_8 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w)));
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_10.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_10.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec3 tmpvar_13;
  tmpvar_13 = ((8.0 * tmpvar_12.w) * tmpvar_12.xyz);
  c_1.xyz = (diff_4.xyz * max (min (tmpvar_13, ((tmpvar_11.x * 2.0) * tmpvar_12.xyz)), (tmpvar_13 * tmpvar_11.x)));
  c_1.w = diff_4.w;
  c_1.xyz = (c_1.xyz + (((((tmpvar_8.xyz * tmpvar_8.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_9.xyz * tmpvar_9.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - ((_World2Object * tmpvar_4).xyz * unity_Scale.w));
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (tmpvar_5 - (2.0 * (dot (tmpvar_1, tmpvar_5) * tmpvar_1))));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_1);
  tmpvar_3 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  mediump vec4 glow_4;
  mediump vec4 spec_5;
  mediump vec4 diff_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_6 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (diff_6 * _Color);
  diff_6 = tmpvar_8;
  diff_6.xyz = (diff_6.xyz * _ExposureIBL.w);
  mediump float tmpvar_9;
  tmpvar_9 = diff_6.w;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_10;
  mediump float specIntensity_11;
  specIntensity_11 = _SpecInt;
  mediump float fresnel_12;
  fresnel_12 = _Fresnel;
  mediump float factor_13;
  highp float tmpvar_14;
  tmpvar_14 = (1.0 - clamp (dot (tmpvar_2, xlv_TEXCOORD3), 0.0, 1.0));
  factor_13 = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = (factor_13 * (factor_13 * factor_13));
  factor_13 = tmpvar_15;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_11 * mix (1.0, tmpvar_15, (fresnel_12 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_16;
  mediump float shininess_17;
  shininess_17 = _Shininess;
  tmpvar_16 = ((7.0 + spec_5.w) - (shininess_17 * spec_5.w));
  highp float glossLod_18;
  glossLod_18 = tmpvar_16;
  mediump vec4 spec_19;
  mediump vec4 lookup_20;
  highp vec4 tmpvar_21;
  tmpvar_21.xyz = tmpvar_3;
  tmpvar_21.w = glossLod_18;
  lookup_20 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCubeLod (_SpecCubeIBL, lookup_20.xyz, lookup_20.w);
  spec_19 = tmpvar_22;
  mediump vec4 diff_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_DiffCubeIBL, tmpvar_2);
  diff_23 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_4 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (glow_4.xyz * _GlowColor.xyz);
  glow_4.xyz = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (glow_4.w * (_EmissionLM * _ExposureIBL.w));
  glow_4.w = tmpvar_27;
  lowp float tmpvar_28;
  mediump float lightShadowDataX_29;
  highp float dist_30;
  lowp float tmpvar_31;
  tmpvar_31 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  dist_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = _LightShadowData.x;
  lightShadowDataX_29 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = max (float((dist_30 > (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))), lightShadowDataX_29);
  tmpvar_28 = tmpvar_33;
  lowp vec3 tmpvar_34;
  tmpvar_34 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz), vec3((tmpvar_28 * 2.0)));
  mediump vec3 tmpvar_35;
  tmpvar_35 = (diff_6.xyz * tmpvar_34);
  c_1.xyz = tmpvar_35;
  c_1.w = tmpvar_9;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (c_1.xyz + (((((spec_19.xyz * spec_19.w) * spec_5.xyz) * _ExposureIBL.y) + (((diff_23.xyz * diff_23.w) * diff_6.xyz) * _ExposureIBL.x)) + (glow_4.xyz * glow_4.w)));
  c_1.xyz = tmpvar_36;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 unity_LightColor[4];
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_2;
  tmpvar_2 = (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w));
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_12;
  tmpvar_12 = (unity_4LightPosX0 - tmpvar_11.x);
  vec4 tmpvar_13;
  tmpvar_13 = (unity_4LightPosY0 - tmpvar_11.y);
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosZ0 - tmpvar_11.z);
  vec4 tmpvar_15;
  tmpvar_15 = (((tmpvar_12 * tmpvar_12) + (tmpvar_13 * tmpvar_13)) + (tmpvar_14 * tmpvar_14));
  vec4 tmpvar_16;
  tmpvar_16 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_12 * tmpvar_6.x) + (tmpvar_13 * tmpvar_6.y)) + (tmpvar_14 * tmpvar_6.z)) * inversesqrt(tmpvar_15))) * (1.0/((1.0 + (tmpvar_15 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (tmpvar_2 - (2.0 * (dot (gl_Normal, tmpvar_2) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_4 * gl_Normal);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (((x1_9 + x2_8) + (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y)))) + ((((unity_LightColor[0].xyz * tmpvar_16.x) + (unity_LightColor[1].xyz * tmpvar_16.y)) + (unity_LightColor[2].xyz * tmpvar_16.z)) + (unity_LightColor[3].xyz * tmpvar_16.w)));
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 spec_3;
  vec4 diff_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_3.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - tmpvar_8));
  vec4 tmpvar_10;
  tmpvar_10 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_12.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_12.w * (_EmissionLM * _ExposureIBL.w));
  vec4 frag_13;
  float tmpvar_14;
  tmpvar_14 = clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0);
  frag_13.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_14)) * diff_4.xyz);
  frag_13.w = diff_4.w;
  frag_13.xyz = (frag_13.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((normalize(xlv_TEXCOORD3) + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_9)) * clamp ((10.0 * tmpvar_14), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec_3.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  c_1.w = frag_13.w;
  c_1.xyz = (frag_13.xyz + (diff_4.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 shlight_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w));
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_8 - (2.0 * (dot (tmpvar_1, tmpvar_8) * tmpvar_1))));
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_1);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (tmpvar_1 * unity_Scale.w));
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_14;
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  shlight_2 = tmpvar_16;
  tmpvar_6 = shlight_2;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosX0 - tmpvar_31.x);
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosY0 - tmpvar_31.y);
  highp vec4 tmpvar_34;
  tmpvar_34 = (unity_4LightPosZ0 - tmpvar_31.z);
  highp vec4 tmpvar_35;
  tmpvar_35 = (((tmpvar_32 * tmpvar_32) + (tmpvar_33 * tmpvar_33)) + (tmpvar_34 * tmpvar_34));
  highp vec4 tmpvar_36;
  tmpvar_36 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_32 * tmpvar_14.x) + (tmpvar_33 * tmpvar_14.y)) + (tmpvar_34 * tmpvar_14.z)) * inversesqrt(tmpvar_35))) * (1.0/((1.0 + (tmpvar_35 * unity_4LightAtten0)))));
  highp vec3 tmpvar_37;
  tmpvar_37 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_36.x) + (unity_LightColor[1].xyz * tmpvar_36.y)) + (unity_LightColor[2].xyz * tmpvar_36.z)) + (unity_LightColor[3].xyz * tmpvar_36.w)));
  tmpvar_6 = tmpvar_37;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_2 = xlv_TEXCOORD4;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_3, xlv_TEXCOORD3), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess_18;
  shininess_18 = _Shininess;
  tmpvar_17 = ((7.0 + spec_7.w) - (shininess_18 * spec_7.w));
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - tmpvar_17));
  highp float glossLod_20;
  glossLod_20 = tmpvar_17;
  mediump vec4 spec_21;
  mediump vec4 lookup_22;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = tmpvar_4;
  tmpvar_23.w = glossLod_20;
  lookup_22 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup_22.xyz, lookup_22.w);
  spec_21 = tmpvar_24;
  highp float gloss_25;
  gloss_25 = tmpvar_19;
  highp vec3 tmpvar_26;
  tmpvar_26 = (spec_7.xyz * ((gloss_25 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_3);
  diff_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_33;
  lightDir_33 = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir_34;
  viewDir_34 = tmpvar_32;
  mediump vec3 spec_35;
  highp float specRefl_36;
  mediump vec4 frag_37;
  mediump float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_2, lightDir_33), 0.0, 1.0);
  frag_37.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_38)) * diff_8.xyz);
  frag_37.w = diff_8.w;
  mediump float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_2, normalize((viewDir_34 + lightDir_33))), 0.0, 1.0);
  specRefl_36 = tmpvar_39;
  highp vec3 tmpvar_40;
  tmpvar_40 = vec3(pow (specRefl_36, tmpvar_19));
  spec_35 = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = (((spec_35 * clamp ((10.0 * tmpvar_38), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_35 = tmpvar_41;
  frag_37.xyz = (frag_37.xyz + (tmpvar_41 * tmpvar_5));
  c_1 = frag_37;
  mediump vec3 tmpvar_42;
  tmpvar_42 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = (c_1.xyz + (((((spec_21.xyz * spec_21.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_43;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 unity_SHC;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAr;
uniform vec4 unity_LightColor[4];
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  vec3 tmpvar_3;
  tmpvar_3 = (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w));
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  vec3 x2_9;
  vec3 x1_10;
  x1_10.x = dot (unity_SHAr, tmpvar_8);
  x1_10.y = dot (unity_SHAg, tmpvar_8);
  x1_10.z = dot (unity_SHAb, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2_9.x = dot (unity_SHBr, tmpvar_11);
  x2_9.y = dot (unity_SHBg, tmpvar_11);
  x2_9.z = dot (unity_SHBb, tmpvar_11);
  vec3 tmpvar_12;
  tmpvar_12 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_13;
  tmpvar_13 = (unity_4LightPosX0 - tmpvar_12.x);
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosY0 - tmpvar_12.y);
  vec4 tmpvar_15;
  tmpvar_15 = (unity_4LightPosZ0 - tmpvar_12.z);
  vec4 tmpvar_16;
  tmpvar_16 = (((tmpvar_13 * tmpvar_13) + (tmpvar_14 * tmpvar_14)) + (tmpvar_15 * tmpvar_15));
  vec4 tmpvar_17;
  tmpvar_17 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_13 * tmpvar_7.x) + (tmpvar_14 * tmpvar_7.y)) + (tmpvar_15 * tmpvar_7.z)) * inversesqrt(tmpvar_16))) * (1.0/((1.0 + (tmpvar_16 * unity_4LightAtten0)))));
  vec4 o_18;
  vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_1 * 0.5);
  vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_18.xy = (tmpvar_20 + tmpvar_19.w);
  o_18.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (tmpvar_3 - (2.0 * (dot (gl_Normal, tmpvar_3) * gl_Normal))));
  xlv_TEXCOORD2 = (tmpvar_5 * gl_Normal);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = (((x1_10 + x2_9) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y)))) + ((((unity_LightColor[0].xyz * tmpvar_17.x) + (unity_LightColor[1].xyz * tmpvar_17.y)) + (unity_LightColor[2].xyz * tmpvar_17.z)) + (unity_LightColor[3].xyz * tmpvar_17.w)));
  xlv_TEXCOORD6 = o_18;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec4 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
uniform vec4 _WorldSpaceLightPos0;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 spec_3;
  vec4 diff_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_4.w = tmpvar_5.w;
  diff_4.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (xlv_TEXCOORD2, xlv_TEXCOORD3), 0.0, 1.0));
  spec_3.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - tmpvar_8));
  vec4 tmpvar_10;
  tmpvar_10 = textureCubeLod (_SpecCubeIBL, xlv_TEXCOORD1, tmpvar_8);
  vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_12.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_12.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  vec4 frag_14;
  float tmpvar_15;
  tmpvar_15 = clamp (dot (xlv_TEXCOORD4, _WorldSpaceLightPos0.xyz), 0.0, 1.0);
  frag_14.xyz = ((_LightColor0.xyz * ((tmpvar_13.x * 2.0) * tmpvar_15)) * diff_4.xyz);
  frag_14.w = diff_4.w;
  frag_14.xyz = (frag_14.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD4, normalize((normalize(xlv_TEXCOORD3) + _WorldSpaceLightPos0.xyz))), 0.0, 1.0), tmpvar_9)) * clamp ((10.0 * tmpvar_15), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_13.x) * 0.5) * (spec_3.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  c_1.w = frag_14.w;
  c_1.xyz = (frag_14.xyz + (diff_4.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + (((((tmpvar_10.xyz * tmpvar_10.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_11.xyz * tmpvar_11.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 shlight_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w));
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_8 - (2.0 * (dot (tmpvar_1, tmpvar_8) * tmpvar_1))));
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_1);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (tmpvar_1 * unity_Scale.w));
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_14;
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  shlight_2 = tmpvar_16;
  tmpvar_6 = shlight_2;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosX0 - tmpvar_31.x);
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosY0 - tmpvar_31.y);
  highp vec4 tmpvar_34;
  tmpvar_34 = (unity_4LightPosZ0 - tmpvar_31.z);
  highp vec4 tmpvar_35;
  tmpvar_35 = (((tmpvar_32 * tmpvar_32) + (tmpvar_33 * tmpvar_33)) + (tmpvar_34 * tmpvar_34));
  highp vec4 tmpvar_36;
  tmpvar_36 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_32 * tmpvar_14.x) + (tmpvar_33 * tmpvar_14.y)) + (tmpvar_34 * tmpvar_14.z)) * inversesqrt(tmpvar_35))) * (1.0/((1.0 + (tmpvar_35 * unity_4LightAtten0)))));
  highp vec3 tmpvar_37;
  tmpvar_37 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_36.x) + (unity_LightColor[1].xyz * tmpvar_36.y)) + (unity_LightColor[2].xyz * tmpvar_36.z)) + (unity_LightColor[3].xyz * tmpvar_36.w)));
  tmpvar_6 = tmpvar_37;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec4 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_2 = xlv_TEXCOORD4;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_3, xlv_TEXCOORD3), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess_18;
  shininess_18 = _Shininess;
  tmpvar_17 = ((7.0 + spec_7.w) - (shininess_18 * spec_7.w));
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - tmpvar_17));
  highp float glossLod_20;
  glossLod_20 = tmpvar_17;
  mediump vec4 spec_21;
  mediump vec4 lookup_22;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = tmpvar_4;
  tmpvar_23.w = glossLod_20;
  lookup_22 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup_22.xyz, lookup_22.w);
  spec_21 = tmpvar_24;
  highp float gloss_25;
  gloss_25 = tmpvar_19;
  highp vec3 tmpvar_26;
  tmpvar_26 = (spec_7.xyz * ((gloss_25 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_3);
  diff_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_31;
  lowp float tmpvar_32;
  mediump float lightShadowDataX_33;
  highp float dist_34;
  lowp float tmpvar_35;
  tmpvar_35 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x;
  dist_34 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = _LightShadowData.x;
  lightShadowDataX_33 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = max (float((dist_34 > (xlv_TEXCOORD6.z / xlv_TEXCOORD6.w))), lightShadowDataX_33);
  tmpvar_32 = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_39;
  lightDir_39 = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir_40;
  viewDir_40 = tmpvar_38;
  mediump float atten_41;
  atten_41 = tmpvar_32;
  mediump vec3 spec_42;
  highp float specRefl_43;
  mediump vec4 frag_44;
  mediump float tmpvar_45;
  tmpvar_45 = clamp (dot (tmpvar_2, lightDir_39), 0.0, 1.0);
  frag_44.xyz = ((_LightColor0.xyz * ((atten_41 * 2.0) * tmpvar_45)) * diff_8.xyz);
  frag_44.w = diff_8.w;
  mediump float tmpvar_46;
  tmpvar_46 = clamp (dot (tmpvar_2, normalize((viewDir_40 + lightDir_39))), 0.0, 1.0);
  specRefl_43 = tmpvar_46;
  highp vec3 tmpvar_47;
  tmpvar_47 = vec3(pow (specRefl_43, tmpvar_19));
  spec_42 = tmpvar_47;
  mediump vec3 tmpvar_48;
  tmpvar_48 = ((((spec_42 * clamp ((10.0 * tmpvar_45), 0.0, 1.0)) * _LightColor0.xyz) * atten_41) * 0.5);
  spec_42 = tmpvar_48;
  frag_44.xyz = (frag_44.xyz + (tmpvar_48 * tmpvar_5));
  c_1 = frag_44;
  mediump vec3 tmpvar_49;
  tmpvar_49 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_49;
  mediump vec3 tmpvar_50;
  tmpvar_50 = (c_1.xyz + (((((spec_21.xyz * spec_21.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_50;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
varying highp vec4 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 shlight_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w));
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_8 - (2.0 * (dot (tmpvar_1, tmpvar_8) * tmpvar_1))));
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_1);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (tmpvar_1 * unity_Scale.w));
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_14;
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  shlight_2 = tmpvar_16;
  tmpvar_6 = shlight_2;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_2 = xlv_TEXCOORD4;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_3, xlv_TEXCOORD3), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess_18;
  shininess_18 = _Shininess;
  tmpvar_17 = ((7.0 + spec_7.w) - (shininess_18 * spec_7.w));
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - tmpvar_17));
  highp float glossLod_20;
  glossLod_20 = tmpvar_17;
  mediump vec4 spec_21;
  mediump vec4 lookup_22;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = tmpvar_4;
  tmpvar_23.w = glossLod_20;
  lookup_22 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup_22.xyz, lookup_22.w);
  spec_21 = tmpvar_24;
  highp float gloss_25;
  gloss_25 = tmpvar_19;
  highp vec3 tmpvar_26;
  tmpvar_26 = (spec_7.xyz * ((gloss_25 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_3);
  diff_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_31;
  lowp float shadow_32;
  lowp float tmpvar_33;
  tmpvar_33 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD6.xyz);
  highp float tmpvar_34;
  tmpvar_34 = (_LightShadowData.x + (tmpvar_33 * (1.0 - _LightShadowData.x)));
  shadow_32 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_36;
  lightDir_36 = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir_37;
  viewDir_37 = tmpvar_35;
  mediump float atten_38;
  atten_38 = shadow_32;
  mediump vec3 spec_39;
  highp float specRefl_40;
  mediump vec4 frag_41;
  mediump float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_2, lightDir_36), 0.0, 1.0);
  frag_41.xyz = ((_LightColor0.xyz * ((atten_38 * 2.0) * tmpvar_42)) * diff_8.xyz);
  frag_41.w = diff_8.w;
  mediump float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_2, normalize((viewDir_37 + lightDir_36))), 0.0, 1.0);
  specRefl_40 = tmpvar_43;
  highp vec3 tmpvar_44;
  tmpvar_44 = vec3(pow (specRefl_40, tmpvar_19));
  spec_39 = tmpvar_44;
  mediump vec3 tmpvar_45;
  tmpvar_45 = ((((spec_39 * clamp ((10.0 * tmpvar_42), 0.0, 1.0)) * _LightColor0.xyz) * atten_38) * 0.5);
  spec_39 = tmpvar_45;
  frag_41.xyz = (frag_41.xyz + (tmpvar_45 * tmpvar_5));
  c_1 = frag_41;
  mediump vec3 tmpvar_46;
  tmpvar_46 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_46;
  mediump vec3 tmpvar_47;
  tmpvar_47 = (c_1.xyz + (((((spec_21.xyz * spec_21.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_47;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - ((_World2Object * tmpvar_4).xyz * unity_Scale.w));
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (tmpvar_5 - (2.0 * (dot (tmpvar_1, tmpvar_5) * tmpvar_1))));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_1);
  tmpvar_3 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  mediump vec4 glow_4;
  mediump vec4 spec_5;
  mediump vec4 diff_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_6 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (diff_6 * _Color);
  diff_6 = tmpvar_8;
  diff_6.xyz = (diff_6.xyz * _ExposureIBL.w);
  mediump float tmpvar_9;
  tmpvar_9 = diff_6.w;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_10;
  mediump float specIntensity_11;
  specIntensity_11 = _SpecInt;
  mediump float fresnel_12;
  fresnel_12 = _Fresnel;
  mediump float factor_13;
  highp float tmpvar_14;
  tmpvar_14 = (1.0 - clamp (dot (tmpvar_2, xlv_TEXCOORD3), 0.0, 1.0));
  factor_13 = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = (factor_13 * (factor_13 * factor_13));
  factor_13 = tmpvar_15;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_11 * mix (1.0, tmpvar_15, (fresnel_12 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_16;
  mediump float shininess_17;
  shininess_17 = _Shininess;
  tmpvar_16 = ((7.0 + spec_5.w) - (shininess_17 * spec_5.w));
  highp float glossLod_18;
  glossLod_18 = tmpvar_16;
  mediump vec4 spec_19;
  mediump vec4 lookup_20;
  highp vec4 tmpvar_21;
  tmpvar_21.xyz = tmpvar_3;
  tmpvar_21.w = glossLod_18;
  lookup_20 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCubeLod (_SpecCubeIBL, lookup_20.xyz, lookup_20.w);
  spec_19 = tmpvar_22;
  mediump vec4 diff_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_DiffCubeIBL, tmpvar_2);
  diff_23 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_4 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (glow_4.xyz * _GlowColor.xyz);
  glow_4.xyz = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (glow_4.w * (_EmissionLM * _ExposureIBL.w));
  glow_4.w = tmpvar_27;
  lowp float shadow_28;
  lowp float tmpvar_29;
  tmpvar_29 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD5.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (_LightShadowData.x + (tmpvar_29 * (1.0 - _LightShadowData.x)));
  shadow_28 = tmpvar_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz), vec3((shadow_28 * 2.0)));
  mediump vec3 tmpvar_32;
  tmpvar_32 = (diff_6.xyz * tmpvar_31);
  c_1.xyz = tmpvar_32;
  c_1.w = tmpvar_9;
  mediump vec3 tmpvar_33;
  tmpvar_33 = (c_1.xyz + (((((spec_19.xyz * spec_19.w) * spec_5.xyz) * _ExposureIBL.y) + (((diff_23.xyz * diff_23.w) * diff_6.xyz) * _ExposureIBL.x)) + (glow_4.xyz * glow_4.w)));
  c_1.xyz = tmpvar_33;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
varying highp vec4 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 shlight_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w));
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_8 - (2.0 * (dot (tmpvar_1, tmpvar_8) * tmpvar_1))));
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_1);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (tmpvar_1 * unity_Scale.w));
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_14;
  mediump vec3 tmpvar_16;
  mediump vec4 normal_17;
  normal_17 = tmpvar_15;
  highp float vC_18;
  mediump vec3 x3_19;
  mediump vec3 x2_20;
  mediump vec3 x1_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal_17);
  x1_21.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal_17);
  x1_21.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal_17);
  x1_21.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal_17.xyzz * normal_17.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2_20.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2_20.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2_20.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal_17.x * normal_17.x) - (normal_17.y * normal_17.y));
  vC_18 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC_18);
  x3_19 = tmpvar_30;
  tmpvar_16 = ((x1_21 + x2_20) + x3_19);
  shlight_2 = tmpvar_16;
  tmpvar_6 = shlight_2;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosX0 - tmpvar_31.x);
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosY0 - tmpvar_31.y);
  highp vec4 tmpvar_34;
  tmpvar_34 = (unity_4LightPosZ0 - tmpvar_31.z);
  highp vec4 tmpvar_35;
  tmpvar_35 = (((tmpvar_32 * tmpvar_32) + (tmpvar_33 * tmpvar_33)) + (tmpvar_34 * tmpvar_34));
  highp vec4 tmpvar_36;
  tmpvar_36 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_32 * tmpvar_14.x) + (tmpvar_33 * tmpvar_14.y)) + (tmpvar_34 * tmpvar_14.z)) * inversesqrt(tmpvar_35))) * (1.0/((1.0 + (tmpvar_35 * unity_4LightAtten0)))));
  highp vec3 tmpvar_37;
  tmpvar_37 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_36.x) + (unity_LightColor[1].xyz * tmpvar_36.y)) + (unity_LightColor[2].xyz * tmpvar_36.z)) + (unity_LightColor[3].xyz * tmpvar_36.w)));
  tmpvar_6 = tmpvar_37;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_2 = xlv_TEXCOORD4;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_3, xlv_TEXCOORD3), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess_18;
  shininess_18 = _Shininess;
  tmpvar_17 = ((7.0 + spec_7.w) - (shininess_18 * spec_7.w));
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - tmpvar_17));
  highp float glossLod_20;
  glossLod_20 = tmpvar_17;
  mediump vec4 spec_21;
  mediump vec4 lookup_22;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = tmpvar_4;
  tmpvar_23.w = glossLod_20;
  lookup_22 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup_22.xyz, lookup_22.w);
  spec_21 = tmpvar_24;
  highp float gloss_25;
  gloss_25 = tmpvar_19;
  highp vec3 tmpvar_26;
  tmpvar_26 = (spec_7.xyz * ((gloss_25 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_3);
  diff_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_31;
  lowp float shadow_32;
  lowp float tmpvar_33;
  tmpvar_33 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD6.xyz);
  highp float tmpvar_34;
  tmpvar_34 = (_LightShadowData.x + (tmpvar_33 * (1.0 - _LightShadowData.x)));
  shadow_32 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_36;
  lightDir_36 = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir_37;
  viewDir_37 = tmpvar_35;
  mediump float atten_38;
  atten_38 = shadow_32;
  mediump vec3 spec_39;
  highp float specRefl_40;
  mediump vec4 frag_41;
  mediump float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_2, lightDir_36), 0.0, 1.0);
  frag_41.xyz = ((_LightColor0.xyz * ((atten_38 * 2.0) * tmpvar_42)) * diff_8.xyz);
  frag_41.w = diff_8.w;
  mediump float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_2, normalize((viewDir_37 + lightDir_36))), 0.0, 1.0);
  specRefl_40 = tmpvar_43;
  highp vec3 tmpvar_44;
  tmpvar_44 = vec3(pow (specRefl_40, tmpvar_19));
  spec_39 = tmpvar_44;
  mediump vec3 tmpvar_45;
  tmpvar_45 = ((((spec_39 * clamp ((10.0 * tmpvar_42), 0.0, 1.0)) * _LightColor0.xyz) * atten_38) * 0.5);
  spec_39 = tmpvar_45;
  frag_41.xyz = (frag_41.xyz + (tmpvar_45 * tmpvar_5));
  c_1 = frag_41;
  mediump vec3 tmpvar_46;
  tmpvar_46 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_46;
  mediump vec3 tmpvar_47;
  tmpvar_47 = (c_1.xyz + (((((spec_21.xyz * spec_21.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_47;
  gl_FragData[0] = c_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
SubProgram "opengl " {
Keywords { "POINT" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD4 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD1, xlv_TEXCOORD2), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = pow (2.0, (8.0 - ((7.0 + tmpvar_5.w) - (_Shininess * tmpvar_5.w))));
  vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD4);
  float atten_9;
  atten_9 = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5))).w;
  vec4 frag_10;
  float tmpvar_11;
  tmpvar_11 = clamp (dot (xlv_TEXCOORD3, tmpvar_8), 0.0, 1.0);
  frag_10.xyz = ((_LightColor0.xyz * ((atten_9 * 2.0) * tmpvar_11)) * diff_3.xyz);
  frag_10.w = diff_3.w;
  frag_10.xyz = (frag_10.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize((normalize(xlv_TEXCOORD2) + tmpvar_8))), 0.0, 1.0), tmpvar_7)) * clamp ((10.0 * tmpvar_11), 0.0, 1.0)) * _LightColor0.xyz) * atten_9) * 0.5) * (spec_2.xyz * ((tmpvar_7 * 0.159155) + 0.31831))));
  c_1.xyz = frag_10.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_1);
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_4, xlv_TEXCOORD2), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_7.w) - (shininess_17 * spec_7.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_7.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(xlv_TEXCOORD4);
  lightDir_2 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD2);
  highp float tmpvar_26;
  tmpvar_26 = dot (xlv_TEXCOORD5, xlv_TEXCOORD5);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_LightTexture0, vec2(tmpvar_26));
  mediump vec3 lightDir_28;
  lightDir_28 = lightDir_2;
  mediump vec3 viewDir_29;
  viewDir_29 = tmpvar_25;
  mediump float atten_30;
  atten_30 = tmpvar_27.w;
  mediump vec3 spec_31;
  highp float specRefl_32;
  mediump vec4 frag_33;
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_3, lightDir_28), 0.0, 1.0);
  frag_33.xyz = ((_LightColor0.xyz * ((atten_30 * 2.0) * tmpvar_34)) * diff_8.xyz);
  frag_33.w = diff_8.w;
  mediump float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_3, normalize((viewDir_29 + lightDir_28))), 0.0, 1.0);
  specRefl_32 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = vec3(pow (specRefl_32, tmpvar_18));
  spec_31 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = ((((spec_31 * clamp ((10.0 * tmpvar_34), 0.0, 1.0)) * _LightColor0.xyz) * atten_30) * 0.5);
  spec_31 = tmpvar_37;
  frag_33.xyz = (frag_33.xyz + (tmpvar_37 * tmpvar_5));
  c_1.xyz = frag_33.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD4 = _WorldSpaceLightPos0.xyz;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD1, xlv_TEXCOORD2), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = pow (2.0, (8.0 - ((7.0 + tmpvar_5.w) - (_Shininess * tmpvar_5.w))));
  vec4 frag_8;
  float tmpvar_9;
  tmpvar_9 = clamp (dot (xlv_TEXCOORD3, xlv_TEXCOORD4), 0.0, 1.0);
  frag_8.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_9)) * diff_3.xyz);
  frag_8.w = diff_3.w;
  frag_8.xyz = (frag_8.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize((normalize(xlv_TEXCOORD2) + xlv_TEXCOORD4))), 0.0, 1.0), tmpvar_7)) * clamp ((10.0 * tmpvar_9), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec_2.xyz * ((tmpvar_7 * 0.159155) + 0.31831))));
  c_1.xyz = frag_8.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_1);
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_4, xlv_TEXCOORD2), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_7.w) - (shininess_17 * spec_7.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_7.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_23;
  lightDir_2 = xlv_TEXCOORD4;
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize(xlv_TEXCOORD2);
  mediump vec3 lightDir_25;
  lightDir_25 = lightDir_2;
  mediump vec3 viewDir_26;
  viewDir_26 = tmpvar_24;
  mediump vec3 spec_27;
  highp float specRefl_28;
  mediump vec4 frag_29;
  mediump float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_3, lightDir_25), 0.0, 1.0);
  frag_29.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_30)) * diff_8.xyz);
  frag_29.w = diff_8.w;
  mediump float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_3, normalize((viewDir_26 + lightDir_25))), 0.0, 1.0);
  specRefl_28 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = vec3(pow (specRefl_28, tmpvar_18));
  spec_27 = tmpvar_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = (((spec_27 * clamp ((10.0 * tmpvar_30), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_27 = tmpvar_33;
  frag_29.xyz = (frag_29.xyz + (tmpvar_33 * tmpvar_5));
  c_1.xyz = frag_29.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD4 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD1, xlv_TEXCOORD2), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = pow (2.0, (8.0 - ((7.0 + tmpvar_5.w) - (_Shininess * tmpvar_5.w))));
  vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD4);
  float atten_9;
  atten_9 = ((float((xlv_TEXCOORD5.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD5.xyz, xlv_TEXCOORD5.xyz))).w);
  vec4 frag_10;
  float tmpvar_11;
  tmpvar_11 = clamp (dot (xlv_TEXCOORD3, tmpvar_8), 0.0, 1.0);
  frag_10.xyz = ((_LightColor0.xyz * ((atten_9 * 2.0) * tmpvar_11)) * diff_3.xyz);
  frag_10.w = diff_3.w;
  frag_10.xyz = (frag_10.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize((normalize(xlv_TEXCOORD2) + tmpvar_8))), 0.0, 1.0), tmpvar_7)) * clamp ((10.0 * tmpvar_11), 0.0, 1.0)) * _LightColor0.xyz) * atten_9) * 0.5) * (spec_2.xyz * ((tmpvar_7 * 0.159155) + 0.31831))));
  c_1.xyz = frag_10.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_1);
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_4, xlv_TEXCOORD2), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_7.w) - (shininess_17 * spec_7.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_7.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(xlv_TEXCOORD4);
  lightDir_2 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD2);
  lowp vec4 tmpvar_26;
  highp vec2 P_27;
  P_27 = ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5);
  tmpvar_26 = texture2D (_LightTexture0, P_27);
  highp float tmpvar_28;
  tmpvar_28 = dot (xlv_TEXCOORD5.xyz, xlv_TEXCOORD5.xyz);
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_LightTextureB0, vec2(tmpvar_28));
  mediump vec3 lightDir_30;
  lightDir_30 = lightDir_2;
  mediump vec3 viewDir_31;
  viewDir_31 = tmpvar_25;
  mediump float atten_32;
  atten_32 = ((float((xlv_TEXCOORD5.z > 0.0)) * tmpvar_26.w) * tmpvar_29.w);
  mediump vec3 spec_33;
  highp float specRefl_34;
  mediump vec4 frag_35;
  mediump float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_3, lightDir_30), 0.0, 1.0);
  frag_35.xyz = ((_LightColor0.xyz * ((atten_32 * 2.0) * tmpvar_36)) * diff_8.xyz);
  frag_35.w = diff_8.w;
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_3, normalize((viewDir_31 + lightDir_30))), 0.0, 1.0);
  specRefl_34 = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = vec3(pow (specRefl_34, tmpvar_18));
  spec_33 = tmpvar_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = ((((spec_33 * clamp ((10.0 * tmpvar_36), 0.0, 1.0)) * _LightColor0.xyz) * atten_32) * 0.5);
  spec_33 = tmpvar_39;
  frag_35.xyz = (frag_35.xyz + (tmpvar_39 * tmpvar_5));
  c_1.xyz = frag_35.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD4 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD1, xlv_TEXCOORD2), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = pow (2.0, (8.0 - ((7.0 + tmpvar_5.w) - (_Shininess * tmpvar_5.w))));
  vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD4);
  float atten_9;
  atten_9 = (texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5))).w * textureCube (_LightTexture0, xlv_TEXCOORD5).w);
  vec4 frag_10;
  float tmpvar_11;
  tmpvar_11 = clamp (dot (xlv_TEXCOORD3, tmpvar_8), 0.0, 1.0);
  frag_10.xyz = ((_LightColor0.xyz * ((atten_9 * 2.0) * tmpvar_11)) * diff_3.xyz);
  frag_10.w = diff_3.w;
  frag_10.xyz = (frag_10.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize((normalize(xlv_TEXCOORD2) + tmpvar_8))), 0.0, 1.0), tmpvar_7)) * clamp ((10.0 * tmpvar_11), 0.0, 1.0)) * _LightColor0.xyz) * atten_9) * 0.5) * (spec_2.xyz * ((tmpvar_7 * 0.159155) + 0.31831))));
  c_1.xyz = frag_10.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_1);
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_4, xlv_TEXCOORD2), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_7.w) - (shininess_17 * spec_7.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_7.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(xlv_TEXCOORD4);
  lightDir_2 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD2);
  highp float tmpvar_26;
  tmpvar_26 = dot (xlv_TEXCOORD5, xlv_TEXCOORD5);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_LightTextureB0, vec2(tmpvar_26));
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_LightTexture0, xlv_TEXCOORD5);
  mediump vec3 lightDir_29;
  lightDir_29 = lightDir_2;
  mediump vec3 viewDir_30;
  viewDir_30 = tmpvar_25;
  mediump float atten_31;
  atten_31 = (tmpvar_27.w * tmpvar_28.w);
  mediump vec3 spec_32;
  highp float specRefl_33;
  mediump vec4 frag_34;
  mediump float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_3, lightDir_29), 0.0, 1.0);
  frag_34.xyz = ((_LightColor0.xyz * ((atten_31 * 2.0) * tmpvar_35)) * diff_8.xyz);
  frag_34.w = diff_8.w;
  mediump float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_3, normalize((viewDir_30 + lightDir_29))), 0.0, 1.0);
  specRefl_33 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = vec3(pow (specRefl_33, tmpvar_18));
  spec_32 = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = ((((spec_32 * clamp ((10.0 * tmpvar_35), 0.0, 1.0)) * _LightColor0.xyz) * atten_31) * 0.5);
  spec_32 = tmpvar_38;
  frag_34.xyz = (frag_34.xyz + (tmpvar_38 * tmpvar_5));
  c_1.xyz = frag_34.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_1 * gl_Normal);
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD4 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec2 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _Fresnel;
uniform float _Shininess;
uniform float _SpecInt;
uniform sampler2D _SpecTex;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _SpecColor;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 spec_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_5.w;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (xlv_TEXCOORD1, xlv_TEXCOORD2), 0.0, 1.0));
  spec_2.xyz = (tmpvar_5.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_7;
  tmpvar_7 = pow (2.0, (8.0 - ((7.0 + tmpvar_5.w) - (_Shininess * tmpvar_5.w))));
  float atten_8;
  atten_8 = texture2D (_LightTexture0, xlv_TEXCOORD5).w;
  vec4 frag_9;
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD3, xlv_TEXCOORD4), 0.0, 1.0);
  frag_9.xyz = ((_LightColor0.xyz * ((atten_8 * 2.0) * tmpvar_10)) * diff_3.xyz);
  frag_9.w = diff_3.w;
  frag_9.xyz = (frag_9.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize((normalize(xlv_TEXCOORD2) + xlv_TEXCOORD4))), 0.0, 1.0), tmpvar_7)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten_8) * 0.5) * (spec_2.xyz * ((tmpvar_7 * 0.159155) + 0.31831))));
  c_1.xyz = frag_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}


#endif
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_1);
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform highp float _Fresnel;
uniform highp float _Shininess;
uniform highp float _SpecInt;
uniform sampler2D _SpecTex;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
  mediump vec4 spec_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_4, xlv_TEXCOORD2), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_7.w) - (shininess_17 * spec_7.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_7.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_5 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_23;
  lightDir_2 = xlv_TEXCOORD4;
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize(xlv_TEXCOORD2);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_LightTexture0, xlv_TEXCOORD5);
  mediump vec3 lightDir_26;
  lightDir_26 = lightDir_2;
  mediump vec3 viewDir_27;
  viewDir_27 = tmpvar_24;
  mediump float atten_28;
  atten_28 = tmpvar_25.w;
  mediump vec3 spec_29;
  highp float specRefl_30;
  mediump vec4 frag_31;
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_3, lightDir_26), 0.0, 1.0);
  frag_31.xyz = ((_LightColor0.xyz * ((atten_28 * 2.0) * tmpvar_32)) * diff_8.xyz);
  frag_31.w = diff_8.w;
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_3, normalize((viewDir_27 + lightDir_26))), 0.0, 1.0);
  specRefl_30 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = vec3(pow (specRefl_30, tmpvar_18));
  spec_29 = tmpvar_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = ((((spec_29 * clamp ((10.0 * tmpvar_32), 0.0, 1.0)) * _LightColor0.xyz) * atten_28) * 0.5);
  spec_29 = tmpvar_35;
  frag_31.xyz = (frag_31.xyz + (tmpvar_35 * tmpvar_5));
  c_1.xyz = frag_31.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 5
SubProgram "opengl " {
Keywords { "POINT" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "SPOT" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLSL"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

}
	}

#LINE 62

	}
	
	FallBack "Diffuse"
}
