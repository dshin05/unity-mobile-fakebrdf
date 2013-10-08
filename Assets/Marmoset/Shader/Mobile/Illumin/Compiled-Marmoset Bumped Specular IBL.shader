// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Mobile/Self-Illumin/Bumped Specular IBL" {
	Properties {
		_Color   ("Diffuse Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecInt ("Specular Intensity", Float) = 1.0
		_Shininess ("Specular Sharpness", Range(2.0,8.0)) = 4.0
		_Fresnel ("Fresnel Strength", Range(0.0,1.0)) = 0.0
		_MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
		_SpecTex ("Specular(RGB) Gloss(A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) 	= "bump" {}
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
		LOD 400
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
varying vec3 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
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
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_1 = TANGENT.xyz;
  tmpvar_2 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_1.x;
  tmpvar_3[0].y = tmpvar_2.x;
  tmpvar_3[0].z = gl_Normal.x;
  tmpvar_3[1].x = tmpvar_1.y;
  tmpvar_3[1].y = tmpvar_2.y;
  tmpvar_3[1].z = gl_Normal.y;
  tmpvar_3[2].x = tmpvar_1.z;
  tmpvar_3[2].y = tmpvar_2.z;
  tmpvar_3[2].z = gl_Normal.z;
  vec3 v_4;
  v_4.x = _Object2World[0].x;
  v_4.y = _Object2World[1].x;
  v_4.z = _Object2World[2].x;
  vec3 v_5;
  v_5.x = _Object2World[0].y;
  v_5.y = _Object2World[1].y;
  v_5.z = _Object2World[2].y;
  vec3 v_6;
  v_6.x = _Object2World[0].z;
  v_6.y = _Object2World[1].z;
  v_6.z = _Object2World[2].z;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_8;
  vec3 x2_11;
  vec3 x1_12;
  x1_12.x = dot (unity_SHAr, tmpvar_10);
  x1_12.y = dot (unity_SHAg, tmpvar_10);
  x1_12.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_8.xyzz * tmpvar_8.yzzx);
  x2_11.x = dot (unity_SHBr, tmpvar_13);
  x2_11.y = dot (unity_SHBg, tmpvar_13);
  x2_11.z = dot (unity_SHBb, tmpvar_13);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = ((tmpvar_3 * v_4) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_3 * v_5) * unity_Scale.w);
  xlv_TEXCOORD5 = ((tmpvar_3 * v_6) * unity_Scale.w);
  xlv_TEXCOORD6 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD7 = ((x1_12 + x2_11) + (unity_SHC.xyz * ((tmpvar_8.x * tmpvar_8.x) - (tmpvar_8.y * tmpvar_8.y))));
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec3 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_7.w;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_7.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_9;
  tmpvar_9 = ((7.0 + tmpvar_7.w) - (_Shininess * tmpvar_7.w));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - tmpvar_9));
  vec3 tmpvar_11;
  tmpvar_11.x = dot (xlv_TEXCOORD3, normal_6);
  tmpvar_11.y = dot (xlv_TEXCOORD4, normal_6);
  tmpvar_11.z = dot (xlv_TEXCOORD5, normal_6);
  vec3 i_12;
  i_12 = -(xlv_TEXCOORD2);
  vec4 tmpvar_13;
  tmpvar_13.xyz = (i_12 - (2.0 * (dot (tmpvar_11, i_12) * tmpvar_11)));
  tmpvar_13.w = tmpvar_9;
  vec4 tmpvar_14;
  tmpvar_14 = textureCubeLod (_SpecCubeIBL, tmpvar_13.xyz, tmpvar_9);
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_11);
  vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_16.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_16.w * (_EmissionLM * _ExposureIBL.w));
  vec4 frag_17;
  float tmpvar_18;
  tmpvar_18 = clamp (dot (normal_6, xlv_TEXCOORD6), 0.0, 1.0);
  frag_17.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_18)) * diff_4.xyz);
  frag_17.w = diff_4.w;
  frag_17.xyz = (frag_17.xyz + ((((vec3(pow (clamp (dot (normal_6, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD6))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_18), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec_3.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c_1.w = frag_17.w;
  c_1.xyz = (frag_17.xyz + (diff_4.xyz * xlv_TEXCOORD7));
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  vec3 v_12;
  v_12.x = _Object2World[0].x;
  v_12.y = _Object2World[1].x;
  v_12.z = _Object2World[2].x;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_11 * v_12) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  vec3 v_14;
  v_14.x = _Object2World[0].y;
  v_14.y = _Object2World[1].y;
  v_14.z = _Object2World[2].y;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_11 * v_14) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  vec3 v_16;
  v_16.x = _Object2World[0].z;
  v_16.y = _Object2World[1].z;
  v_16.z = _Object2World[2].z;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_11 * v_16) * unity_Scale.w);
  tmpvar_6 = tmpvar_17;
  mat3 tmpvar_18;
  tmpvar_18[0] = _Object2World[0].xyz;
  tmpvar_18[1] = _Object2World[1].xyz;
  tmpvar_18[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_7 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (tmpvar_18 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_22;
  mediump vec4 normal_23;
  normal_23 = tmpvar_21;
  highp float vC_24;
  mediump vec3 x3_25;
  mediump vec3 x2_26;
  mediump vec3 x1_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAr, normal_23);
  x1_27.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAg, normal_23);
  x1_27.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAb, normal_23);
  x1_27.z = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31 = (normal_23.xyzz * normal_23.yzzx);
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBr, tmpvar_31);
  x2_26.x = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBg, tmpvar_31);
  x2_26.y = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBb, tmpvar_31);
  x2_26.z = tmpvar_34;
  mediump float tmpvar_35;
  tmpvar_35 = ((normal_23.x * normal_23.x) - (normal_23.y * normal_23.y));
  vC_24 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (unity_SHC.xyz * vC_24);
  x3_25 = tmpvar_36;
  tmpvar_22 = ((x1_27 + x2_26) + x3_25);
  shlight_3 = tmpvar_22;
  tmpvar_8 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = tmpvar_8;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump vec4 glow_7;
  mediump vec4 spec_8;
  highp vec3 N_9;
  mediump vec4 diff_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_10 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff_10 * _Color);
  diff_10 = tmpvar_12;
  diff_10.xyz = (diff_10.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_9 = tmpvar_13;
  tmpvar_5 = N_9;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_8 = tmpvar_14;
  mediump float specIntensity_15;
  specIntensity_15 = _SpecInt;
  mediump float fresnel_16;
  fresnel_16 = _Fresnel;
  mediump float factor_17;
  highp float tmpvar_18;
  tmpvar_18 = (1.0 - clamp (dot (N_9, xlv_TEXCOORD1), 0.0, 1.0));
  factor_17 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (factor_17 * (factor_17 * factor_17));
  factor_17 = tmpvar_19;
  spec_8.xyz = (spec_8.xyz * ((_SpecColor.xyz * (specIntensity_15 * mix (1.0, tmpvar_19, (fresnel_16 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_20;
  mediump float shininess_21;
  shininess_21 = _Shininess;
  tmpvar_20 = ((7.0 + spec_8.w) - (shininess_21 * spec_8.w));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_20));
  highp vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_2, N_9);
  tmpvar_23.y = dot (tmpvar_3, N_9);
  tmpvar_23.z = dot (tmpvar_4, N_9);
  N_9 = tmpvar_23;
  highp vec3 i_24;
  i_24 = -(xlv_TEXCOORD2);
  highp float glossLod_25;
  glossLod_25 = tmpvar_20;
  mediump vec4 spec_26;
  mediump vec4 lookup_27;
  highp vec4 tmpvar_28;
  tmpvar_28.xyz = (i_24 - (2.0 * (dot (tmpvar_23, i_24) * tmpvar_23)));
  tmpvar_28.w = glossLod_25;
  lookup_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCubeLod (_SpecCubeIBL, lookup_27.xyz, lookup_27.w);
  spec_26 = tmpvar_29;
  highp float gloss_30;
  gloss_30 = tmpvar_22;
  highp vec3 tmpvar_31;
  tmpvar_31 = (spec_8.xyz * ((gloss_30 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_31;
  mediump vec4 diff_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_DiffCubeIBL, tmpvar_23);
  diff_32 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_7 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow_7.xyz * _GlowColor.xyz);
  glow_7.xyz = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = (glow_7.w * (_EmissionLM * _ExposureIBL.w));
  glow_7.w = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_38;
  lightDir_38 = xlv_TEXCOORD6;
  mediump vec3 viewDir_39;
  viewDir_39 = tmpvar_37;
  mediump vec3 spec_40;
  highp float specRefl_41;
  mediump vec4 frag_42;
  mediump float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_5, lightDir_38), 0.0, 1.0);
  frag_42.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_43)) * diff_10.xyz);
  frag_42.w = diff_10.w;
  mediump float tmpvar_44;
  tmpvar_44 = clamp (dot (tmpvar_5, normalize((viewDir_39 + lightDir_38))), 0.0, 1.0);
  specRefl_41 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = vec3(pow (specRefl_41, tmpvar_22));
  spec_40 = tmpvar_45;
  mediump vec3 tmpvar_46;
  tmpvar_46 = (((spec_40 * clamp ((10.0 * tmpvar_43), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_40 = tmpvar_46;
  frag_42.xyz = (frag_42.xyz + (tmpvar_46 * tmpvar_6));
  c_1 = frag_42;
  mediump vec3 tmpvar_47;
  tmpvar_47 = (c_1.xyz + (diff_10.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_47;
  mediump vec3 tmpvar_48;
  tmpvar_48 = (c_1.xyz + (((((spec_26.xyz * spec_26.w) * spec_8.xyz) * _ExposureIBL.y) + (((diff_32.xyz * diff_32.w) * diff_10.xyz) * _ExposureIBL.x)) + (glow_7.xyz * glow_7.w)));
  c_1.xyz = tmpvar_48;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_1 = TANGENT.xyz;
  tmpvar_2 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_1.x;
  tmpvar_3[0].y = tmpvar_2.x;
  tmpvar_3[0].z = gl_Normal.x;
  tmpvar_3[1].x = tmpvar_1.y;
  tmpvar_3[1].y = tmpvar_2.y;
  tmpvar_3[1].z = gl_Normal.y;
  tmpvar_3[2].x = tmpvar_1.z;
  tmpvar_3[2].y = tmpvar_2.z;
  tmpvar_3[2].z = gl_Normal.z;
  vec3 v_4;
  v_4.x = _Object2World[0].x;
  v_4.y = _Object2World[1].x;
  v_4.z = _Object2World[2].x;
  vec3 v_5;
  v_5.x = _Object2World[0].y;
  v_5.y = _Object2World[1].y;
  v_5.z = _Object2World[2].y;
  vec3 v_6;
  v_6.x = _Object2World[0].z;
  v_6.y = _Object2World[1].z;
  v_6.z = _Object2World[2].z;
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = ((tmpvar_3 * v_4) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_3 * v_5) * unity_Scale.w);
  xlv_TEXCOORD5 = ((tmpvar_3 * v_6) * unity_Scale.w);
  xlv_TEXCOORD6 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec2 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_7.w;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_7.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_9;
  tmpvar_9 = ((7.0 + tmpvar_7.w) - (_Shininess * tmpvar_7.w));
  vec3 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD3, normal_6);
  tmpvar_10.y = dot (xlv_TEXCOORD4, normal_6);
  tmpvar_10.z = dot (xlv_TEXCOORD5, normal_6);
  vec3 i_11;
  i_11 = -(xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12.xyz = (i_11 - (2.0 * (dot (tmpvar_10, i_11) * tmpvar_10)));
  tmpvar_12.w = tmpvar_9;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_9);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_10);
  vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_15.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_15.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_Lightmap, xlv_TEXCOORD6);
  c_1.xyz = (diff_4.xyz * ((8.0 * tmpvar_16.w) * tmpvar_16.xyz));
  c_1.w = diff_4.w;
  c_1.xyz = (c_1.xyz + (((((tmpvar_13.xyz * tmpvar_13.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
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

varying highp vec2 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_6 = tmpvar_1.xyz;
  tmpvar_7 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_6.x;
  tmpvar_8[0].y = tmpvar_7.x;
  tmpvar_8[0].z = tmpvar_2.x;
  tmpvar_8[1].x = tmpvar_6.y;
  tmpvar_8[1].y = tmpvar_7.y;
  tmpvar_8[1].z = tmpvar_2.y;
  tmpvar_8[2].x = tmpvar_6.z;
  tmpvar_8[2].y = tmpvar_7.z;
  tmpvar_8[2].z = tmpvar_2.z;
  vec3 v_9;
  v_9.x = _Object2World[0].x;
  v_9.y = _Object2World[1].x;
  v_9.z = _Object2World[2].x;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_8 * v_9) * unity_Scale.w);
  tmpvar_3 = tmpvar_10;
  vec3 v_11;
  v_11.x = _Object2World[0].y;
  v_11.y = _Object2World[1].y;
  v_11.z = _Object2World[2].y;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_8 * v_11) * unity_Scale.w);
  tmpvar_4 = tmpvar_12;
  vec3 v_13;
  v_13.x = _Object2World[0].z;
  v_13.y = _Object2World[1].z;
  v_13.z = _Object2World[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_8 * v_13) * unity_Scale.w);
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_8 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec2 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec4 glow_5;
  mediump vec4 spec_6;
  highp vec3 N_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  mediump float tmpvar_11;
  tmpvar_11 = diff_8.w;
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_6 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_7, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_6.xyz = (spec_6.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_6.w) - (shininess_20 * spec_6.w));
  highp vec3 tmpvar_21;
  tmpvar_21.x = dot (tmpvar_2, N_7);
  tmpvar_21.y = dot (tmpvar_3, N_7);
  tmpvar_21.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_21;
  highp vec3 i_22;
  i_22 = -(xlv_TEXCOORD2);
  highp float glossLod_23;
  glossLod_23 = tmpvar_19;
  mediump vec4 spec_24;
  mediump vec4 lookup_25;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = (i_22 - (2.0 * (dot (tmpvar_21, i_22) * tmpvar_21)));
  tmpvar_26.w = glossLod_23;
  lookup_25 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup_25.xyz, lookup_25.w);
  spec_24 = tmpvar_27;
  mediump vec4 diff_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_21);
  diff_28 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_32;
  lowp vec3 tmpvar_33;
  tmpvar_33 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD6).xyz);
  mediump vec3 tmpvar_34;
  tmpvar_34 = (diff_8.xyz * tmpvar_33);
  c_1.xyz = tmpvar_34;
  c_1.w = tmpvar_11;
  mediump vec3 tmpvar_35;
  tmpvar_35 = (c_1.xyz + (((((spec_24.xyz * spec_24.w) * spec_6.xyz) * _ExposureIBL.y) + (((diff_28.xyz * diff_28.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_5.xyz * glow_5.w)));
  c_1.xyz = tmpvar_35;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD8;
varying vec3 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
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
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec3 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_2 = TANGENT.xyz;
  tmpvar_3 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_2.x;
  tmpvar_4[0].y = tmpvar_3.x;
  tmpvar_4[0].z = gl_Normal.x;
  tmpvar_4[1].x = tmpvar_2.y;
  tmpvar_4[1].y = tmpvar_3.y;
  tmpvar_4[1].z = gl_Normal.y;
  tmpvar_4[2].x = tmpvar_2.z;
  tmpvar_4[2].y = tmpvar_3.z;
  tmpvar_4[2].z = gl_Normal.z;
  vec3 v_5;
  v_5.x = _Object2World[0].x;
  v_5.y = _Object2World[1].x;
  v_5.z = _Object2World[2].x;
  vec3 v_6;
  v_6.x = _Object2World[0].y;
  v_6.y = _Object2World[1].y;
  v_6.z = _Object2World[2].y;
  vec3 v_7;
  v_7.x = _Object2World[0].z;
  v_7.y = _Object2World[1].z;
  v_7.z = _Object2World[2].z;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  vec3 x2_12;
  vec3 x1_13;
  x1_13.x = dot (unity_SHAr, tmpvar_11);
  x1_13.y = dot (unity_SHAg, tmpvar_11);
  x1_13.z = dot (unity_SHAb, tmpvar_11);
  vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9.xyzz * tmpvar_9.yzzx);
  x2_12.x = dot (unity_SHBr, tmpvar_14);
  x2_12.y = dot (unity_SHBg, tmpvar_14);
  x2_12.z = dot (unity_SHBb, tmpvar_14);
  vec4 o_15;
  vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_1 * 0.5);
  vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_15.xy = (tmpvar_17 + tmpvar_16.w);
  o_15.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (((_World2Object * tmpvar_10).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = ((tmpvar_4 * v_5) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_4 * v_6) * unity_Scale.w);
  xlv_TEXCOORD5 = ((tmpvar_4 * v_7) * unity_Scale.w);
  xlv_TEXCOORD6 = (tmpvar_4 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD7 = ((x1_13 + x2_12) + (unity_SHC.xyz * ((tmpvar_9.x * tmpvar_9.x) - (tmpvar_9.y * tmpvar_9.y))));
  xlv_TEXCOORD8 = o_15;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec4 xlv_TEXCOORD8;
varying vec3 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_7.w;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_7.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_9;
  tmpvar_9 = ((7.0 + tmpvar_7.w) - (_Shininess * tmpvar_7.w));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - tmpvar_9));
  vec3 tmpvar_11;
  tmpvar_11.x = dot (xlv_TEXCOORD3, normal_6);
  tmpvar_11.y = dot (xlv_TEXCOORD4, normal_6);
  tmpvar_11.z = dot (xlv_TEXCOORD5, normal_6);
  vec3 i_12;
  i_12 = -(xlv_TEXCOORD2);
  vec4 tmpvar_13;
  tmpvar_13.xyz = (i_12 - (2.0 * (dot (tmpvar_11, i_12) * tmpvar_11)));
  tmpvar_13.w = tmpvar_9;
  vec4 tmpvar_14;
  tmpvar_14 = textureCubeLod (_SpecCubeIBL, tmpvar_13.xyz, tmpvar_9);
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_11);
  vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_16.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_16.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD8);
  vec4 frag_18;
  float tmpvar_19;
  tmpvar_19 = clamp (dot (normal_6, xlv_TEXCOORD6), 0.0, 1.0);
  frag_18.xyz = ((_LightColor0.xyz * ((tmpvar_17.x * 2.0) * tmpvar_19)) * diff_4.xyz);
  frag_18.w = diff_4.w;
  frag_18.xyz = (frag_18.xyz + (((((vec3(pow (clamp (dot (normal_6, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD6))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_19), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_17.x) * 0.5) * (spec_3.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c_1.w = frag_18.w;
  c_1.xyz = (frag_18.xyz + (diff_4.xyz * xlv_TEXCOORD7));
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
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

varying highp vec4 xlv_TEXCOORD8;
varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  vec3 v_12;
  v_12.x = _Object2World[0].x;
  v_12.y = _Object2World[1].x;
  v_12.z = _Object2World[2].x;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_11 * v_12) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  vec3 v_14;
  v_14.x = _Object2World[0].y;
  v_14.y = _Object2World[1].y;
  v_14.z = _Object2World[2].y;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_11 * v_14) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  vec3 v_16;
  v_16.x = _Object2World[0].z;
  v_16.y = _Object2World[1].z;
  v_16.z = _Object2World[2].z;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_11 * v_16) * unity_Scale.w);
  tmpvar_6 = tmpvar_17;
  mat3 tmpvar_18;
  tmpvar_18[0] = _Object2World[0].xyz;
  tmpvar_18[1] = _Object2World[1].xyz;
  tmpvar_18[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_7 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (tmpvar_18 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_22;
  mediump vec4 normal_23;
  normal_23 = tmpvar_21;
  highp float vC_24;
  mediump vec3 x3_25;
  mediump vec3 x2_26;
  mediump vec3 x1_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAr, normal_23);
  x1_27.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAg, normal_23);
  x1_27.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAb, normal_23);
  x1_27.z = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31 = (normal_23.xyzz * normal_23.yzzx);
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBr, tmpvar_31);
  x2_26.x = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBg, tmpvar_31);
  x2_26.y = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBb, tmpvar_31);
  x2_26.z = tmpvar_34;
  mediump float tmpvar_35;
  tmpvar_35 = ((normal_23.x * normal_23.x) - (normal_23.y * normal_23.y));
  vC_24 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (unity_SHC.xyz * vC_24);
  x3_25 = tmpvar_36;
  tmpvar_22 = ((x1_27 + x2_26) + x3_25);
  shlight_3 = tmpvar_22;
  tmpvar_8 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = tmpvar_8;
  xlv_TEXCOORD8 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec4 xlv_TEXCOORD8;
varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump vec4 glow_7;
  mediump vec4 spec_8;
  highp vec3 N_9;
  mediump vec4 diff_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_10 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff_10 * _Color);
  diff_10 = tmpvar_12;
  diff_10.xyz = (diff_10.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_9 = tmpvar_13;
  tmpvar_5 = N_9;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_8 = tmpvar_14;
  mediump float specIntensity_15;
  specIntensity_15 = _SpecInt;
  mediump float fresnel_16;
  fresnel_16 = _Fresnel;
  mediump float factor_17;
  highp float tmpvar_18;
  tmpvar_18 = (1.0 - clamp (dot (N_9, xlv_TEXCOORD1), 0.0, 1.0));
  factor_17 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (factor_17 * (factor_17 * factor_17));
  factor_17 = tmpvar_19;
  spec_8.xyz = (spec_8.xyz * ((_SpecColor.xyz * (specIntensity_15 * mix (1.0, tmpvar_19, (fresnel_16 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_20;
  mediump float shininess_21;
  shininess_21 = _Shininess;
  tmpvar_20 = ((7.0 + spec_8.w) - (shininess_21 * spec_8.w));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_20));
  highp vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_2, N_9);
  tmpvar_23.y = dot (tmpvar_3, N_9);
  tmpvar_23.z = dot (tmpvar_4, N_9);
  N_9 = tmpvar_23;
  highp vec3 i_24;
  i_24 = -(xlv_TEXCOORD2);
  highp float glossLod_25;
  glossLod_25 = tmpvar_20;
  mediump vec4 spec_26;
  mediump vec4 lookup_27;
  highp vec4 tmpvar_28;
  tmpvar_28.xyz = (i_24 - (2.0 * (dot (tmpvar_23, i_24) * tmpvar_23)));
  tmpvar_28.w = glossLod_25;
  lookup_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCubeLod (_SpecCubeIBL, lookup_27.xyz, lookup_27.w);
  spec_26 = tmpvar_29;
  highp float gloss_30;
  gloss_30 = tmpvar_22;
  highp vec3 tmpvar_31;
  tmpvar_31 = (spec_8.xyz * ((gloss_30 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_31;
  mediump vec4 diff_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_DiffCubeIBL, tmpvar_23);
  diff_32 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_7 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow_7.xyz * _GlowColor.xyz);
  glow_7.xyz = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = (glow_7.w * (_EmissionLM * _ExposureIBL.w));
  glow_7.w = tmpvar_36;
  lowp float tmpvar_37;
  mediump float lightShadowDataX_38;
  highp float dist_39;
  lowp float tmpvar_40;
  tmpvar_40 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD8).x;
  dist_39 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = _LightShadowData.x;
  lightShadowDataX_38 = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = max (float((dist_39 > (xlv_TEXCOORD8.z / xlv_TEXCOORD8.w))), lightShadowDataX_38);
  tmpvar_37 = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_44;
  lightDir_44 = xlv_TEXCOORD6;
  mediump vec3 viewDir_45;
  viewDir_45 = tmpvar_43;
  mediump float atten_46;
  atten_46 = tmpvar_37;
  mediump vec3 spec_47;
  highp float specRefl_48;
  mediump vec4 frag_49;
  mediump float tmpvar_50;
  tmpvar_50 = clamp (dot (tmpvar_5, lightDir_44), 0.0, 1.0);
  frag_49.xyz = ((_LightColor0.xyz * ((atten_46 * 2.0) * tmpvar_50)) * diff_10.xyz);
  frag_49.w = diff_10.w;
  mediump float tmpvar_51;
  tmpvar_51 = clamp (dot (tmpvar_5, normalize((viewDir_45 + lightDir_44))), 0.0, 1.0);
  specRefl_48 = tmpvar_51;
  highp vec3 tmpvar_52;
  tmpvar_52 = vec3(pow (specRefl_48, tmpvar_22));
  spec_47 = tmpvar_52;
  mediump vec3 tmpvar_53;
  tmpvar_53 = ((((spec_47 * clamp ((10.0 * tmpvar_50), 0.0, 1.0)) * _LightColor0.xyz) * atten_46) * 0.5);
  spec_47 = tmpvar_53;
  frag_49.xyz = (frag_49.xyz + (tmpvar_53 * tmpvar_6));
  c_1 = frag_49;
  mediump vec3 tmpvar_54;
  tmpvar_54 = (c_1.xyz + (diff_10.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_54;
  mediump vec3 tmpvar_55;
  tmpvar_55 = (c_1.xyz + (((((spec_26.xyz * spec_26.w) * spec_8.xyz) * _ExposureIBL.y) + (((diff_32.xyz * diff_32.w) * diff_10.xyz) * _ExposureIBL.x)) + (glow_7.xyz * glow_7.w)));
  c_1.xyz = tmpvar_55;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec2 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
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
  vec3 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_2 = TANGENT.xyz;
  tmpvar_3 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_2.x;
  tmpvar_4[0].y = tmpvar_3.x;
  tmpvar_4[0].z = gl_Normal.x;
  tmpvar_4[1].x = tmpvar_2.y;
  tmpvar_4[1].y = tmpvar_3.y;
  tmpvar_4[1].z = gl_Normal.y;
  tmpvar_4[2].x = tmpvar_2.z;
  tmpvar_4[2].y = tmpvar_3.z;
  tmpvar_4[2].z = gl_Normal.z;
  vec3 v_5;
  v_5.x = _Object2World[0].x;
  v_5.y = _Object2World[1].x;
  v_5.z = _Object2World[2].x;
  vec3 v_6;
  v_6.x = _Object2World[0].y;
  v_6.y = _Object2World[1].y;
  v_6.z = _Object2World[2].y;
  vec3 v_7;
  v_7.x = _Object2World[0].z;
  v_7.y = _Object2World[1].z;
  v_7.z = _Object2World[2].z;
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  vec4 o_9;
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_1 * 0.5);
  vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10.x;
  tmpvar_11.y = (tmpvar_10.y * _ProjectionParams.x);
  o_9.xy = (tmpvar_11 + tmpvar_10.w);
  o_9.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = ((tmpvar_4 * v_5) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_4 * v_6) * unity_Scale.w);
  xlv_TEXCOORD5 = ((tmpvar_4 * v_7) * unity_Scale.w);
  xlv_TEXCOORD6 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD7 = o_9;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec4 xlv_TEXCOORD7;
varying vec2 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_7.w;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_7.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_9;
  tmpvar_9 = ((7.0 + tmpvar_7.w) - (_Shininess * tmpvar_7.w));
  vec3 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD3, normal_6);
  tmpvar_10.y = dot (xlv_TEXCOORD4, normal_6);
  tmpvar_10.z = dot (xlv_TEXCOORD5, normal_6);
  vec3 i_11;
  i_11 = -(xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12.xyz = (i_11 - (2.0 * (dot (tmpvar_10, i_11) * tmpvar_10)));
  tmpvar_12.w = tmpvar_9;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_9);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_10);
  vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_15.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_15.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_16;
  tmpvar_16 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_Lightmap, xlv_TEXCOORD6);
  vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_17.w) * tmpvar_17.xyz);
  c_1.xyz = (diff_4.xyz * max (min (tmpvar_18, ((tmpvar_16.x * 2.0) * tmpvar_17.xyz)), (tmpvar_18 * tmpvar_16.x)));
  c_1.w = diff_4.w;
  c_1.xyz = (c_1.xyz + (((((tmpvar_13.xyz * tmpvar_13.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
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

varying highp vec4 xlv_TEXCOORD7;
varying highp vec2 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_6 = tmpvar_1.xyz;
  tmpvar_7 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_6.x;
  tmpvar_8[0].y = tmpvar_7.x;
  tmpvar_8[0].z = tmpvar_2.x;
  tmpvar_8[1].x = tmpvar_6.y;
  tmpvar_8[1].y = tmpvar_7.y;
  tmpvar_8[1].z = tmpvar_2.y;
  tmpvar_8[2].x = tmpvar_6.z;
  tmpvar_8[2].y = tmpvar_7.z;
  tmpvar_8[2].z = tmpvar_2.z;
  vec3 v_9;
  v_9.x = _Object2World[0].x;
  v_9.y = _Object2World[1].x;
  v_9.z = _Object2World[2].x;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_8 * v_9) * unity_Scale.w);
  tmpvar_3 = tmpvar_10;
  vec3 v_11;
  v_11.x = _Object2World[0].y;
  v_11.y = _Object2World[1].y;
  v_11.z = _Object2World[2].y;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_8 * v_11) * unity_Scale.w);
  tmpvar_4 = tmpvar_12;
  vec3 v_13;
  v_13.x = _Object2World[0].z;
  v_13.y = _Object2World[1].z;
  v_13.z = _Object2World[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_8 * v_13) * unity_Scale.w);
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_8 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD7 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec4 xlv_TEXCOORD7;
varying highp vec2 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec4 glow_5;
  mediump vec4 spec_6;
  highp vec3 N_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  mediump float tmpvar_11;
  tmpvar_11 = diff_8.w;
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_6 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_7, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_6.xyz = (spec_6.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_6.w) - (shininess_20 * spec_6.w));
  highp vec3 tmpvar_21;
  tmpvar_21.x = dot (tmpvar_2, N_7);
  tmpvar_21.y = dot (tmpvar_3, N_7);
  tmpvar_21.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_21;
  highp vec3 i_22;
  i_22 = -(xlv_TEXCOORD2);
  highp float glossLod_23;
  glossLod_23 = tmpvar_19;
  mediump vec4 spec_24;
  mediump vec4 lookup_25;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = (i_22 - (2.0 * (dot (tmpvar_21, i_22) * tmpvar_21)));
  tmpvar_26.w = glossLod_23;
  lookup_25 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup_25.xyz, lookup_25.w);
  spec_24 = tmpvar_27;
  mediump vec4 diff_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_21);
  diff_28 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_32;
  lowp float tmpvar_33;
  mediump float lightShadowDataX_34;
  highp float dist_35;
  lowp float tmpvar_36;
  tmpvar_36 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  dist_35 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = _LightShadowData.x;
  lightShadowDataX_34 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = max (float((dist_35 > (xlv_TEXCOORD7.z / xlv_TEXCOORD7.w))), lightShadowDataX_34);
  tmpvar_33 = tmpvar_38;
  lowp vec3 tmpvar_39;
  tmpvar_39 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD6).xyz), vec3((tmpvar_33 * 2.0)));
  mediump vec3 tmpvar_40;
  tmpvar_40 = (diff_8.xyz * tmpvar_39);
  c_1.xyz = tmpvar_40;
  c_1.w = tmpvar_11;
  mediump vec3 tmpvar_41;
  tmpvar_41 = (c_1.xyz + (((((spec_24.xyz * spec_24.w) * spec_6.xyz) * _ExposureIBL.y) + (((diff_28.xyz * diff_28.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_5.xyz * glow_5.w)));
  c_1.xyz = tmpvar_41;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
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
uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_1 = TANGENT.xyz;
  tmpvar_2 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_1.x;
  tmpvar_3[0].y = tmpvar_2.x;
  tmpvar_3[0].z = gl_Normal.x;
  tmpvar_3[1].x = tmpvar_1.y;
  tmpvar_3[1].y = tmpvar_2.y;
  tmpvar_3[1].z = gl_Normal.y;
  tmpvar_3[2].x = tmpvar_1.z;
  tmpvar_3[2].y = tmpvar_2.z;
  tmpvar_3[2].z = gl_Normal.z;
  vec3 v_4;
  v_4.x = _Object2World[0].x;
  v_4.y = _Object2World[1].x;
  v_4.z = _Object2World[2].x;
  vec3 v_5;
  v_5.x = _Object2World[0].y;
  v_5.y = _Object2World[1].y;
  v_5.z = _Object2World[2].y;
  vec3 v_6;
  v_6.x = _Object2World[0].z;
  v_6.y = _Object2World[1].z;
  v_6.z = _Object2World[2].z;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_8;
  vec3 x2_11;
  vec3 x1_12;
  x1_12.x = dot (unity_SHAr, tmpvar_10);
  x1_12.y = dot (unity_SHAg, tmpvar_10);
  x1_12.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_8.xyzz * tmpvar_8.yzzx);
  x2_11.x = dot (unity_SHBr, tmpvar_13);
  x2_11.y = dot (unity_SHBg, tmpvar_13);
  x2_11.z = dot (unity_SHBb, tmpvar_13);
  vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_15;
  tmpvar_15 = (unity_4LightPosX0 - tmpvar_14.x);
  vec4 tmpvar_16;
  tmpvar_16 = (unity_4LightPosY0 - tmpvar_14.y);
  vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosZ0 - tmpvar_14.z);
  vec4 tmpvar_18;
  tmpvar_18 = (((tmpvar_15 * tmpvar_15) + (tmpvar_16 * tmpvar_16)) + (tmpvar_17 * tmpvar_17));
  vec4 tmpvar_19;
  tmpvar_19 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_15 * tmpvar_8.x) + (tmpvar_16 * tmpvar_8.y)) + (tmpvar_17 * tmpvar_8.z)) * inversesqrt(tmpvar_18))) * (1.0/((1.0 + (tmpvar_18 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = ((tmpvar_3 * v_4) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_3 * v_5) * unity_Scale.w);
  xlv_TEXCOORD5 = ((tmpvar_3 * v_6) * unity_Scale.w);
  xlv_TEXCOORD6 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD7 = (((x1_12 + x2_11) + (unity_SHC.xyz * ((tmpvar_8.x * tmpvar_8.x) - (tmpvar_8.y * tmpvar_8.y)))) + ((((unity_LightColor[0].xyz * tmpvar_19.x) + (unity_LightColor[1].xyz * tmpvar_19.y)) + (unity_LightColor[2].xyz * tmpvar_19.z)) + (unity_LightColor[3].xyz * tmpvar_19.w)));
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec3 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_7.w;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_7.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_9;
  tmpvar_9 = ((7.0 + tmpvar_7.w) - (_Shininess * tmpvar_7.w));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - tmpvar_9));
  vec3 tmpvar_11;
  tmpvar_11.x = dot (xlv_TEXCOORD3, normal_6);
  tmpvar_11.y = dot (xlv_TEXCOORD4, normal_6);
  tmpvar_11.z = dot (xlv_TEXCOORD5, normal_6);
  vec3 i_12;
  i_12 = -(xlv_TEXCOORD2);
  vec4 tmpvar_13;
  tmpvar_13.xyz = (i_12 - (2.0 * (dot (tmpvar_11, i_12) * tmpvar_11)));
  tmpvar_13.w = tmpvar_9;
  vec4 tmpvar_14;
  tmpvar_14 = textureCubeLod (_SpecCubeIBL, tmpvar_13.xyz, tmpvar_9);
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_11);
  vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_16.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_16.w * (_EmissionLM * _ExposureIBL.w));
  vec4 frag_17;
  float tmpvar_18;
  tmpvar_18 = clamp (dot (normal_6, xlv_TEXCOORD6), 0.0, 1.0);
  frag_17.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_18)) * diff_4.xyz);
  frag_17.w = diff_4.w;
  frag_17.xyz = (frag_17.xyz + ((((vec3(pow (clamp (dot (normal_6, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD6))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_18), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec_3.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c_1.w = frag_17.w;
  c_1.xyz = (frag_17.xyz + (diff_4.xyz * xlv_TEXCOORD7));
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  vec3 v_12;
  v_12.x = _Object2World[0].x;
  v_12.y = _Object2World[1].x;
  v_12.z = _Object2World[2].x;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_11 * v_12) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  vec3 v_14;
  v_14.x = _Object2World[0].y;
  v_14.y = _Object2World[1].y;
  v_14.z = _Object2World[2].y;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_11 * v_14) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  vec3 v_16;
  v_16.x = _Object2World[0].z;
  v_16.y = _Object2World[1].z;
  v_16.z = _Object2World[2].z;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_11 * v_16) * unity_Scale.w);
  tmpvar_6 = tmpvar_17;
  mat3 tmpvar_18;
  tmpvar_18[0] = _Object2World[0].xyz;
  tmpvar_18[1] = _Object2World[1].xyz;
  tmpvar_18[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_7 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_19;
  mediump vec3 tmpvar_23;
  mediump vec4 normal_24;
  normal_24 = tmpvar_22;
  highp float vC_25;
  mediump vec3 x3_26;
  mediump vec3 x2_27;
  mediump vec3 x1_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAr, normal_24);
  x1_28.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAg, normal_24);
  x1_28.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHAb, normal_24);
  x1_28.z = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32 = (normal_24.xyzz * normal_24.yzzx);
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBr, tmpvar_32);
  x2_27.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBg, tmpvar_32);
  x2_27.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHBb, tmpvar_32);
  x2_27.z = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = ((normal_24.x * normal_24.x) - (normal_24.y * normal_24.y));
  vC_25 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (unity_SHC.xyz * vC_25);
  x3_26 = tmpvar_37;
  tmpvar_23 = ((x1_28 + x2_27) + x3_26);
  shlight_3 = tmpvar_23;
  tmpvar_8 = shlight_3;
  highp vec3 tmpvar_38;
  tmpvar_38 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_39;
  tmpvar_39 = (unity_4LightPosX0 - tmpvar_38.x);
  highp vec4 tmpvar_40;
  tmpvar_40 = (unity_4LightPosY0 - tmpvar_38.y);
  highp vec4 tmpvar_41;
  tmpvar_41 = (unity_4LightPosZ0 - tmpvar_38.z);
  highp vec4 tmpvar_42;
  tmpvar_42 = (((tmpvar_39 * tmpvar_39) + (tmpvar_40 * tmpvar_40)) + (tmpvar_41 * tmpvar_41));
  highp vec4 tmpvar_43;
  tmpvar_43 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_39 * tmpvar_19.x) + (tmpvar_40 * tmpvar_19.y)) + (tmpvar_41 * tmpvar_19.z)) * inversesqrt(tmpvar_42))) * (1.0/((1.0 + (tmpvar_42 * unity_4LightAtten0)))));
  highp vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_8 + ((((unity_LightColor[0].xyz * tmpvar_43.x) + (unity_LightColor[1].xyz * tmpvar_43.y)) + (unity_LightColor[2].xyz * tmpvar_43.z)) + (unity_LightColor[3].xyz * tmpvar_43.w)));
  tmpvar_8 = tmpvar_44;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = tmpvar_8;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump vec4 glow_7;
  mediump vec4 spec_8;
  highp vec3 N_9;
  mediump vec4 diff_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_10 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff_10 * _Color);
  diff_10 = tmpvar_12;
  diff_10.xyz = (diff_10.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_9 = tmpvar_13;
  tmpvar_5 = N_9;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_8 = tmpvar_14;
  mediump float specIntensity_15;
  specIntensity_15 = _SpecInt;
  mediump float fresnel_16;
  fresnel_16 = _Fresnel;
  mediump float factor_17;
  highp float tmpvar_18;
  tmpvar_18 = (1.0 - clamp (dot (N_9, xlv_TEXCOORD1), 0.0, 1.0));
  factor_17 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (factor_17 * (factor_17 * factor_17));
  factor_17 = tmpvar_19;
  spec_8.xyz = (spec_8.xyz * ((_SpecColor.xyz * (specIntensity_15 * mix (1.0, tmpvar_19, (fresnel_16 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_20;
  mediump float shininess_21;
  shininess_21 = _Shininess;
  tmpvar_20 = ((7.0 + spec_8.w) - (shininess_21 * spec_8.w));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_20));
  highp vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_2, N_9);
  tmpvar_23.y = dot (tmpvar_3, N_9);
  tmpvar_23.z = dot (tmpvar_4, N_9);
  N_9 = tmpvar_23;
  highp vec3 i_24;
  i_24 = -(xlv_TEXCOORD2);
  highp float glossLod_25;
  glossLod_25 = tmpvar_20;
  mediump vec4 spec_26;
  mediump vec4 lookup_27;
  highp vec4 tmpvar_28;
  tmpvar_28.xyz = (i_24 - (2.0 * (dot (tmpvar_23, i_24) * tmpvar_23)));
  tmpvar_28.w = glossLod_25;
  lookup_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCubeLod (_SpecCubeIBL, lookup_27.xyz, lookup_27.w);
  spec_26 = tmpvar_29;
  highp float gloss_30;
  gloss_30 = tmpvar_22;
  highp vec3 tmpvar_31;
  tmpvar_31 = (spec_8.xyz * ((gloss_30 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_31;
  mediump vec4 diff_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_DiffCubeIBL, tmpvar_23);
  diff_32 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_7 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow_7.xyz * _GlowColor.xyz);
  glow_7.xyz = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = (glow_7.w * (_EmissionLM * _ExposureIBL.w));
  glow_7.w = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_38;
  lightDir_38 = xlv_TEXCOORD6;
  mediump vec3 viewDir_39;
  viewDir_39 = tmpvar_37;
  mediump vec3 spec_40;
  highp float specRefl_41;
  mediump vec4 frag_42;
  mediump float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_5, lightDir_38), 0.0, 1.0);
  frag_42.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_43)) * diff_10.xyz);
  frag_42.w = diff_10.w;
  mediump float tmpvar_44;
  tmpvar_44 = clamp (dot (tmpvar_5, normalize((viewDir_39 + lightDir_38))), 0.0, 1.0);
  specRefl_41 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = vec3(pow (specRefl_41, tmpvar_22));
  spec_40 = tmpvar_45;
  mediump vec3 tmpvar_46;
  tmpvar_46 = (((spec_40 * clamp ((10.0 * tmpvar_43), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_40 = tmpvar_46;
  frag_42.xyz = (frag_42.xyz + (tmpvar_46 * tmpvar_6));
  c_1 = frag_42;
  mediump vec3 tmpvar_47;
  tmpvar_47 = (c_1.xyz + (diff_10.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_47;
  mediump vec3 tmpvar_48;
  tmpvar_48 = (c_1.xyz + (((((spec_26.xyz * spec_26.w) * spec_8.xyz) * _ExposureIBL.y) + (((diff_32.xyz * diff_32.w) * diff_10.xyz) * _ExposureIBL.x)) + (glow_7.xyz * glow_7.w)));
  c_1.xyz = tmpvar_48;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD8;
varying vec3 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
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
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec3 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_2 = TANGENT.xyz;
  tmpvar_3 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_2.x;
  tmpvar_4[0].y = tmpvar_3.x;
  tmpvar_4[0].z = gl_Normal.x;
  tmpvar_4[1].x = tmpvar_2.y;
  tmpvar_4[1].y = tmpvar_3.y;
  tmpvar_4[1].z = gl_Normal.y;
  tmpvar_4[2].x = tmpvar_2.z;
  tmpvar_4[2].y = tmpvar_3.z;
  tmpvar_4[2].z = gl_Normal.z;
  vec3 v_5;
  v_5.x = _Object2World[0].x;
  v_5.y = _Object2World[1].x;
  v_5.z = _Object2World[2].x;
  vec3 v_6;
  v_6.x = _Object2World[0].y;
  v_6.y = _Object2World[1].y;
  v_6.z = _Object2World[2].y;
  vec3 v_7;
  v_7.x = _Object2World[0].z;
  v_7.y = _Object2World[1].z;
  v_7.z = _Object2World[2].z;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  vec3 x2_12;
  vec3 x1_13;
  x1_13.x = dot (unity_SHAr, tmpvar_11);
  x1_13.y = dot (unity_SHAg, tmpvar_11);
  x1_13.z = dot (unity_SHAb, tmpvar_11);
  vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9.xyzz * tmpvar_9.yzzx);
  x2_12.x = dot (unity_SHBr, tmpvar_14);
  x2_12.y = dot (unity_SHBg, tmpvar_14);
  x2_12.z = dot (unity_SHBb, tmpvar_14);
  vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_16;
  tmpvar_16 = (unity_4LightPosX0 - tmpvar_15.x);
  vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosY0 - tmpvar_15.y);
  vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosZ0 - tmpvar_15.z);
  vec4 tmpvar_19;
  tmpvar_19 = (((tmpvar_16 * tmpvar_16) + (tmpvar_17 * tmpvar_17)) + (tmpvar_18 * tmpvar_18));
  vec4 tmpvar_20;
  tmpvar_20 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_16 * tmpvar_9.x) + (tmpvar_17 * tmpvar_9.y)) + (tmpvar_18 * tmpvar_9.z)) * inversesqrt(tmpvar_19))) * (1.0/((1.0 + (tmpvar_19 * unity_4LightAtten0)))));
  vec4 o_21;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_1 * 0.5);
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_21.xy = (tmpvar_23 + tmpvar_22.w);
  o_21.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_4 * (((_World2Object * tmpvar_10).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = ((tmpvar_4 * v_5) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_4 * v_6) * unity_Scale.w);
  xlv_TEXCOORD5 = ((tmpvar_4 * v_7) * unity_Scale.w);
  xlv_TEXCOORD6 = (tmpvar_4 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD7 = (((x1_13 + x2_12) + (unity_SHC.xyz * ((tmpvar_9.x * tmpvar_9.x) - (tmpvar_9.y * tmpvar_9.y)))) + ((((unity_LightColor[0].xyz * tmpvar_20.x) + (unity_LightColor[1].xyz * tmpvar_20.y)) + (unity_LightColor[2].xyz * tmpvar_20.z)) + (unity_LightColor[3].xyz * tmpvar_20.w)));
  xlv_TEXCOORD8 = o_21;
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec4 xlv_TEXCOORD8;
varying vec3 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  vec3 normal_6;
  normal_6.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_6.z = sqrt(((1.0 - (normal_6.x * normal_6.x)) - (normal_6.y * normal_6.y)));
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_3.w = tmpvar_7.w;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (normal_6, xlv_TEXCOORD1), 0.0, 1.0));
  spec_3.xyz = (tmpvar_7.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_9;
  tmpvar_9 = ((7.0 + tmpvar_7.w) - (_Shininess * tmpvar_7.w));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - tmpvar_9));
  vec3 tmpvar_11;
  tmpvar_11.x = dot (xlv_TEXCOORD3, normal_6);
  tmpvar_11.y = dot (xlv_TEXCOORD4, normal_6);
  tmpvar_11.z = dot (xlv_TEXCOORD5, normal_6);
  vec3 i_12;
  i_12 = -(xlv_TEXCOORD2);
  vec4 tmpvar_13;
  tmpvar_13.xyz = (i_12 - (2.0 * (dot (tmpvar_11, i_12) * tmpvar_11)));
  tmpvar_13.w = tmpvar_9;
  vec4 tmpvar_14;
  tmpvar_14 = textureCubeLod (_SpecCubeIBL, tmpvar_13.xyz, tmpvar_9);
  vec4 tmpvar_15;
  tmpvar_15 = textureCube (_DiffCubeIBL, tmpvar_11);
  vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_16.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_16.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD8);
  vec4 frag_18;
  float tmpvar_19;
  tmpvar_19 = clamp (dot (normal_6, xlv_TEXCOORD6), 0.0, 1.0);
  frag_18.xyz = ((_LightColor0.xyz * ((tmpvar_17.x * 2.0) * tmpvar_19)) * diff_4.xyz);
  frag_18.w = diff_4.w;
  frag_18.xyz = (frag_18.xyz + (((((vec3(pow (clamp (dot (normal_6, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD6))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_19), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_17.x) * 0.5) * (spec_3.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c_1.w = frag_18.w;
  c_1.xyz = (frag_18.xyz + (diff_4.xyz * xlv_TEXCOORD7));
  c_1.xyz = (c_1.xyz + (((((tmpvar_14.xyz * tmpvar_14.w) * spec_3.xyz) * _ExposureIBL.y) + (((tmpvar_15.xyz * tmpvar_15.w) * diff_4.xyz) * _ExposureIBL.x)) + (glow_2.xyz * glow_2.w)));
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

varying highp vec4 xlv_TEXCOORD8;
varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  vec3 v_12;
  v_12.x = _Object2World[0].x;
  v_12.y = _Object2World[1].x;
  v_12.z = _Object2World[2].x;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_11 * v_12) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  vec3 v_14;
  v_14.x = _Object2World[0].y;
  v_14.y = _Object2World[1].y;
  v_14.z = _Object2World[2].y;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_11 * v_14) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  vec3 v_16;
  v_16.x = _Object2World[0].z;
  v_16.y = _Object2World[1].z;
  v_16.z = _Object2World[2].z;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_11 * v_16) * unity_Scale.w);
  tmpvar_6 = tmpvar_17;
  mat3 tmpvar_18;
  tmpvar_18[0] = _Object2World[0].xyz;
  tmpvar_18[1] = _Object2World[1].xyz;
  tmpvar_18[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_7 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_19;
  mediump vec3 tmpvar_23;
  mediump vec4 normal_24;
  normal_24 = tmpvar_22;
  highp float vC_25;
  mediump vec3 x3_26;
  mediump vec3 x2_27;
  mediump vec3 x1_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAr, normal_24);
  x1_28.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAg, normal_24);
  x1_28.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHAb, normal_24);
  x1_28.z = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32 = (normal_24.xyzz * normal_24.yzzx);
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBr, tmpvar_32);
  x2_27.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBg, tmpvar_32);
  x2_27.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHBb, tmpvar_32);
  x2_27.z = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = ((normal_24.x * normal_24.x) - (normal_24.y * normal_24.y));
  vC_25 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (unity_SHC.xyz * vC_25);
  x3_26 = tmpvar_37;
  tmpvar_23 = ((x1_28 + x2_27) + x3_26);
  shlight_3 = tmpvar_23;
  tmpvar_8 = shlight_3;
  highp vec3 tmpvar_38;
  tmpvar_38 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_39;
  tmpvar_39 = (unity_4LightPosX0 - tmpvar_38.x);
  highp vec4 tmpvar_40;
  tmpvar_40 = (unity_4LightPosY0 - tmpvar_38.y);
  highp vec4 tmpvar_41;
  tmpvar_41 = (unity_4LightPosZ0 - tmpvar_38.z);
  highp vec4 tmpvar_42;
  tmpvar_42 = (((tmpvar_39 * tmpvar_39) + (tmpvar_40 * tmpvar_40)) + (tmpvar_41 * tmpvar_41));
  highp vec4 tmpvar_43;
  tmpvar_43 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_39 * tmpvar_19.x) + (tmpvar_40 * tmpvar_19.y)) + (tmpvar_41 * tmpvar_19.z)) * inversesqrt(tmpvar_42))) * (1.0/((1.0 + (tmpvar_42 * unity_4LightAtten0)))));
  highp vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_8 + ((((unity_LightColor[0].xyz * tmpvar_43.x) + (unity_LightColor[1].xyz * tmpvar_43.y)) + (unity_LightColor[2].xyz * tmpvar_43.z)) + (unity_LightColor[3].xyz * tmpvar_43.w)));
  tmpvar_8 = tmpvar_44;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = tmpvar_8;
  xlv_TEXCOORD8 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec4 xlv_TEXCOORD8;
varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump vec4 glow_7;
  mediump vec4 spec_8;
  highp vec3 N_9;
  mediump vec4 diff_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_10 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff_10 * _Color);
  diff_10 = tmpvar_12;
  diff_10.xyz = (diff_10.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_9 = tmpvar_13;
  tmpvar_5 = N_9;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_8 = tmpvar_14;
  mediump float specIntensity_15;
  specIntensity_15 = _SpecInt;
  mediump float fresnel_16;
  fresnel_16 = _Fresnel;
  mediump float factor_17;
  highp float tmpvar_18;
  tmpvar_18 = (1.0 - clamp (dot (N_9, xlv_TEXCOORD1), 0.0, 1.0));
  factor_17 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (factor_17 * (factor_17 * factor_17));
  factor_17 = tmpvar_19;
  spec_8.xyz = (spec_8.xyz * ((_SpecColor.xyz * (specIntensity_15 * mix (1.0, tmpvar_19, (fresnel_16 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_20;
  mediump float shininess_21;
  shininess_21 = _Shininess;
  tmpvar_20 = ((7.0 + spec_8.w) - (shininess_21 * spec_8.w));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_20));
  highp vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_2, N_9);
  tmpvar_23.y = dot (tmpvar_3, N_9);
  tmpvar_23.z = dot (tmpvar_4, N_9);
  N_9 = tmpvar_23;
  highp vec3 i_24;
  i_24 = -(xlv_TEXCOORD2);
  highp float glossLod_25;
  glossLod_25 = tmpvar_20;
  mediump vec4 spec_26;
  mediump vec4 lookup_27;
  highp vec4 tmpvar_28;
  tmpvar_28.xyz = (i_24 - (2.0 * (dot (tmpvar_23, i_24) * tmpvar_23)));
  tmpvar_28.w = glossLod_25;
  lookup_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCubeLod (_SpecCubeIBL, lookup_27.xyz, lookup_27.w);
  spec_26 = tmpvar_29;
  highp float gloss_30;
  gloss_30 = tmpvar_22;
  highp vec3 tmpvar_31;
  tmpvar_31 = (spec_8.xyz * ((gloss_30 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_31;
  mediump vec4 diff_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_DiffCubeIBL, tmpvar_23);
  diff_32 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_7 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow_7.xyz * _GlowColor.xyz);
  glow_7.xyz = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = (glow_7.w * (_EmissionLM * _ExposureIBL.w));
  glow_7.w = tmpvar_36;
  lowp float tmpvar_37;
  mediump float lightShadowDataX_38;
  highp float dist_39;
  lowp float tmpvar_40;
  tmpvar_40 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD8).x;
  dist_39 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = _LightShadowData.x;
  lightShadowDataX_38 = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = max (float((dist_39 > (xlv_TEXCOORD8.z / xlv_TEXCOORD8.w))), lightShadowDataX_38);
  tmpvar_37 = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_44;
  lightDir_44 = xlv_TEXCOORD6;
  mediump vec3 viewDir_45;
  viewDir_45 = tmpvar_43;
  mediump float atten_46;
  atten_46 = tmpvar_37;
  mediump vec3 spec_47;
  highp float specRefl_48;
  mediump vec4 frag_49;
  mediump float tmpvar_50;
  tmpvar_50 = clamp (dot (tmpvar_5, lightDir_44), 0.0, 1.0);
  frag_49.xyz = ((_LightColor0.xyz * ((atten_46 * 2.0) * tmpvar_50)) * diff_10.xyz);
  frag_49.w = diff_10.w;
  mediump float tmpvar_51;
  tmpvar_51 = clamp (dot (tmpvar_5, normalize((viewDir_45 + lightDir_44))), 0.0, 1.0);
  specRefl_48 = tmpvar_51;
  highp vec3 tmpvar_52;
  tmpvar_52 = vec3(pow (specRefl_48, tmpvar_22));
  spec_47 = tmpvar_52;
  mediump vec3 tmpvar_53;
  tmpvar_53 = ((((spec_47 * clamp ((10.0 * tmpvar_50), 0.0, 1.0)) * _LightColor0.xyz) * atten_46) * 0.5);
  spec_47 = tmpvar_53;
  frag_49.xyz = (frag_49.xyz + (tmpvar_53 * tmpvar_6));
  c_1 = frag_49;
  mediump vec3 tmpvar_54;
  tmpvar_54 = (c_1.xyz + (diff_10.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_54;
  mediump vec3 tmpvar_55;
  tmpvar_55 = (c_1.xyz + (((((spec_26.xyz * spec_26.w) * spec_8.xyz) * _ExposureIBL.y) + (((diff_32.xyz * diff_32.w) * diff_10.xyz) * _ExposureIBL.x)) + (glow_7.xyz * glow_7.w)));
  c_1.xyz = tmpvar_55;
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
varying highp vec4 xlv_TEXCOORD8;
varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  vec3 v_12;
  v_12.x = _Object2World[0].x;
  v_12.y = _Object2World[1].x;
  v_12.z = _Object2World[2].x;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_11 * v_12) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  vec3 v_14;
  v_14.x = _Object2World[0].y;
  v_14.y = _Object2World[1].y;
  v_14.z = _Object2World[2].y;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_11 * v_14) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  vec3 v_16;
  v_16.x = _Object2World[0].z;
  v_16.y = _Object2World[1].z;
  v_16.z = _Object2World[2].z;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_11 * v_16) * unity_Scale.w);
  tmpvar_6 = tmpvar_17;
  mat3 tmpvar_18;
  tmpvar_18[0] = _Object2World[0].xyz;
  tmpvar_18[1] = _Object2World[1].xyz;
  tmpvar_18[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_7 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (tmpvar_18 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_22;
  mediump vec4 normal_23;
  normal_23 = tmpvar_21;
  highp float vC_24;
  mediump vec3 x3_25;
  mediump vec3 x2_26;
  mediump vec3 x1_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAr, normal_23);
  x1_27.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAg, normal_23);
  x1_27.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAb, normal_23);
  x1_27.z = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31 = (normal_23.xyzz * normal_23.yzzx);
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBr, tmpvar_31);
  x2_26.x = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBg, tmpvar_31);
  x2_26.y = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBb, tmpvar_31);
  x2_26.z = tmpvar_34;
  mediump float tmpvar_35;
  tmpvar_35 = ((normal_23.x * normal_23.x) - (normal_23.y * normal_23.y));
  vC_24 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (unity_SHC.xyz * vC_24);
  x3_25 = tmpvar_36;
  tmpvar_22 = ((x1_27 + x2_26) + x3_25);
  shlight_3 = tmpvar_22;
  tmpvar_8 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = tmpvar_8;
  xlv_TEXCOORD8 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
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
varying highp vec4 xlv_TEXCOORD8;
varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump vec4 glow_7;
  mediump vec4 spec_8;
  highp vec3 N_9;
  mediump vec4 diff_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_10 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff_10 * _Color);
  diff_10 = tmpvar_12;
  diff_10.xyz = (diff_10.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_9 = tmpvar_13;
  tmpvar_5 = N_9;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_8 = tmpvar_14;
  mediump float specIntensity_15;
  specIntensity_15 = _SpecInt;
  mediump float fresnel_16;
  fresnel_16 = _Fresnel;
  mediump float factor_17;
  highp float tmpvar_18;
  tmpvar_18 = (1.0 - clamp (dot (N_9, xlv_TEXCOORD1), 0.0, 1.0));
  factor_17 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (factor_17 * (factor_17 * factor_17));
  factor_17 = tmpvar_19;
  spec_8.xyz = (spec_8.xyz * ((_SpecColor.xyz * (specIntensity_15 * mix (1.0, tmpvar_19, (fresnel_16 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_20;
  mediump float shininess_21;
  shininess_21 = _Shininess;
  tmpvar_20 = ((7.0 + spec_8.w) - (shininess_21 * spec_8.w));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_20));
  highp vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_2, N_9);
  tmpvar_23.y = dot (tmpvar_3, N_9);
  tmpvar_23.z = dot (tmpvar_4, N_9);
  N_9 = tmpvar_23;
  highp vec3 i_24;
  i_24 = -(xlv_TEXCOORD2);
  highp float glossLod_25;
  glossLod_25 = tmpvar_20;
  mediump vec4 spec_26;
  mediump vec4 lookup_27;
  highp vec4 tmpvar_28;
  tmpvar_28.xyz = (i_24 - (2.0 * (dot (tmpvar_23, i_24) * tmpvar_23)));
  tmpvar_28.w = glossLod_25;
  lookup_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCubeLod (_SpecCubeIBL, lookup_27.xyz, lookup_27.w);
  spec_26 = tmpvar_29;
  highp float gloss_30;
  gloss_30 = tmpvar_22;
  highp vec3 tmpvar_31;
  tmpvar_31 = (spec_8.xyz * ((gloss_30 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_31;
  mediump vec4 diff_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_DiffCubeIBL, tmpvar_23);
  diff_32 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_7 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow_7.xyz * _GlowColor.xyz);
  glow_7.xyz = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = (glow_7.w * (_EmissionLM * _ExposureIBL.w));
  glow_7.w = tmpvar_36;
  lowp float shadow_37;
  lowp float tmpvar_38;
  tmpvar_38 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD8.xyz);
  highp float tmpvar_39;
  tmpvar_39 = (_LightShadowData.x + (tmpvar_38 * (1.0 - _LightShadowData.x)));
  shadow_37 = tmpvar_39;
  highp vec3 tmpvar_40;
  tmpvar_40 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_41;
  lightDir_41 = xlv_TEXCOORD6;
  mediump vec3 viewDir_42;
  viewDir_42 = tmpvar_40;
  mediump float atten_43;
  atten_43 = shadow_37;
  mediump vec3 spec_44;
  highp float specRefl_45;
  mediump vec4 frag_46;
  mediump float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_5, lightDir_41), 0.0, 1.0);
  frag_46.xyz = ((_LightColor0.xyz * ((atten_43 * 2.0) * tmpvar_47)) * diff_10.xyz);
  frag_46.w = diff_10.w;
  mediump float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_5, normalize((viewDir_42 + lightDir_41))), 0.0, 1.0);
  specRefl_45 = tmpvar_48;
  highp vec3 tmpvar_49;
  tmpvar_49 = vec3(pow (specRefl_45, tmpvar_22));
  spec_44 = tmpvar_49;
  mediump vec3 tmpvar_50;
  tmpvar_50 = ((((spec_44 * clamp ((10.0 * tmpvar_47), 0.0, 1.0)) * _LightColor0.xyz) * atten_43) * 0.5);
  spec_44 = tmpvar_50;
  frag_46.xyz = (frag_46.xyz + (tmpvar_50 * tmpvar_6));
  c_1 = frag_46;
  mediump vec3 tmpvar_51;
  tmpvar_51 = (c_1.xyz + (diff_10.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_51;
  mediump vec3 tmpvar_52;
  tmpvar_52 = (c_1.xyz + (((((spec_26.xyz * spec_26.w) * spec_8.xyz) * _ExposureIBL.y) + (((diff_32.xyz * diff_32.w) * diff_10.xyz) * _ExposureIBL.x)) + (glow_7.xyz * glow_7.w)));
  c_1.xyz = tmpvar_52;
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
varying highp vec4 xlv_TEXCOORD7;
varying highp vec2 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_6 = tmpvar_1.xyz;
  tmpvar_7 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_6.x;
  tmpvar_8[0].y = tmpvar_7.x;
  tmpvar_8[0].z = tmpvar_2.x;
  tmpvar_8[1].x = tmpvar_6.y;
  tmpvar_8[1].y = tmpvar_7.y;
  tmpvar_8[1].z = tmpvar_2.y;
  tmpvar_8[2].x = tmpvar_6.z;
  tmpvar_8[2].y = tmpvar_7.z;
  tmpvar_8[2].z = tmpvar_2.z;
  vec3 v_9;
  v_9.x = _Object2World[0].x;
  v_9.y = _Object2World[1].x;
  v_9.z = _Object2World[2].x;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_8 * v_9) * unity_Scale.w);
  tmpvar_3 = tmpvar_10;
  vec3 v_11;
  v_11.x = _Object2World[0].y;
  v_11.y = _Object2World[1].y;
  v_11.z = _Object2World[2].y;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_8 * v_11) * unity_Scale.w);
  tmpvar_4 = tmpvar_12;
  vec3 v_13;
  v_13.x = _Object2World[0].z;
  v_13.y = _Object2World[1].z;
  v_13.z = _Object2World[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_8 * v_13) * unity_Scale.w);
  tmpvar_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_8 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD7 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
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
varying highp vec4 xlv_TEXCOORD7;
varying highp vec2 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec4 glow_5;
  mediump vec4 spec_6;
  highp vec3 N_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  mediump float tmpvar_11;
  tmpvar_11 = diff_8.w;
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_6 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_7, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_6.xyz = (spec_6.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_6.w) - (shininess_20 * spec_6.w));
  highp vec3 tmpvar_21;
  tmpvar_21.x = dot (tmpvar_2, N_7);
  tmpvar_21.y = dot (tmpvar_3, N_7);
  tmpvar_21.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_21;
  highp vec3 i_22;
  i_22 = -(xlv_TEXCOORD2);
  highp float glossLod_23;
  glossLod_23 = tmpvar_19;
  mediump vec4 spec_24;
  mediump vec4 lookup_25;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = (i_22 - (2.0 * (dot (tmpvar_21, i_22) * tmpvar_21)));
  tmpvar_26.w = glossLod_23;
  lookup_25 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup_25.xyz, lookup_25.w);
  spec_24 = tmpvar_27;
  mediump vec4 diff_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_21);
  diff_28 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_32;
  lowp float shadow_33;
  lowp float tmpvar_34;
  tmpvar_34 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD7.xyz);
  highp float tmpvar_35;
  tmpvar_35 = (_LightShadowData.x + (tmpvar_34 * (1.0 - _LightShadowData.x)));
  shadow_33 = tmpvar_35;
  lowp vec3 tmpvar_36;
  tmpvar_36 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD6).xyz), vec3((shadow_33 * 2.0)));
  mediump vec3 tmpvar_37;
  tmpvar_37 = (diff_8.xyz * tmpvar_36);
  c_1.xyz = tmpvar_37;
  c_1.w = tmpvar_11;
  mediump vec3 tmpvar_38;
  tmpvar_38 = (c_1.xyz + (((((spec_24.xyz * spec_24.w) * spec_6.xyz) * _ExposureIBL.y) + (((diff_28.xyz * diff_28.w) * diff_8.xyz) * _ExposureIBL.x)) + (glow_5.xyz * glow_5.w)));
  c_1.xyz = tmpvar_38;
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
varying highp vec4 xlv_TEXCOORD8;
varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  vec3 v_12;
  v_12.x = _Object2World[0].x;
  v_12.y = _Object2World[1].x;
  v_12.z = _Object2World[2].x;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_11 * v_12) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  vec3 v_14;
  v_14.x = _Object2World[0].y;
  v_14.y = _Object2World[1].y;
  v_14.z = _Object2World[2].y;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_11 * v_14) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  vec3 v_16;
  v_16.x = _Object2World[0].z;
  v_16.y = _Object2World[1].z;
  v_16.z = _Object2World[2].z;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_11 * v_16) * unity_Scale.w);
  tmpvar_6 = tmpvar_17;
  mat3 tmpvar_18;
  tmpvar_18[0] = _Object2World[0].xyz;
  tmpvar_18[1] = _Object2World[1].xyz;
  tmpvar_18[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_7 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_19;
  mediump vec3 tmpvar_23;
  mediump vec4 normal_24;
  normal_24 = tmpvar_22;
  highp float vC_25;
  mediump vec3 x3_26;
  mediump vec3 x2_27;
  mediump vec3 x1_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAr, normal_24);
  x1_28.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAg, normal_24);
  x1_28.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHAb, normal_24);
  x1_28.z = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32 = (normal_24.xyzz * normal_24.yzzx);
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBr, tmpvar_32);
  x2_27.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBg, tmpvar_32);
  x2_27.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHBb, tmpvar_32);
  x2_27.z = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = ((normal_24.x * normal_24.x) - (normal_24.y * normal_24.y));
  vC_25 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (unity_SHC.xyz * vC_25);
  x3_26 = tmpvar_37;
  tmpvar_23 = ((x1_28 + x2_27) + x3_26);
  shlight_3 = tmpvar_23;
  tmpvar_8 = shlight_3;
  highp vec3 tmpvar_38;
  tmpvar_38 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_39;
  tmpvar_39 = (unity_4LightPosX0 - tmpvar_38.x);
  highp vec4 tmpvar_40;
  tmpvar_40 = (unity_4LightPosY0 - tmpvar_38.y);
  highp vec4 tmpvar_41;
  tmpvar_41 = (unity_4LightPosZ0 - tmpvar_38.z);
  highp vec4 tmpvar_42;
  tmpvar_42 = (((tmpvar_39 * tmpvar_39) + (tmpvar_40 * tmpvar_40)) + (tmpvar_41 * tmpvar_41));
  highp vec4 tmpvar_43;
  tmpvar_43 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_39 * tmpvar_19.x) + (tmpvar_40 * tmpvar_19.y)) + (tmpvar_41 * tmpvar_19.z)) * inversesqrt(tmpvar_42))) * (1.0/((1.0 + (tmpvar_42 * unity_4LightAtten0)))));
  highp vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_8 + ((((unity_LightColor[0].xyz * tmpvar_43.x) + (unity_LightColor[1].xyz * tmpvar_43.y)) + (unity_LightColor[2].xyz * tmpvar_43.z)) + (unity_LightColor[3].xyz * tmpvar_43.w)));
  tmpvar_8 = tmpvar_44;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = tmpvar_8;
  xlv_TEXCOORD8 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
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
varying highp vec4 xlv_TEXCOORD8;
varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD3;
  tmpvar_3 = xlv_TEXCOORD4;
  tmpvar_4 = xlv_TEXCOORD5;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump vec4 glow_7;
  mediump vec4 spec_8;
  highp vec3 N_9;
  mediump vec4 diff_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_10 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff_10 * _Color);
  diff_10 = tmpvar_12;
  diff_10.xyz = (diff_10.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_9 = tmpvar_13;
  tmpvar_5 = N_9;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_8 = tmpvar_14;
  mediump float specIntensity_15;
  specIntensity_15 = _SpecInt;
  mediump float fresnel_16;
  fresnel_16 = _Fresnel;
  mediump float factor_17;
  highp float tmpvar_18;
  tmpvar_18 = (1.0 - clamp (dot (N_9, xlv_TEXCOORD1), 0.0, 1.0));
  factor_17 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (factor_17 * (factor_17 * factor_17));
  factor_17 = tmpvar_19;
  spec_8.xyz = (spec_8.xyz * ((_SpecColor.xyz * (specIntensity_15 * mix (1.0, tmpvar_19, (fresnel_16 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_20;
  mediump float shininess_21;
  shininess_21 = _Shininess;
  tmpvar_20 = ((7.0 + spec_8.w) - (shininess_21 * spec_8.w));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_20));
  highp vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_2, N_9);
  tmpvar_23.y = dot (tmpvar_3, N_9);
  tmpvar_23.z = dot (tmpvar_4, N_9);
  N_9 = tmpvar_23;
  highp vec3 i_24;
  i_24 = -(xlv_TEXCOORD2);
  highp float glossLod_25;
  glossLod_25 = tmpvar_20;
  mediump vec4 spec_26;
  mediump vec4 lookup_27;
  highp vec4 tmpvar_28;
  tmpvar_28.xyz = (i_24 - (2.0 * (dot (tmpvar_23, i_24) * tmpvar_23)));
  tmpvar_28.w = glossLod_25;
  lookup_27 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCubeLod (_SpecCubeIBL, lookup_27.xyz, lookup_27.w);
  spec_26 = tmpvar_29;
  highp float gloss_30;
  gloss_30 = tmpvar_22;
  highp vec3 tmpvar_31;
  tmpvar_31 = (spec_8.xyz * ((gloss_30 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_31;
  mediump vec4 diff_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_DiffCubeIBL, tmpvar_23);
  diff_32 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_7 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow_7.xyz * _GlowColor.xyz);
  glow_7.xyz = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = (glow_7.w * (_EmissionLM * _ExposureIBL.w));
  glow_7.w = tmpvar_36;
  lowp float shadow_37;
  lowp float tmpvar_38;
  tmpvar_38 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD8.xyz);
  highp float tmpvar_39;
  tmpvar_39 = (_LightShadowData.x + (tmpvar_38 * (1.0 - _LightShadowData.x)));
  shadow_37 = tmpvar_39;
  highp vec3 tmpvar_40;
  tmpvar_40 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_41;
  lightDir_41 = xlv_TEXCOORD6;
  mediump vec3 viewDir_42;
  viewDir_42 = tmpvar_40;
  mediump float atten_43;
  atten_43 = shadow_37;
  mediump vec3 spec_44;
  highp float specRefl_45;
  mediump vec4 frag_46;
  mediump float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_5, lightDir_41), 0.0, 1.0);
  frag_46.xyz = ((_LightColor0.xyz * ((atten_43 * 2.0) * tmpvar_47)) * diff_10.xyz);
  frag_46.w = diff_10.w;
  mediump float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_5, normalize((viewDir_42 + lightDir_41))), 0.0, 1.0);
  specRefl_45 = tmpvar_48;
  highp vec3 tmpvar_49;
  tmpvar_49 = vec3(pow (specRefl_45, tmpvar_22));
  spec_44 = tmpvar_49;
  mediump vec3 tmpvar_50;
  tmpvar_50 = ((((spec_44 * clamp ((10.0 * tmpvar_47), 0.0, 1.0)) * _LightColor0.xyz) * atten_43) * 0.5);
  spec_44 = tmpvar_50;
  frag_46.xyz = (frag_46.xyz + (tmpvar_50 * tmpvar_6));
  c_1 = frag_46;
  mediump vec3 tmpvar_51;
  tmpvar_51 = (c_1.xyz + (diff_10.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_51;
  mediump vec3 tmpvar_52;
  tmpvar_52 = (c_1.xyz + (((((spec_26.xyz * spec_26.w) * spec_8.xyz) * _ExposureIBL.y) + (((diff_32.xyz * diff_32.w) * diff_10.xyz) * _ExposureIBL.x)) + (glow_7.xyz * glow_7.w)));
  c_1.xyz = tmpvar_52;
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_1 = TANGENT.xyz;
  tmpvar_2 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_1.x;
  tmpvar_3[0].y = tmpvar_2.x;
  tmpvar_3[0].z = gl_Normal.x;
  tmpvar_3[1].x = tmpvar_1.y;
  tmpvar_3[1].y = tmpvar_2.y;
  tmpvar_3[1].z = gl_Normal.y;
  tmpvar_3[2].x = tmpvar_1.z;
  tmpvar_3[2].y = tmpvar_2.z;
  tmpvar_3[2].z = gl_Normal.z;
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = (tmpvar_3 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
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
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
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
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (normal_5, xlv_TEXCOORD1), 0.0, 1.0));
  spec_2.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w))));
  vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  float atten_10;
  atten_10 = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w;
  vec4 frag_11;
  float tmpvar_12;
  tmpvar_12 = clamp (dot (normal_5, tmpvar_9), 0.0, 1.0);
  frag_11.xyz = ((_LightColor0.xyz * ((atten_10 * 2.0) * tmpvar_12)) * diff_3.xyz);
  frag_11.w = diff_3.w;
  frag_11.xyz = (frag_11.xyz + (((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_12), 0.0, 1.0)) * _LightColor0.xyz) * atten_10) * 0.5) * (spec_2.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
  c_1.xyz = frag_11.xyz;
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  mediump vec3 tmpvar_4;
  mediump vec4 glow_5;
  mediump vec4 spec_6;
  highp vec3 N_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_7 = tmpvar_11;
  tmpvar_3 = N_7;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_6 = tmpvar_12;
  mediump float specIntensity_13;
  specIntensity_13 = _SpecInt;
  mediump float fresnel_14;
  fresnel_14 = _Fresnel;
  mediump float factor_15;
  highp float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N_7, xlv_TEXCOORD1), 0.0, 1.0));
  factor_15 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = (factor_15 * (factor_15 * factor_15));
  factor_15 = tmpvar_17;
  spec_6.xyz = (spec_6.xyz * ((_SpecColor.xyz * (specIntensity_13 * mix (1.0, tmpvar_17, (fresnel_14 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_18;
  shininess_18 = _Shininess;
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - ((7.0 + spec_6.w) - (shininess_18 * spec_6.w))));
  highp float gloss_20;
  gloss_20 = tmpvar_19;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec_6.xyz * ((gloss_20 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_27;
  tmpvar_27 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_LightTexture0, vec2(tmpvar_27));
  mediump vec3 lightDir_29;
  lightDir_29 = lightDir_2;
  mediump vec3 viewDir_30;
  viewDir_30 = tmpvar_26;
  mediump float atten_31;
  atten_31 = tmpvar_28.w;
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
  tmpvar_37 = vec3(pow (specRefl_33, tmpvar_19));
  spec_32 = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = ((((spec_32 * clamp ((10.0 * tmpvar_35), 0.0, 1.0)) * _LightColor0.xyz) * atten_31) * 0.5);
  spec_32 = tmpvar_38;
  frag_34.xyz = (frag_34.xyz + (tmpvar_38 * tmpvar_4));
  c_1.xyz = frag_34.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_1 = TANGENT.xyz;
  tmpvar_2 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_1.x;
  tmpvar_3[0].y = tmpvar_2.x;
  tmpvar_3[0].z = gl_Normal.x;
  tmpvar_3[1].x = tmpvar_1.y;
  tmpvar_3[1].y = tmpvar_2.y;
  tmpvar_3[1].z = gl_Normal.y;
  tmpvar_3[2].x = tmpvar_1.z;
  tmpvar_3[2].y = tmpvar_2.z;
  tmpvar_3[2].z = gl_Normal.z;
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
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
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (normal_5, xlv_TEXCOORD1), 0.0, 1.0));
  spec_2.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w))));
  vec4 frag_9;
  float tmpvar_10;
  tmpvar_10 = clamp (dot (normal_5, xlv_TEXCOORD3), 0.0, 1.0);
  frag_9.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_10)) * diff_3.xyz);
  frag_9.w = diff_3.w;
  frag_9.xyz = (frag_9.xyz + ((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD3))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec_2.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
  c_1.xyz = frag_9.xyz;
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

varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  mediump vec3 tmpvar_4;
  mediump vec4 glow_5;
  mediump vec4 spec_6;
  highp vec3 N_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_7 = tmpvar_11;
  tmpvar_3 = N_7;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_6 = tmpvar_12;
  mediump float specIntensity_13;
  specIntensity_13 = _SpecInt;
  mediump float fresnel_14;
  fresnel_14 = _Fresnel;
  mediump float factor_15;
  highp float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N_7, xlv_TEXCOORD1), 0.0, 1.0));
  factor_15 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = (factor_15 * (factor_15 * factor_15));
  factor_15 = tmpvar_17;
  spec_6.xyz = (spec_6.xyz * ((_SpecColor.xyz * (specIntensity_13 * mix (1.0, tmpvar_17, (fresnel_14 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_18;
  shininess_18 = _Shininess;
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - ((7.0 + spec_6.w) - (shininess_18 * spec_6.w))));
  highp float gloss_20;
  gloss_20 = tmpvar_19;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec_6.xyz * ((gloss_20 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_24;
  lightDir_2 = xlv_TEXCOORD3;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_26;
  lightDir_26 = lightDir_2;
  mediump vec3 viewDir_27;
  viewDir_27 = tmpvar_25;
  mediump vec3 spec_28;
  highp float specRefl_29;
  mediump vec4 frag_30;
  mediump float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_3, lightDir_26), 0.0, 1.0);
  frag_30.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_31)) * diff_8.xyz);
  frag_30.w = diff_8.w;
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_3, normalize((viewDir_27 + lightDir_26))), 0.0, 1.0);
  specRefl_29 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = vec3(pow (specRefl_29, tmpvar_19));
  spec_28 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = (((spec_28 * clamp ((10.0 * tmpvar_31), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_28 = tmpvar_34;
  frag_30.xyz = (frag_30.xyz + (tmpvar_34 * tmpvar_4));
  c_1.xyz = frag_30.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_1 = TANGENT.xyz;
  tmpvar_2 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_1.x;
  tmpvar_3[0].y = tmpvar_2.x;
  tmpvar_3[0].z = gl_Normal.x;
  tmpvar_3[1].x = tmpvar_1.y;
  tmpvar_3[1].y = tmpvar_2.y;
  tmpvar_3[1].z = gl_Normal.y;
  tmpvar_3[2].x = tmpvar_1.z;
  tmpvar_3[2].y = tmpvar_2.z;
  tmpvar_3[2].z = gl_Normal.z;
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = (tmpvar_3 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
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
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (normal_5, xlv_TEXCOORD1), 0.0, 1.0));
  spec_2.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w))));
  vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  float atten_10;
  atten_10 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz))).w);
  vec4 frag_11;
  float tmpvar_12;
  tmpvar_12 = clamp (dot (normal_5, tmpvar_9), 0.0, 1.0);
  frag_11.xyz = ((_LightColor0.xyz * ((atten_10 * 2.0) * tmpvar_12)) * diff_3.xyz);
  frag_11.w = diff_3.w;
  frag_11.xyz = (frag_11.xyz + (((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_12), 0.0, 1.0)) * _LightColor0.xyz) * atten_10) * 0.5) * (spec_2.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
  c_1.xyz = frag_11.xyz;
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

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  mediump vec3 tmpvar_4;
  mediump vec4 glow_5;
  mediump vec4 spec_6;
  highp vec3 N_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_7 = tmpvar_11;
  tmpvar_3 = N_7;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_6 = tmpvar_12;
  mediump float specIntensity_13;
  specIntensity_13 = _SpecInt;
  mediump float fresnel_14;
  fresnel_14 = _Fresnel;
  mediump float factor_15;
  highp float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N_7, xlv_TEXCOORD1), 0.0, 1.0));
  factor_15 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = (factor_15 * (factor_15 * factor_15));
  factor_15 = tmpvar_17;
  spec_6.xyz = (spec_6.xyz * ((_SpecColor.xyz * (specIntensity_13 * mix (1.0, tmpvar_17, (fresnel_14 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_18;
  shininess_18 = _Shininess;
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - ((7.0 + spec_6.w) - (shininess_18 * spec_6.w))));
  highp float gloss_20;
  gloss_20 = tmpvar_19;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec_6.xyz * ((gloss_20 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD1);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  tmpvar_27 = texture2D (_LightTexture0, P_28);
  highp float tmpvar_29;
  tmpvar_29 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_LightTextureB0, vec2(tmpvar_29));
  mediump vec3 lightDir_31;
  lightDir_31 = lightDir_2;
  mediump vec3 viewDir_32;
  viewDir_32 = tmpvar_26;
  mediump float atten_33;
  atten_33 = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_27.w) * tmpvar_30.w);
  mediump vec3 spec_34;
  highp float specRefl_35;
  mediump vec4 frag_36;
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_3, lightDir_31), 0.0, 1.0);
  frag_36.xyz = ((_LightColor0.xyz * ((atten_33 * 2.0) * tmpvar_37)) * diff_8.xyz);
  frag_36.w = diff_8.w;
  mediump float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_3, normalize((viewDir_32 + lightDir_31))), 0.0, 1.0);
  specRefl_35 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = vec3(pow (specRefl_35, tmpvar_19));
  spec_34 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = ((((spec_34 * clamp ((10.0 * tmpvar_37), 0.0, 1.0)) * _LightColor0.xyz) * atten_33) * 0.5);
  spec_34 = tmpvar_40;
  frag_36.xyz = (frag_36.xyz + (tmpvar_40 * tmpvar_4));
  c_1.xyz = frag_36.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_1 = TANGENT.xyz;
  tmpvar_2 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_1.x;
  tmpvar_3[0].y = tmpvar_2.x;
  tmpvar_3[0].z = gl_Normal.x;
  tmpvar_3[1].x = tmpvar_1.y;
  tmpvar_3[1].y = tmpvar_2.y;
  tmpvar_3[1].z = gl_Normal.y;
  tmpvar_3[2].x = tmpvar_1.z;
  tmpvar_3[2].y = tmpvar_2.z;
  tmpvar_3[2].z = gl_Normal.z;
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = (tmpvar_3 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
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
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
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
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (normal_5, xlv_TEXCOORD1), 0.0, 1.0));
  spec_2.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w))));
  vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  float atten_10;
  atten_10 = (texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w);
  vec4 frag_11;
  float tmpvar_12;
  tmpvar_12 = clamp (dot (normal_5, tmpvar_9), 0.0, 1.0);
  frag_11.xyz = ((_LightColor0.xyz * ((atten_10 * 2.0) * tmpvar_12)) * diff_3.xyz);
  frag_11.w = diff_3.w;
  frag_11.xyz = (frag_11.xyz + (((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_12), 0.0, 1.0)) * _LightColor0.xyz) * atten_10) * 0.5) * (spec_2.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
  c_1.xyz = frag_11.xyz;
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#ifdef SHADER_API_GLES
#extension GL_EXT_shader_texture_lod : enable
#define textureCubeLod textureCubeLodEXT
#else
#extension GL_ARB_shader_texture_lod : enable
#endif

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  mediump vec3 tmpvar_4;
  mediump vec4 glow_5;
  mediump vec4 spec_6;
  highp vec3 N_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_7 = tmpvar_11;
  tmpvar_3 = N_7;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_6 = tmpvar_12;
  mediump float specIntensity_13;
  specIntensity_13 = _SpecInt;
  mediump float fresnel_14;
  fresnel_14 = _Fresnel;
  mediump float factor_15;
  highp float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N_7, xlv_TEXCOORD1), 0.0, 1.0));
  factor_15 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = (factor_15 * (factor_15 * factor_15));
  factor_15 = tmpvar_17;
  spec_6.xyz = (spec_6.xyz * ((_SpecColor.xyz * (specIntensity_13 * mix (1.0, tmpvar_17, (fresnel_14 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_18;
  shininess_18 = _Shininess;
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - ((7.0 + spec_6.w) - (shininess_18 * spec_6.w))));
  highp float gloss_20;
  gloss_20 = tmpvar_19;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec_6.xyz * ((gloss_20 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_27;
  tmpvar_27 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_LightTextureB0, vec2(tmpvar_27));
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_30;
  lightDir_30 = lightDir_2;
  mediump vec3 viewDir_31;
  viewDir_31 = tmpvar_26;
  mediump float atten_32;
  atten_32 = (tmpvar_28.w * tmpvar_29.w);
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
  tmpvar_38 = vec3(pow (specRefl_34, tmpvar_19));
  spec_33 = tmpvar_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = ((((spec_33 * clamp ((10.0 * tmpvar_36), 0.0, 1.0)) * _LightColor0.xyz) * atten_32) * 0.5);
  spec_33 = tmpvar_39;
  frag_35.xyz = (frag_35.xyz + (tmpvar_39 * tmpvar_4));
  c_1.xyz = frag_35.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;
uniform mat4 _Object2World;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_1 = TANGENT.xyz;
  tmpvar_2 = (((gl_Normal.yzx * TANGENT.zxy) - (gl_Normal.zxy * TANGENT.yzx)) * TANGENT.w);
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_1.x;
  tmpvar_3[0].y = tmpvar_2.x;
  tmpvar_3[0].z = gl_Normal.x;
  tmpvar_3[1].x = tmpvar_1.y;
  tmpvar_3[1].y = tmpvar_2.y;
  tmpvar_3[1].z = gl_Normal.y;
  tmpvar_3[2].x = tmpvar_1.z;
  tmpvar_3[2].y = tmpvar_2.z;
  tmpvar_3[2].z = gl_Normal.z;
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz));
  xlv_TEXCOORD3 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
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
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
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
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_2.w = tmpvar_6.w;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (normal_5, xlv_TEXCOORD1), 0.0, 1.0));
  spec_2.xyz = (tmpvar_6.xyz * ((_SpecColor.xyz * (_SpecInt * mix (1.0, (tmpvar_7 * (tmpvar_7 * tmpvar_7)), (_Fresnel * 0.9)))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w))));
  float atten_9;
  atten_9 = texture2D (_LightTexture0, xlv_TEXCOORD4).w;
  vec4 frag_10;
  float tmpvar_11;
  tmpvar_11 = clamp (dot (normal_5, xlv_TEXCOORD3), 0.0, 1.0);
  frag_10.xyz = ((_LightColor0.xyz * ((atten_9 * 2.0) * tmpvar_11)) * diff_3.xyz);
  frag_10.w = diff_3.w;
  frag_10.xyz = (frag_10.xyz + (((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD3))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_11), 0.0, 1.0)) * _LightColor0.xyz) * atten_9) * 0.5) * (spec_2.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
  c_1.xyz = frag_10.xyz;
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

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
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
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
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
  mediump vec3 tmpvar_4;
  mediump vec4 glow_5;
  mediump vec4 spec_6;
  highp vec3 N_7;
  mediump vec4 diff_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_8 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (diff_8 * _Color);
  diff_8 = tmpvar_10;
  diff_8.xyz = (diff_8.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_7 = tmpvar_11;
  tmpvar_3 = N_7;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_6 = tmpvar_12;
  mediump float specIntensity_13;
  specIntensity_13 = _SpecInt;
  mediump float fresnel_14;
  fresnel_14 = _Fresnel;
  mediump float factor_15;
  highp float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N_7, xlv_TEXCOORD1), 0.0, 1.0));
  factor_15 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = (factor_15 * (factor_15 * factor_15));
  factor_15 = tmpvar_17;
  spec_6.xyz = (spec_6.xyz * ((_SpecColor.xyz * (specIntensity_13 * mix (1.0, tmpvar_17, (fresnel_14 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_18;
  shininess_18 = _Shininess;
  mediump float tmpvar_19;
  tmpvar_19 = pow (2.0, (8.0 - ((7.0 + spec_6.w) - (shininess_18 * spec_6.w))));
  highp float gloss_20;
  gloss_20 = tmpvar_19;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec_6.xyz * ((gloss_20 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_24;
  lightDir_2 = xlv_TEXCOORD3;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD1);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_27;
  lightDir_27 = lightDir_2;
  mediump vec3 viewDir_28;
  viewDir_28 = tmpvar_25;
  mediump float atten_29;
  atten_29 = tmpvar_26.w;
  mediump vec3 spec_30;
  highp float specRefl_31;
  mediump vec4 frag_32;
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_3, lightDir_27), 0.0, 1.0);
  frag_32.xyz = ((_LightColor0.xyz * ((atten_29 * 2.0) * tmpvar_33)) * diff_8.xyz);
  frag_32.w = diff_8.w;
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_3, normalize((viewDir_28 + lightDir_27))), 0.0, 1.0);
  specRefl_31 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = vec3(pow (specRefl_31, tmpvar_19));
  spec_30 = tmpvar_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = ((((spec_30 * clamp ((10.0 * tmpvar_33), 0.0, 1.0)) * _LightColor0.xyz) * atten_29) * 0.5);
  spec_30 = tmpvar_36;
  frag_32.xyz = (frag_32.xyz + (tmpvar_36 * tmpvar_4));
  c_1.xyz = frag_32.xyz;
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

#LINE 63

	}
	
	FallBack "Diffuse"
}
