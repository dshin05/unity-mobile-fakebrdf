// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Mobile/Self-Illumin/Bumped Diffuse IBL" {
	Properties {
		_Color   ("Diffuse Color", Color) = (1,1,1,1)
		_MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
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
		LOD 350
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
  xlv_TEXCOORD1 = ((tmpvar_3 * v_4) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_5) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_6) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1_12 + x2_11) + (unity_SHC.xyz * ((tmpvar_8.x * tmpvar_8.x) - (tmpvar_8.y * tmpvar_8.y))));
  xlv_TEXCOORD6 = (tmpvar_3 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
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
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec3 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_5);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_5);
  tmpvar_6.z = dot (xlv_TEXCOORD3, normal_5);
  vec4 tmpvar_7;
  tmpvar_7 = textureCube (_DiffCubeIBL, tmpvar_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_8.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_8.w * (_EmissionLM * _ExposureIBL.w));
  vec4 frag_9;
  frag_9.xyz = ((_LightColor0.xyz * (2.0 * clamp (dot (normal_5, xlv_TEXCOORD4), 0.0, 1.0))) * diff_3.xyz);
  frag_9.w = diff_3.w;
  c_1.w = frag_9.w;
  c_1.xyz = (frag_9.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + ((((tmpvar_7.xyz * tmpvar_7.w) * diff_3.xyz) * _ExposureIBL.x) + (glow_2.xyz * glow_2.w)));
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = (tmpvar_11 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
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
  tmpvar_5 = N_7;
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_7);
  tmpvar_12.y = dot (tmpvar_3, N_7);
  tmpvar_12.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_17;
  mediump vec3 lightDir_18;
  lightDir_18 = xlv_TEXCOORD4;
  mediump vec4 frag_19;
  frag_19.xyz = ((_LightColor0.xyz * (2.0 * clamp (dot (tmpvar_5, lightDir_18), 0.0, 1.0))) * diff_8.xyz);
  frag_19.w = diff_8.w;
  c_1 = frag_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_8.xyz) * _ExposureIBL.x) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_21;
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
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

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
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_3 * v_4) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_5) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_6) * unity_Scale.w);
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform float _EmissionLM;
uniform vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec3 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_5);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_5);
  tmpvar_6.z = dot (xlv_TEXCOORD3, normal_5);
  vec4 tmpvar_7;
  tmpvar_7 = textureCube (_DiffCubeIBL, tmpvar_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_8.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_8.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_9;
  tmpvar_9 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  c_1.xyz = (diff_3.xyz * ((8.0 * tmpvar_9.w) * tmpvar_9.xyz));
  c_1.w = diff_3.w;
  c_1.xyz = (c_1.xyz + ((((tmpvar_7.xyz * tmpvar_7.w) * diff_3.xyz) * _ExposureIBL.x) + (glow_2.xyz * glow_2.w)));
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
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;

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
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec4 glow_5;
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
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_6);
  tmpvar_12.y = dot (tmpvar_3, N_6);
  tmpvar_12.z = dot (tmpvar_4, N_6);
  N_6 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  mediump vec3 tmpvar_19;
  tmpvar_19 = (diff_7.xyz * tmpvar_18);
  c_1.xyz = tmpvar_19;
  c_1.w = tmpvar_10;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_7.xyz) * _ExposureIBL.x) + (glow_5.xyz * glow_5.w)));
  c_1.xyz = tmpvar_20;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
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
  xlv_TEXCOORD1 = ((tmpvar_4 * v_5) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_4 * v_6) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_4 * v_7) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_4 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1_13 + x2_12) + (unity_SHC.xyz * ((tmpvar_9.x * tmpvar_9.x) - (tmpvar_9.y * tmpvar_9.y))));
  xlv_TEXCOORD6 = (tmpvar_4 * (((_World2Object * tmpvar_10).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD7 = o_15;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
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
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec3 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_5);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_5);
  tmpvar_6.z = dot (xlv_TEXCOORD3, normal_5);
  vec4 tmpvar_7;
  tmpvar_7 = textureCube (_DiffCubeIBL, tmpvar_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_8.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_8.w * (_EmissionLM * _ExposureIBL.w));
  vec4 frag_9;
  frag_9.xyz = ((_LightColor0.xyz * ((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0) * clamp (dot (normal_5, xlv_TEXCOORD4), 0.0, 1.0))) * diff_3.xyz);
  frag_9.w = diff_3.w;
  c_1.w = frag_9.w;
  c_1.xyz = (frag_9.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + ((((tmpvar_7.xyz * tmpvar_7.w) * diff_3.xyz) * _ExposureIBL.x) + (glow_2.xyz * glow_2.w)));
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

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = (tmpvar_11 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
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
  tmpvar_5 = N_7;
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_7);
  tmpvar_12.y = dot (tmpvar_3, N_7);
  tmpvar_12.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_17;
  lowp float tmpvar_18;
  mediump float lightShadowDataX_19;
  highp float dist_20;
  lowp float tmpvar_21;
  tmpvar_21 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  dist_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = _LightShadowData.x;
  lightShadowDataX_19 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = max (float((dist_20 > (xlv_TEXCOORD7.z / xlv_TEXCOORD7.w))), lightShadowDataX_19);
  tmpvar_18 = tmpvar_23;
  mediump vec3 lightDir_24;
  lightDir_24 = xlv_TEXCOORD4;
  mediump float atten_25;
  atten_25 = tmpvar_18;
  mediump vec4 frag_26;
  frag_26.xyz = ((_LightColor0.xyz * ((atten_25 * 2.0) * clamp (dot (tmpvar_5, lightDir_24), 0.0, 1.0))) * diff_8.xyz);
  frag_26.w = diff_8.w;
  c_1 = frag_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_8.xyz) * _ExposureIBL.x) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_28;
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
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_LightmapST;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
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
  vec4 o_8;
  vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_1 * 0.5);
  vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_8.xy = (tmpvar_10 + tmpvar_9.w);
  o_8.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_4 * v_5) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_4 * v_6) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_4 * v_7) * unity_Scale.w);
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_8;
}


