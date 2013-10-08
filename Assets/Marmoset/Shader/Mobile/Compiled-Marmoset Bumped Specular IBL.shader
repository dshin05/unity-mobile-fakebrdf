// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Mobile/Bumped Specular IBL" {
	Properties {
		_Color   ("Diffuse Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecInt ("Specular Intensity", Float) = 1.0
		_Shininess ("Specular Sharpness", Range(2.0,8.0)) = 4.0
		_Fresnel ("Fresnel Strength", Range(0.0,1.0)) = 0.0
		_MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
		_SpecTex ("Specular(RGB) Gloss(A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) 	= "bump" {}
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
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD3, normal_5);
  tmpvar_10.y = dot (xlv_TEXCOORD4, normal_5);
  tmpvar_10.z = dot (xlv_TEXCOORD5, normal_5);
  vec3 i_11;
  i_11 = -(xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12.xyz = (i_11 - (2.0 * (dot (tmpvar_10, i_11) * tmpvar_10)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_8);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_10);
  vec4 frag_15;
  float tmpvar_16;
  tmpvar_16 = clamp (dot (normal_5, xlv_TEXCOORD6), 0.0, 1.0);
  frag_15.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_16)) * diff_3.xyz);
  frag_15.w = diff_3.w;
  frag_15.xyz = (frag_15.xyz + ((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD6))), 0.0, 1.0), tmpvar_9)) * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  c_1.w = frag_15.w;
  c_1.xyz = (frag_15.xyz + (diff_3.xyz * xlv_TEXCOORD7));
  c_1.xyz = (c_1.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec_2.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff_3.xyz) * _ExposureIBL.x)));
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
  mediump vec4 spec_7;
  highp vec3 N_8;
  mediump vec4 diff_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_9 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff_9 * _Color);
  diff_9 = tmpvar_11;
  diff_9.xyz = (diff_9.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_8 = tmpvar_12;
  tmpvar_5 = N_8;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_8, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_7.w) - (shininess_20 * spec_7.w));
  mediump float tmpvar_21;
  tmpvar_21 = pow (2.0, (8.0 - tmpvar_19));
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N_8);
  tmpvar_22.y = dot (tmpvar_3, N_8);
  tmpvar_22.z = dot (tmpvar_4, N_8);
  N_8 = tmpvar_22;
  highp vec3 i_23;
  i_23 = -(xlv_TEXCOORD2);
  highp float glossLod_24;
  glossLod_24 = tmpvar_19;
  mediump vec4 spec_25;
  mediump vec4 lookup_26;
  highp vec4 tmpvar_27;
  tmpvar_27.xyz = (i_23 - (2.0 * (dot (tmpvar_22, i_23) * tmpvar_22)));
  tmpvar_27.w = glossLod_24;
  lookup_26 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCubeLod (_SpecCubeIBL, lookup_26.xyz, lookup_26.w);
  spec_25 = tmpvar_28;
  highp float gloss_29;
  gloss_29 = tmpvar_21;
  highp vec3 tmpvar_30;
  tmpvar_30 = (spec_7.xyz * ((gloss_29 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_30;
  mediump vec4 diff_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_31 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_34;
  lightDir_34 = xlv_TEXCOORD6;
  mediump vec3 viewDir_35;
  viewDir_35 = tmpvar_33;
  mediump vec3 spec_36;
  highp float specRefl_37;
  mediump vec4 frag_38;
  mediump float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_5, lightDir_34), 0.0, 1.0);
  frag_38.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_39)) * diff_9.xyz);
  frag_38.w = diff_9.w;
  mediump float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_5, normalize((viewDir_35 + lightDir_34))), 0.0, 1.0);
  specRefl_37 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = vec3(pow (specRefl_37, tmpvar_21));
  spec_36 = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = (((spec_36 * clamp ((10.0 * tmpvar_39), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_36 = tmpvar_42;
  frag_38.xyz = (frag_38.xyz + (tmpvar_42 * tmpvar_6));
  c_1 = frag_38;
  mediump vec3 tmpvar_43;
  tmpvar_43 = (c_1.xyz + (diff_9.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = (c_1.xyz + ((((spec_25.xyz * spec_25.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_31.xyz * diff_31.w) * diff_9.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_44;
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
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  vec3 tmpvar_9;
  tmpvar_9.x = dot (xlv_TEXCOORD3, normal_5);
  tmpvar_9.y = dot (xlv_TEXCOORD4, normal_5);
  tmpvar_9.z = dot (xlv_TEXCOORD5, normal_5);
  vec3 i_10;
  i_10 = -(xlv_TEXCOORD2);
  vec4 tmpvar_11;
  tmpvar_11.xyz = (i_10 - (2.0 * (dot (tmpvar_9, i_10) * tmpvar_9)));
  tmpvar_11.w = tmpvar_8;
  vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_SpecCubeIBL, tmpvar_11.xyz, tmpvar_8);
  vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, tmpvar_9);
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD6);
  c_1.xyz = (diff_3.xyz * ((8.0 * tmpvar_14.w) * tmpvar_14.xyz));
  c_1.w = diff_3.w;
  c_1.xyz = (c_1.xyz + ((((tmpvar_12.xyz * tmpvar_12.w) * spec_2.xyz) * _ExposureIBL.y) + (((tmpvar_13.xyz * tmpvar_13.w) * diff_3.xyz) * _ExposureIBL.x)));
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
  mediump vec4 spec_5;
  highp vec3 N_6;
  mediump vec4 diff_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_7 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (diff_7 * _Color);
  diff_7 = tmpvar_9;
  diff_7.xyz = (diff_7.xyz * _ExposureIBL.w);
  mediump float tmpvar_10;
  tmpvar_10 = diff_7.w;
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_12;
  mediump float specIntensity_13;
  specIntensity_13 = _SpecInt;
  mediump float fresnel_14;
  fresnel_14 = _Fresnel;
  mediump float factor_15;
  highp float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N_6, xlv_TEXCOORD1), 0.0, 1.0));
  factor_15 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = (factor_15 * (factor_15 * factor_15));
  factor_15 = tmpvar_17;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_13 * mix (1.0, tmpvar_17, (fresnel_14 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_18;
  mediump float shininess_19;
  shininess_19 = _Shininess;
  tmpvar_18 = ((7.0 + spec_5.w) - (shininess_19 * spec_5.w));
  highp vec3 tmpvar_20;
  tmpvar_20.x = dot (tmpvar_2, N_6);
  tmpvar_20.y = dot (tmpvar_3, N_6);
  tmpvar_20.z = dot (tmpvar_4, N_6);
  N_6 = tmpvar_20;
  highp vec3 i_21;
  i_21 = -(xlv_TEXCOORD2);
  highp float glossLod_22;
  glossLod_22 = tmpvar_18;
  mediump vec4 spec_23;
  mediump vec4 lookup_24;
  highp vec4 tmpvar_25;
  tmpvar_25.xyz = (i_21 - (2.0 * (dot (tmpvar_20, i_21) * tmpvar_20)));
  tmpvar_25.w = glossLod_22;
  lookup_24 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCubeLod (_SpecCubeIBL, lookup_24.xyz, lookup_24.w);
  spec_23 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_20);
  diff_27 = tmpvar_28;
  lowp vec3 tmpvar_29;
  tmpvar_29 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD6).xyz);
  mediump vec3 tmpvar_30;
  tmpvar_30 = (diff_7.xyz * tmpvar_29);
  c_1.xyz = tmpvar_30;
  c_1.w = tmpvar_10;
  mediump vec3 tmpvar_31;
  tmpvar_31 = (c_1.xyz + ((((spec_23.xyz * spec_23.w) * spec_5.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_7.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_31;
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
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD3, normal_5);
  tmpvar_10.y = dot (xlv_TEXCOORD4, normal_5);
  tmpvar_10.z = dot (xlv_TEXCOORD5, normal_5);
  vec3 i_11;
  i_11 = -(xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12.xyz = (i_11 - (2.0 * (dot (tmpvar_10, i_11) * tmpvar_10)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_8);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_10);
  vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD8);
  vec4 frag_16;
  float tmpvar_17;
  tmpvar_17 = clamp (dot (normal_5, xlv_TEXCOORD6), 0.0, 1.0);
  frag_16.xyz = ((_LightColor0.xyz * ((tmpvar_15.x * 2.0) * tmpvar_17)) * diff_3.xyz);
  frag_16.w = diff_3.w;
  frag_16.xyz = (frag_16.xyz + (((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD6))), 0.0, 1.0), tmpvar_9)) * clamp ((10.0 * tmpvar_17), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_15.x) * 0.5) * (spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  c_1.w = frag_16.w;
  c_1.xyz = (frag_16.xyz + (diff_3.xyz * xlv_TEXCOORD7));
  c_1.xyz = (c_1.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec_2.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff_3.xyz) * _ExposureIBL.x)));
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
  mediump vec4 spec_7;
  highp vec3 N_8;
  mediump vec4 diff_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_9 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff_9 * _Color);
  diff_9 = tmpvar_11;
  diff_9.xyz = (diff_9.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_8 = tmpvar_12;
  tmpvar_5 = N_8;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_8, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_7.w) - (shininess_20 * spec_7.w));
  mediump float tmpvar_21;
  tmpvar_21 = pow (2.0, (8.0 - tmpvar_19));
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N_8);
  tmpvar_22.y = dot (tmpvar_3, N_8);
  tmpvar_22.z = dot (tmpvar_4, N_8);
  N_8 = tmpvar_22;
  highp vec3 i_23;
  i_23 = -(xlv_TEXCOORD2);
  highp float glossLod_24;
  glossLod_24 = tmpvar_19;
  mediump vec4 spec_25;
  mediump vec4 lookup_26;
  highp vec4 tmpvar_27;
  tmpvar_27.xyz = (i_23 - (2.0 * (dot (tmpvar_22, i_23) * tmpvar_22)));
  tmpvar_27.w = glossLod_24;
  lookup_26 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCubeLod (_SpecCubeIBL, lookup_26.xyz, lookup_26.w);
  spec_25 = tmpvar_28;
  highp float gloss_29;
  gloss_29 = tmpvar_21;
  highp vec3 tmpvar_30;
  tmpvar_30 = (spec_7.xyz * ((gloss_29 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_30;
  mediump vec4 diff_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_31 = tmpvar_32;
  lowp float tmpvar_33;
  mediump float lightShadowDataX_34;
  highp float dist_35;
  lowp float tmpvar_36;
  tmpvar_36 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD8).x;
  dist_35 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = _LightShadowData.x;
  lightShadowDataX_34 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = max (float((dist_35 > (xlv_TEXCOORD8.z / xlv_TEXCOORD8.w))), lightShadowDataX_34);
  tmpvar_33 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_40;
  lightDir_40 = xlv_TEXCOORD6;
  mediump vec3 viewDir_41;
  viewDir_41 = tmpvar_39;
  mediump float atten_42;
  atten_42 = tmpvar_33;
  mediump vec3 spec_43;
  highp float specRefl_44;
  mediump vec4 frag_45;
  mediump float tmpvar_46;
  tmpvar_46 = clamp (dot (tmpvar_5, lightDir_40), 0.0, 1.0);
  frag_45.xyz = ((_LightColor0.xyz * ((atten_42 * 2.0) * tmpvar_46)) * diff_9.xyz);
  frag_45.w = diff_9.w;
  mediump float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_5, normalize((viewDir_41 + lightDir_40))), 0.0, 1.0);
  specRefl_44 = tmpvar_47;
  highp vec3 tmpvar_48;
  tmpvar_48 = vec3(pow (specRefl_44, tmpvar_21));
  spec_43 = tmpvar_48;
  mediump vec3 tmpvar_49;
  tmpvar_49 = ((((spec_43 * clamp ((10.0 * tmpvar_46), 0.0, 1.0)) * _LightColor0.xyz) * atten_42) * 0.5);
  spec_43 = tmpvar_49;
  frag_45.xyz = (frag_45.xyz + (tmpvar_49 * tmpvar_6));
  c_1 = frag_45;
  mediump vec3 tmpvar_50;
  tmpvar_50 = (c_1.xyz + (diff_9.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_50;
  mediump vec3 tmpvar_51;
  tmpvar_51 = (c_1.xyz + ((((spec_25.xyz * spec_25.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_31.xyz * diff_31.w) * diff_9.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_51;
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
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  vec3 tmpvar_9;
  tmpvar_9.x = dot (xlv_TEXCOORD3, normal_5);
  tmpvar_9.y = dot (xlv_TEXCOORD4, normal_5);
  tmpvar_9.z = dot (xlv_TEXCOORD5, normal_5);
  vec3 i_10;
  i_10 = -(xlv_TEXCOORD2);
  vec4 tmpvar_11;
  tmpvar_11.xyz = (i_10 - (2.0 * (dot (tmpvar_9, i_10) * tmpvar_9)));
  tmpvar_11.w = tmpvar_8;
  vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_SpecCubeIBL, tmpvar_11.xyz, tmpvar_8);
  vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, tmpvar_9);
  vec4 tmpvar_14;
  tmpvar_14 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_Lightmap, xlv_TEXCOORD6);
  vec3 tmpvar_16;
  tmpvar_16 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  c_1.xyz = (diff_3.xyz * max (min (tmpvar_16, ((tmpvar_14.x * 2.0) * tmpvar_15.xyz)), (tmpvar_16 * tmpvar_14.x)));
  c_1.w = diff_3.w;
  c_1.xyz = (c_1.xyz + ((((tmpvar_12.xyz * tmpvar_12.w) * spec_2.xyz) * _ExposureIBL.y) + (((tmpvar_13.xyz * tmpvar_13.w) * diff_3.xyz) * _ExposureIBL.x)));
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
  mediump vec4 spec_5;
  highp vec3 N_6;
  mediump vec4 diff_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_7 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (diff_7 * _Color);
  diff_7 = tmpvar_9;
  diff_7.xyz = (diff_7.xyz * _ExposureIBL.w);
  mediump float tmpvar_10;
  tmpvar_10 = diff_7.w;
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_12;
  mediump float specIntensity_13;
  specIntensity_13 = _SpecInt;
  mediump float fresnel_14;
  fresnel_14 = _Fresnel;
  mediump float factor_15;
  highp float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N_6, xlv_TEXCOORD1), 0.0, 1.0));
  factor_15 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = (factor_15 * (factor_15 * factor_15));
  factor_15 = tmpvar_17;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_13 * mix (1.0, tmpvar_17, (fresnel_14 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_18;
  mediump float shininess_19;
  shininess_19 = _Shininess;
  tmpvar_18 = ((7.0 + spec_5.w) - (shininess_19 * spec_5.w));
  highp vec3 tmpvar_20;
  tmpvar_20.x = dot (tmpvar_2, N_6);
  tmpvar_20.y = dot (tmpvar_3, N_6);
  tmpvar_20.z = dot (tmpvar_4, N_6);
  N_6 = tmpvar_20;
  highp vec3 i_21;
  i_21 = -(xlv_TEXCOORD2);
  highp float glossLod_22;
  glossLod_22 = tmpvar_18;
  mediump vec4 spec_23;
  mediump vec4 lookup_24;
  highp vec4 tmpvar_25;
  tmpvar_25.xyz = (i_21 - (2.0 * (dot (tmpvar_20, i_21) * tmpvar_20)));
  tmpvar_25.w = glossLod_22;
  lookup_24 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCubeLod (_SpecCubeIBL, lookup_24.xyz, lookup_24.w);
  spec_23 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_20);
  diff_27 = tmpvar_28;
  lowp float tmpvar_29;
  mediump float lightShadowDataX_30;
  highp float dist_31;
  lowp float tmpvar_32;
  tmpvar_32 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  dist_31 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = _LightShadowData.x;
  lightShadowDataX_30 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = max (float((dist_31 > (xlv_TEXCOORD7.z / xlv_TEXCOORD7.w))), lightShadowDataX_30);
  tmpvar_29 = tmpvar_34;
  lowp vec3 tmpvar_35;
  tmpvar_35 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD6).xyz), vec3((tmpvar_29 * 2.0)));
  mediump vec3 tmpvar_36;
  tmpvar_36 = (diff_7.xyz * tmpvar_35);
  c_1.xyz = tmpvar_36;
  c_1.w = tmpvar_10;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c_1.xyz + ((((spec_23.xyz * spec_23.w) * spec_5.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_7.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_37;
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
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD3, normal_5);
  tmpvar_10.y = dot (xlv_TEXCOORD4, normal_5);
  tmpvar_10.z = dot (xlv_TEXCOORD5, normal_5);
  vec3 i_11;
  i_11 = -(xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12.xyz = (i_11 - (2.0 * (dot (tmpvar_10, i_11) * tmpvar_10)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_8);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_10);
  vec4 frag_15;
  float tmpvar_16;
  tmpvar_16 = clamp (dot (normal_5, xlv_TEXCOORD6), 0.0, 1.0);
  frag_15.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_16)) * diff_3.xyz);
  frag_15.w = diff_3.w;
  frag_15.xyz = (frag_15.xyz + ((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD6))), 0.0, 1.0), tmpvar_9)) * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  c_1.w = frag_15.w;
  c_1.xyz = (frag_15.xyz + (diff_3.xyz * xlv_TEXCOORD7));
  c_1.xyz = (c_1.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec_2.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff_3.xyz) * _ExposureIBL.x)));
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
  mediump vec4 spec_7;
  highp vec3 N_8;
  mediump vec4 diff_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_9 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff_9 * _Color);
  diff_9 = tmpvar_11;
  diff_9.xyz = (diff_9.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_8 = tmpvar_12;
  tmpvar_5 = N_8;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_8, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_7.w) - (shininess_20 * spec_7.w));
  mediump float tmpvar_21;
  tmpvar_21 = pow (2.0, (8.0 - tmpvar_19));
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N_8);
  tmpvar_22.y = dot (tmpvar_3, N_8);
  tmpvar_22.z = dot (tmpvar_4, N_8);
  N_8 = tmpvar_22;
  highp vec3 i_23;
  i_23 = -(xlv_TEXCOORD2);
  highp float glossLod_24;
  glossLod_24 = tmpvar_19;
  mediump vec4 spec_25;
  mediump vec4 lookup_26;
  highp vec4 tmpvar_27;
  tmpvar_27.xyz = (i_23 - (2.0 * (dot (tmpvar_22, i_23) * tmpvar_22)));
  tmpvar_27.w = glossLod_24;
  lookup_26 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCubeLod (_SpecCubeIBL, lookup_26.xyz, lookup_26.w);
  spec_25 = tmpvar_28;
  highp float gloss_29;
  gloss_29 = tmpvar_21;
  highp vec3 tmpvar_30;
  tmpvar_30 = (spec_7.xyz * ((gloss_29 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_30;
  mediump vec4 diff_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_31 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_34;
  lightDir_34 = xlv_TEXCOORD6;
  mediump vec3 viewDir_35;
  viewDir_35 = tmpvar_33;
  mediump vec3 spec_36;
  highp float specRefl_37;
  mediump vec4 frag_38;
  mediump float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_5, lightDir_34), 0.0, 1.0);
  frag_38.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_39)) * diff_9.xyz);
  frag_38.w = diff_9.w;
  mediump float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_5, normalize((viewDir_35 + lightDir_34))), 0.0, 1.0);
  specRefl_37 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = vec3(pow (specRefl_37, tmpvar_21));
  spec_36 = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = (((spec_36 * clamp ((10.0 * tmpvar_39), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_36 = tmpvar_42;
  frag_38.xyz = (frag_38.xyz + (tmpvar_42 * tmpvar_6));
  c_1 = frag_38;
  mediump vec3 tmpvar_43;
  tmpvar_43 = (c_1.xyz + (diff_9.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = (c_1.xyz + ((((spec_25.xyz * spec_25.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_31.xyz * diff_31.w) * diff_9.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_44;
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
  tmpvar_8 = ((7.0 + tmpvar_6.w) - (_Shininess * tmpvar_6.w));
  float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - tmpvar_8));
  vec3 tmpvar_10;
  tmpvar_10.x = dot (xlv_TEXCOORD3, normal_5);
  tmpvar_10.y = dot (xlv_TEXCOORD4, normal_5);
  tmpvar_10.z = dot (xlv_TEXCOORD5, normal_5);
  vec3 i_11;
  i_11 = -(xlv_TEXCOORD2);
  vec4 tmpvar_12;
  tmpvar_12.xyz = (i_11 - (2.0 * (dot (tmpvar_10, i_11) * tmpvar_10)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_8);
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_10);
  vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD8);
  vec4 frag_16;
  float tmpvar_17;
  tmpvar_17 = clamp (dot (normal_5, xlv_TEXCOORD6), 0.0, 1.0);
  frag_16.xyz = ((_LightColor0.xyz * ((tmpvar_15.x * 2.0) * tmpvar_17)) * diff_3.xyz);
  frag_16.w = diff_3.w;
  frag_16.xyz = (frag_16.xyz + (((((vec3(pow (clamp (dot (normal_5, normalize((normalize(xlv_TEXCOORD1) + xlv_TEXCOORD6))), 0.0, 1.0), tmpvar_9)) * clamp ((10.0 * tmpvar_17), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_15.x) * 0.5) * (spec_2.xyz * ((tmpvar_9 * 0.159155) + 0.31831))));
  c_1.w = frag_16.w;
  c_1.xyz = (frag_16.xyz + (diff_3.xyz * xlv_TEXCOORD7));
  c_1.xyz = (c_1.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec_2.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff_3.xyz) * _ExposureIBL.x)));
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
  mediump vec4 spec_7;
  highp vec3 N_8;
  mediump vec4 diff_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_9 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff_9 * _Color);
  diff_9 = tmpvar_11;
  diff_9.xyz = (diff_9.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_8 = tmpvar_12;
  tmpvar_5 = N_8;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_8, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_7.w) - (shininess_20 * spec_7.w));
  mediump float tmpvar_21;
  tmpvar_21 = pow (2.0, (8.0 - tmpvar_19));
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N_8);
  tmpvar_22.y = dot (tmpvar_3, N_8);
  tmpvar_22.z = dot (tmpvar_4, N_8);
  N_8 = tmpvar_22;
  highp vec3 i_23;
  i_23 = -(xlv_TEXCOORD2);
  highp float glossLod_24;
  glossLod_24 = tmpvar_19;
  mediump vec4 spec_25;
  mediump vec4 lookup_26;
  highp vec4 tmpvar_27;
  tmpvar_27.xyz = (i_23 - (2.0 * (dot (tmpvar_22, i_23) * tmpvar_22)));
  tmpvar_27.w = glossLod_24;
  lookup_26 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCubeLod (_SpecCubeIBL, lookup_26.xyz, lookup_26.w);
  spec_25 = tmpvar_28;
  highp float gloss_29;
  gloss_29 = tmpvar_21;
  highp vec3 tmpvar_30;
  tmpvar_30 = (spec_7.xyz * ((gloss_29 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_30;
  mediump vec4 diff_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_31 = tmpvar_32;
  lowp float tmpvar_33;
  mediump float lightShadowDataX_34;
  highp float dist_35;
  lowp float tmpvar_36;
  tmpvar_36 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD8).x;
  dist_35 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = _LightShadowData.x;
  lightShadowDataX_34 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = max (float((dist_35 > (xlv_TEXCOORD8.z / xlv_TEXCOORD8.w))), lightShadowDataX_34);
  tmpvar_33 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_40;
  lightDir_40 = xlv_TEXCOORD6;
  mediump vec3 viewDir_41;
  viewDir_41 = tmpvar_39;
  mediump float atten_42;
  atten_42 = tmpvar_33;
  mediump vec3 spec_43;
  highp float specRefl_44;
  mediump vec4 frag_45;
  mediump float tmpvar_46;
  tmpvar_46 = clamp (dot (tmpvar_5, lightDir_40), 0.0, 1.0);
  frag_45.xyz = ((_LightColor0.xyz * ((atten_42 * 2.0) * tmpvar_46)) * diff_9.xyz);
  frag_45.w = diff_9.w;
  mediump float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_5, normalize((viewDir_41 + lightDir_40))), 0.0, 1.0);
  specRefl_44 = tmpvar_47;
  highp vec3 tmpvar_48;
  tmpvar_48 = vec3(pow (specRefl_44, tmpvar_21));
  spec_43 = tmpvar_48;
  mediump vec3 tmpvar_49;
  tmpvar_49 = ((((spec_43 * clamp ((10.0 * tmpvar_46), 0.0, 1.0)) * _LightColor0.xyz) * atten_42) * 0.5);
  spec_43 = tmpvar_49;
  frag_45.xyz = (frag_45.xyz + (tmpvar_49 * tmpvar_6));
  c_1 = frag_45;
  mediump vec3 tmpvar_50;
  tmpvar_50 = (c_1.xyz + (diff_9.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_50;
  mediump vec3 tmpvar_51;
  tmpvar_51 = (c_1.xyz + ((((spec_25.xyz * spec_25.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_31.xyz * diff_31.w) * diff_9.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_51;
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
  mediump vec4 spec_7;
  highp vec3 N_8;
  mediump vec4 diff_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_9 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff_9 * _Color);
  diff_9 = tmpvar_11;
  diff_9.xyz = (diff_9.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_8 = tmpvar_12;
  tmpvar_5 = N_8;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_8, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_7.w) - (shininess_20 * spec_7.w));
  mediump float tmpvar_21;
  tmpvar_21 = pow (2.0, (8.0 - tmpvar_19));
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N_8);
  tmpvar_22.y = dot (tmpvar_3, N_8);
  tmpvar_22.z = dot (tmpvar_4, N_8);
  N_8 = tmpvar_22;
  highp vec3 i_23;
  i_23 = -(xlv_TEXCOORD2);
  highp float glossLod_24;
  glossLod_24 = tmpvar_19;
  mediump vec4 spec_25;
  mediump vec4 lookup_26;
  highp vec4 tmpvar_27;
  tmpvar_27.xyz = (i_23 - (2.0 * (dot (tmpvar_22, i_23) * tmpvar_22)));
  tmpvar_27.w = glossLod_24;
  lookup_26 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCubeLod (_SpecCubeIBL, lookup_26.xyz, lookup_26.w);
  spec_25 = tmpvar_28;
  highp float gloss_29;
  gloss_29 = tmpvar_21;
  highp vec3 tmpvar_30;
  tmpvar_30 = (spec_7.xyz * ((gloss_29 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_30;
  mediump vec4 diff_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_31 = tmpvar_32;
  lowp float shadow_33;
  lowp float tmpvar_34;
  tmpvar_34 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD8.xyz);
  highp float tmpvar_35;
  tmpvar_35 = (_LightShadowData.x + (tmpvar_34 * (1.0 - _LightShadowData.x)));
  shadow_33 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_37;
  lightDir_37 = xlv_TEXCOORD6;
  mediump vec3 viewDir_38;
  viewDir_38 = tmpvar_36;
  mediump float atten_39;
  atten_39 = shadow_33;
  mediump vec3 spec_40;
  highp float specRefl_41;
  mediump vec4 frag_42;
  mediump float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_5, lightDir_37), 0.0, 1.0);
  frag_42.xyz = ((_LightColor0.xyz * ((atten_39 * 2.0) * tmpvar_43)) * diff_9.xyz);
  frag_42.w = diff_9.w;
  mediump float tmpvar_44;
  tmpvar_44 = clamp (dot (tmpvar_5, normalize((viewDir_38 + lightDir_37))), 0.0, 1.0);
  specRefl_41 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = vec3(pow (specRefl_41, tmpvar_21));
  spec_40 = tmpvar_45;
  mediump vec3 tmpvar_46;
  tmpvar_46 = ((((spec_40 * clamp ((10.0 * tmpvar_43), 0.0, 1.0)) * _LightColor0.xyz) * atten_39) * 0.5);
  spec_40 = tmpvar_46;
  frag_42.xyz = (frag_42.xyz + (tmpvar_46 * tmpvar_6));
  c_1 = frag_42;
  mediump vec3 tmpvar_47;
  tmpvar_47 = (c_1.xyz + (diff_9.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_47;
  mediump vec3 tmpvar_48;
  tmpvar_48 = (c_1.xyz + ((((spec_25.xyz * spec_25.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_31.xyz * diff_31.w) * diff_9.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_48;
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
  mediump vec4 spec_5;
  highp vec3 N_6;
  mediump vec4 diff_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_7 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (diff_7 * _Color);
  diff_7 = tmpvar_9;
  diff_7.xyz = (diff_7.xyz * _ExposureIBL.w);
  mediump float tmpvar_10;
  tmpvar_10 = diff_7.w;
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_12;
  mediump float specIntensity_13;
  specIntensity_13 = _SpecInt;
  mediump float fresnel_14;
  fresnel_14 = _Fresnel;
  mediump float factor_15;
  highp float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N_6, xlv_TEXCOORD1), 0.0, 1.0));
  factor_15 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = (factor_15 * (factor_15 * factor_15));
  factor_15 = tmpvar_17;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_13 * mix (1.0, tmpvar_17, (fresnel_14 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_18;
  mediump float shininess_19;
  shininess_19 = _Shininess;
  tmpvar_18 = ((7.0 + spec_5.w) - (shininess_19 * spec_5.w));
  highp vec3 tmpvar_20;
  tmpvar_20.x = dot (tmpvar_2, N_6);
  tmpvar_20.y = dot (tmpvar_3, N_6);
  tmpvar_20.z = dot (tmpvar_4, N_6);
  N_6 = tmpvar_20;
  highp vec3 i_21;
  i_21 = -(xlv_TEXCOORD2);
  highp float glossLod_22;
  glossLod_22 = tmpvar_18;
  mediump vec4 spec_23;
  mediump vec4 lookup_24;
  highp vec4 tmpvar_25;
  tmpvar_25.xyz = (i_21 - (2.0 * (dot (tmpvar_20, i_21) * tmpvar_20)));
  tmpvar_25.w = glossLod_22;
  lookup_24 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCubeLod (_SpecCubeIBL, lookup_24.xyz, lookup_24.w);
  spec_23 = tmpvar_26;
  mediump vec4 diff_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCube (_DiffCubeIBL, tmpvar_20);
  diff_27 = tmpvar_28;
  lowp float shadow_29;
  lowp float tmpvar_30;
  tmpvar_30 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD7.xyz);
  highp float tmpvar_31;
  tmpvar_31 = (_LightShadowData.x + (tmpvar_30 * (1.0 - _LightShadowData.x)));
  shadow_29 = tmpvar_31;
  lowp vec3 tmpvar_32;
  tmpvar_32 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD6).xyz), vec3((shadow_29 * 2.0)));
  mediump vec3 tmpvar_33;
  tmpvar_33 = (diff_7.xyz * tmpvar_32);
  c_1.xyz = tmpvar_33;
  c_1.w = tmpvar_10;
  mediump vec3 tmpvar_34;
  tmpvar_34 = (c_1.xyz + ((((spec_23.xyz * spec_23.w) * spec_5.xyz) * _ExposureIBL.y) + (((diff_27.xyz * diff_27.w) * diff_7.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_34;
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
  mediump vec4 spec_7;
  highp vec3 N_8;
  mediump vec4 diff_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_9 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff_9 * _Color);
  diff_9 = tmpvar_11;
  diff_9.xyz = (diff_9.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_8 = tmpvar_12;
  tmpvar_5 = N_8;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_7 = tmpvar_13;
  mediump float specIntensity_14;
  specIntensity_14 = _SpecInt;
  mediump float fresnel_15;
  fresnel_15 = _Fresnel;
  mediump float factor_16;
  highp float tmpvar_17;
  tmpvar_17 = (1.0 - clamp (dot (N_8, xlv_TEXCOORD1), 0.0, 1.0));
  factor_16 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = (factor_16 * (factor_16 * factor_16));
  factor_16 = tmpvar_18;
  spec_7.xyz = (spec_7.xyz * ((_SpecColor.xyz * (specIntensity_14 * mix (1.0, tmpvar_18, (fresnel_15 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess_20;
  shininess_20 = _Shininess;
  tmpvar_19 = ((7.0 + spec_7.w) - (shininess_20 * spec_7.w));
  mediump float tmpvar_21;
  tmpvar_21 = pow (2.0, (8.0 - tmpvar_19));
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N_8);
  tmpvar_22.y = dot (tmpvar_3, N_8);
  tmpvar_22.z = dot (tmpvar_4, N_8);
  N_8 = tmpvar_22;
  highp vec3 i_23;
  i_23 = -(xlv_TEXCOORD2);
  highp float glossLod_24;
  glossLod_24 = tmpvar_19;
  mediump vec4 spec_25;
  mediump vec4 lookup_26;
  highp vec4 tmpvar_27;
  tmpvar_27.xyz = (i_23 - (2.0 * (dot (tmpvar_22, i_23) * tmpvar_22)));
  tmpvar_27.w = glossLod_24;
  lookup_26 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = textureCubeLod (_SpecCubeIBL, lookup_26.xyz, lookup_26.w);
  spec_25 = tmpvar_28;
  highp float gloss_29;
  gloss_29 = tmpvar_21;
  highp vec3 tmpvar_30;
  tmpvar_30 = (spec_7.xyz * ((gloss_29 * 0.159155) + 0.31831));
  tmpvar_6 = tmpvar_30;
  mediump vec4 diff_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_31 = tmpvar_32;
  lowp float shadow_33;
  lowp float tmpvar_34;
  tmpvar_34 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD8.xyz);
  highp float tmpvar_35;
  tmpvar_35 = (_LightShadowData.x + (tmpvar_34 * (1.0 - _LightShadowData.x)));
  shadow_33 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_37;
  lightDir_37 = xlv_TEXCOORD6;
  mediump vec3 viewDir_38;
  viewDir_38 = tmpvar_36;
  mediump float atten_39;
  atten_39 = shadow_33;
  mediump vec3 spec_40;
  highp float specRefl_41;
  mediump vec4 frag_42;
  mediump float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_5, lightDir_37), 0.0, 1.0);
  frag_42.xyz = ((_LightColor0.xyz * ((atten_39 * 2.0) * tmpvar_43)) * diff_9.xyz);
  frag_42.w = diff_9.w;
  mediump float tmpvar_44;
  tmpvar_44 = clamp (dot (tmpvar_5, normalize((viewDir_38 + lightDir_37))), 0.0, 1.0);
  specRefl_41 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = vec3(pow (specRefl_41, tmpvar_21));
  spec_40 = tmpvar_45;
  mediump vec3 tmpvar_46;
  tmpvar_46 = ((((spec_40 * clamp ((10.0 * tmpvar_43), 0.0, 1.0)) * _LightColor0.xyz) * atten_39) * 0.5);
  spec_40 = tmpvar_46;
  frag_42.xyz = (frag_42.xyz + (tmpvar_46 * tmpvar_6));
  c_1 = frag_42;
  mediump vec3 tmpvar_47;
  tmpvar_47 = (c_1.xyz + (diff_9.xyz * xlv_TEXCOORD7));
  c_1.xyz = tmpvar_47;
  mediump vec3 tmpvar_48;
  tmpvar_48 = (c_1.xyz + ((((spec_25.xyz * spec_25.w) * spec_7.xyz) * _ExposureIBL.y) + (((diff_31.xyz * diff_31.w) * diff_9.xyz) * _ExposureIBL.x)));
  c_1.xyz = tmpvar_48;
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
  mediump vec4 spec_5;
  highp vec3 N_6;
  mediump vec4 diff_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_7 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (diff_7 * _Color);
  diff_7 = tmpvar_9;
  diff_7.xyz = (diff_7.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_6 = tmpvar_10;
  tmpvar_3 = N_6;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N_6, xlv_TEXCOORD1), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_5.w) - (shininess_17 * spec_5.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_5.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_23;
  tmpvar_23 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_LightTexture0, vec2(tmpvar_23));
  mediump vec3 lightDir_25;
  lightDir_25 = lightDir_2;
  mediump vec3 viewDir_26;
  viewDir_26 = tmpvar_22;
  mediump float atten_27;
  atten_27 = tmpvar_24.w;
  mediump vec3 spec_28;
  highp float specRefl_29;
  mediump vec4 frag_30;
  mediump float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_3, lightDir_25), 0.0, 1.0);
  frag_30.xyz = ((_LightColor0.xyz * ((atten_27 * 2.0) * tmpvar_31)) * diff_7.xyz);
  frag_30.w = diff_7.w;
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_3, normalize((viewDir_26 + lightDir_25))), 0.0, 1.0);
  specRefl_29 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = vec3(pow (specRefl_29, tmpvar_18));
  spec_28 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = ((((spec_28 * clamp ((10.0 * tmpvar_31), 0.0, 1.0)) * _LightColor0.xyz) * atten_27) * 0.5);
  spec_28 = tmpvar_34;
  frag_30.xyz = (frag_30.xyz + (tmpvar_34 * tmpvar_4));
  c_1.xyz = frag_30.xyz;
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
  mediump vec4 spec_5;
  highp vec3 N_6;
  mediump vec4 diff_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_7 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (diff_7 * _Color);
  diff_7 = tmpvar_9;
  diff_7.xyz = (diff_7.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_6 = tmpvar_10;
  tmpvar_3 = N_6;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N_6, xlv_TEXCOORD1), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_5.w) - (shininess_17 * spec_5.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_5.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_20;
  lightDir_2 = xlv_TEXCOORD3;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD1);
  mediump vec3 lightDir_22;
  lightDir_22 = lightDir_2;
  mediump vec3 viewDir_23;
  viewDir_23 = tmpvar_21;
  mediump vec3 spec_24;
  highp float specRefl_25;
  mediump vec4 frag_26;
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_3, lightDir_22), 0.0, 1.0);
  frag_26.xyz = ((_LightColor0.xyz * (2.0 * tmpvar_27)) * diff_7.xyz);
  frag_26.w = diff_7.w;
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_3, normalize((viewDir_23 + lightDir_22))), 0.0, 1.0);
  specRefl_25 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = vec3(pow (specRefl_25, tmpvar_18));
  spec_24 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (((spec_24 * clamp ((10.0 * tmpvar_27), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_24 = tmpvar_30;
  frag_26.xyz = (frag_26.xyz + (tmpvar_30 * tmpvar_4));
  c_1.xyz = frag_26.xyz;
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
  mediump vec4 spec_5;
  highp vec3 N_6;
  mediump vec4 diff_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_7 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (diff_7 * _Color);
  diff_7 = tmpvar_9;
  diff_7.xyz = (diff_7.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_6 = tmpvar_10;
  tmpvar_3 = N_6;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N_6, xlv_TEXCOORD1), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_5.w) - (shininess_17 * spec_5.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_5.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD1);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  tmpvar_23 = texture2D (_LightTexture0, P_24);
  highp float tmpvar_25;
  tmpvar_25 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_LightTextureB0, vec2(tmpvar_25));
  mediump vec3 lightDir_27;
  lightDir_27 = lightDir_2;
  mediump vec3 viewDir_28;
  viewDir_28 = tmpvar_22;
  mediump float atten_29;
  atten_29 = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_23.w) * tmpvar_26.w);
  mediump vec3 spec_30;
  highp float specRefl_31;
  mediump vec4 frag_32;
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_3, lightDir_27), 0.0, 1.0);
  frag_32.xyz = ((_LightColor0.xyz * ((atten_29 * 2.0) * tmpvar_33)) * diff_7.xyz);
  frag_32.w = diff_7.w;
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_3, normalize((viewDir_28 + lightDir_27))), 0.0, 1.0);
  specRefl_31 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = vec3(pow (specRefl_31, tmpvar_18));
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
  mediump vec4 spec_5;
  highp vec3 N_6;
  mediump vec4 diff_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_7 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (diff_7 * _Color);
  diff_7 = tmpvar_9;
  diff_7.xyz = (diff_7.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_6 = tmpvar_10;
  tmpvar_3 = N_6;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N_6, xlv_TEXCOORD1), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_5.w) - (shininess_17 * spec_5.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_5.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_23;
  tmpvar_23 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_LightTextureB0, vec2(tmpvar_23));
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_26;
  lightDir_26 = lightDir_2;
  mediump vec3 viewDir_27;
  viewDir_27 = tmpvar_22;
  mediump float atten_28;
  atten_28 = (tmpvar_24.w * tmpvar_25.w);
  mediump vec3 spec_29;
  highp float specRefl_30;
  mediump vec4 frag_31;
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_3, lightDir_26), 0.0, 1.0);
  frag_31.xyz = ((_LightColor0.xyz * ((atten_28 * 2.0) * tmpvar_32)) * diff_7.xyz);
  frag_31.w = diff_7.w;
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_3, normalize((viewDir_27 + lightDir_26))), 0.0, 1.0);
  specRefl_30 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = vec3(pow (specRefl_30, tmpvar_18));
  spec_29 = tmpvar_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = ((((spec_29 * clamp ((10.0 * tmpvar_32), 0.0, 1.0)) * _LightColor0.xyz) * atten_28) * 0.5);
  spec_29 = tmpvar_35;
  frag_31.xyz = (frag_31.xyz + (tmpvar_35 * tmpvar_4));
  c_1.xyz = frag_31.xyz;
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
  mediump vec4 spec_5;
  highp vec3 N_6;
  mediump vec4 diff_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_7 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (diff_7 * _Color);
  diff_7 = tmpvar_9;
  diff_7.xyz = (diff_7.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_6 = tmpvar_10;
  tmpvar_3 = N_6;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec_5 = tmpvar_11;
  mediump float specIntensity_12;
  specIntensity_12 = _SpecInt;
  mediump float fresnel_13;
  fresnel_13 = _Fresnel;
  mediump float factor_14;
  highp float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N_6, xlv_TEXCOORD1), 0.0, 1.0));
  factor_14 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (factor_14 * (factor_14 * factor_14));
  factor_14 = tmpvar_16;
  spec_5.xyz = (spec_5.xyz * ((_SpecColor.xyz * (specIntensity_12 * mix (1.0, tmpvar_16, (fresnel_13 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess_17;
  shininess_17 = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = pow (2.0, (8.0 - ((7.0 + spec_5.w) - (shininess_17 * spec_5.w))));
  highp float gloss_19;
  gloss_19 = tmpvar_18;
  highp vec3 tmpvar_20;
  tmpvar_20 = (spec_5.xyz * ((gloss_19 * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_20;
  lightDir_2 = xlv_TEXCOORD3;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize(xlv_TEXCOORD1);
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_23;
  lightDir_23 = lightDir_2;
  mediump vec3 viewDir_24;
  viewDir_24 = tmpvar_21;
  mediump float atten_25;
  atten_25 = tmpvar_22.w;
  mediump vec3 spec_26;
  highp float specRefl_27;
  mediump vec4 frag_28;
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_3, lightDir_23), 0.0, 1.0);
  frag_28.xyz = ((_LightColor0.xyz * ((atten_25 * 2.0) * tmpvar_29)) * diff_7.xyz);
  frag_28.w = diff_7.w;
  mediump float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_3, normalize((viewDir_24 + lightDir_23))), 0.0, 1.0);
  specRefl_27 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = vec3(pow (specRefl_27, tmpvar_18));
  spec_26 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = ((((spec_26 * clamp ((10.0 * tmpvar_29), 0.0, 1.0)) * _LightColor0.xyz) * atten_25) * 0.5);
  spec_26 = tmpvar_32;
  frag_28.xyz = (frag_28.xyz + (tmpvar_32 * tmpvar_4));
  c_1.xyz = frag_28.xyz;
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

#LINE 60

	}
	
	FallBack "Diffuse"
}