#endif
#ifdef FRAGMENT
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
uniform sampler2D _BumpMap;
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec3 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_5);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_5);
  tmpvar_6.z = dot (xlv_TEXCOORD3, normal_5);
  vec4 tmpvar_7;
  tmpvar_7 = textureCube (_DiffCubeIBL, tmpvar_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_8.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_8.w * (_EmissionLM * _ExposureIBL.w));
  vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  c_1.xyz = (diff_3.xyz * max (min (tmpvar_11, ((tmpvar_9.x * 2.0) * tmpvar_10.xyz)), (tmpvar_11 * tmpvar_9.x)));
  c_1.w = diff_3.w;
  c_1.xyz = (c_1.xyz + ((((tmpvar_7.xyz * tmpvar_7.w) * diff_3.xyz) * _ExposureIBL.x) + (glow_2.xyz * glow_2.w)));
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
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
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
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec4 glow_5;
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
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_6);
  tmpvar_12.y = dot (tmpvar_3, N_6);
  tmpvar_12.z = dot (tmpvar_4, N_6);
  N_6 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_17;
  lowp float tmpvar_18;
  mediump float lightShadowDataX_19;
  highp float dist_20;
  lowp float tmpvar_21;
  tmpvar_21 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  dist_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = _LightShadowData.x;
  lightShadowDataX_19 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = max (float((dist_20 > (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))), lightShadowDataX_19);
  tmpvar_18 = tmpvar_23;
  lowp vec3 tmpvar_24;
  tmpvar_24 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz), vec3((tmpvar_18 * 2.0)));
  mediump vec3 tmpvar_25;
  tmpvar_25 = (diff_7.xyz * tmpvar_24);
  c_1.xyz = tmpvar_25;
  c_1.w = tmpvar_10;
  mediump vec3 tmpvar_26;
  tmpvar_26 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_7.xyz) * _ExposureIBL.x) + (glow_5.xyz * glow_5.w)));
  c_1.xyz = tmpvar_26;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
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
  xlv_TEXCOORD1 = ((tmpvar_3 * v_4) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_5) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_6) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1_12 + x2_11) + (unity_SHC.xyz * ((tmpvar_8.x * tmpvar_8.x) - (tmpvar_8.y * tmpvar_8.y)))) + ((((unity_LightColor[0].xyz * tmpvar_19.x) + (unity_LightColor[1].xyz * tmpvar_19.y)) + (unity_LightColor[2].xyz * tmpvar_19.z)) + (unity_LightColor[3].xyz * tmpvar_19.w)));
  xlv_TEXCOORD6 = (tmpvar_3 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
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
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec3 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_5);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_5);
  tmpvar_6.z = dot (xlv_TEXCOORD3, normal_5);
  vec4 tmpvar_7;
  tmpvar_7 = textureCube (_DiffCubeIBL, tmpvar_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_8.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_8.w * (_EmissionLM * _ExposureIBL.w));
  vec4 frag_9;
  frag_9.xyz = ((_LightColor0.xyz * (2.0 * clamp (dot (normal_5, xlv_TEXCOORD4), 0.0, 1.0))) * diff_3.xyz);
  frag_9.w = diff_3.w;
  c_1.w = frag_9.w;
  c_1.xyz = (frag_9.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + ((((tmpvar_7.xyz * tmpvar_7.w) * diff_3.xyz) * _ExposureIBL.x) + (glow_2.xyz * glow_2.w)));
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = (tmpvar_11 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
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
  tmpvar_5 = N_7;
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_7);
  tmpvar_12.y = dot (tmpvar_3, N_7);
  tmpvar_12.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_17;
  mediump vec3 lightDir_18;
  lightDir_18 = xlv_TEXCOORD4;
  mediump vec4 frag_19;
  frag_19.xyz = ((_LightColor0.xyz * (2.0 * clamp (dot (tmpvar_5, lightDir_18), 0.0, 1.0))) * diff_8.xyz);
  frag_19.w = diff_8.w;
  c_1 = frag_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_8.xyz) * _ExposureIBL.x) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_21;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
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
  xlv_TEXCOORD1 = ((tmpvar_4 * v_5) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_4 * v_6) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_4 * v_7) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_4 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1_13 + x2_12) + (unity_SHC.xyz * ((tmpvar_9.x * tmpvar_9.x) - (tmpvar_9.y * tmpvar_9.y)))) + ((((unity_LightColor[0].xyz * tmpvar_20.x) + (unity_LightColor[1].xyz * tmpvar_20.y)) + (unity_LightColor[2].xyz * tmpvar_20.z)) + (unity_LightColor[3].xyz * tmpvar_20.w)));
  xlv_TEXCOORD6 = (tmpvar_4 * (((_World2Object * tmpvar_10).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD7 = o_21;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
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
uniform vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 glow_2;
  vec4 diff_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_3.w = tmpvar_4.w;
  diff_3.xyz = (tmpvar_4.xyz * _ExposureIBL.w);
  vec3 normal_5;
  normal_5.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_5.z = sqrt(((1.0 - (normal_5.x * normal_5.x)) - (normal_5.y * normal_5.y)));
  vec3 tmpvar_6;
  tmpvar_6.x = dot (xlv_TEXCOORD1, normal_5);
  tmpvar_6.y = dot (xlv_TEXCOORD2, normal_5);
  tmpvar_6.z = dot (xlv_TEXCOORD3, normal_5);
  vec4 tmpvar_7;
  tmpvar_7 = textureCube (_DiffCubeIBL, tmpvar_6);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_2.xyz = (tmpvar_8.xyz * _GlowColor.xyz);
  glow_2.w = (tmpvar_8.w * (_EmissionLM * _ExposureIBL.w));
  vec4 frag_9;
  frag_9.xyz = ((_LightColor0.xyz * ((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0) * clamp (dot (normal_5, xlv_TEXCOORD4), 0.0, 1.0))) * diff_3.xyz);
  frag_9.w = diff_3.w;
  c_1.w = frag_9.w;
  c_1.xyz = (frag_9.xyz + (diff_3.xyz * xlv_TEXCOORD5));
  c_1.xyz = (c_1.xyz + ((((tmpvar_7.xyz * tmpvar_7.w) * diff_3.xyz) * _ExposureIBL.x) + (glow_2.xyz * glow_2.w)));
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

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = (tmpvar_11 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
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
  tmpvar_5 = N_7;
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_7);
  tmpvar_12.y = dot (tmpvar_3, N_7);
  tmpvar_12.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_17;
  lowp float tmpvar_18;
  mediump float lightShadowDataX_19;
  highp float dist_20;
  lowp float tmpvar_21;
  tmpvar_21 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  dist_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = _LightShadowData.x;
  lightShadowDataX_19 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = max (float((dist_20 > (xlv_TEXCOORD7.z / xlv_TEXCOORD7.w))), lightShadowDataX_19);
  tmpvar_18 = tmpvar_23;
  mediump vec3 lightDir_24;
  lightDir_24 = xlv_TEXCOORD4;
  mediump float atten_25;
  atten_25 = tmpvar_18;
  mediump vec4 frag_26;
  frag_26.xyz = ((_LightColor0.xyz * ((atten_25 * 2.0) * clamp (dot (tmpvar_5, lightDir_24), 0.0, 1.0))) * diff_8.xyz);
  frag_26.w = diff_8.w;
  c_1 = frag_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_8.xyz) * _ExposureIBL.x) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_28;
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
varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = (tmpvar_11 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
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
  tmpvar_5 = N_7;
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_7);
  tmpvar_12.y = dot (tmpvar_3, N_7);
  tmpvar_12.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_17;
  lowp float shadow_18;
  lowp float tmpvar_19;
  tmpvar_19 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD7.xyz);
  highp float tmpvar_20;
  tmpvar_20 = (_LightShadowData.x + (tmpvar_19 * (1.0 - _LightShadowData.x)));
  shadow_18 = tmpvar_20;
  mediump vec3 lightDir_21;
  lightDir_21 = xlv_TEXCOORD4;
  mediump float atten_22;
  atten_22 = shadow_18;
  mediump vec4 frag_23;
  frag_23.xyz = ((_LightColor0.xyz * ((atten_22 * 2.0) * clamp (dot (tmpvar_5, lightDir_21), 0.0, 1.0))) * diff_8.xyz);
  frag_23.w = diff_8.w;
  c_1 = frag_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_8.xyz) * _ExposureIBL.x) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_25;
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
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;

uniform highp mat4 unity_World2Shadow[4];
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
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec4 glow_5;
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
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_6);
  tmpvar_12.y = dot (tmpvar_3, N_6);
  tmpvar_12.z = dot (tmpvar_4, N_6);
  N_6 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_5.xyz * _GlowColor.xyz);
  glow_5.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_5.w * (_EmissionLM * _ExposureIBL.w));
  glow_5.w = tmpvar_17;
  lowp float shadow_18;
  lowp float tmpvar_19;
  tmpvar_19 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD5.xyz);
  highp float tmpvar_20;
  tmpvar_20 = (_LightShadowData.x + (tmpvar_19 * (1.0 - _LightShadowData.x)));
  shadow_18 = tmpvar_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz), vec3((shadow_18 * 2.0)));
  mediump vec3 tmpvar_22;
  tmpvar_22 = (diff_7.xyz * tmpvar_21);
  c_1.xyz = tmpvar_22;
  c_1.w = tmpvar_10;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_7.xyz) * _ExposureIBL.x) + (glow_5.xyz * glow_5.w)));
  c_1.xyz = tmpvar_23;
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
varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = (tmpvar_11 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform samplerCube _DiffCubeIBL;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_4 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_5;
  mediump vec4 glow_6;
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
  tmpvar_5 = N_7;
  highp vec3 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2, N_7);
  tmpvar_12.y = dot (tmpvar_3, N_7);
  tmpvar_12.z = dot (tmpvar_4, N_7);
  N_7 = tmpvar_12;
  mediump vec4 diff_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, tmpvar_12);
  diff_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_6 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow_6.xyz * _GlowColor.xyz);
  glow_6.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (glow_6.w * (_EmissionLM * _ExposureIBL.w));
  glow_6.w = tmpvar_17;
  lowp float shadow_18;
  lowp float tmpvar_19;
  tmpvar_19 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD7.xyz);
  highp float tmpvar_20;
  tmpvar_20 = (_LightShadowData.x + (tmpvar_19 * (1.0 - _LightShadowData.x)));
  shadow_18 = tmpvar_20;
  mediump vec3 lightDir_21;
  lightDir_21 = xlv_TEXCOORD4;
  mediump float atten_22;
  atten_22 = shadow_18;
  mediump vec4 frag_23;
  frag_23.xyz = ((_LightColor0.xyz * ((atten_22 * 2.0) * clamp (dot (tmpvar_5, lightDir_21), 0.0, 1.0))) * diff_8.xyz);
  frag_23.w = diff_8.w;
  c_1 = frag_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (c_1.xyz + (diff_8.xyz * xlv_TEXCOORD5));
  c_1.xyz = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (c_1.xyz + ((((diff_13.xyz * diff_13.w) * diff_8.xyz) * _ExposureIBL.x) + (glow_6.xyz * glow_6.w)));
  c_1.xyz = tmpvar_25;
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
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * _ExposureIBL.w);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  vec4 frag_5;
  frag_5.xyz = ((_LightColor0.xyz * ((texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * 2.0) * clamp (dot (normal_4, normalize(xlv_TEXCOORD1)), 0.0, 1.0))) * diff_2.xyz);
  frag_5.w = diff_2.w;
  c_1.xyz = frag_5.xyz;
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

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow_4;
  highp vec3 N_5;
  mediump vec4 diff_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_6 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (diff_6 * _Color);
  diff_6 = tmpvar_8;
  diff_6.xyz = (diff_6.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_5 = tmpvar_9;
  tmpvar_3 = N_5;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_4 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow_4.xyz * _GlowColor.xyz);
  glow_4.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow_4.w * (_EmissionLM * _ExposureIBL.w));
  glow_4.w = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, vec2(tmpvar_14));
  mediump vec3 lightDir_16;
  lightDir_16 = lightDir_2;
  mediump float atten_17;
  atten_17 = tmpvar_15.w;
  mediump vec4 frag_18;
  frag_18.xyz = ((_LightColor0.xyz * ((atten_17 * 2.0) * clamp (dot (tmpvar_3, lightDir_16), 0.0, 1.0))) * diff_6.xyz);
  frag_18.w = diff_6.w;
  c_1.xyz = frag_18.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 _MainTex_ST;
uniform vec4 unity_Scale;
uniform mat4 _World2Object;

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
  xlv_TEXCOORD1 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * _ExposureIBL.w);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  vec4 frag_5;
  frag_5.xyz = ((_LightColor0.xyz * (2.0 * clamp (dot (normal_4, xlv_TEXCOORD1), 0.0, 1.0))) * diff_2.xyz);
  frag_5.w = diff_2.w;
  c_1.xyz = frag_5.xyz;
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

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;

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
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow_4;
  highp vec3 N_5;
  mediump vec4 diff_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_6 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (diff_6 * _Color);
  diff_6 = tmpvar_8;
  diff_6.xyz = (diff_6.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_5 = tmpvar_9;
  tmpvar_3 = N_5;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_4 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow_4.xyz * _GlowColor.xyz);
  glow_4.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow_4.w * (_EmissionLM * _ExposureIBL.w));
  glow_4.w = tmpvar_12;
  lightDir_2 = xlv_TEXCOORD1;
  mediump vec3 lightDir_13;
  lightDir_13 = lightDir_2;
  mediump vec4 frag_14;
  frag_14.xyz = ((_LightColor0.xyz * (2.0 * clamp (dot (tmpvar_3, lightDir_13), 0.0, 1.0))) * diff_6.xyz);
  frag_14.w = diff_6.w;
  c_1.xyz = frag_14.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
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
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * _ExposureIBL.w);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  vec4 frag_5;
  frag_5.xyz = ((_LightColor0.xyz * ((((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz))).w) * 2.0) * clamp (dot (normal_4, normalize(xlv_TEXCOORD1)), 0.0, 1.0))) * diff_2.xyz);
  frag_5.w = diff_2.w;
  c_1.xyz = frag_5.xyz;
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

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow_4;
  highp vec3 N_5;
  mediump vec4 diff_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_6 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (diff_6 * _Color);
  diff_6 = tmpvar_8;
  diff_6.xyz = (diff_6.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_5 = tmpvar_9;
  tmpvar_3 = N_5;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_4 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow_4.xyz * _GlowColor.xyz);
  glow_4.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow_4.w * (_EmissionLM * _ExposureIBL.w));
  glow_4.w = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_13;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5);
  tmpvar_14 = texture2D (_LightTexture0, P_15);
  highp float tmpvar_16;
  tmpvar_16 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16));
  mediump vec3 lightDir_18;
  lightDir_18 = lightDir_2;
  mediump float atten_19;
  atten_19 = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_14.w) * tmpvar_17.w);
  mediump vec4 frag_20;
  frag_20.xyz = ((_LightColor0.xyz * ((atten_19 * 2.0) * clamp (dot (tmpvar_3, lightDir_18), 0.0, 1.0))) * diff_6.xyz);
  frag_20.w = diff_6.w;
  c_1.xyz = frag_20.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
"!!GLSL
#ifdef VERTEX
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
  xlv_TEXCOORD1 = (tmpvar_3 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * _ExposureIBL.w);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  vec4 frag_5;
  frag_5.xyz = ((_LightColor0.xyz * (((texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w) * 2.0) * clamp (dot (normal_4, normalize(xlv_TEXCOORD1)), 0.0, 1.0))) * diff_2.xyz);
  frag_5.w = diff_2.w;
  c_1.xyz = frag_5.xyz;
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

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow_4;
  highp vec3 N_5;
  mediump vec4 diff_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_6 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (diff_6 * _Color);
  diff_6 = tmpvar_8;
  diff_6.xyz = (diff_6.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_5 = tmpvar_9;
  tmpvar_3 = N_5;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_4 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow_4.xyz * _GlowColor.xyz);
  glow_4.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow_4.w * (_EmissionLM * _ExposureIBL.w));
  glow_4.w = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14));
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_17;
  lightDir_17 = lightDir_2;
  mediump float atten_18;
  atten_18 = (tmpvar_15.w * tmpvar_16.w);
  mediump vec4 frag_19;
  frag_19.xyz = ((_LightColor0.xyz * ((atten_18 * 2.0) * clamp (dot (tmpvar_3, lightDir_17), 0.0, 1.0))) * diff_6.xyz);
  frag_19.w = diff_6.w;
  c_1.xyz = frag_19.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD1 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_3 * (((_World2Object * tmpvar_4).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
uniform vec4 _Color;
uniform vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
void main ()
{
  vec4 c_1;
  vec4 diff_2;
  vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff_2.w = tmpvar_3.w;
  diff_2.xyz = (tmpvar_3.xyz * _ExposureIBL.w);
  vec3 normal_4;
  normal_4.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal_4.z = sqrt(((1.0 - (normal_4.x * normal_4.x)) - (normal_4.y * normal_4.y)));
  vec4 frag_5;
  frag_5.xyz = ((_LightColor0.xyz * ((texture2D (_LightTexture0, xlv_TEXCOORD3).w * 2.0) * clamp (dot (normal_4, xlv_TEXCOORD1), 0.0, 1.0))) * diff_2.xyz);
  frag_5.w = diff_2.w;
  c_1.xyz = frag_5.xyz;
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

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _EmissionLM;
uniform highp vec4 _GlowColor;
uniform sampler2D _Illum;
uniform sampler2D _BumpMap;
uniform highp vec4 _Color;
uniform mediump vec4 _ExposureIBL;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow_4;
  highp vec3 N_5;
  mediump vec4 diff_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff_6 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (diff_6 * _Color);
  diff_6 = tmpvar_8;
  diff_6.xyz = (diff_6.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N_5 = tmpvar_9;
  tmpvar_3 = N_5;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow_4 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow_4.xyz * _GlowColor.xyz);
  glow_4.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow_4.w * (_EmissionLM * _ExposureIBL.w));
  glow_4.w = tmpvar_12;
  lightDir_2 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_14;
  lightDir_14 = lightDir_2;
  mediump float atten_15;
  atten_15 = tmpvar_13.w;
  mediump vec4 frag_16;
  frag_16.xyz = ((_LightColor0.xyz * ((atten_15 * 2.0) * clamp (dot (tmpvar_3, lightDir_14), 0.0, 1.0))) * diff_6.xyz);
  frag_16.w = diff_6.w;
  c_1.xyz = frag_16.xyz;
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

#LINE 58

	}
	
	FallBack "Diffuse"
}
