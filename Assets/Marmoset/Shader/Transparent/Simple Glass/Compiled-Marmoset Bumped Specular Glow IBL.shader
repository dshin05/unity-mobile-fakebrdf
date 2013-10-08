// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Transparent/Simple Glass/Bumped Specular Glow IBL" {
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
		_GlowStrength("Glow Strength", Float) = 1.0
		_EmissionLM ("Diffuse Emission Strength", Float) = 0.0
		_Illum ("Glow(RGB) Diffuse Emission(A)", 2D) = "white" {}
		//slots for custom lighting cubemaps
		_DiffCubeIBL ("Custom Diffuse Cube", Cube) = "black" {}
		_SpecCubeIBL ("Custom Specular Cube", Cube) = "black" {}
	}
	
	SubShader {
		Blend One OneMinusSrcAlpha
		Fog { Mode Off }
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
			"IgnoreProjector"="True"
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
// Vertex combos: 12
//   d3d9 - ALU: 35 to 97
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  mat3 tmpvar_4;
  tmpvar_4[0] = TANGENT.xyz;
  tmpvar_4[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_4[2] = gl_Normal;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_6;
  tmpvar_6.xyz = (tmpvar_5 * v_i0_i1.xyz);
  tmpvar_6.w = tmpvar_3.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_5 * v_i0_i1_i2.xyz);
  tmpvar_7.w = tmpvar_3.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_5 * v_i0_i1_i2_i3.xyz);
  tmpvar_8.w = tmpvar_3.z;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_12);
  x1.y = dot (unity_SHAg, tmpvar_12);
  x1.z = dot (unity_SHAb, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_10.xyzz * tmpvar_10.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_13);
  x2.y = dot (unity_SHBg, tmpvar_13);
  x2.z = dot (unity_SHBb, tmpvar_13);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_6 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_10.x * tmpvar_10.x) - (tmpvar_10.y * tmpvar_10.y))));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec3 tmpvar_5;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_6;
  tmpvar_6 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_6;
  diff.xyz = (tmpvar_6.xyz * _ExposureIBL.w);
  tmpvar_5 = (diff.xyz * tmpvar_6.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_12;
  float tmpvar_13;
  tmpvar_13 = (1.0 - tmpvar_8.w);
  float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (_Shininess * tmpvar_14));
  float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  vec3 tmpvar_16;
  tmpvar_16.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_16.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_16.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_17;
  tmpvar_17 = reflect (tmpvar_1, tmpvar_16);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18.xyz = ((v_i0.xyz * tmpvar_17.x) + ((v_i0_i1.xyz * tmpvar_17.y) + (v_i0_i1_i2.xyz * tmpvar_17.z)));
  tmpvar_18.w = tmpvar_12;
  vec4 tmpvar_19;
  tmpvar_19 = textureCubeLod (_SpecCubeIBL, tmpvar_18.xyz, tmpvar_18.w);
  float tmpvar_20;
  tmpvar_20 = (tmpvar_19.w * tmpvar_19.w);
  vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20;
  tmpvar_21.y = (tmpvar_19.w * tmpvar_20);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_22;
  tmpvar_22 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  float tmpvar_23;
  tmpvar_23 = (tmpvar_22.w * tmpvar_22.w);
  vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23;
  tmpvar_24.y = (tmpvar_22.w * tmpvar_23);
  vec4 tmpvar_25;
  tmpvar_25 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_25;
  glow.xyz = (tmpvar_25.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_25.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_26;
  tmpvar_26 = normalize (xlv_TEXCOORD5);
  float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_7, tmpvar_26), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_27) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (tmpvar_7, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_26))), 0.0, 1.0), tmpvar_15)) * clamp ((10.0 * tmpvar_27), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_15 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_5 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (((((tmpvar_19.xyz * dot (vec2(0.7532, 0.2468), tmpvar_21)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_22.xyz * dot (vec2(0.7532, 0.2468), tmpvar_24)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [_MainTex_ST]
"vs_3_0
; 61 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c12.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c23.x
dp4 r2.z, r0, c17
dp4 r2.y, r0, c16
dp4 r2.x, r0, c15
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c20
dp4 r3.y, r1, c19
dp4 r3.x, r1, c18
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c21
add o7.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1.w, c23.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c12.w
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c22, c22.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_23;
  mediump vec4 normal;
  normal = tmpvar_22;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal);
  x1.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal);
  x1.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal);
  x1.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC);
  x3 = tmpvar_32;
  tmpvar_23 = ((x1 + x2) + x3);
  shlight = tmpvar_23;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_14;
  tmpvar_9 = N;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_16 * (tmpvar_16 * tmpvar_16)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - spec.w);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - (tmpvar_18 * tmpvar_18));
  tmpvar_17 = ((7.0 + tmpvar_19) - (shininess * tmpvar_19));
  mediump float tmpvar_20;
  tmpvar_20 = pow (2.0, (8.0 - tmpvar_17));
  highp float gloss;
  gloss = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_17;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = reflect (tmpvar_1, tmpvar_22);
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25.x = dot (tmpvar_2, N);
  tmpvar_25.y = dot (tmpvar_3, N);
  tmpvar_25.z = dot (tmpvar_4, N);
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_31;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_9, lightDir), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_32) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_9, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = vec3(pow (specRefl, tmpvar_20));
  spec_i0_i1 = tmpvar_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_32), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_35;
  frag.xyz = (frag.xyz + (tmpvar_35 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_37;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_23;
  mediump vec4 normal;
  normal = tmpvar_22;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal);
  x1.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal);
  x1.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal);
  x1.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC);
  x3 = tmpvar_32;
  tmpvar_23 = ((x1 + x2) + x3);
  shlight = tmpvar_23;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec3 tmpvar_11;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (diff * _Color);
  diff = tmpvar_13;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_9 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_10 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_19));
  highp float gloss;
  gloss = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_11 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24.x = dot (tmpvar_2, tmpvar_10);
  tmpvar_24.y = dot (tmpvar_3, tmpvar_10);
  tmpvar_24.z = dot (tmpvar_4, tmpvar_10);
  highp vec3 tmpvar_25;
  tmpvar_25 = reflect (tmpvar_1, tmpvar_24);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((v_i0.xyz * tmpvar_25.x) + ((v_i0_i1.xyz * tmpvar_25.y) + (v_i0_i1_i2.xyz * tmpvar_25.z)));
  tmpvar_26.w = glossLod_i0_i1;
  lookup = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_28;
  tmpvar_29.y = (spec_i0.w * tmpvar_28);
  highp vec3 tmpvar_30;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_30 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_30;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_31;
  tmpvar_31 = textureCube (_DiffCubeIBL, tmpvar_30);
  diff_i0 = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_33;
  tmpvar_33.x = tmpvar_32;
  tmpvar_33.y = (diff_i0.w * tmpvar_32);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (glow.w * _EmissionLM);
  glow.w = tmpvar_37;
  glow.xyz = (glow.xyz + (tmpvar_9 * glow.w));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_38;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize (lightDir);
  mediump float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_10, tmpvar_39), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_40) * tmpvar_9) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_10, normalize ((viewDir + tmpvar_39))), 0.0, 1.0);
  specRefl = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = vec3(pow (specRefl, tmpvar_22));
  spec_i0_i1 = tmpvar_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_40), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_43;
  frag.xyz = (frag.xyz + (tmpvar_43 * tmpvar_11));
  c = frag;
  mediump vec3 tmpvar_44;
  tmpvar_44 = (c.xyz + (tmpvar_9 * xlv_TEXCOORD6));
  c.xyz = tmpvar_44;
  mediump vec3 tmpvar_45;
  tmpvar_45 = (c.xyz + (((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_29)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_33)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_45;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  mat3 tmpvar_4;
  tmpvar_4[0] = TANGENT.xyz;
  tmpvar_4[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_4[2] = gl_Normal;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_6;
  tmpvar_6.xyz = (tmpvar_5 * v_i0_i1.xyz);
  tmpvar_6.w = tmpvar_3.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_5 * v_i0_i1_i2.xyz);
  tmpvar_7.w = tmpvar_3.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_5 * v_i0_i1_i2_i3.xyz);
  tmpvar_8.w = tmpvar_3.z;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_6 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec3 tmpvar_5;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_6;
  tmpvar_6 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_6;
  diff.xyz = (tmpvar_6.xyz * _ExposureIBL.w);
  tmpvar_5 = (diff.xyz * tmpvar_6.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_12;
  tmpvar_12 = (1.0 - tmpvar_8.w);
  float tmpvar_13;
  tmpvar_13 = (1.0 - (tmpvar_12 * tmpvar_12));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_14.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_14.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_16;
  tmpvar_16.xyz = ((v_i0.xyz * tmpvar_15.x) + ((v_i0_i1.xyz * tmpvar_15.y) + (v_i0_i1_i2.xyz * tmpvar_15.z)));
  tmpvar_16.w = ((7.0 + tmpvar_13) - (_Shininess * tmpvar_13));
  vec4 tmpvar_17;
  tmpvar_17 = textureCubeLod (_SpecCubeIBL, tmpvar_16.xyz, tmpvar_16.w);
  float tmpvar_18;
  tmpvar_18 = (tmpvar_17.w * tmpvar_17.w);
  vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_18;
  tmpvar_19.y = (tmpvar_17.w * tmpvar_18);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  float tmpvar_21;
  tmpvar_21 = (tmpvar_20.w * tmpvar_20.w);
  vec2 tmpvar_22;
  tmpvar_22.x = tmpvar_21;
  tmpvar_22.y = (tmpvar_20.w * tmpvar_21);
  vec4 tmpvar_23;
  tmpvar_23 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_23;
  glow.xyz = (tmpvar_23.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_23.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_24;
  tmpvar_24 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  c.xyz = (tmpvar_5 * ((8.0 * tmpvar_24.w) * tmpvar_24.xyz));
  c.w = diff.w;
  c.xyz = (c.xyz + (((((tmpvar_17.xyz * dot (vec2(0.7532, 0.2468), tmpvar_19)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_20.xyz * dot (vec2(0.7532, 0.2468), tmpvar_22)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c13
mov r0.w, c16.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c12.w, -v0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r1, r2
mul o5, r0, c12.w
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
mad o1.xy, v3, c15, c15.zwzw
mad o6.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)));
  highp mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_10 * v_i0_i1.xyz);
  tmpvar_11.w = tmpvar_8.x;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_10 * v_i0_i1_i2.xyz);
  tmpvar_13.w = tmpvar_8.y;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_10 * v_i0_i1_i2_i3.xyz);
  tmpvar_15.w = tmpvar_8.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff * _Color);
  diff = tmpvar_11;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_12;
  tmpvar_12 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_13;
  tmpvar_9 = N;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_14;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_15 * (tmpvar_15 * tmpvar_15)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_16;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_17;
  tmpvar_17 = (1.0 - spec.w);
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - (tmpvar_17 * tmpvar_17));
  tmpvar_16 = ((7.0 + tmpvar_18) - (shininess * tmpvar_18));
  mediump vec3 tmpvar_19;
  tmpvar_19.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_19.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_19.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_16;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = reflect (tmpvar_1, tmpvar_19);
  tmpvar_20.w = glossLod_i0_i1;
  lookup = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N);
  tmpvar_22.y = dot (tmpvar_3, N);
  tmpvar_22.z = dot (tmpvar_4, N);
  N = tmpvar_22;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_i0 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (glow.w * _EmissionLM);
  glow.w = tmpvar_27;
  glow.xyz = (glow.xyz + (tmpvar_12 * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_28;
  tmpvar_28 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz);
  mediump vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_12 * tmpvar_28);
  c.xyz = tmpvar_29;
  c.w = diff.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_30;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)));
  highp mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_10 * v_i0_i1.xyz);
  tmpvar_11.w = tmpvar_8.x;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_10 * v_i0_i1_i2.xyz);
  tmpvar_13.w = tmpvar_8.y;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_10 * v_i0_i1_i2_i3.xyz);
  tmpvar_15.w = tmpvar_8.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump float tmpvar_10;
  mediump vec3 tmpvar_11;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (diff * _Color);
  diff = tmpvar_13;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_10 = diff.w;
  tmpvar_9 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_11 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_11);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_11);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_11);
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (tmpvar_1, tmpvar_22);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_24;
  tmpvar_24.xyz = ((v_i0.xyz * tmpvar_23.x) + ((v_i0_i1.xyz * tmpvar_23.y) + (v_i0_i1_i2.xyz * tmpvar_23.z)));
  tmpvar_24.w = glossLod_i0_i1;
  lookup = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26;
  tmpvar_27.y = (spec_i0.w * tmpvar_26);
  highp vec3 tmpvar_28;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_28 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_28;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_28);
  diff_i0 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_31;
  tmpvar_31.x = tmpvar_30;
  tmpvar_31.y = (diff_i0.w * tmpvar_30);
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (glow.w * _EmissionLM);
  glow.w = tmpvar_35;
  glow.xyz = (glow.xyz + (tmpvar_9 * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  lowp vec3 tmpvar_37;
  tmpvar_37 = ((8.0 * tmpvar_36.w) * tmpvar_36.xyz);
  mediump vec3 tmpvar_38;
  tmpvar_38 = (tmpvar_9 * tmpvar_37);
  c.xyz = tmpvar_38;
  c.w = tmpvar_10;
  mediump vec3 tmpvar_39;
  tmpvar_39 = (c.xyz + (((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_27)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_31)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_39;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  mat3 tmpvar_5;
  tmpvar_5[0] = TANGENT.xyz;
  tmpvar_5[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_5[2] = gl_Normal;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_6 * v_i0_i1.xyz);
  tmpvar_7.w = tmpvar_4.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_i0_i1_i2.xyz);
  tmpvar_8.w = tmpvar_4.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_6 * v_i0_i1_i2_i3.xyz);
  tmpvar_9.w = tmpvar_4.z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_11;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_13);
  x1.y = dot (unity_SHAg, tmpvar_13);
  x1.z = dot (unity_SHAb, tmpvar_13);
  vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_11.xyzz * tmpvar_11.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_14);
  x2.y = dot (unity_SHBg, tmpvar_14);
  x2.z = dot (unity_SHBb, tmpvar_14);
  vec4 o_i0;
  vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_15;
  vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_11.x * tmpvar_11.x) - (tmpvar_11.y * tmpvar_11.y))));
  xlv_TEXCOORD7 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec3 tmpvar_5;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_6;
  tmpvar_6 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_6;
  diff.xyz = (tmpvar_6.xyz * _ExposureIBL.w);
  tmpvar_5 = (diff.xyz * tmpvar_6.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_12;
  float tmpvar_13;
  tmpvar_13 = (1.0 - tmpvar_8.w);
  float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (_Shininess * tmpvar_14));
  float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  vec3 tmpvar_16;
  tmpvar_16.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_16.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_16.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_17;
  tmpvar_17 = reflect (tmpvar_1, tmpvar_16);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18.xyz = ((v_i0.xyz * tmpvar_17.x) + ((v_i0_i1.xyz * tmpvar_17.y) + (v_i0_i1_i2.xyz * tmpvar_17.z)));
  tmpvar_18.w = tmpvar_12;
  vec4 tmpvar_19;
  tmpvar_19 = textureCubeLod (_SpecCubeIBL, tmpvar_18.xyz, tmpvar_18.w);
  float tmpvar_20;
  tmpvar_20 = (tmpvar_19.w * tmpvar_19.w);
  vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20;
  tmpvar_21.y = (tmpvar_19.w * tmpvar_20);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_22;
  tmpvar_22 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  float tmpvar_23;
  tmpvar_23 = (tmpvar_22.w * tmpvar_22.w);
  vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23;
  tmpvar_24.y = (tmpvar_22.w * tmpvar_23);
  vec4 tmpvar_25;
  tmpvar_25 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_25;
  glow.xyz = (tmpvar_25.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_25.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_27;
  tmpvar_27 = normalize (xlv_TEXCOORD5);
  float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_7, tmpvar_27), 0.0, 1.0);
  frag.xyz = ((((tmpvar_26.x * 2.0) * tmpvar_28) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_7, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_27))), 0.0, 1.0), tmpvar_15)) * clamp ((10.0 * tmpvar_28), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_26.x) * 0.5) * (spec.xyz * ((tmpvar_15 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_5 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (((((tmpvar_19.xyz * dot (vec2(0.7532, 0.2468), tmpvar_21)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_22.xyz * dot (vec2(0.7532, 0.2468), tmpvar_24)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
"vs_3_0
; 66 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c25, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c14.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c25.x
dp4 r2.z, r0, c19
dp4 r2.y, r0, c18
dp4 r2.x, r0, c17
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c22
dp4 r3.y, r1, c21
dp4 r3.x, r1, c20
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c23
add o7.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1.w, c25.x
mov r1.xyz, c15
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c16, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c14.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c14.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c14.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c12.x
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov o8.zw, r0
mad o1.xy, v3, c24, c24.zwzw
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_glesVertex.xyz - ((_World2Object * tmpvar_9).xyz * unity_Scale.w)));
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_13 * v_i0_i1.xyz);
  tmpvar_14.w = tmpvar_11.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_3 = tmpvar_15;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_13 * v_i0_i1_i2.xyz);
  tmpvar_16.w = tmpvar_11.y;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_4 = tmpvar_17;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_18;
  tmpvar_18.xyz = (tmpvar_13 * v_i0_i1_i2_i3.xyz);
  tmpvar_18.w = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * unity_Scale.w);
  tmpvar_5 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (tmpvar_20 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_34;
  tmpvar_34 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_34;
  highp vec2 tmpvar_35;
  tmpvar_35.x = tmpvar_34.x;
  tmpvar_35.y = (tmpvar_34.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_35 + tmpvar_34.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_13 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_14;
  tmpvar_9 = N;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_16 * (tmpvar_16 * tmpvar_16)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - spec.w);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - (tmpvar_18 * tmpvar_18));
  tmpvar_17 = ((7.0 + tmpvar_19) - (shininess * tmpvar_19));
  mediump float tmpvar_20;
  tmpvar_20 = pow (2.0, (8.0 - tmpvar_17));
  highp float gloss;
  gloss = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_17;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = reflect (tmpvar_1, tmpvar_22);
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25.x = dot (tmpvar_2, N);
  tmpvar_25.y = dot (tmpvar_3, N);
  tmpvar_25.z = dot (tmpvar_4, N);
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  lowp float tmpvar_31;
  tmpvar_31 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_32;
  mediump float atten_i0;
  atten_i0 = tmpvar_31;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_9, lightDir), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_33) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_9, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = vec3(pow (specRefl, tmpvar_20));
  spec_i0_i1 = tmpvar_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_33), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_36;
  frag.xyz = (frag.xyz + (tmpvar_36 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_38;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_glesVertex.xyz - ((_World2Object * tmpvar_9).xyz * unity_Scale.w)));
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_13 * v_i0_i1.xyz);
  tmpvar_14.w = tmpvar_11.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_3 = tmpvar_15;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_13 * v_i0_i1_i2.xyz);
  tmpvar_16.w = tmpvar_11.y;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_4 = tmpvar_17;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_18;
  tmpvar_18.xyz = (tmpvar_13 * v_i0_i1_i2_i3.xyz);
  tmpvar_18.w = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * unity_Scale.w);
  tmpvar_5 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (tmpvar_20 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_34;
  tmpvar_34 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_34;
  highp vec2 tmpvar_35;
  tmpvar_35.x = tmpvar_34.x;
  tmpvar_35.y = (tmpvar_34.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_35 + tmpvar_34.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_13 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec3 tmpvar_11;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (diff * _Color);
  diff = tmpvar_13;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_9 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_10 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_19));
  highp float gloss;
  gloss = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_11 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24.x = dot (tmpvar_2, tmpvar_10);
  tmpvar_24.y = dot (tmpvar_3, tmpvar_10);
  tmpvar_24.z = dot (tmpvar_4, tmpvar_10);
  highp vec3 tmpvar_25;
  tmpvar_25 = reflect (tmpvar_1, tmpvar_24);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((v_i0.xyz * tmpvar_25.x) + ((v_i0_i1.xyz * tmpvar_25.y) + (v_i0_i1_i2.xyz * tmpvar_25.z)));
  tmpvar_26.w = glossLod_i0_i1;
  lookup = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_28;
  tmpvar_29.y = (spec_i0.w * tmpvar_28);
  highp vec3 tmpvar_30;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_30 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_30;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_31;
  tmpvar_31 = textureCube (_DiffCubeIBL, tmpvar_30);
  diff_i0 = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_33;
  tmpvar_33.x = tmpvar_32;
  tmpvar_33.y = (diff_i0.w * tmpvar_32);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (glow.w * _EmissionLM);
  glow.w = tmpvar_37;
  glow.xyz = (glow.xyz + (tmpvar_9 * glow.w));
  lowp float tmpvar_38;
  tmpvar_38 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_39;
  mediump float atten_i0;
  atten_i0 = tmpvar_38;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize (lightDir);
  mediump float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_10, tmpvar_40), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_41) * tmpvar_9) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_10, normalize ((viewDir + tmpvar_40))), 0.0, 1.0);
  specRefl = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = vec3(pow (specRefl, tmpvar_22));
  spec_i0_i1 = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_41), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_44;
  frag.xyz = (frag.xyz + (tmpvar_44 * tmpvar_11));
  c = frag;
  mediump vec3 tmpvar_45;
  tmpvar_45 = (c.xyz + (tmpvar_9 * xlv_TEXCOORD6));
  c.xyz = tmpvar_45;
  mediump vec3 tmpvar_46;
  tmpvar_46 = (c.xyz + (((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_29)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_33)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_46;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  mat3 tmpvar_5;
  tmpvar_5[0] = TANGENT.xyz;
  tmpvar_5[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_5[2] = gl_Normal;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_6 * v_i0_i1.xyz);
  tmpvar_7.w = tmpvar_4.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_i0_i1_i2.xyz);
  tmpvar_8.w = tmpvar_4.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_6 * v_i0_i1_i2_i3.xyz);
  tmpvar_9.w = tmpvar_4.z;
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  vec4 o_i0;
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_11;
  vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_12 + tmpvar_11.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_10).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec3 tmpvar_5;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_6;
  tmpvar_6 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_6;
  diff.xyz = (tmpvar_6.xyz * _ExposureIBL.w);
  tmpvar_5 = (diff.xyz * tmpvar_6.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_12;
  tmpvar_12 = (1.0 - tmpvar_8.w);
  float tmpvar_13;
  tmpvar_13 = (1.0 - (tmpvar_12 * tmpvar_12));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_14.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_14.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_16;
  tmpvar_16.xyz = ((v_i0.xyz * tmpvar_15.x) + ((v_i0_i1.xyz * tmpvar_15.y) + (v_i0_i1_i2.xyz * tmpvar_15.z)));
  tmpvar_16.w = ((7.0 + tmpvar_13) - (_Shininess * tmpvar_13));
  vec4 tmpvar_17;
  tmpvar_17 = textureCubeLod (_SpecCubeIBL, tmpvar_16.xyz, tmpvar_16.w);
  float tmpvar_18;
  tmpvar_18 = (tmpvar_17.w * tmpvar_17.w);
  vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_18;
  tmpvar_19.y = (tmpvar_17.w * tmpvar_18);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  float tmpvar_21;
  tmpvar_21 = (tmpvar_20.w * tmpvar_20.w);
  vec2 tmpvar_22;
  tmpvar_22.x = tmpvar_21;
  tmpvar_22.y = (tmpvar_20.w * tmpvar_21);
  vec4 tmpvar_23;
  tmpvar_23 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_23;
  glow.xyz = (tmpvar_23.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_23.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_25;
  tmpvar_25 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  vec3 tmpvar_26;
  tmpvar_26 = ((8.0 * tmpvar_25.w) * tmpvar_25.xyz);
  c.xyz = (tmpvar_5 * max (min (tmpvar_26, ((tmpvar_24.x * 2.0) * tmpvar_25.xyz)), (tmpvar_26 * tmpvar_24.x)));
  c.w = diff.w;
  c.xyz = (c.xyz + (((((tmpvar_17.xyz * dot (vec2(0.7532, 0.2468), tmpvar_19)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_20.xyz * dot (vec2(0.7532, 0.2468), tmpvar_22)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"vs_3_0
; 41 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c18, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c15
mov r0.w, c18.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c14.w, -v0
dp3 r0.w, -r1, c4
dp3 o2.y, r1, r2
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c14.w
dp3 r0.w, -r1, c5
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c14.w
dp3 r0.w, -r1, c6
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c14.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp3 o2.z, v2, r1
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c18.y
dp3 o2.x, r1, v1
mov r1.x, r2
mul r1.y, r2, c12.x
mad o7.xy, r2.z, c13.zwzw, r1
mov o0, r0
mov o7.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o6.xy, v4, c16, c16.zwzw
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_19;
  highp vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_20 + tmpvar_19.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff * _Color);
  diff = tmpvar_11;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_12;
  tmpvar_12 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_13;
  tmpvar_9 = N;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_14;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_15 * (tmpvar_15 * tmpvar_15)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_16;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_17;
  tmpvar_17 = (1.0 - spec.w);
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - (tmpvar_17 * tmpvar_17));
  tmpvar_16 = ((7.0 + tmpvar_18) - (shininess * tmpvar_18));
  mediump vec3 tmpvar_19;
  tmpvar_19.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_19.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_19.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_16;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = reflect (tmpvar_1, tmpvar_19);
  tmpvar_20.w = glossLod_i0_i1;
  lookup = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N);
  tmpvar_22.y = dot (tmpvar_3, N);
  tmpvar_22.z = dot (tmpvar_4, N);
  N = tmpvar_22;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_i0 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (glow.w * _EmissionLM);
  glow.w = tmpvar_27;
  glow.xyz = (glow.xyz + (tmpvar_12 * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_28;
  tmpvar_28 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x * 2.0)));
  mediump vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_12 * tmpvar_28);
  c.xyz = tmpvar_29;
  c.w = diff.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_30;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_19;
  highp vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_20 + tmpvar_19.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump float tmpvar_10;
  mediump vec3 tmpvar_11;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (diff * _Color);
  diff = tmpvar_13;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_10 = diff.w;
  tmpvar_9 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_11 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_11);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_11);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_11);
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (tmpvar_1, tmpvar_22);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_24;
  tmpvar_24.xyz = ((v_i0.xyz * tmpvar_23.x) + ((v_i0_i1.xyz * tmpvar_23.y) + (v_i0_i1_i2.xyz * tmpvar_23.z)));
  tmpvar_24.w = glossLod_i0_i1;
  lookup = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26;
  tmpvar_27.y = (spec_i0.w * tmpvar_26);
  highp vec3 tmpvar_28;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_28 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_28;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_28);
  diff_i0 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_31;
  tmpvar_31.x = tmpvar_30;
  tmpvar_31.y = (diff_i0.w * tmpvar_30);
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (glow.w * _EmissionLM);
  glow.w = tmpvar_35;
  glow.xyz = (glow.xyz + (tmpvar_9 * glow.w));
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  lowp vec3 tmpvar_38;
  tmpvar_38 = ((8.0 * tmpvar_37.w) * tmpvar_37.xyz);
  lowp vec3 tmpvar_39;
  tmpvar_39 = max (min (tmpvar_38, ((tmpvar_36.x * 2.0) * tmpvar_37.xyz)), (tmpvar_38 * tmpvar_36.x));
  mediump vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_9 * tmpvar_39);
  c.xyz = tmpvar_40;
  c.w = tmpvar_10;
  mediump vec3 tmpvar_41;
  tmpvar_41 = (c.xyz + (((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_27)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_31)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_41;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_LightColor[4];
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightAtten0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  mat3 tmpvar_4;
  tmpvar_4[0] = TANGENT.xyz;
  tmpvar_4[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_4[2] = gl_Normal;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_6;
  tmpvar_6.xyz = (tmpvar_5 * v_i0_i1.xyz);
  tmpvar_6.w = tmpvar_3.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_5 * v_i0_i1_i2.xyz);
  tmpvar_7.w = tmpvar_3.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_5 * v_i0_i1_i2_i3.xyz);
  tmpvar_8.w = tmpvar_3.z;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_12);
  x1.y = dot (unity_SHAg, tmpvar_12);
  x1.z = dot (unity_SHAb, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_10.xyzz * tmpvar_10.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_13);
  x2.y = dot (unity_SHBg, tmpvar_13);
  x2.z = dot (unity_SHBb, tmpvar_13);
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
  tmpvar_19 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_15 * tmpvar_10.x) + (tmpvar_16 * tmpvar_10.y)) + (tmpvar_17 * tmpvar_10.z)) * inversesqrt (tmpvar_18))) * (1.0/((1.0 + (tmpvar_18 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_6 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_10.x * tmpvar_10.x) - (tmpvar_10.y * tmpvar_10.y)))) + ((((unity_LightColor[0].xyz * tmpvar_19.x) + (unity_LightColor[1].xyz * tmpvar_19.y)) + (unity_LightColor[2].xyz * tmpvar_19.z)) + (unity_LightColor[3].xyz * tmpvar_19.w)));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec3 tmpvar_5;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_6;
  tmpvar_6 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_6;
  diff.xyz = (tmpvar_6.xyz * _ExposureIBL.w);
  tmpvar_5 = (diff.xyz * tmpvar_6.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_12;
  float tmpvar_13;
  tmpvar_13 = (1.0 - tmpvar_8.w);
  float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (_Shininess * tmpvar_14));
  float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  vec3 tmpvar_16;
  tmpvar_16.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_16.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_16.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_17;
  tmpvar_17 = reflect (tmpvar_1, tmpvar_16);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18.xyz = ((v_i0.xyz * tmpvar_17.x) + ((v_i0_i1.xyz * tmpvar_17.y) + (v_i0_i1_i2.xyz * tmpvar_17.z)));
  tmpvar_18.w = tmpvar_12;
  vec4 tmpvar_19;
  tmpvar_19 = textureCubeLod (_SpecCubeIBL, tmpvar_18.xyz, tmpvar_18.w);
  float tmpvar_20;
  tmpvar_20 = (tmpvar_19.w * tmpvar_19.w);
  vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20;
  tmpvar_21.y = (tmpvar_19.w * tmpvar_20);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_22;
  tmpvar_22 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  float tmpvar_23;
  tmpvar_23 = (tmpvar_22.w * tmpvar_22.w);
  vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23;
  tmpvar_24.y = (tmpvar_22.w * tmpvar_23);
  vec4 tmpvar_25;
  tmpvar_25 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_25;
  glow.xyz = (tmpvar_25.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_25.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_26;
  tmpvar_26 = normalize (xlv_TEXCOORD5);
  float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_7, tmpvar_26), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_27) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (tmpvar_7, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_26))), 0.0, 1.0), tmpvar_15)) * clamp ((10.0 * tmpvar_27), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_15 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_5 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (((((tmpvar_19.xyz * dot (vec2(0.7532, 0.2468), tmpvar_21)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_22.xyz * dot (vec2(0.7532, 0.2468), tmpvar_24)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Vector 30 [_MainTex_ST]
"vs_3_0
; 92 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c31, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c12.w
dp4 r0.x, v0, c5
add r1, -r0.x, c16
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c15
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c31.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c17
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c18
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
dp4 r2.z, r4, c25
dp4 r2.y, r4, c24
dp4 r2.x, r4, c23
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c20
mad r1.xyz, r0.x, c19, r1
mad r0.xyz, r0.z, c21, r1
mad r1.xyz, r0.w, c22, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c28
dp4 r3.y, r0, c27
dp4 r3.x, r0, c26
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c29
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add o7.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1.w, c31.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c12.w
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c30, c30.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_20;
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_20.x) + (tmpvar_36 * tmpvar_20.y)) + (tmpvar_37 * tmpvar_20.z)) * inversesqrt (tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_7 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_14;
  tmpvar_9 = N;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_16 * (tmpvar_16 * tmpvar_16)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - spec.w);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - (tmpvar_18 * tmpvar_18));
  tmpvar_17 = ((7.0 + tmpvar_19) - (shininess * tmpvar_19));
  mediump float tmpvar_20;
  tmpvar_20 = pow (2.0, (8.0 - tmpvar_17));
  highp float gloss;
  gloss = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_17;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = reflect (tmpvar_1, tmpvar_22);
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25.x = dot (tmpvar_2, N);
  tmpvar_25.y = dot (tmpvar_3, N);
  tmpvar_25.z = dot (tmpvar_4, N);
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_31;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_9, lightDir), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_32) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_9, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = vec3(pow (specRefl, tmpvar_20));
  spec_i0_i1 = tmpvar_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_32), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_35;
  frag.xyz = (frag.xyz + (tmpvar_35 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_37;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_20;
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_20.x) + (tmpvar_36 * tmpvar_20.y)) + (tmpvar_37 * tmpvar_20.z)) * inversesqrt (tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_7 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec3 tmpvar_11;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (diff * _Color);
  diff = tmpvar_13;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_9 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_10 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_19));
  highp float gloss;
  gloss = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_11 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24.x = dot (tmpvar_2, tmpvar_10);
  tmpvar_24.y = dot (tmpvar_3, tmpvar_10);
  tmpvar_24.z = dot (tmpvar_4, tmpvar_10);
  highp vec3 tmpvar_25;
  tmpvar_25 = reflect (tmpvar_1, tmpvar_24);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((v_i0.xyz * tmpvar_25.x) + ((v_i0_i1.xyz * tmpvar_25.y) + (v_i0_i1_i2.xyz * tmpvar_25.z)));
  tmpvar_26.w = glossLod_i0_i1;
  lookup = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_28;
  tmpvar_29.y = (spec_i0.w * tmpvar_28);
  highp vec3 tmpvar_30;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_30 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_30;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_31;
  tmpvar_31 = textureCube (_DiffCubeIBL, tmpvar_30);
  diff_i0 = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_33;
  tmpvar_33.x = tmpvar_32;
  tmpvar_33.y = (diff_i0.w * tmpvar_32);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (glow.w * _EmissionLM);
  glow.w = tmpvar_37;
  glow.xyz = (glow.xyz + (tmpvar_9 * glow.w));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_38;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize (lightDir);
  mediump float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_10, tmpvar_39), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_40) * tmpvar_9) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_10, normalize ((viewDir + tmpvar_39))), 0.0, 1.0);
  specRefl = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = vec3(pow (specRefl, tmpvar_22));
  spec_i0_i1 = tmpvar_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_40), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_43;
  frag.xyz = (frag.xyz + (tmpvar_43 * tmpvar_11));
  c = frag;
  mediump vec3 tmpvar_44;
  tmpvar_44 = (c.xyz + (tmpvar_9 * xlv_TEXCOORD6));
  c.xyz = tmpvar_44;
  mediump vec3 tmpvar_45;
  tmpvar_45 = (c.xyz + (((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_29)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_33)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_45;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_LightColor[4];
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightAtten0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  mat3 tmpvar_5;
  tmpvar_5[0] = TANGENT.xyz;
  tmpvar_5[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_5[2] = gl_Normal;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_6 * v_i0_i1.xyz);
  tmpvar_7.w = tmpvar_4.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_i0_i1_i2.xyz);
  tmpvar_8.w = tmpvar_4.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_6 * v_i0_i1_i2_i3.xyz);
  tmpvar_9.w = tmpvar_4.z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_11;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_13);
  x1.y = dot (unity_SHAg, tmpvar_13);
  x1.z = dot (unity_SHAb, tmpvar_13);
  vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_11.xyzz * tmpvar_11.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_14);
  x2.y = dot (unity_SHBg, tmpvar_14);
  x2.z = dot (unity_SHBb, tmpvar_14);
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
  tmpvar_20 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_16 * tmpvar_11.x) + (tmpvar_17 * tmpvar_11.y)) + (tmpvar_18 * tmpvar_11.z)) * inversesqrt (tmpvar_19))) * (1.0/((1.0 + (tmpvar_19 * unity_4LightAtten0)))));
  vec4 o_i0;
  vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_21;
  vec2 tmpvar_22;
  tmpvar_22.x = tmpvar_21.x;
  tmpvar_22.y = (tmpvar_21.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_22 + tmpvar_21.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_11.x * tmpvar_11.x) - (tmpvar_11.y * tmpvar_11.y)))) + ((((unity_LightColor[0].xyz * tmpvar_20.x) + (unity_LightColor[1].xyz * tmpvar_20.y)) + (unity_LightColor[2].xyz * tmpvar_20.z)) + (unity_LightColor[3].xyz * tmpvar_20.w)));
  xlv_TEXCOORD7 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec3 tmpvar_5;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_6;
  tmpvar_6 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_6;
  diff.xyz = (tmpvar_6.xyz * _ExposureIBL.w);
  tmpvar_5 = (diff.xyz * tmpvar_6.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_12;
  float tmpvar_13;
  tmpvar_13 = (1.0 - tmpvar_8.w);
  float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (_Shininess * tmpvar_14));
  float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  vec3 tmpvar_16;
  tmpvar_16.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_16.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_16.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_17;
  tmpvar_17 = reflect (tmpvar_1, tmpvar_16);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18.xyz = ((v_i0.xyz * tmpvar_17.x) + ((v_i0_i1.xyz * tmpvar_17.y) + (v_i0_i1_i2.xyz * tmpvar_17.z)));
  tmpvar_18.w = tmpvar_12;
  vec4 tmpvar_19;
  tmpvar_19 = textureCubeLod (_SpecCubeIBL, tmpvar_18.xyz, tmpvar_18.w);
  float tmpvar_20;
  tmpvar_20 = (tmpvar_19.w * tmpvar_19.w);
  vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20;
  tmpvar_21.y = (tmpvar_19.w * tmpvar_20);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_22;
  tmpvar_22 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  float tmpvar_23;
  tmpvar_23 = (tmpvar_22.w * tmpvar_22.w);
  vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23;
  tmpvar_24.y = (tmpvar_22.w * tmpvar_23);
  vec4 tmpvar_25;
  tmpvar_25 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_25;
  glow.xyz = (tmpvar_25.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_25.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_27;
  tmpvar_27 = normalize (xlv_TEXCOORD5);
  float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_7, tmpvar_27), 0.0, 1.0);
  frag.xyz = ((((tmpvar_26.x * 2.0) * tmpvar_28) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_7, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_27))), 0.0, 1.0), tmpvar_15)) * clamp ((10.0 * tmpvar_28), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_26.x) * 0.5) * (spec.xyz * ((tmpvar_15 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_5 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (((((tmpvar_19.xyz * dot (vec2(0.7532, 0.2468), tmpvar_21)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_22.xyz * dot (vec2(0.7532, 0.2468), tmpvar_24)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Vector 32 [_MainTex_ST]
"vs_3_0
; 97 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c33, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c14.w
dp4 r0.x, v0, c5
add r1, -r0.x, c18
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c17
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c33.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c19
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c20
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c33.x
dp4 r2.z, r4, c27
dp4 r2.y, r4, c26
dp4 r2.x, r4, c25
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c33.y
mul r0, r0, r1
mul r1.xyz, r0.y, c22
mad r1.xyz, r0.x, c21, r1
mad r0.xyz, r0.z, c23, r1
mad r1.xyz, r0.w, c24, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c30
dp4 r3.y, r0, c29
dp4 r3.x, r0, c28
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c31
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add o7.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1.w, c33.x
mov r1.xyz, c15
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c16, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c14.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c14.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c14.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c33.z
mul r1.y, r1, c12.x
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov o8.zw, r0
mad o1.xy, v3, c32, c32.zwzw
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_glesVertex.xyz - ((_World2Object * tmpvar_9).xyz * unity_Scale.w)));
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_13 * v_i0_i1.xyz);
  tmpvar_14.w = tmpvar_11.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_3 = tmpvar_15;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_13 * v_i0_i1_i2.xyz);
  tmpvar_16.w = tmpvar_11.y;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_4 = tmpvar_17;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_18;
  tmpvar_18.xyz = (tmpvar_13 * v_i0_i1_i2_i3.xyz);
  tmpvar_18.w = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * unity_Scale.w);
  tmpvar_5 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_21;
  mediump vec3 tmpvar_25;
  mediump vec4 normal;
  normal = tmpvar_24;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal);
  x1.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal);
  x1.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal);
  x1.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC);
  x3 = tmpvar_34;
  tmpvar_25 = ((x1 + x2) + x3);
  shlight = tmpvar_25;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosX0 - tmpvar_35.x);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosY0 - tmpvar_35.y);
  highp vec4 tmpvar_38;
  tmpvar_38 = (unity_4LightPosZ0 - tmpvar_35.z);
  highp vec4 tmpvar_39;
  tmpvar_39 = (((tmpvar_36 * tmpvar_36) + (tmpvar_37 * tmpvar_37)) + (tmpvar_38 * tmpvar_38));
  highp vec4 tmpvar_40;
  tmpvar_40 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_36 * tmpvar_21.x) + (tmpvar_37 * tmpvar_21.y)) + (tmpvar_38 * tmpvar_21.z)) * inversesqrt (tmpvar_39))) * (1.0/((1.0 + (tmpvar_39 * unity_4LightAtten0)))));
  highp vec3 tmpvar_41;
  tmpvar_41 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_40.x) + (unity_LightColor[1].xyz * tmpvar_40.y)) + (unity_LightColor[2].xyz * tmpvar_40.z)) + (unity_LightColor[3].xyz * tmpvar_40.w)));
  tmpvar_7 = tmpvar_41;
  highp vec4 o_i0;
  highp vec4 tmpvar_42;
  tmpvar_42 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_42;
  highp vec2 tmpvar_43;
  tmpvar_43.x = tmpvar_42.x;
  tmpvar_43.y = (tmpvar_42.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_43 + tmpvar_42.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_13 * (((_World2Object * tmpvar_23).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_14;
  tmpvar_9 = N;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_16 * (tmpvar_16 * tmpvar_16)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - spec.w);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - (tmpvar_18 * tmpvar_18));
  tmpvar_17 = ((7.0 + tmpvar_19) - (shininess * tmpvar_19));
  mediump float tmpvar_20;
  tmpvar_20 = pow (2.0, (8.0 - tmpvar_17));
  highp float gloss;
  gloss = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_17;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = reflect (tmpvar_1, tmpvar_22);
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25.x = dot (tmpvar_2, N);
  tmpvar_25.y = dot (tmpvar_3, N);
  tmpvar_25.z = dot (tmpvar_4, N);
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  lowp float tmpvar_31;
  tmpvar_31 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_32;
  mediump float atten_i0;
  atten_i0 = tmpvar_31;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_9, lightDir), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_33) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_9, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = vec3(pow (specRefl, tmpvar_20));
  spec_i0_i1 = tmpvar_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_33), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_36;
  frag.xyz = (frag.xyz + (tmpvar_36 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_38;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_glesVertex.xyz - ((_World2Object * tmpvar_9).xyz * unity_Scale.w)));
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_13 * v_i0_i1.xyz);
  tmpvar_14.w = tmpvar_11.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_3 = tmpvar_15;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_13 * v_i0_i1_i2.xyz);
  tmpvar_16.w = tmpvar_11.y;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_4 = tmpvar_17;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_18;
  tmpvar_18.xyz = (tmpvar_13 * v_i0_i1_i2_i3.xyz);
  tmpvar_18.w = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * unity_Scale.w);
  tmpvar_5 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_21;
  mediump vec3 tmpvar_25;
  mediump vec4 normal;
  normal = tmpvar_24;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal);
  x1.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal);
  x1.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal);
  x1.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC);
  x3 = tmpvar_34;
  tmpvar_25 = ((x1 + x2) + x3);
  shlight = tmpvar_25;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosX0 - tmpvar_35.x);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosY0 - tmpvar_35.y);
  highp vec4 tmpvar_38;
  tmpvar_38 = (unity_4LightPosZ0 - tmpvar_35.z);
  highp vec4 tmpvar_39;
  tmpvar_39 = (((tmpvar_36 * tmpvar_36) + (tmpvar_37 * tmpvar_37)) + (tmpvar_38 * tmpvar_38));
  highp vec4 tmpvar_40;
  tmpvar_40 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_36 * tmpvar_21.x) + (tmpvar_37 * tmpvar_21.y)) + (tmpvar_38 * tmpvar_21.z)) * inversesqrt (tmpvar_39))) * (1.0/((1.0 + (tmpvar_39 * unity_4LightAtten0)))));
  highp vec3 tmpvar_41;
  tmpvar_41 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_40.x) + (unity_LightColor[1].xyz * tmpvar_40.y)) + (unity_LightColor[2].xyz * tmpvar_40.z)) + (unity_LightColor[3].xyz * tmpvar_40.w)));
  tmpvar_7 = tmpvar_41;
  highp vec4 o_i0;
  highp vec4 tmpvar_42;
  tmpvar_42 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_42;
  highp vec2 tmpvar_43;
  tmpvar_43.x = tmpvar_42.x;
  tmpvar_43.y = (tmpvar_42.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_43 + tmpvar_42.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_13 * (((_World2Object * tmpvar_23).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec3 tmpvar_11;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (diff * _Color);
  diff = tmpvar_13;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_9 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_10 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_19));
  highp float gloss;
  gloss = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_11 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24.x = dot (tmpvar_2, tmpvar_10);
  tmpvar_24.y = dot (tmpvar_3, tmpvar_10);
  tmpvar_24.z = dot (tmpvar_4, tmpvar_10);
  highp vec3 tmpvar_25;
  tmpvar_25 = reflect (tmpvar_1, tmpvar_24);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((v_i0.xyz * tmpvar_25.x) + ((v_i0_i1.xyz * tmpvar_25.y) + (v_i0_i1_i2.xyz * tmpvar_25.z)));
  tmpvar_26.w = glossLod_i0_i1;
  lookup = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_28;
  tmpvar_29.y = (spec_i0.w * tmpvar_28);
  highp vec3 tmpvar_30;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_30 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_30;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_31;
  tmpvar_31 = textureCube (_DiffCubeIBL, tmpvar_30);
  diff_i0 = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_33;
  tmpvar_33.x = tmpvar_32;
  tmpvar_33.y = (diff_i0.w * tmpvar_32);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (glow.w * _EmissionLM);
  glow.w = tmpvar_37;
  glow.xyz = (glow.xyz + (tmpvar_9 * glow.w));
  lowp float tmpvar_38;
  tmpvar_38 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_39;
  mediump float atten_i0;
  atten_i0 = tmpvar_38;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize (lightDir);
  mediump float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_10, tmpvar_40), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_41) * tmpvar_9) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_10, normalize ((viewDir + tmpvar_40))), 0.0, 1.0);
  specRefl = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = vec3(pow (specRefl, tmpvar_22));
  spec_i0_i1 = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_41), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_44;
  frag.xyz = (frag.xyz + (tmpvar_44 * tmpvar_11));
  c = frag;
  mediump vec3 tmpvar_45;
  tmpvar_45 = (c.xyz + (tmpvar_9 * xlv_TEXCOORD6));
  c.xyz = tmpvar_45;
  mediump vec3 tmpvar_46;
  tmpvar_46 = (c.xyz + (((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_29)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_33)) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_46;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  mat3 tmpvar_4;
  tmpvar_4[0] = TANGENT.xyz;
  tmpvar_4[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_4[2] = gl_Normal;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_6;
  tmpvar_6.xyz = (tmpvar_5 * v_i0_i1.xyz);
  tmpvar_6.w = tmpvar_3.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_5 * v_i0_i1_i2.xyz);
  tmpvar_7.w = tmpvar_3.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_5 * v_i0_i1_i2_i3.xyz);
  tmpvar_8.w = tmpvar_3.z;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_12);
  x1.y = dot (unity_SHAg, tmpvar_12);
  x1.z = dot (unity_SHAb, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_10.xyzz * tmpvar_10.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_13);
  x2.y = dot (unity_SHBg, tmpvar_13);
  x2.z = dot (unity_SHBb, tmpvar_13);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_6 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_10.x * tmpvar_10.x) - (tmpvar_10.y * tmpvar_10.y))));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_5;
  diff.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_12;
  float tmpvar_13;
  tmpvar_13 = (1.0 - tmpvar_8.w);
  float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (_Shininess * tmpvar_14));
  float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  vec3 tmpvar_16;
  tmpvar_16.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_16.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_16.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_17;
  tmpvar_17 = reflect (tmpvar_1, tmpvar_16);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18.xyz = ((v_i0.xyz * tmpvar_17.x) + ((v_i0_i1.xyz * tmpvar_17.y) + (v_i0_i1_i2.xyz * tmpvar_17.z)));
  tmpvar_18.w = tmpvar_12;
  vec4 tmpvar_19;
  tmpvar_19 = textureCubeLod (_SpecCubeIBL, tmpvar_18.xyz, tmpvar_18.w);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_21;
  glow.xyz = (tmpvar_21.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_21.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_6 * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD5);
  float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_7, tmpvar_22), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_23) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (tmpvar_7, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_22))), 0.0, 1.0), tmpvar_15)) * clamp ((10.0 * tmpvar_23), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_15 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_6 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (((((tmpvar_19.xyz * tmpvar_19.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_20.xyz * tmpvar_20.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [_MainTex_ST]
"vs_3_0
; 61 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c12.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c23.x
dp4 r2.z, r0, c17
dp4 r2.y, r0, c16
dp4 r2.x, r0, c15
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c20
dp4 r3.y, r1, c19
dp4 r3.x, r1, c18
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c21
add o7.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1.w, c23.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c12.w
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c22, c22.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_23;
  mediump vec4 normal;
  normal = tmpvar_22;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal);
  x1.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal);
  x1.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal);
  x1.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC);
  x3 = tmpvar_32;
  tmpvar_23 = ((x1 + x2) + x3);
  shlight = tmpvar_23;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_14;
  tmpvar_9 = N;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_16 * (tmpvar_16 * tmpvar_16)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - spec.w);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - (tmpvar_18 * tmpvar_18));
  tmpvar_17 = ((7.0 + tmpvar_19) - (shininess * tmpvar_19));
  mediump float tmpvar_20;
  tmpvar_20 = pow (2.0, (8.0 - tmpvar_17));
  highp float gloss;
  gloss = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_17;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = reflect (tmpvar_1, tmpvar_22);
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25.x = dot (tmpvar_2, N);
  tmpvar_25.y = dot (tmpvar_3, N);
  tmpvar_25.z = dot (tmpvar_4, N);
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_31;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_9, lightDir), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_32) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_9, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = vec3(pow (specRefl, tmpvar_20));
  spec_i0_i1 = tmpvar_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_32), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_35;
  frag.xyz = (frag.xyz + (tmpvar_35 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_37;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_23;
  mediump vec4 normal;
  normal = tmpvar_22;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal);
  x1.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal);
  x1.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal);
  x1.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC);
  x3 = tmpvar_32;
  tmpvar_23 = ((x1 + x2) + x3);
  shlight = tmpvar_23;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_9 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_19));
  highp float gloss;
  gloss = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_24.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_24.z = dot (tmpvar_4, tmpvar_9);
  highp vec3 tmpvar_25;
  tmpvar_25 = reflect (tmpvar_1, tmpvar_24);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((v_i0.xyz * tmpvar_25.x) + ((v_i0_i1.xyz * tmpvar_25.y) + (v_i0_i1_i2.xyz * tmpvar_25.z)));
  tmpvar_26.w = glossLod_i0_i1;
  lookup = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_27;
  highp vec3 tmpvar_28;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_28 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_28;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_28);
  diff_i0 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (glow.w * _EmissionLM);
  glow.w = tmpvar_33;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  highp vec3 tmpvar_34;
  tmpvar_34 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_34;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_35;
  tmpvar_35 = normalize (lightDir);
  mediump float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_9, tmpvar_35), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_36) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_9, normalize ((viewDir + tmpvar_35))), 0.0, 1.0);
  specRefl = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = vec3(pow (specRefl, tmpvar_22));
  spec_i0_i1 = tmpvar_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_36), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_39;
  frag.xyz = (frag.xyz + (tmpvar_39 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_40;
  tmpvar_40 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_41;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  mat3 tmpvar_4;
  tmpvar_4[0] = TANGENT.xyz;
  tmpvar_4[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_4[2] = gl_Normal;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_6;
  tmpvar_6.xyz = (tmpvar_5 * v_i0_i1.xyz);
  tmpvar_6.w = tmpvar_3.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_5 * v_i0_i1_i2.xyz);
  tmpvar_7.w = tmpvar_3.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_5 * v_i0_i1_i2_i3.xyz);
  tmpvar_8.w = tmpvar_3.z;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_6 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_5;
  diff.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_12;
  tmpvar_12 = (1.0 - tmpvar_8.w);
  float tmpvar_13;
  tmpvar_13 = (1.0 - (tmpvar_12 * tmpvar_12));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_14.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_14.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_16;
  tmpvar_16.xyz = ((v_i0.xyz * tmpvar_15.x) + ((v_i0_i1.xyz * tmpvar_15.y) + (v_i0_i1_i2.xyz * tmpvar_15.z)));
  tmpvar_16.w = ((7.0 + tmpvar_13) - (_Shininess * tmpvar_13));
  vec4 tmpvar_17;
  tmpvar_17 = textureCubeLod (_SpecCubeIBL, tmpvar_16.xyz, tmpvar_16.w);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_19;
  glow.xyz = (tmpvar_19.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_19.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_6 * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_20;
  tmpvar_20 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  c.xyz = (tmpvar_6 * ((8.0 * tmpvar_20.w) * tmpvar_20.xyz));
  c.w = diff.w;
  c.xyz = (c.xyz + (((((tmpvar_17.xyz * tmpvar_17.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_18.xyz * tmpvar_18.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c13
mov r0.w, c16.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c12.w, -v0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r1, r2
mul o5, r0, c12.w
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
mad o1.xy, v3, c15, c15.zwzw
mad o6.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)));
  highp mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_10 * v_i0_i1.xyz);
  tmpvar_11.w = tmpvar_8.x;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_10 * v_i0_i1_i2.xyz);
  tmpvar_13.w = tmpvar_8.y;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_10 * v_i0_i1_i2_i3.xyz);
  tmpvar_15.w = tmpvar_8.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff * _Color);
  diff = tmpvar_11;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_12;
  tmpvar_12 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_13;
  tmpvar_9 = N;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_14;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_15 * (tmpvar_15 * tmpvar_15)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_16;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_17;
  tmpvar_17 = (1.0 - spec.w);
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - (tmpvar_17 * tmpvar_17));
  tmpvar_16 = ((7.0 + tmpvar_18) - (shininess * tmpvar_18));
  mediump vec3 tmpvar_19;
  tmpvar_19.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_19.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_19.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_16;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = reflect (tmpvar_1, tmpvar_19);
  tmpvar_20.w = glossLod_i0_i1;
  lookup = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N);
  tmpvar_22.y = dot (tmpvar_3, N);
  tmpvar_22.z = dot (tmpvar_4, N);
  N = tmpvar_22;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_i0 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (glow.w * _EmissionLM);
  glow.w = tmpvar_27;
  glow.xyz = (glow.xyz + (tmpvar_12 * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_28;
  tmpvar_28 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz);
  mediump vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_12 * tmpvar_28);
  c.xyz = tmpvar_29;
  c.w = diff.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_30;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)));
  highp mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_10 * v_i0_i1.xyz);
  tmpvar_11.w = tmpvar_8.x;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_10 * v_i0_i1_i2.xyz);
  tmpvar_13.w = tmpvar_8.y;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_10 * v_i0_i1_i2_i3.xyz);
  tmpvar_15.w = tmpvar_8.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff * _Color);
  diff = tmpvar_11;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_12;
  tmpvar_12 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (N);
  tmpvar_9 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_14;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_13, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_16;
  tmpvar_16.x = 1.0;
  tmpvar_16.y = tmpvar_15;
  tmpvar_16.z = ((tmpvar_15 * tmpvar_15) * tmpvar_15);
  p = tmpvar_16;
  mediump vec2 tmpvar_17;
  tmpvar_17.x = (1.0 - fresnel_i0);
  tmpvar_17.y = fresnel_i0;
  p.x = dot (tmpvar_16.xy, tmpvar_17);
  p.y = dot (p.yz, tmpvar_17);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_17))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_18;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - spec.w);
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - (tmpvar_19 * tmpvar_19));
  tmpvar_18 = ((7.0 + tmpvar_20) - (shininess * tmpvar_20));
  mediump vec3 tmpvar_21;
  tmpvar_21.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_21.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_21.z = dot (tmpvar_4, tmpvar_9);
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (tmpvar_1, tmpvar_21);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_18;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = ((v_i0.xyz * tmpvar_22.x) + ((v_i0_i1.xyz * tmpvar_22.y) + (v_i0_i1_i2.xyz * tmpvar_22.z)));
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_25 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_13)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_13)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_13))));
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_12 * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  lowp vec3 tmpvar_32;
  tmpvar_32 = ((8.0 * tmpvar_31.w) * tmpvar_31.xyz);
  mediump vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_12 * tmpvar_32);
  c.xyz = tmpvar_33;
  c.w = diff.w;
  mediump vec3 tmpvar_34;
  tmpvar_34 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_34;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  mat3 tmpvar_5;
  tmpvar_5[0] = TANGENT.xyz;
  tmpvar_5[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_5[2] = gl_Normal;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_6 * v_i0_i1.xyz);
  tmpvar_7.w = tmpvar_4.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_i0_i1_i2.xyz);
  tmpvar_8.w = tmpvar_4.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_6 * v_i0_i1_i2_i3.xyz);
  tmpvar_9.w = tmpvar_4.z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_11;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_13);
  x1.y = dot (unity_SHAg, tmpvar_13);
  x1.z = dot (unity_SHAb, tmpvar_13);
  vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_11.xyzz * tmpvar_11.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_14);
  x2.y = dot (unity_SHBg, tmpvar_14);
  x2.z = dot (unity_SHBb, tmpvar_14);
  vec4 o_i0;
  vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_15;
  vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_11.x * tmpvar_11.x) - (tmpvar_11.y * tmpvar_11.y))));
  xlv_TEXCOORD7 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_5;
  diff.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_12;
  float tmpvar_13;
  tmpvar_13 = (1.0 - tmpvar_8.w);
  float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (_Shininess * tmpvar_14));
  float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  vec3 tmpvar_16;
  tmpvar_16.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_16.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_16.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_17;
  tmpvar_17 = reflect (tmpvar_1, tmpvar_16);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18.xyz = ((v_i0.xyz * tmpvar_17.x) + ((v_i0_i1.xyz * tmpvar_17.y) + (v_i0_i1_i2.xyz * tmpvar_17.z)));
  tmpvar_18.w = tmpvar_12;
  vec4 tmpvar_19;
  tmpvar_19 = textureCubeLod (_SpecCubeIBL, tmpvar_18.xyz, tmpvar_18.w);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_21;
  glow.xyz = (tmpvar_21.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_21.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_6 * glow.w));
  vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_23;
  tmpvar_23 = normalize (xlv_TEXCOORD5);
  float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_7, tmpvar_23), 0.0, 1.0);
  frag.xyz = ((((tmpvar_22.x * 2.0) * tmpvar_24) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_7, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_23))), 0.0, 1.0), tmpvar_15)) * clamp ((10.0 * tmpvar_24), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_22.x) * 0.5) * (spec.xyz * ((tmpvar_15 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_6 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (((((tmpvar_19.xyz * tmpvar_19.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_20.xyz * tmpvar_20.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
"vs_3_0
; 66 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c25, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c14.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c25.x
dp4 r2.z, r0, c19
dp4 r2.y, r0, c18
dp4 r2.x, r0, c17
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c22
dp4 r3.y, r1, c21
dp4 r3.x, r1, c20
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c23
add o7.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1.w, c25.x
mov r1.xyz, c15
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c16, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c14.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c14.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c14.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c12.x
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov o8.zw, r0
mad o1.xy, v3, c24, c24.zwzw
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_glesVertex.xyz - ((_World2Object * tmpvar_9).xyz * unity_Scale.w)));
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_13 * v_i0_i1.xyz);
  tmpvar_14.w = tmpvar_11.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_3 = tmpvar_15;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_13 * v_i0_i1_i2.xyz);
  tmpvar_16.w = tmpvar_11.y;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_4 = tmpvar_17;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_18;
  tmpvar_18.xyz = (tmpvar_13 * v_i0_i1_i2_i3.xyz);
  tmpvar_18.w = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * unity_Scale.w);
  tmpvar_5 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (tmpvar_20 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_34;
  tmpvar_34 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_34;
  highp vec2 tmpvar_35;
  tmpvar_35.x = tmpvar_34.x;
  tmpvar_35.y = (tmpvar_34.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_35 + tmpvar_34.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_13 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_14;
  tmpvar_9 = N;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_16 * (tmpvar_16 * tmpvar_16)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - spec.w);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - (tmpvar_18 * tmpvar_18));
  tmpvar_17 = ((7.0 + tmpvar_19) - (shininess * tmpvar_19));
  mediump float tmpvar_20;
  tmpvar_20 = pow (2.0, (8.0 - tmpvar_17));
  highp float gloss;
  gloss = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_17;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = reflect (tmpvar_1, tmpvar_22);
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25.x = dot (tmpvar_2, N);
  tmpvar_25.y = dot (tmpvar_3, N);
  tmpvar_25.z = dot (tmpvar_4, N);
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  lowp float tmpvar_31;
  tmpvar_31 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_32;
  mediump float atten_i0;
  atten_i0 = tmpvar_31;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_9, lightDir), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_33) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_9, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = vec3(pow (specRefl, tmpvar_20));
  spec_i0_i1 = tmpvar_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_33), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_36;
  frag.xyz = (frag.xyz + (tmpvar_36 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_38;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_glesVertex.xyz - ((_World2Object * tmpvar_9).xyz * unity_Scale.w)));
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_13 * v_i0_i1.xyz);
  tmpvar_14.w = tmpvar_11.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_3 = tmpvar_15;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_13 * v_i0_i1_i2.xyz);
  tmpvar_16.w = tmpvar_11.y;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_4 = tmpvar_17;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_18;
  tmpvar_18.xyz = (tmpvar_13 * v_i0_i1_i2_i3.xyz);
  tmpvar_18.w = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * unity_Scale.w);
  tmpvar_5 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (tmpvar_20 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_34;
  tmpvar_34 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_34;
  highp vec2 tmpvar_35;
  tmpvar_35.x = tmpvar_34.x;
  tmpvar_35.y = (tmpvar_34.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_35 + tmpvar_34.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_13 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_9 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_19));
  highp float gloss;
  gloss = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_24.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_24.z = dot (tmpvar_4, tmpvar_9);
  highp vec3 tmpvar_25;
  tmpvar_25 = reflect (tmpvar_1, tmpvar_24);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((v_i0.xyz * tmpvar_25.x) + ((v_i0_i1.xyz * tmpvar_25.y) + (v_i0_i1_i2.xyz * tmpvar_25.z)));
  tmpvar_26.w = glossLod_i0_i1;
  lookup = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_27;
  highp vec3 tmpvar_28;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_28 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_28;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_28);
  diff_i0 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (glow.w * _EmissionLM);
  glow.w = tmpvar_33;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  lowp float tmpvar_34;
  tmpvar_34 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_35;
  mediump float atten_i0;
  atten_i0 = tmpvar_34;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_36;
  tmpvar_36 = normalize (lightDir);
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_9, tmpvar_36), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_37) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_9, normalize ((viewDir + tmpvar_36))), 0.0, 1.0);
  specRefl = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = vec3(pow (specRefl, tmpvar_22));
  spec_i0_i1 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_37), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_40;
  frag.xyz = (frag.xyz + (tmpvar_40 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_41;
  tmpvar_41 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_42;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  mat3 tmpvar_5;
  tmpvar_5[0] = TANGENT.xyz;
  tmpvar_5[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_5[2] = gl_Normal;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_6 * v_i0_i1.xyz);
  tmpvar_7.w = tmpvar_4.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_i0_i1_i2.xyz);
  tmpvar_8.w = tmpvar_4.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_6 * v_i0_i1_i2_i3.xyz);
  tmpvar_9.w = tmpvar_4.z;
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  vec4 o_i0;
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_11;
  vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_12 + tmpvar_11.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_10).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD5 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_5;
  diff.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_12;
  tmpvar_12 = (1.0 - tmpvar_8.w);
  float tmpvar_13;
  tmpvar_13 = (1.0 - (tmpvar_12 * tmpvar_12));
  vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_14.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_14.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_16;
  tmpvar_16.xyz = ((v_i0.xyz * tmpvar_15.x) + ((v_i0_i1.xyz * tmpvar_15.y) + (v_i0_i1_i2.xyz * tmpvar_15.z)));
  tmpvar_16.w = ((7.0 + tmpvar_13) - (_Shininess * tmpvar_13));
  vec4 tmpvar_17;
  tmpvar_17 = textureCubeLod (_SpecCubeIBL, tmpvar_16.xyz, tmpvar_16.w);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_19;
  glow.xyz = (tmpvar_19.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_19.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_6 * glow.w));
  vec4 tmpvar_20;
  tmpvar_20 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_21;
  tmpvar_21 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  vec3 tmpvar_22;
  tmpvar_22 = ((8.0 * tmpvar_21.w) * tmpvar_21.xyz);
  c.xyz = (tmpvar_6 * max (min (tmpvar_22, ((tmpvar_20.x * 2.0) * tmpvar_21.xyz)), (tmpvar_22 * tmpvar_20.x)));
  c.w = diff.w;
  c.xyz = (c.xyz + (((((tmpvar_17.xyz * tmpvar_17.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_18.xyz * tmpvar_18.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"vs_3_0
; 41 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c18, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c15
mov r0.w, c18.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c14.w, -v0
dp3 r0.w, -r1, c4
dp3 o2.y, r1, r2
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c14.w
dp3 r0.w, -r1, c5
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c14.w
dp3 r0.w, -r1, c6
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c14.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp3 o2.z, v2, r1
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c18.y
dp3 o2.x, r1, v1
mov r1.x, r2
mul r1.y, r2, c12.x
mad o7.xy, r2.z, c13.zwzw, r1
mov o0, r0
mov o7.zw, r0
mad o1.xy, v3, c17, c17.zwzw
mad o6.xy, v4, c16, c16.zwzw
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_19;
  highp vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_20 + tmpvar_19.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff * _Color);
  diff = tmpvar_11;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_12;
  tmpvar_12 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_13;
  tmpvar_9 = N;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_14;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_15 * (tmpvar_15 * tmpvar_15)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_16;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_17;
  tmpvar_17 = (1.0 - spec.w);
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - (tmpvar_17 * tmpvar_17));
  tmpvar_16 = ((7.0 + tmpvar_18) - (shininess * tmpvar_18));
  mediump vec3 tmpvar_19;
  tmpvar_19.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_19.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_19.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_16;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = reflect (tmpvar_1, tmpvar_19);
  tmpvar_20.w = glossLod_i0_i1;
  lookup = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, N);
  tmpvar_22.y = dot (tmpvar_3, N);
  tmpvar_22.z = dot (tmpvar_4, N);
  N = tmpvar_22;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_DiffCubeIBL, tmpvar_22);
  diff_i0 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (glow.w * _EmissionLM);
  glow.w = tmpvar_27;
  glow.xyz = (glow.xyz + (tmpvar_12 * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_28;
  tmpvar_28 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x * 2.0)));
  mediump vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_12 * tmpvar_28);
  c.xyz = tmpvar_29;
  c.w = diff.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_30;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_19;
  highp vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_20 + tmpvar_19.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (diff * _Color);
  diff = tmpvar_11;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_12;
  tmpvar_12 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (N);
  tmpvar_9 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_14;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_15;
  tmpvar_15 = (1.0 - clamp (dot (tmpvar_13, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_16;
  tmpvar_16.x = 1.0;
  tmpvar_16.y = tmpvar_15;
  tmpvar_16.z = ((tmpvar_15 * tmpvar_15) * tmpvar_15);
  p = tmpvar_16;
  mediump vec2 tmpvar_17;
  tmpvar_17.x = (1.0 - fresnel_i0);
  tmpvar_17.y = fresnel_i0;
  p.x = dot (tmpvar_16.xy, tmpvar_17);
  p.y = dot (p.yz, tmpvar_17);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_17))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_18;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - spec.w);
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - (tmpvar_19 * tmpvar_19));
  tmpvar_18 = ((7.0 + tmpvar_20) - (shininess * tmpvar_20));
  mediump vec3 tmpvar_21;
  tmpvar_21.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_21.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_21.z = dot (tmpvar_4, tmpvar_9);
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (tmpvar_1, tmpvar_21);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_18;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = ((v_i0.xyz * tmpvar_22.x) + ((v_i0_i1.xyz * tmpvar_22.y) + (v_i0_i1_i2.xyz * tmpvar_22.z)));
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_25 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_13)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_13)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_13))));
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_12 * glow.w));
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  lowp vec3 tmpvar_33;
  tmpvar_33 = ((8.0 * tmpvar_32.w) * tmpvar_32.xyz);
  lowp vec3 tmpvar_34;
  tmpvar_34 = max (min (tmpvar_33, ((tmpvar_31.x * 2.0) * tmpvar_32.xyz)), (tmpvar_33 * tmpvar_31.x));
  mediump vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_12 * tmpvar_34);
  c.xyz = tmpvar_35;
  c.w = diff.w;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_36;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_LightColor[4];
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightAtten0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)));
  mat3 tmpvar_4;
  tmpvar_4[0] = TANGENT.xyz;
  tmpvar_4[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_4[2] = gl_Normal;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_6;
  tmpvar_6.xyz = (tmpvar_5 * v_i0_i1.xyz);
  tmpvar_6.w = tmpvar_3.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_5 * v_i0_i1_i2.xyz);
  tmpvar_7.w = tmpvar_3.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_5 * v_i0_i1_i2_i3.xyz);
  tmpvar_8.w = tmpvar_3.z;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_12);
  x1.y = dot (unity_SHAg, tmpvar_12);
  x1.z = dot (unity_SHAb, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_10.xyzz * tmpvar_10.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_13);
  x2.y = dot (unity_SHBg, tmpvar_13);
  x2.z = dot (unity_SHBb, tmpvar_13);
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
  tmpvar_19 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_15 * tmpvar_10.x) + (tmpvar_16 * tmpvar_10.y)) + (tmpvar_17 * tmpvar_10.z)) * inversesqrt (tmpvar_18))) * (1.0/((1.0 + (tmpvar_18 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_6 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_10.x * tmpvar_10.x) - (tmpvar_10.y * tmpvar_10.y)))) + ((((unity_LightColor[0].xyz * tmpvar_19.x) + (unity_LightColor[1].xyz * tmpvar_19.y)) + (unity_LightColor[2].xyz * tmpvar_19.z)) + (unity_LightColor[3].xyz * tmpvar_19.w)));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_5;
  diff.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_12;
  float tmpvar_13;
  tmpvar_13 = (1.0 - tmpvar_8.w);
  float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (_Shininess * tmpvar_14));
  float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  vec3 tmpvar_16;
  tmpvar_16.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_16.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_16.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_17;
  tmpvar_17 = reflect (tmpvar_1, tmpvar_16);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18.xyz = ((v_i0.xyz * tmpvar_17.x) + ((v_i0_i1.xyz * tmpvar_17.y) + (v_i0_i1_i2.xyz * tmpvar_17.z)));
  tmpvar_18.w = tmpvar_12;
  vec4 tmpvar_19;
  tmpvar_19 = textureCubeLod (_SpecCubeIBL, tmpvar_18.xyz, tmpvar_18.w);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_21;
  glow.xyz = (tmpvar_21.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_21.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_6 * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD5);
  float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_7, tmpvar_22), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_23) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (tmpvar_7, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_22))), 0.0, 1.0), tmpvar_15)) * clamp ((10.0 * tmpvar_23), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_15 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_6 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (((((tmpvar_19.xyz * tmpvar_19.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_20.xyz * tmpvar_20.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Vector 30 [_MainTex_ST]
"vs_3_0
; 92 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c31, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c12.w
dp4 r0.x, v0, c5
add r1, -r0.x, c16
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c15
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c31.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c17
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c18
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
dp4 r2.z, r4, c25
dp4 r2.y, r4, c24
dp4 r2.x, r4, c23
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c20
mad r1.xyz, r0.x, c19, r1
mad r0.xyz, r0.z, c21, r1
mad r1.xyz, r0.w, c22, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c28
dp4 r3.y, r0, c27
dp4 r3.x, r0, c26
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c29
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add o7.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1.w, c31.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c12.w
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c30, c30.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_20;
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_20.x) + (tmpvar_36 * tmpvar_20.y)) + (tmpvar_37 * tmpvar_20.z)) * inversesqrt (tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_7 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_14;
  tmpvar_9 = N;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_16 * (tmpvar_16 * tmpvar_16)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - spec.w);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - (tmpvar_18 * tmpvar_18));
  tmpvar_17 = ((7.0 + tmpvar_19) - (shininess * tmpvar_19));
  mediump float tmpvar_20;
  tmpvar_20 = pow (2.0, (8.0 - tmpvar_17));
  highp float gloss;
  gloss = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_17;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = reflect (tmpvar_1, tmpvar_22);
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25.x = dot (tmpvar_2, N);
  tmpvar_25.y = dot (tmpvar_3, N);
  tmpvar_25.z = dot (tmpvar_4, N);
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_31;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_9, lightDir), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_32) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_9, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = vec3(pow (specRefl, tmpvar_20));
  spec_i0_i1 = tmpvar_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_32), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_35;
  frag.xyz = (frag.xyz + (tmpvar_35 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_37;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_20;
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_20.x) + (tmpvar_36 * tmpvar_20.y)) + (tmpvar_37 * tmpvar_20.z)) * inversesqrt (tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_7 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_9 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_19));
  highp float gloss;
  gloss = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_24.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_24.z = dot (tmpvar_4, tmpvar_9);
  highp vec3 tmpvar_25;
  tmpvar_25 = reflect (tmpvar_1, tmpvar_24);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((v_i0.xyz * tmpvar_25.x) + ((v_i0_i1.xyz * tmpvar_25.y) + (v_i0_i1_i2.xyz * tmpvar_25.z)));
  tmpvar_26.w = glossLod_i0_i1;
  lookup = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_27;
  highp vec3 tmpvar_28;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_28 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_28;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_28);
  diff_i0 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (glow.w * _EmissionLM);
  glow.w = tmpvar_33;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  highp vec3 tmpvar_34;
  tmpvar_34 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_34;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_35;
  tmpvar_35 = normalize (lightDir);
  mediump float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_9, tmpvar_35), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_36) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_9, normalize ((viewDir + tmpvar_35))), 0.0, 1.0);
  specRefl = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = vec3(pow (specRefl, tmpvar_22));
  spec_i0_i1 = tmpvar_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_36), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_39;
  frag.xyz = (frag.xyz + (tmpvar_39 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_40;
  tmpvar_40 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_41;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_LightColor[4];
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightAtten0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)));
  mat3 tmpvar_5;
  tmpvar_5[0] = TANGENT.xyz;
  tmpvar_5[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_5[2] = gl_Normal;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  vec4 tmpvar_7;
  tmpvar_7.xyz = (tmpvar_6 * v_i0_i1.xyz);
  tmpvar_7.w = tmpvar_4.x;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  vec4 tmpvar_8;
  tmpvar_8.xyz = (tmpvar_6 * v_i0_i1_i2.xyz);
  tmpvar_8.w = tmpvar_4.y;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  vec4 tmpvar_9;
  tmpvar_9.xyz = (tmpvar_6 * v_i0_i1_i2_i3.xyz);
  tmpvar_9.w = tmpvar_4.z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_11;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_13);
  x1.y = dot (unity_SHAg, tmpvar_13);
  x1.z = dot (unity_SHAb, tmpvar_13);
  vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_11.xyzz * tmpvar_11.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_14);
  x2.y = dot (unity_SHBg, tmpvar_14);
  x2.z = dot (unity_SHBb, tmpvar_14);
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
  tmpvar_20 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_16 * tmpvar_11.x) + (tmpvar_17 * tmpvar_11.y)) + (tmpvar_18 * tmpvar_11.z)) * inversesqrt (tmpvar_19))) * (1.0/((1.0 + (tmpvar_19 * unity_4LightAtten0)))));
  vec4 o_i0;
  vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_21;
  vec2 tmpvar_22;
  tmpvar_22.x = tmpvar_21.x;
  tmpvar_22.y = (tmpvar_21.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_22 + tmpvar_21.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_6 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_7 * unity_Scale.w);
  xlv_TEXCOORD3 = (tmpvar_8 * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_9 * unity_Scale.w);
  xlv_TEXCOORD5 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD6 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_11.x * tmpvar_11.x) - (tmpvar_11.y * tmpvar_11.y)))) + ((((unity_LightColor[0].xyz * tmpvar_20.x) + (unity_LightColor[1].xyz * tmpvar_20.y)) + (unity_LightColor[2].xyz * tmpvar_20.z)) + (unity_LightColor[3].xyz * tmpvar_20.w)));
  xlv_TEXCOORD7 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD6;
varying vec3 xlv_TEXCOORD5;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  tmpvar_1.x = xlv_TEXCOORD2.w;
  tmpvar_1.y = xlv_TEXCOORD3.w;
  tmpvar_1.z = xlv_TEXCOORD4.w;
  vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD2.xyz;
  vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xyz;
  vec3 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD4.xyz;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_5;
  diff.xyz = (tmpvar_5.xyz * _ExposureIBL.w);
  vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_7;
  tmpvar_7 = normalize (normal);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - _Fresnel);
  tmpvar_11.y = _Fresnel;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (tmpvar_8.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_12;
  float tmpvar_13;
  tmpvar_13 = (1.0 - tmpvar_8.w);
  float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (_Shininess * tmpvar_14));
  float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  vec3 tmpvar_16;
  tmpvar_16.x = dot (tmpvar_2, tmpvar_7);
  tmpvar_16.y = dot (tmpvar_3, tmpvar_7);
  tmpvar_16.z = dot (tmpvar_4, tmpvar_7);
  vec3 tmpvar_17;
  tmpvar_17 = reflect (tmpvar_1, tmpvar_16);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  vec4 tmpvar_18;
  tmpvar_18.xyz = ((v_i0.xyz * tmpvar_17.x) + ((v_i0_i1.xyz * tmpvar_17.y) + (v_i0_i1_i2.xyz * tmpvar_17.z)));
  tmpvar_18.w = tmpvar_12;
  vec4 tmpvar_19;
  tmpvar_19 = textureCubeLod (_SpecCubeIBL, tmpvar_18.xyz, tmpvar_18.w);
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_7)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_7)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_7)))));
  vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_21;
  glow.xyz = (tmpvar_21.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_21.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_6 * glow.w));
  vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_23;
  tmpvar_23 = normalize (xlv_TEXCOORD5);
  float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_7, tmpvar_23), 0.0, 1.0);
  frag.xyz = ((((tmpvar_22.x * 2.0) * tmpvar_24) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_7, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_23))), 0.0, 1.0), tmpvar_15)) * clamp ((10.0 * tmpvar_24), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_22.x) * 0.5) * (spec.xyz * ((tmpvar_15 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_6 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (((((tmpvar_19.xyz * tmpvar_19.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_20.xyz * tmpvar_20.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Vector 32 [_MainTex_ST]
"vs_3_0
; 97 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c33, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c14.w
dp4 r0.x, v0, c5
add r1, -r0.x, c18
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c17
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c33.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c19
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c20
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c33.x
dp4 r2.z, r4, c27
dp4 r2.y, r4, c26
dp4 r2.x, r4, c25
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c33.y
mul r0, r0, r1
mul r1.xyz, r0.y, c22
mad r1.xyz, r0.x, c21, r1
mad r0.xyz, r0.z, c23, r1
mad r1.xyz, r0.w, c24, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c30
dp4 r3.y, r0, c29
dp4 r3.x, r0, c28
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c31
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add o7.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1.w, c33.x
mov r1.xyz, c15
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c16, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c14.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c14.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c14.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c33.z
mul r1.y, r1, c12.x
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov o8.zw, r0
mad o1.xy, v3, c32, c32.zwzw
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_glesVertex.xyz - ((_World2Object * tmpvar_9).xyz * unity_Scale.w)));
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_13 * v_i0_i1.xyz);
  tmpvar_14.w = tmpvar_11.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_3 = tmpvar_15;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_13 * v_i0_i1_i2.xyz);
  tmpvar_16.w = tmpvar_11.y;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_4 = tmpvar_17;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_18;
  tmpvar_18.xyz = (tmpvar_13 * v_i0_i1_i2_i3.xyz);
  tmpvar_18.w = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * unity_Scale.w);
  tmpvar_5 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_21;
  mediump vec3 tmpvar_25;
  mediump vec4 normal;
  normal = tmpvar_24;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal);
  x1.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal);
  x1.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal);
  x1.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC);
  x3 = tmpvar_34;
  tmpvar_25 = ((x1 + x2) + x3);
  shlight = tmpvar_25;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosX0 - tmpvar_35.x);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosY0 - tmpvar_35.y);
  highp vec4 tmpvar_38;
  tmpvar_38 = (unity_4LightPosZ0 - tmpvar_35.z);
  highp vec4 tmpvar_39;
  tmpvar_39 = (((tmpvar_36 * tmpvar_36) + (tmpvar_37 * tmpvar_37)) + (tmpvar_38 * tmpvar_38));
  highp vec4 tmpvar_40;
  tmpvar_40 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_36 * tmpvar_21.x) + (tmpvar_37 * tmpvar_21.y)) + (tmpvar_38 * tmpvar_21.z)) * inversesqrt (tmpvar_39))) * (1.0/((1.0 + (tmpvar_39 * unity_4LightAtten0)))));
  highp vec3 tmpvar_41;
  tmpvar_41 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_40.x) + (unity_LightColor[1].xyz * tmpvar_40.y)) + (unity_LightColor[2].xyz * tmpvar_40.z)) + (unity_LightColor[3].xyz * tmpvar_40.w)));
  tmpvar_7 = tmpvar_41;
  highp vec4 o_i0;
  highp vec4 tmpvar_42;
  tmpvar_42 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_42;
  highp vec2 tmpvar_43;
  tmpvar_43.x = tmpvar_42.x;
  tmpvar_43.y = (tmpvar_42.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_43 + tmpvar_42.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_13 * (((_World2Object * tmpvar_23).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_14;
  tmpvar_9 = N;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_16 * (tmpvar_16 * tmpvar_16)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_17;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - spec.w);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - (tmpvar_18 * tmpvar_18));
  tmpvar_17 = ((7.0 + tmpvar_19) - (shininess * tmpvar_19));
  mediump float tmpvar_20;
  tmpvar_20 = pow (2.0, (8.0 - tmpvar_17));
  highp float gloss;
  gloss = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_22.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_22.z = dot (tmpvar_4, tmpvar_9);
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_17;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = reflect (tmpvar_1, tmpvar_22);
  tmpvar_23.w = glossLod_i0_i1;
  lookup = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25.x = dot (tmpvar_2, N);
  tmpvar_25.y = dot (tmpvar_3, N);
  tmpvar_25.z = dot (tmpvar_4, N);
  N = tmpvar_25;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_DiffCubeIBL, tmpvar_25);
  diff_i0 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (glow.w * _EmissionLM);
  glow.w = tmpvar_30;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  lowp float tmpvar_31;
  tmpvar_31 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_32;
  mediump float atten_i0;
  atten_i0 = tmpvar_31;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_9, lightDir), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_33) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_9, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = vec3(pow (specRefl, tmpvar_20));
  spec_i0_i1 = tmpvar_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_33), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_36;
  frag.xyz = (frag.xyz + (tmpvar_36 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_38;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_glesVertex.xyz - ((_World2Object * tmpvar_9).xyz * unity_Scale.w)));
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_13 * v_i0_i1.xyz);
  tmpvar_14.w = tmpvar_11.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_3 = tmpvar_15;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_13 * v_i0_i1_i2.xyz);
  tmpvar_16.w = tmpvar_11.y;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_4 = tmpvar_17;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_18;
  tmpvar_18.xyz = (tmpvar_13 * v_i0_i1_i2_i3.xyz);
  tmpvar_18.w = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * unity_Scale.w);
  tmpvar_5 = tmpvar_19;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_21;
  mediump vec3 tmpvar_25;
  mediump vec4 normal;
  normal = tmpvar_24;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal);
  x1.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal);
  x1.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal);
  x1.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC);
  x3 = tmpvar_34;
  tmpvar_25 = ((x1 + x2) + x3);
  shlight = tmpvar_25;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosX0 - tmpvar_35.x);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosY0 - tmpvar_35.y);
  highp vec4 tmpvar_38;
  tmpvar_38 = (unity_4LightPosZ0 - tmpvar_35.z);
  highp vec4 tmpvar_39;
  tmpvar_39 = (((tmpvar_36 * tmpvar_36) + (tmpvar_37 * tmpvar_37)) + (tmpvar_38 * tmpvar_38));
  highp vec4 tmpvar_40;
  tmpvar_40 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_36 * tmpvar_21.x) + (tmpvar_37 * tmpvar_21.y)) + (tmpvar_38 * tmpvar_21.z)) * inversesqrt (tmpvar_39))) * (1.0/((1.0 + (tmpvar_39 * unity_4LightAtten0)))));
  highp vec3 tmpvar_41;
  tmpvar_41 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_40.x) + (unity_LightColor[1].xyz * tmpvar_40.y)) + (unity_LightColor[2].xyz * tmpvar_40.z)) + (unity_LightColor[3].xyz * tmpvar_40.w)));
  tmpvar_7 = tmpvar_41;
  highp vec4 o_i0;
  highp vec4 tmpvar_42;
  tmpvar_42 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_42;
  highp vec2 tmpvar_43;
  tmpvar_43.x = tmpvar_42.x;
  tmpvar_43.y = (tmpvar_42.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_43 + tmpvar_42.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_13 * (((_World2Object * tmpvar_23).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  mediump vec3 tmpvar_10;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (diff * _Color);
  diff = tmpvar_12;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (N);
  tmpvar_9 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_15;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_16;
  tmpvar_16 = (1.0 - clamp (dot (tmpvar_14, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17.x = 1.0;
  tmpvar_17.y = tmpvar_16;
  tmpvar_17.z = ((tmpvar_16 * tmpvar_16) * tmpvar_16);
  p = tmpvar_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = (1.0 - fresnel_i0);
  tmpvar_18.y = fresnel_i0;
  p.x = dot (tmpvar_17.xy, tmpvar_18);
  p.y = dot (p.yz, tmpvar_18);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_18))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_19;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - spec.w);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - (tmpvar_20 * tmpvar_20));
  tmpvar_19 = ((7.0 + tmpvar_21) - (shininess * tmpvar_21));
  mediump float tmpvar_22;
  tmpvar_22 = pow (2.0, (8.0 - tmpvar_19));
  highp float gloss;
  gloss = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_10 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24.x = dot (tmpvar_2, tmpvar_9);
  tmpvar_24.y = dot (tmpvar_3, tmpvar_9);
  tmpvar_24.z = dot (tmpvar_4, tmpvar_9);
  highp vec3 tmpvar_25;
  tmpvar_25 = reflect (tmpvar_1, tmpvar_24);
  vec4 v_i0;
  v_i0.x = _SkyMatrix[0].x;
  v_i0.y = _SkyMatrix[1].x;
  v_i0.z = _SkyMatrix[2].x;
  v_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1;
  v_i0_i1.x = _SkyMatrix[0].y;
  v_i0_i1.y = _SkyMatrix[1].y;
  v_i0_i1.z = _SkyMatrix[2].y;
  v_i0_i1.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _SkyMatrix[0].z;
  v_i0_i1_i2.y = _SkyMatrix[1].z;
  v_i0_i1_i2.z = _SkyMatrix[2].z;
  v_i0_i1_i2.w = _SkyMatrix[3].z;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_19;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((v_i0.xyz * tmpvar_25.x) + ((v_i0_i1.xyz * tmpvar_25.y) + (v_i0_i1_i2.xyz * tmpvar_25.z)));
  tmpvar_26.w = glossLod_i0_i1;
  lookup = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_27;
  highp vec3 tmpvar_28;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  tmpvar_28 = ((v_i0_i0.xyz * dot (tmpvar_2, tmpvar_14)) + ((v_i0_i1_i0.xyz * dot (tmpvar_3, tmpvar_14)) + (v_i0_i1_i2_i0.xyz * dot (tmpvar_4, tmpvar_14))));
  N = tmpvar_28;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_DiffCubeIBL, tmpvar_28);
  diff_i0 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (glow.w * _EmissionLM);
  glow.w = tmpvar_33;
  glow.xyz = (glow.xyz + (tmpvar_13 * glow.w));
  lowp float tmpvar_34;
  tmpvar_34 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD5;
  mediump vec3 viewDir;
  viewDir = tmpvar_35;
  mediump float atten_i0;
  atten_i0 = tmpvar_34;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_36;
  tmpvar_36 = normalize (lightDir);
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_9, tmpvar_36), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_37) * tmpvar_13) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_9, normalize ((viewDir + tmpvar_36))), 0.0, 1.0);
  specRefl = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = vec3(pow (specRefl, tmpvar_22));
  spec_i0_i1 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_37), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_40;
  frag.xyz = (frag.xyz + (tmpvar_40 * tmpvar_10));
  c = frag;
  mediump vec3 tmpvar_41;
  tmpvar_41 = (c.xyz + (tmpvar_13 * xlv_TEXCOORD6));
  c.xyz = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = (c.xyz + (((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_42;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   d3d9 - ALU: 73 to 110, TEX: 7 to 9
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
Vector 11 [_GlowColor]
Float 12 [_GlowStrength]
Float 13 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_SpecCubeIBL] CUBE
SetTexture 4 [_DiffCubeIBL] CUBE
SetTexture 5 [_Illum] 2D
"ps_3_0
; 108 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
def c14, 2.00000000, -1.00000000, 7.00000000, 8.00000000
def c15, 10.00000000, 1.00000000, 0.95019531, 0.04998779
def c16, 0.15915494, 0.31830987, 0.50000000, 0
def c17, 0.75341797, 0.24682617, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c14.x, c14.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c15.y
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r2.xyz, r1.x, v1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
dp3_sat r0.x, r1, r2
add r1.w, -r0.x, c15.y
mul_pp r0.x, r1.w, r1.w
mul_pp r2.y, r1.w, r0.x
mov_pp r0.x, c10
add_pp r0.x, c15.y, -r0
mov_pp r0.y, c10.x
mov_pp r2.x, r1.w
mul_pp r2.xy, r2, r0
mov_pp r0.w, r1
mov_pp r0.z, c15.y
mul_pp r0.zw, r0.xyxy, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r2.x, r2.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r1.w, r0.x, r0.y
texld r0, v0, s2
mad_pp r1.w, r1, c15.z, c15
mul_pp r1.w, r1, c8.x
mul_pp r4.xyz, r1.w, c5
add_pp r0.w, -r0, c15.y
mad_pp r0.w, -r0, r0, c15.y
mad_pp r0.w, -r0, c9.x, r0
add_pp r0.w, r0, c14.z
dp3_pp r1.w, v5, v5
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, v5
dp3_pp r2.x, v1, v1
rsq_pp r1.w, r2.x
mad_pp r5.xyz, r1.w, v1, r3
add_pp r3.w, -r0, c14
pow_pp r2, c14.x, r3.w
dp3_pp r1.w, r5, r5
rsq_pp r1.w, r1.w
mul_pp r5.xyz, r1.w, r5
dp3_pp_sat r3.w, r1, r5
mov_pp r1.w, r2.x
pow r2, r3.w, r1.w
dp3_pp_sat r4.w, r1, r3
mul_pp_sat r2.y, r4.w, c15.x
mul_pp r2.w, r2.x, r2.y
mul_pp r2.xyz, r4, c6.w
mul_pp r4.xyz, r0, r2
mad r1.w, r1, c16.x, c16.y
mul_pp r2.xyz, r4, r1.w
mul_pp r0.xyz, r2.w, c4
mul_pp r0.xyz, r0, r2
texld r2, v0, s0
mul_pp r2, r2, c7
dp3_pp r1.w, r1, v2
dp3_pp r3.xw, r1, v3
dp3_pp r5.xw, r1, v4
mov_pp r1.y, r5.x
mov_pp r1.x, r3
mul_pp r2.xyz, r2, c6.w
mul_pp r3.xyz, r2, r2.w
mov r5.x, v2.w
mov r5.z, v4.w
mov r5.y, v3.w
dp3 r1.z, r1.wxyw, r5
mul r1.xyz, r1.wxyw, r1.z
mad r6.xyz, -r1, c14.x, r5
mul_pp r5.xyz, r3, r4.w
mul r1.xyz, r6.z, c2
mul_pp r0.xyz, r0, c16.z
mul_pp r5.xyz, r5, c4
mad_pp r5.xyz, r5, c14.x, r0
mad r0.xyz, r6.y, c1, r1
mad r0.xyz, r6.x, c0, r0
texldl r0, r0, s3
mul_pp r6.x, r0.w, r0.w
mul_pp r6.y, r0.w, r6.x
mul r1.xyz, r5.w, c2
mad r1.xyz, r3.w, c1, r1
mad r1.xyz, r1.w, c0, r1
texld r1, r1, s4
mul_pp r6.z, r1.w, r1.w
mul_pp r6.w, r1, r6.z
mul_pp r6.xy, r6, c17
add_pp r0.w, r6.x, r6.y
mul_pp r0.xyz, r0, r0.w
mul_pp r6.zw, r6, c17.xyxy
add_pp r1.w, r6.z, r6
mul_pp r1.xyz, r1, r1.w
mul_pp r2.xyz, r2, r1
texld r1, v0, s5
mul_pp r0.xyz, r4, r0
mul_pp r2.xyz, r2, c6.x
mad_pp r2.xyz, r0, c6.y, r2
mul_pp r0.w, r1, c13.x
mul_pp r1.xyz, r1, c11
mul_pp r0.xyz, r3, r0.w
mad_pp r0.xyz, r1, c12.x, r0
mad_pp r0.xyz, r0, c6.w, r2
mad_pp r1.xyz, r3, v6, r5
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, r2
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 4 [_SpecColor]
Vector 5 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 6 [_Color]
Float 7 [_SpecInt]
Float 8 [_Shininess]
Float 9 [_Fresnel]
Vector 10 [_GlowColor]
Float 11 [_GlowStrength]
Float 12 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_SpecCubeIBL] CUBE
SetTexture 4 [_DiffCubeIBL] CUBE
SetTexture 5 [_Illum] 2D
SetTexture 6 [unity_Lightmap] 2D
"ps_3_0
; 79 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
def c13, 2.00000000, -1.00000000, 7.00000000, 1.00000000
def c14, 0.75341797, 0.24682617, 0.95019531, 0.04998779
def c15, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c13.x, c13.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c13.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
dp3_pp r3.xw, r1, v4
dp3 r1.w, v1, v1
dp3_pp r4.x, v2, r1
dp3_pp r4.yw, r1, v3
mov_pp r4.z, r3.x
texld r2, v0, s2
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r0.w, r4, r0
mul r3.xyz, r4, r0.w
mad r0.xyz, -r3, c13.x, r0
mul r3.xyz, r0.z, c2
add_pp r0.w, -r2, c13
mad_pp r0.z, -r0.w, r0.w, c13.w
mad_pp r0.w, -r0.z, c8.x, r0.z
mad r3.xyz, r0.y, c1, r3
mad r0.xyz, r0.x, c0, r3
rsq r1.w, r1.w
add_pp r0.w, r0, c13.z
texldl r0, r0, s3
mul_pp r4.y, r0.w, r0.w
mul r3.xyz, r1.w, v1
mul_pp r4.z, r0.w, r4.y
dp3_sat r0.w, r1, r3
add r1.w, -r0, c13
mul_pp r1.xy, r4.yzzw, c14
add_pp r0.w, r1.x, r1.y
mul_pp r1.xyz, r0, r0.w
mul_pp r2.w, r1, r1
mov_pp r0.x, c9
add_pp r0.x, c13.w, -r0
mov_pp r0.y, c9.x
mul_pp r0.w, r1, r2
mov_pp r0.z, r1.w
mul_pp r0.zw, r0, r0.xyxy
mov_pp r3.y, r1.w
mov_pp r3.x, c13.w
mul_pp r3.xy, r0, r3
add_pp r3.x, r3, r3.y
add_pp r3.y, r0.z, r0.w
mul_pp r3.xy, r3, r0
add_pp r0.w, r3.x, r3.y
mad_pp r0.w, r0, c14.z, c14
mul_pp r1.w, r0, c7.x
mul_pp r3.xyz, r1.w, c4
mul r0.xyz, r3.w, c2
mad r0.xyz, r4.w, c1, r0
mad r0.xyz, r4.x, c0, r0
texld r0, r0, s4
mul_pp r4.x, r0.w, r0.w
mul_pp r4.y, r0.w, r4.x
mul_pp r4.xy, r4, c14
add_pp r0.w, r4.x, r4.y
mul_pp r3.xyz, r3, c5.w
mul_pp r3.xyz, r2, r3
mul_pp r3.xyz, r1, r3
texld r1, v0, s5
mul_pp r4.xyz, r0, r0.w
texld r2, v0, s0
mul_pp r2, r2, c6
mul_pp r0.xyz, r2, c5.w
mul_pp r2.xyz, r0, r4
mul_pp r2.xyz, r2, c5.x
mad_pp r2.xyz, r3, c5.y, r2
mul_pp r3.xyz, r0, r2.w
mul_pp r0.w, r1, c12.x
mul_pp r4.xyz, r3, r0.w
texld r0, v5, s6
mul_pp r1.xyz, r1, c10
mad_pp r1.xyz, r1, c11.x, r4
mul_pp r0.xyz, r0.w, r0
mad_pp r1.xyz, r1, c5.w, r2
mul_pp r0.xyz, r0, r3
mad_pp oC0.xyz, r0, c15.x, r1
mov_pp oC0.w, r2
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
Vector 11 [_GlowColor]
Float 12 [_GlowStrength]
Float 13 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_SpecCubeIBL] CUBE
SetTexture 4 [_DiffCubeIBL] CUBE
SetTexture 5 [_Illum] 2D
SetTexture 6 [_ShadowMapTexture] 2D
"ps_3_0
; 110 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
def c14, 2.00000000, -1.00000000, 7.00000000, 8.00000000
def c15, 10.00000000, 1.00000000, 0.95019531, 0.04998779
def c16, 0.15915494, 0.31830987, 0.50000000, 0
def c17, 0.75341797, 0.24682617, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c14.x, c14.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c15.y
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c15.y
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
dp3_pp r4.w, r2, v2
add_pp r0.x, c15.y, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c15.y
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.y, r0.x, c15.z, c15.w
texld r1, v0, s2
add_pp r0.x, -r1.w, c15.y
mul_pp r0.y, r0, c8.x
mul_pp r4.xyz, r0.y, c5
mad_pp r0.x, -r0, r0, c15.y
mad_pp r0.y, -r0.x, c9.x, r0.x
add_pp r3.w, r0.y, c14.z
dp3_pp r0.x, v5, v5
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v5
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r5.xyz, r0.x, v1, r3
add_pp r2.w, -r3, c14
dp3_pp_sat r6.w, r2, r3
pow_pp r0, c14.x, r2.w
dp3_pp r1.w, r5, r5
rsq_pp r0.y, r1.w
mul_pp r5.xyz, r0.y, r5
dp3_pp_sat r2.w, r2, r5
mov_pp r1.w, r0.x
pow r0, r2.w, r1.w
mul_pp_sat r0.y, r6.w, c15.x
mul_pp r0.w, r0.x, r0.y
mul_pp r0.xyz, r4, c6.w
mul_pp r3.xyz, r1, r0
mad r1.w, r1, c16.x, c16.y
mul_pp r4.xyz, r3, r1.w
dp3_pp r1.yw, r2, v3
dp3_pp r5.xw, r2, v4
texldp r1.x, v7, s6
mul_pp r0.xyz, r0.w, c4
mul_pp r0.xyz, r1.x, r0
mul_pp r0.xyz, r0, r4
mul_pp r6.xyz, r0, c16.z
mov_pp r4.y, r5.x
texld r0, v0, s0
mul_pp r2, r0, c7
mul_pp r0.w, r1.x, r6
mov_pp r4.x, r1.y
mov r5.x, v2.w
mov r5.z, v4.w
mov r5.y, v3.w
dp3 r1.y, r4.wxyw, r5
mul r4.xyz, r4.wxyw, r1.y
mad r0.xyz, -r4, c14.x, r5
mul_pp r5.xyz, r2, c6.w
mul_pp r4.xyz, r5, r2.w
mul_pp r2.xyz, r4, r0.w
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mul_pp r2.xyz, r2, c4
mad_pp r2.xyz, r2, c14.x, r6
mul r6.xyz, r5.w, c2
mad r1.xyz, r0.x, c0, r1
mad r0.xyz, r1.w, c1, r6
mov_pp r1.w, r3
texldl r1, r1, s3
mul_pp r6.x, r1.w, r1.w
mul_pp r6.y, r1.w, r6.x
mad r0.xyz, r4.w, c0, r0
texld r0, r0, s4
mul_pp r6.z, r0.w, r0.w
mul_pp r6.w, r0, r6.z
mul_pp r6.xy, r6, c17
add_pp r0.w, r6.x, r6.y
mul_pp r1.xyz, r1, r0.w
mul_pp r6.zw, r6, c17.xyxy
add_pp r1.w, r6.z, r6
mul_pp r1.xyz, r3, r1
mul_pp r0.xyz, r0, r1.w
mul_pp r3.xyz, r5, r0
texld r0, v0, s5
mul_pp r3.xyz, r3, c6.x
mad_pp r3.xyz, r1, c6.y, r3
mul_pp r0.w, r0, c13.x
mul_pp r1.xyz, r4, r0.w
mul_pp r0.xyz, r0, c11
mad_pp r0.xyz, r0, c12.x, r1
mad_pp r0.xyz, r0, c6.w, r3
mad_pp r1.xyz, r4, v6, r2
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, r2
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 4 [_SpecColor]
Vector 5 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 6 [_Color]
Float 7 [_SpecInt]
Float 8 [_Shininess]
Float 9 [_Fresnel]
Vector 10 [_GlowColor]
Float 11 [_GlowStrength]
Float 12 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_SpecCubeIBL] CUBE
SetTexture 4 [_DiffCubeIBL] CUBE
SetTexture 5 [_Illum] 2D
SetTexture 6 [_ShadowMapTexture] 2D
SetTexture 7 [unity_Lightmap] 2D
"ps_3_0
; 84 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
dcl_2d s7
def c13, 8.00000000, 2.00000000, -1.00000000, 7.00000000
def c14, 0.75341797, 0.24682617, 1.00000000, 0
def c15, 0.95019531, 0.04998779, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c13.y, c13.z
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c14
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r3.xw, r2, v4
dp3_pp r4.x, v2, r2
dp3_pp r4.yw, r2, v3
mov_pp r4.z, r3.x
mov r1.x, v2.w
mov r1.z, v4.w
mov r1.y, v3.w
dp3 r0.x, r4, r1
mul r3.xyz, r4, r0.x
mad r1.xyz, -r3, c13.y, r1
texld r0, v0, s2
mul r3.xyz, r1.z, c2
mad r3.xyz, r1.y, c1, r3
add_pp r0.w, -r0, c14.z
mad_pp r0.w, -r0, r0, c14.z
mad_pp r0.w, -r0, c8.x, r0
add_pp r1.w, r0, c13
mad r1.xyz, r1.x, c0, r3
texldl r1, r1, s3
mul_pp r4.y, r1.w, r1.w
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r3.xyz, r0.w, v1
dp3_sat r0.w, r2, r3
add r0.w, -r0, c14.z
mul_pp r4.z, r1.w, r4.y
mul_pp r2.xy, r4.yzzw, c14
add_pp r1.w, r2.x, r2.y
mul_pp r2.xyz, r1, r1.w
mul_pp r2.w, r0, r0
mov_pp r1.x, c9
add_pp r1.x, c14.z, -r1
mov_pp r1.y, c9.x
mul_pp r1.w, r0, r2
mov_pp r1.z, r0.w
mul_pp r1.zw, r1, r1.xyxy
mov_pp r3.y, r0.w
mov_pp r3.x, c14.z
mul_pp r3.xy, r1, r3
add_pp r3.x, r3, r3.y
add_pp r3.y, r1.z, r1.w
mul_pp r3.xy, r3, r1
add_pp r0.w, r3.x, r3.y
mul r1.xyz, r3.w, c2
mad r1.xyz, r4.w, c1, r1
mad r1.xyz, r4.x, c0, r1
texld r1, r1, s4
mul_pp r4.x, r1.w, r1.w
mul_pp r4.y, r1.w, r4.x
mul_pp r4.xy, r4, c14
add_pp r1.w, r4.x, r4.y
mad_pp r0.w, r0, c15.x, c15.y
mul_pp r0.w, r0, c7.x
mul_pp r3.xyz, r0.w, c4
mul_pp r3.xyz, r3, c5.w
mul_pp r3.xyz, r0, r3
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r0, c5.w
mul_pp r1.xyz, r0, r1
mul_pp r2.xyz, r2, r3
mul_pp r3.xyz, r1, c5.x
texld r1, v0, s5
mad_pp r2.xyz, r2, c5.y, r3
mul_pp r1.w, r1, c12.x
mul_pp r0.xyz, r0, r0.w
mul_pp r3.xyz, r0, r1.w
mul_pp r1.xyz, r1, c10
mad_pp r1.xyz, r1, c11.x, r3
mad_pp r2.xyz, r1, c5.w, r2
texld r1, v5, s7
mul_pp r3.xyz, r1.w, r1
texldp r4.x, v6, s6
mul_pp r1.xyz, r1, r4.x
mul_pp r3.xyz, r3, c13.x
mul_pp r1.xyz, r1, c13.y
mul_pp r4.xyz, r3, r4.x
min_pp r1.xyz, r3, r1
max_pp r1.xyz, r1, r4
mad_pp oC0.xyz, r0, r1, r2
mov_pp oC0.w, r0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
Vector 11 [_GlowColor]
Float 12 [_GlowStrength]
Float 13 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_SpecCubeIBL] CUBE
SetTexture 4 [_DiffCubeIBL] CUBE
SetTexture 5 [_Illum] 2D
"ps_3_0
; 102 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
def c14, 2.00000000, -1.00000000, 7.00000000, 8.00000000
def c15, 10.00000000, 1.00000000, 0.95019531, 0.04998779
def c16, 0.15915494, 0.31830987, 0.50000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c14.x, c14.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c15.y
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r2.xyz, r1.x, v1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
dp3_sat r0.x, r1, r2
add r1.w, -r0.x, c15.y
mul_pp r0.x, r1.w, r1.w
mul_pp r2.y, r1.w, r0.x
mov_pp r0.x, c10
add_pp r0.x, c15.y, -r0
mov_pp r0.y, c10.x
mov_pp r2.x, r1.w
mul_pp r2.xy, r2, r0
mov_pp r0.w, r1
mov_pp r0.z, c15.y
mul_pp r0.zw, r0.xyxy, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r2.x, r2.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c15.z, c15.w
mul_pp r1.w, r0.x, c8.x
texld r0, v0, s2
rsq_pp r1.w, r1.w
rcp_pp r1.w, r1.w
mul_pp r4.xyz, r1.w, c5
add_pp r0.w, -r0, c15.y
mad_pp r0.w, -r0, r0, c15.y
mad_pp r0.w, -r0, c9.x, r0
add_pp r0.w, r0, c14.z
dp3_pp r1.w, v5, v5
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, v5
dp3_pp r2.x, v1, v1
rsq_pp r1.w, r2.x
mad_pp r5.xyz, r1.w, v1, r3
add_pp r3.w, -r0, c14
pow_pp r2, c14.x, r3.w
dp3_pp r1.w, r5, r5
rsq_pp r1.w, r1.w
mul_pp r5.xyz, r1.w, r5
dp3_pp_sat r3.w, r1, r5
mov_pp r1.w, r2.x
pow r2, r3.w, r1.w
dp3_pp_sat r4.w, r1, r3
mul_pp_sat r2.y, r4.w, c15.x
mul_pp r2.w, r2.x, r2.y
mul_pp r2.xyz, r4, c6.w
mul_pp r4.xyz, r0, r2
mad r1.w, r1, c16.x, c16.y
mul_pp r2.xyz, r4, r1.w
mul_pp r0.xyz, r2.w, c4
mul_pp r0.xyz, r0, r2
texld r2, v0, s0
mul_pp r2, r2, c7
dp3_pp r1.w, r1, v2
dp3_pp r3.xw, r1, v3
dp3_pp r5.xw, r1, v4
mov_pp r1.y, r5.x
mov_pp r1.x, r3
mul_pp r2.xyz, r2, c6.w
mul_pp r3.xyz, r2, r2.w
mov r5.x, v2.w
mov r5.z, v4.w
mov r5.y, v3.w
dp3 r1.z, r1.wxyw, r5
mul r1.xyz, r1.wxyw, r1.z
mad r6.xyz, -r1, c14.x, r5
mul_pp r5.xyz, r3, r4.w
mul_pp r0.xyz, r0, c16.z
mul_pp r5.xyz, r5, c4
mul r1.xyz, r6.z, c2
mad_pp r5.xyz, r5, c14.x, r0
mad r0.xyz, r6.y, c1, r1
mul r1.xyz, r5.w, c2
mad r0.xyz, r6.x, c0, r0
texldl r0, r0, s3
mul_pp r0.xyz, r0, r0.w
mad r1.xyz, r3.w, c1, r1
mad r1.xyz, r1.w, c0, r1
texld r1, r1, s4
mul_pp r1.xyz, r1, r1.w
mul_pp r2.xyz, r2, r1
texld r1, v0, s5
mul_pp r0.xyz, r4, r0
mul_pp r2.xyz, r2, c6.x
mad_pp r2.xyz, r0, c6.y, r2
mul_pp r0.w, r1, c13.x
mul_pp r1.xyz, r1, c11
mul_pp r0.xyz, r3, r0.w
mad_pp r0.xyz, r1, c12.x, r0
mad_pp r0.xyz, r0, c6.w, r2
mad_pp r1.xyz, r3, v6, r5
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, r2
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 4 [_SpecColor]
Vector 5 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 6 [_Color]
Float 7 [_SpecInt]
Float 8 [_Shininess]
Float 9 [_Fresnel]
Vector 10 [_GlowColor]
Float 11 [_GlowStrength]
Float 12 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_SpecCubeIBL] CUBE
SetTexture 4 [_DiffCubeIBL] CUBE
SetTexture 5 [_Illum] 2D
SetTexture 6 [unity_Lightmap] 2D
"ps_3_0
; 73 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
def c13, 2.00000000, -1.00000000, 7.00000000, 1.00000000
def c14, 0.95019531, 0.04998779, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c13.x, c13.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
dp3 r3.x, v1, v1
rsq r3.w, r3.x
add_pp r0.z, r0, c13.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r1.xw, r2, v4
mov_pp r0.z, r1.x
dp3_pp r0.yw, r2, v3
dp3_pp r0.x, v2, r2
mul r4.xyz, r3.w, v1
mov r1.x, v2.w
mov r1.z, v4.w
mov r1.y, v3.w
dp3 r2.w, r0, r1
mul r3.xyz, r0, r2.w
dp3_sat r0.y, r2, r4
mad r1.xyz, -r3, c13.x, r1
add r0.y, -r0, c13.w
mul r2.xyz, r1.z, c2
mad r2.xyz, r1.y, c1, r2
mul_pp r0.z, r0.y, r0.y
mul_pp r1.y, r0, r0.z
mad r2.xyz, r1.x, c0, r2
mov_pp r0.z, c9.x
add_pp r4.x, c13.w, -r0.z
mov_pp r4.y, c9.x
mov_pp r1.x, r0.y
mul_pp r1.xy, r1, r4
mov_pp r3.y, r0
mov_pp r3.x, c13.w
mul_pp r3.xy, r4, r3
add_pp r1.y, r1.x, r1
add_pp r1.x, r3, r3.y
mul_pp r1.xy, r1, r4
add_pp r0.z, r1.x, r1.y
texld r3, v0, s2
add_pp r0.y, -r3.w, c13.w
mul r1.xyz, r1.w, c2
mad r1.xyz, r0.w, c1, r1
mad r1.xyz, r0.x, c0, r1
texld r1, r1, s4
mad_pp r0.y, -r0, r0, c13.w
mad_pp r0.y, -r0, c8.x, r0
add_pp r2.w, r0.y, c13.z
mad_pp r0.z, r0, c14.x, c14.y
mul_pp r0.z, r0, c7.x
rsq_pp r0.y, r0.z
rcp_pp r0.y, r0.y
mul_pp r4.xyz, r0.y, c4
mul_pp r4.xyz, r4, c5.w
texldl r2, r2, s3
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r3.xyz, r3, r4
mul_pp r2.xyz, r2, r2.w
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r0, c5.w
mul_pp r1.xyz, r0, r1
mul_pp r2.xyz, r2, r3
mul_pp r3.xyz, r1, c5.x
texld r1, v0, s5
mad_pp r2.xyz, r2, c5.y, r3
texld r3, v5, s6
mul_pp r0.xyz, r0, r0.w
mul_pp r1.w, r1, c12.x
mul_pp r4.xyz, r0, r1.w
mul_pp r1.xyz, r1, c10
mad_pp r1.xyz, r1, c11.x, r4
mul_pp r3.xyz, r3.w, r3
mad_pp r1.xyz, r1, c5.w, r2
mul_pp r0.xyz, r3, r0
mad_pp oC0.xyz, r0, c14.z, r1
mov_pp oC0.w, r0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
Vector 11 [_GlowColor]
Float 12 [_GlowStrength]
Float 13 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_SpecCubeIBL] CUBE
SetTexture 4 [_DiffCubeIBL] CUBE
SetTexture 5 [_Illum] 2D
SetTexture 6 [_ShadowMapTexture] 2D
"ps_3_0
; 104 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
def c14, 2.00000000, -1.00000000, 7.00000000, 8.00000000
def c15, 10.00000000, 1.00000000, 0.95019531, 0.04998779
def c16, 0.15915494, 0.31830987, 0.50000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c14.x, c14.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c15.y
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c15.y
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c15.y, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c15.y
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c15.z, c15.w
mul_pp r0.x, r0, c8
rsq_pp r0.y, r0.x
texld r1, v0, s2
add_pp r0.x, -r1.w, c15.y
rcp_pp r0.y, r0.y
mul_pp r4.xyz, r0.y, c5
mad_pp r0.x, -r0, r0, c15.y
mad_pp r0.y, -r0.x, c9.x, r0.x
add_pp r3.w, r0.y, c14.z
dp3_pp r0.x, v5, v5
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v5
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r5.xyz, r0.x, v1, r3
add_pp r2.w, -r3, c14
dp3_pp_sat r6.w, r2, r3
pow_pp r0, c14.x, r2.w
dp3_pp r1.w, r5, r5
rsq_pp r0.y, r1.w
mul_pp r5.xyz, r0.y, r5
dp3_pp_sat r2.w, r2, r5
mov_pp r1.w, r0.x
pow r0, r2.w, r1.w
mul_pp_sat r0.y, r6.w, c15.x
mul_pp r0.w, r0.x, r0.y
mul_pp r0.xyz, r4, c6.w
mul_pp r3.xyz, r1, r0
dp3_pp r5.xw, r2, v4
mad r1.w, r1, c16.x, c16.y
mul_pp r4.xyz, r3, r1.w
dp3_pp r1.w, r2, v2
mov_pp r1.z, r5.x
texldp r1.x, v7, s6
mul_pp r0.xyz, r0.w, c4
mul_pp r0.xyz, r1.x, r0
mul_pp r0.xyz, r0, r4
dp3_pp r4.xw, r2, v3
mov_pp r1.y, r4.x
mul_pp r6.xyz, r0, c16.z
mov r4.x, v2.w
mov r4.z, v4.w
mov r4.y, v3.w
dp3 r2.x, r1.wyzw, r4
mul r5.xyz, r1.wyzw, r2.x
texld r0, v0, s0
mul_pp r2, r0, c7
mad r0.xyz, -r5, c14.x, r4
mul_pp r5.xyz, r2, c6.w
mul_pp r0.w, r1.x, r6
mul_pp r4.xyz, r5, r2.w
mul_pp r2.xyz, r4, r0.w
mul_pp r2.xyz, r2, c4
mul r1.xyz, r0.z, c2
mad_pp r2.xyz, r2, c14.x, r6
mad r6.xyz, r0.y, c1, r1
mul r1.xyz, r5.w, c2
mad r1.xyz, r4.w, c1, r1
mad r1.xyz, r1.w, c0, r1
texld r1, r1, s4
mul_pp r1.xyz, r1, r1.w
mul_pp r1.xyz, r5, r1
mul_pp r1.xyz, r1, c6.x
mad r0.xyz, r0.x, c0, r6
mov_pp r0.w, r3
texldl r0, r0, s3
mul_pp r0.xyz, r0, r0.w
mul_pp r3.xyz, r3, r0
texld r0, v0, s5
mad_pp r3.xyz, r3, c6.y, r1
mul_pp r0.w, r0, c13.x
mul_pp r1.xyz, r4, r0.w
mul_pp r0.xyz, r0, c11
mad_pp r0.xyz, r0, c12.x, r1
mad_pp r0.xyz, r0, c6.w, r3
mad_pp r1.xyz, r4, v6, r2
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, r2
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 4 [_SpecColor]
Vector 5 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 6 [_Color]
Float 7 [_SpecInt]
Float 8 [_Shininess]
Float 9 [_Fresnel]
Vector 10 [_GlowColor]
Float 11 [_GlowStrength]
Float 12 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_SpecCubeIBL] CUBE
SetTexture 4 [_DiffCubeIBL] CUBE
SetTexture 5 [_Illum] 2D
SetTexture 6 [_ShadowMapTexture] 2D
SetTexture 7 [unity_Lightmap] 2D
"ps_3_0
; 78 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
dcl_cube s4
dcl_2d s5
dcl_2d s6
dcl_2d s7
def c13, 8.00000000, 2.00000000, -1.00000000, 7.00000000
def c14, 1.00000000, 0.95019531, 0.04998779, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
dcl_texcoord6 v6
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c13.y, c13.z
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
dp3 r3.x, v1, v1
rsq r3.w, r3.x
add_pp r0.z, r0, c14.x
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r0.xw, r2, v3
mov_pp r1.y, r0.x
dp3_pp r1.zw, r2, v4
mul r4.xyz, r3.w, v1
dp3_pp r1.x, v2, r2
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r2.w, r1, r0
mul r3.xyz, r1, r2.w
mad r0.xyz, -r3, c13.y, r0
dp3_sat r1.y, r2, r4
mul r2.xyz, r0.z, c2
add r0.z, -r1.y, c14.x
mad r2.xyz, r0.y, c1, r2
mul_pp r0.y, r0.z, r0.z
mad r2.xyz, r0.x, c0, r2
mov_pp r1.y, c9.x
add_pp r4.x, c14, -r1.y
mov_pp r4.y, c9.x
mul_pp r0.y, r0.z, r0
mov_pp r0.x, r0.z
mul_pp r0.xy, r0, r4
mov_pp r3.y, r0.z
mov_pp r3.x, c14
mul_pp r3.xy, r4, r3
add_pp r0.y, r0.x, r0
add_pp r0.x, r3, r3.y
mul_pp r0.xy, r0, r4
texld r3, v0, s2
add_pp r0.y, r0.x, r0
add_pp r0.z, -r3.w, c14.x
mad_pp r0.x, -r0.z, r0.z, c14
mad_pp r0.x, -r0, c8, r0
add_pp r2.w, r0.x, c13
mad_pp r0.y, r0, c14, c14.z
mul_pp r0.y, r0, c7.x
rsq_pp r0.x, r0.y
rcp_pp r0.x, r0.x
mul_pp r4.xyz, r0.x, c4
mul_pp r4.xyz, r4, c5.w
mul_pp r3.xyz, r3, r4
mul r0.xyz, r1.w, c2
mad r0.xyz, r0.w, c1, r0
mad r1.xyz, r1.x, c0, r0
texld r1, r1, s4
texldl r2, r2, s3
mul_pp r2.xyz, r2, r2.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r0, c5.w
mul_pp r1.xyz, r0, r1
mul_pp r2.xyz, r2, r3
mul_pp r3.xyz, r1, c5.x
texld r1, v0, s5
mad_pp r2.xyz, r2, c5.y, r3
mul_pp r1.w, r1, c12.x
mul_pp r0.xyz, r0, r0.w
mul_pp r3.xyz, r0, r1.w
mul_pp r1.xyz, r1, c10
mad_pp r1.xyz, r1, c11.x, r3
mad_pp r2.xyz, r1, c5.w, r2
texld r1, v5, s7
mul_pp r3.xyz, r1.w, r1
texldp r4.x, v6, s6
mul_pp r1.xyz, r1, r4.x
mul_pp r3.xyz, r3, c13.x
mul_pp r1.xyz, r1, c13.y
mul_pp r4.xyz, r3, r4.x
min_pp r1.xyz, r3, r1
max_pp r1.xyz, r1, r4
mad_pp oC0.xyz, r0, r1, r2
mov_pp oC0.w, r0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 10
//   d3d9 - ALU: 28 to 37
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "POINT" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  float atten;
  atten = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (normalize (xlv_TEXCOORD2));
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c20.x
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_19;
  tmpvar_19 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTexture0, tmpvar_19);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten;
  atten = tmpvar_20.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_21) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_21), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_24;
  frag.xyz = (frag.xyz + (tmpvar_24 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_21;
  tmpvar_21 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_LightTexture0, tmpvar_21);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_20;
  mediump float atten;
  atten = tmpvar_22.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize (lightDir_i0);
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_2, tmpvar_23), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_24) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_2, normalize ((viewDir + tmpvar_23))), 0.0, 1.0);
  specRefl = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_24), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_27;
  frag.xyz = (frag.xyz + (tmpvar_27 * tmpvar_3));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD2);
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_13) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Vector 11 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c12, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c6
dp4 r4.z, c10, r0
mov r0, c5
mov r1.w, c12.x
mov r1.xyz, c9
dp4 r4.y, c10, r0
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r2.xyz, r2, c8.w, -v0
mov r1, c4
dp4 r4.x, c10, r1
dp3 o2.y, r2, r3
dp3 o3.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o3.z, v2, r4
dp3 o3.x, v1, r4
mad o1.xy, v3, c11, c11.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  lightDir = xlv_TEXCOORD2;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_18) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_18), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_21;
  frag.xyz = (frag.xyz + (tmpvar_21 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  lightDir = xlv_TEXCOORD2;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_19;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (lightDir_i0);
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_2, tmpvar_20), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_21) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_2, normalize ((viewDir + tmpvar_20))), 0.0, 1.0);
  specRefl = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_21), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_24;
  frag.xyz = (frag.xyz + (tmpvar_24 * tmpvar_3));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "SPOT" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (normalize (xlv_TEXCOORD2));
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c20.x
dp4 r0.w, v0, c7
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.w, r0, c15
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_20;
  tmpvar_20 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, tmpvar_20);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_19.w) * tmpvar_21.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_22) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_22), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_25;
  frag.xyz = (frag.xyz + (tmpvar_25 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_22;
  tmpvar_22 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_LightTextureB0, tmpvar_22);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_20;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_21.w) * tmpvar_23.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize (lightDir_i0);
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_2, tmpvar_24), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_25) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_2, normalize ((viewDir + tmpvar_24))), 0.0, 1.0);
  specRefl = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_25), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_28;
  frag.xyz = (frag.xyz + (tmpvar_28 * tmpvar_3));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "POINT_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  float atten;
  atten = (texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (normalize (xlv_TEXCOORD2));
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c20.x
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_19;
  tmpvar_19 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, tmpvar_19);
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten;
  atten = (tmpvar_20.w * tmpvar_21.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_22) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_22), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_25;
  frag.xyz = (frag.xyz + (tmpvar_25 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_21;
  tmpvar_21 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_LightTextureB0, tmpvar_21);
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_20;
  mediump float atten;
  atten = (tmpvar_22.w * tmpvar_23.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize (lightDir_i0);
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_2, tmpvar_24), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_25) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_2, normalize ((viewDir + tmpvar_24))), 0.0, 1.0);
  specRefl = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_25), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_28;
  frag.xyz = (frag.xyz + (tmpvar_28 * tmpvar_3));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  float atten;
  atten = texture2D (_LightTexture0, xlv_TEXCOORD3).w;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD2);
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1.w, c20.x
mov r1.xyz, c17
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c16.w, -v0
mov r1, c8
dp4 r4.x, c18, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r2, r3
dp3 o3.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o3.z, v2, r4
dp3 o3.x, v1, r4
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  lightDir = xlv_TEXCOORD2;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_17;
  mediump float atten;
  atten = tmpvar_18.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_19) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_19), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_22;
  frag.xyz = (frag.xyz + (tmpvar_22 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_1 * glow.w));
  lightDir = xlv_TEXCOORD2;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_19;
  mediump float atten;
  atten = tmpvar_20.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (lightDir_i0);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_2, tmpvar_21), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_22) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_2, normalize ((viewDir + tmpvar_21))), 0.0, 1.0);
  specRefl = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_22), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_25;
  frag.xyz = (frag.xyz + (tmpvar_25 * tmpvar_3));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "POINT" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_2 * glow.w));
  float atten;
  atten = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (normalize (xlv_TEXCOORD2));
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c20.x
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_19;
  tmpvar_19 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTexture0, tmpvar_19);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten;
  atten = tmpvar_20.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_21) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_21), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_24;
  frag.xyz = (frag.xyz + (tmpvar_24 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_1 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_21;
  tmpvar_21 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_LightTexture0, tmpvar_21);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_20;
  mediump float atten;
  atten = tmpvar_22.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize (lightDir_i0);
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_1, tmpvar_23), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_24) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_23))), 0.0, 1.0);
  specRefl = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_24), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_27;
  frag.xyz = (frag.xyz + (tmpvar_27 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_2 * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD2);
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_13) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Vector 11 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c12, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c6
dp4 r4.z, c10, r0
mov r0, c5
mov r1.w, c12.x
mov r1.xyz, c9
dp4 r4.y, c10, r0
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r2.xyz, r2, c8.w, -v0
mov r1, c4
dp4 r4.x, c10, r1
dp3 o2.y, r2, r3
dp3 o3.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o3.z, v2, r4
dp3 o3.x, v1, r4
mad o1.xy, v3, c11, c11.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  lightDir = xlv_TEXCOORD2;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_18) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_18), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_21;
  frag.xyz = (frag.xyz + (tmpvar_21 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_1 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  lightDir = xlv_TEXCOORD2;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_19;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (lightDir_i0);
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_1, tmpvar_20), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_21) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_20))), 0.0, 1.0);
  specRefl = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_21), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_24;
  frag.xyz = (frag.xyz + (tmpvar_24 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "SPOT" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_2 * glow.w));
  vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (normalize (xlv_TEXCOORD2));
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c20.x
dp4 r0.w, v0, c7
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.w, r0, c15
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_20;
  tmpvar_20 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, tmpvar_20);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_19.w) * tmpvar_21.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_22) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_22), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_25;
  frag.xyz = (frag.xyz + (tmpvar_25 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_1 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_22;
  tmpvar_22 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_LightTextureB0, tmpvar_22);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_20;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_21.w) * tmpvar_23.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize (lightDir_i0);
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_1, tmpvar_24), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_25) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_24))), 0.0, 1.0);
  specRefl = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_25), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_28;
  frag.xyz = (frag.xyz + (tmpvar_28 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "POINT_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_2 * glow.w));
  float atten;
  atten = (texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (normalize (xlv_TEXCOORD2));
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c20.x
dp3 o3.y, r2, r0
dp3 o3.z, v2, r0
dp3 o3.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 o2.y, r1, r2
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_19;
  tmpvar_19 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, tmpvar_19);
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten;
  atten = (tmpvar_20.w * tmpvar_21.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_22) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_22), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_25;
  frag.xyz = (frag.xyz + (tmpvar_25 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_1 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_21;
  tmpvar_21 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_LightTextureB0, tmpvar_21);
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_20;
  mediump float atten;
  atten = (tmpvar_22.w * tmpvar_23.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize (lightDir_i0);
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_1, tmpvar_24), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_25) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_24))), 0.0, 1.0);
  specRefl = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_25), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_28;
  frag.xyz = (frag.xyz + (tmpvar_28 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL_COOKIE" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = TANGENT.xyz;
  tmpvar_1[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_1[2] = gl_Normal;
  mat3 tmpvar_2;
  tmpvar_2[0].x = tmpvar_1[0].x;
  tmpvar_2[0].y = tmpvar_1[1].x;
  tmpvar_2[0].z = tmpvar_1[2].x;
  tmpvar_2[1].x = tmpvar_1[0].y;
  tmpvar_2[1].y = tmpvar_1[1].y;
  tmpvar_2[1].z = tmpvar_1[2].y;
  tmpvar_2[2].x = tmpvar_1[0].z;
  tmpvar_2[2].y = tmpvar_1[1].z;
  tmpvar_2[2].z = tmpvar_1[2].z;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize (normal);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6.x = 1.0;
  tmpvar_6.y = tmpvar_5;
  tmpvar_6.z = ((tmpvar_5 * tmpvar_5) * tmpvar_5);
  p = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = (1.0 - _Fresnel);
  tmpvar_7.y = _Fresnel;
  p.x = dot (tmpvar_6.xy, tmpvar_7);
  p.y = dot (p.yz, tmpvar_7);
  spec.xyz = (tmpvar_4.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_7))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_8;
  tmpvar_8 = (1.0 - tmpvar_4.w);
  float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  float tmpvar_10;
  tmpvar_10 = pow (2.0, (8.0 - ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9))));
  vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  glow.xyz = (tmpvar_11.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_11.w * _EmissionLM);
  glow.xyz = (glow.xyz + (tmpvar_2 * glow.w));
  float atten;
  atten = texture2D (_LightTexture0, xlv_TEXCOORD3).w;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD2);
  float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_3, tmpvar_12), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (tmpvar_3, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_12))), 0.0, 1.0), tmpvar_10)) * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_10 * 0.159155) + 0.31831))));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1.w, c20.x
mov r1.xyz, c17
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c16.w, -v0
mov r1, c8
dp4 r4.x, c18, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r2, r3
dp3 o3.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o3.z, v2, r4
dp3 o3.x, v1, r4
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  tmpvar_1 = N;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - spec.w);
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  mediump float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - ((7.0 + tmpvar_10) - (shininess * tmpvar_10))));
  highp float gloss;
  gloss = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (glow.w * _EmissionLM);
  glow.w = tmpvar_16;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  lightDir = xlv_TEXCOORD2;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_17;
  mediump float atten;
  atten = tmpvar_18.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_19) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = vec3(pow (specRefl, tmpvar_11));
  spec_i0_i1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_19), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_22;
  frag.xyz = (frag.xyz + (tmpvar_22 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_5 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec4 glow;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (diff * _Color);
  diff = tmpvar_4;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (diff.xyz * diff.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  tmpvar_1 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_9;
  tmpvar_9.x = 1.0;
  tmpvar_9.y = tmpvar_8;
  tmpvar_9.z = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  p = tmpvar_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = (1.0 - fresnel_i0);
  tmpvar_10.y = fresnel_i0;
  p.x = dot (tmpvar_9.xy, tmpvar_10);
  p.y = dot (p.yz, tmpvar_10);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_10))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  mediump float tmpvar_13;
  tmpvar_13 = pow (2.0, (8.0 - ((7.0 + tmpvar_12) - (shininess * tmpvar_12))));
  highp float gloss;
  gloss = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_14;
  vec4 v_i0_i0;
  v_i0_i0.x = _SkyMatrix[0].x;
  v_i0_i0.y = _SkyMatrix[1].x;
  v_i0_i0.z = _SkyMatrix[2].x;
  v_i0_i0.w = _SkyMatrix[3].x;
  vec4 v_i0_i1_i0;
  v_i0_i1_i0.x = _SkyMatrix[0].y;
  v_i0_i1_i0.y = _SkyMatrix[1].y;
  v_i0_i1_i0.z = _SkyMatrix[2].y;
  v_i0_i1_i0.w = _SkyMatrix[3].y;
  vec4 v_i0_i1_i2_i0;
  v_i0_i1_i2_i0.x = _SkyMatrix[0].z;
  v_i0_i1_i2_i0.y = _SkyMatrix[1].z;
  v_i0_i1_i2_i0.z = _SkyMatrix[2].z;
  v_i0_i1_i2_i0.w = _SkyMatrix[3].z;
  N = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (glow.w * _EmissionLM);
  glow.w = tmpvar_18;
  glow.xyz = (glow.xyz + (tmpvar_5 * glow.w));
  lightDir = xlv_TEXCOORD2;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_19;
  mediump float atten;
  atten = tmpvar_20.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (lightDir_i0);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_1, tmpvar_21), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_22) * tmpvar_5) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_21))), 0.0, 1.0);
  specRefl = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = vec3(pow (specRefl, tmpvar_13));
  spec_i0_i1 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_22), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_25;
  frag.xyz = (frag.xyz + (tmpvar_25 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 10
//   d3d9 - ALU: 68 to 81, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "POINT" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "POINT" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 5 [_LightTexture0] 2D
"ps_3_0
; 74 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s5
def c11, 2.00000000, -1.00000000, 10.00000000, 1.00000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.w
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.w, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.w
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
texld r1, v0, s2
mad_pp r3.w, r0.x, c12.x, c12.y
add_pp r0.w, -r1, c11
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mad_pp r0.w, -r0, r0, c11
mul_pp r3.xyz, r1.w, r0
dp3_pp r2.w, v1, v1
rsq_pp r0.x, r2.w
mad_pp r4.xyz, r0.x, v1, r3
mad_pp r0.w, -r0, c9.x, r0
add_pp r2.w, -r0, c11
pow_pp r0, c11.x, r2.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
mov_pp r2.w, r0.x
dp3_pp_sat r1.w, r2, r4
pow r0, r1.w, r2.w
dp3_pp_sat r0.y, r2, r3
mul_pp_sat r0.z, r0.y, c11
mul_pp r0.x, r0, r0.z
mul_pp r0.z, r3.w, c8.x
mul_pp r3.xyz, r0.z, c5
mul_pp r2.xyz, r0.x, c4
dp3 r0.x, v3, v3
texld r0.x, r0.x, s5
mul_pp r2.xyz, r0.x, r2
mul_pp r3.xyz, r3, c6.w
mul_pp r3.xyz, r1, r3
mad r0.z, r2.w, c12, c12.w
mul_pp r3.xyz, r3, r0.z
texld r1, v0, s0
mul_pp r1, r1, c7
mul_pp r1.xyz, r1, c6.w
mul_pp r1.xyz, r1, r1.w
mul_pp r0.x, r0, r0.y
mul_pp r0.xyz, r0.x, r1
mul_pp r2.xyz, r2, r3
mul_pp r1.xyz, r2, c13.x
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.y
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
"ps_3_0
; 68 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c11, 2.00000000, -1.00000000, 10.00000000, 1.00000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.w
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.w, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.w
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.y, r0.x, c12.x, c12
texld r1, v0, s2
add_pp r0.x, -r1.w, c11.w
mul_pp r2.w, r0.y, c8.x
mad_pp r0.y, -r0.x, r0.x, c11.w
mad_pp r0.z, -r0.y, c9.x, r0.y
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v2
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r4.xyz, r0.x, v1, r3
add_pp r3.w, -r0.z, c11
pow_pp r0, c11.x, r3.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
mov_pp r1.w, r0.x
dp3_pp_sat r3.w, r2, r4
pow r0, r3.w, r1.w
dp3_pp_sat r3.w, r2, r3
mul_pp_sat r0.y, r3.w, c11.z
mul_pp r0.w, r0.x, r0.y
mul_pp r0.xyz, r2.w, c5
mul_pp r3.xyz, r0, c6.w
mul_pp r2.xyz, r0.w, c4
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c6.w
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r3.w, r0
mul_pp r1.xyz, r1, r3
mad r1.w, r1, c12.z, c12
mul_pp r1.xyz, r1, r1.w
mul_pp r1.xyz, r2, r1
mul_pp r1.xyz, r1, c13.x
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.y
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "SPOT" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "SPOT" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 5 [_LightTexture0] 2D
SetTexture 6 [_LightTextureB0] 2D
"ps_3_0
; 79 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s5
dcl_2d s6
def c11, 0.00000000, 1.00000000, 0.50000000, 2.00000000
def c12, 2.00000000, -1.00000000, 10.00000000, 0
def c13, 0.95019531, 0.04998779, 0.15915494, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c12.x, c12.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.y
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.y
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.y, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.y
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r2.w, r0.x, c13.x, c13.y
texld r1, v0, s2
add_pp r0.w, -r1, c11.y
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mad_pp r0.w, -r0, r0, c11.y
mul_pp r3.xyz, r1.w, r0
dp3_pp r3.w, v1, v1
rsq_pp r0.x, r3.w
mad_pp r4.xyz, r0.x, v1, r3
mad_pp r0.w, -r0, c9.x, r0
add_pp r3.w, -r0, c11.y
pow_pp r0, c11.w, r3.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
dp3_pp_sat r3.w, r2, r4
mov_pp r1.w, r0.x
pow r0, r3.w, r1.w
dp3_pp_sat r3.w, r2, r3
mul_pp_sat r0.y, r3.w, c12.z
mul_pp r0.x, r0, r0.y
rcp r0.w, v3.w
mad r4.xy, v3, r0.w, c11.z
mul_pp r2.xyz, r0.x, c4
mul_pp r0.y, r2.w, c8.x
mul_pp r0.xyz, r0.y, c5
mul_pp r3.xyz, r0, c6.w
dp3 r0.x, v3, v3
texld r0.w, r4, s5
cmp r0.y, -v3.z, c11.x, c11
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s6
mul_pp r0.w, r0.y, r0.x
mul_pp r0.xyz, r0.w, r2
texld r2, v0, s0
mul_pp r2, r2, c7
mul_pp r2.xyz, r2, c6.w
mul_pp r1.xyz, r1, r3
mad r1.w, r1, c13.z, c13
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r0, r1
mul_pp r1.xyz, r2, r2.w
mul_pp r0.w, r0, r3
mul_pp r2.xyz, r0, c11.z
mul_pp r1.xyz, r0.w, r1
mul_pp r0.xyz, r1, c4
mad_pp oC0.xyz, r0, c11.w, r2
mov_pp oC0.w, c11.x
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "POINT_COOKIE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "POINT_COOKIE" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 5 [_LightTextureB0] 2D
SetTexture 6 [_LightTexture0] CUBE
"ps_3_0
; 76 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s5
dcl_cube s6
def c11, 2.00000000, -1.00000000, 10.00000000, 1.00000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.w
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.w, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.w
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r3.w, r0.x, c8.x
texld r0, v0, s2
dp3_pp r1.x, v2, v2
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, v2
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
add_pp r0.w, -r0, c11
mad_pp r0.w, -r0, r0, c11
mul_pp r3.xyz, r1.w, r1
dp3_pp r2.w, v1, v1
rsq_pp r1.x, r2.w
mad_pp r0.w, -r0, c9.x, r0
mad_pp r4.xyz, r1.x, v1, r3
add_pp r2.w, -r0, c11
pow_pp r1, c11.x, r2.w
dp3_pp r0.w, r4, r4
rsq_pp r0.w, r0.w
mul_pp r4.xyz, r0.w, r4
mov_pp r2.w, r1.x
dp3_pp_sat r0.w, r2, r4
pow r1, r0.w, r2.w
dp3_pp_sat r1.w, r2, r3
mul_pp_sat r1.y, r1.w, c11.z
mov r0.w, r1.x
mul_pp r0.w, r0, r1.y
mul_pp r1.xyz, r3.w, c5
mul_pp r2.xyz, r0.w, c4
mul_pp r3.xyz, r1, c6.w
dp3 r1.x, v3, v3
texld r0.w, v3, s6
texld r1.x, r1.x, s5
mul r3.w, r1.x, r0
mul_pp r1.xyz, r3.w, r2
mul_pp r2.xyz, r0, r3
texld r0, v0, s0
mul_pp r0, r0, c7
mad r2.w, r2, c12.z, c12
mul_pp r2.xyz, r2, r2.w
mul_pp r1.xyz, r1, r2
mul_pp r0.xyz, r0, c6.w
mul_pp r2.xyz, r0, r0.w
mul_pp r0.x, r3.w, r1.w
mul_pp r0.xyz, r0.x, r2
mul_pp r1.xyz, r1, c13.x
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.y
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL_COOKIE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL_COOKIE" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 5 [_LightTexture0] 2D
"ps_3_0
; 70 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s5
def c11, 2.00000000, -1.00000000, 10.00000000, 1.00000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.w
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.w, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.w
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.y, r0.x, c8.x
texld r1, v0, s2
add_pp r0.x, -r1.w, c11.w
mul_pp r4.xyz, r0.y, c5
mad_pp r0.y, -r0.x, r0.x, c11.w
mad_pp r0.z, -r0.y, c9.x, r0.y
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v2
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r5.xyz, r0.x, v1, r3
add_pp r2.w, -r0.z, c11
pow_pp r0, c11.x, r2.w
dp3_pp r1.w, r5, r5
rsq_pp r0.y, r1.w
mul_pp r5.xyz, r0.y, r5
mov_pp r1.w, r0.x
dp3_pp_sat r2.w, r2, r5
pow r0, r2.w, r1.w
dp3_pp_sat r0.w, r2, r3
mul_pp_sat r0.y, r0.w, c11.z
mul_pp r2.xyz, r4, c6.w
mul_pp r1.xyz, r1, r2
texld r3.w, v3, s5
mul_pp r0.x, r0, r0.y
mul_pp r0.xyz, r0.x, c4
texld r2, v0, s0
mul_pp r2, r2, c7
mad r1.w, r1, c12.z, c12
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r3.w, r0
mul_pp r0.xyz, r0, r1
mul_pp r2.xyz, r2, c6.w
mul_pp r1.xyz, r2, r2.w
mul_pp r0.w, r3, r0
mul_pp r2.xyz, r0, c13.x
mul_pp r1.xyz, r0.w, r1
mul_pp r0.xyz, r1, c4
mad_pp oC0.xyz, r0, c11.x, r2
mov_pp oC0.w, c13.y
"
}

SubProgram "gles " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "POINT" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "POINT" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 76 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c11, 2.00000000, -1.00000000, 10.00000000, 1.00000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.w
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.w, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.w
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
texld r1, v0, s2
add_pp r0.x, r0, r0.y
add_pp r0.w, -r1, c11
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
rsq_pp r3.w, r0.x
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mad_pp r0.w, -r0, r0, c11
mul_pp r3.xyz, r1.w, r0
dp3_pp r2.w, v1, v1
rsq_pp r0.x, r2.w
mad_pp r4.xyz, r0.x, v1, r3
mad_pp r0.w, -r0, c9.x, r0
add_pp r2.w, -r0, c11
pow_pp r0, c11.x, r2.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
mov_pp r2.w, r0.x
dp3_pp_sat r1.w, r2, r4
pow r0, r1.w, r2.w
dp3_pp_sat r0.y, r2, r3
mul_pp_sat r0.z, r0.y, c11
mul_pp r0.x, r0, r0.z
rcp_pp r0.z, r3.w
mul_pp r3.xyz, r0.z, c5
mul_pp r2.xyz, r0.x, c4
dp3 r0.x, v3, v3
texld r0.x, r0.x, s3
mul_pp r2.xyz, r0.x, r2
mul_pp r3.xyz, r3, c6.w
mul_pp r3.xyz, r1, r3
mad r0.z, r2.w, c12, c12.w
mul_pp r3.xyz, r3, r0.z
texld r1, v0, s0
mul_pp r1, r1, c7
mul_pp r1.xyz, r1, c6.w
mul_pp r1.xyz, r1, r1.w
mul_pp r0.x, r0, r0.y
mul_pp r0.xyz, r0.x, r1
mul_pp r2.xyz, r2, r3
mul_pp r1.xyz, r2, c13.x
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.y
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
"ps_3_0
; 70 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c11, 2.00000000, -1.00000000, 10.00000000, 1.00000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.w
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.w, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.w
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
rsq_pp r0.y, r0.x
texld r1, v0, s2
add_pp r0.x, -r1.w, c11.w
rcp_pp r2.w, r0.y
mad_pp r0.y, -r0.x, r0.x, c11.w
mad_pp r0.z, -r0.y, c9.x, r0.y
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v2
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r4.xyz, r0.x, v1, r3
add_pp r3.w, -r0.z, c11
pow_pp r0, c11.x, r3.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
mov_pp r1.w, r0.x
dp3_pp_sat r3.w, r2, r4
pow r0, r3.w, r1.w
dp3_pp_sat r3.w, r2, r3
mul_pp_sat r0.y, r3.w, c11.z
mul_pp r0.w, r0.x, r0.y
mul_pp r0.xyz, r2.w, c5
mul_pp r3.xyz, r0, c6.w
mul_pp r2.xyz, r0.w, c4
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c6.w
mul_pp r0.xyz, r0, r0.w
mul_pp r0.xyz, r3.w, r0
mul_pp r1.xyz, r1, r3
mad r1.w, r1, c12.z, c12
mul_pp r1.xyz, r1, r1.w
mul_pp r1.xyz, r2, r1
mul_pp r1.xyz, r1, c13.x
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.y
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "SPOT" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "SPOT" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_3_0
; 81 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c11, 0.00000000, 1.00000000, 0.50000000, 2.00000000
def c12, 2.00000000, -1.00000000, 10.00000000, 0
def c13, 0.95019531, 0.04998779, 0.15915494, 0.31830987
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c12.x, c12.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.y
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.y
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.y, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.y
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
texld r1, v0, s2
add_pp r0.w, -r1, c11.y
mad_pp r0.x, r0, c13, c13.y
mul_pp r0.x, r0, c8
rsq_pp r2.w, r0.x
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mad_pp r0.w, -r0, r0, c11.y
mul_pp r3.xyz, r1.w, r0
dp3_pp r3.w, v1, v1
rsq_pp r0.x, r3.w
mad_pp r4.xyz, r0.x, v1, r3
mad_pp r0.w, -r0, c9.x, r0
add_pp r3.w, -r0, c11.y
pow_pp r0, c11.w, r3.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
dp3_pp_sat r3.w, r2, r4
mov_pp r1.w, r0.x
pow r0, r3.w, r1.w
dp3_pp_sat r3.w, r2, r3
mul_pp_sat r0.y, r3.w, c12.z
mul_pp r0.x, r0, r0.y
rcp r0.w, v3.w
mad r4.xy, v3, r0.w, c11.z
mul_pp r2.xyz, r0.x, c4
rcp_pp r0.y, r2.w
mul_pp r0.xyz, r0.y, c5
mul_pp r3.xyz, r0, c6.w
dp3 r0.x, v3, v3
texld r0.w, r4, s3
cmp r0.y, -v3.z, c11.x, c11
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s4
mul_pp r0.w, r0.y, r0.x
mul_pp r0.xyz, r0.w, r2
texld r2, v0, s0
mul_pp r2, r2, c7
mul_pp r2.xyz, r2, c6.w
mul_pp r1.xyz, r1, r3
mad r1.w, r1, c13.z, c13
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r0, r1
mul_pp r1.xyz, r2, r2.w
mul_pp r0.w, r0, r3
mul_pp r2.xyz, r0, c11.z
mul_pp r1.xyz, r0.w, r1
mul_pp r0.xyz, r1, c4
mad_pp oC0.xyz, r0, c11.w, r2
mov_pp oC0.w, c11.x
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "POINT_COOKIE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "POINT_COOKIE" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_3_0
; 78 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c11, 2.00000000, -1.00000000, 10.00000000, 1.00000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.w
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.w, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.w
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
rsq_pp r0.x, r0.x
rcp_pp r3.w, r0.x
texld r0, v0, s2
dp3_pp r1.x, v2, v2
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, v2
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
add_pp r0.w, -r0, c11
mad_pp r0.w, -r0, r0, c11
mul_pp r3.xyz, r1.w, r1
dp3_pp r2.w, v1, v1
rsq_pp r1.x, r2.w
mad_pp r0.w, -r0, c9.x, r0
mad_pp r4.xyz, r1.x, v1, r3
add_pp r2.w, -r0, c11
pow_pp r1, c11.x, r2.w
dp3_pp r0.w, r4, r4
rsq_pp r0.w, r0.w
mul_pp r4.xyz, r0.w, r4
mov_pp r2.w, r1.x
dp3_pp_sat r0.w, r2, r4
pow r1, r0.w, r2.w
dp3_pp_sat r1.w, r2, r3
mul_pp_sat r1.y, r1.w, c11.z
mov r0.w, r1.x
mul_pp r0.w, r0, r1.y
mul_pp r1.xyz, r3.w, c5
mul_pp r2.xyz, r0.w, c4
mul_pp r3.xyz, r1, c6.w
dp3 r1.x, v3, v3
texld r0.w, v3, s4
texld r1.x, r1.x, s3
mul r3.w, r1.x, r0
mul_pp r1.xyz, r3.w, r2
mul_pp r2.xyz, r0, r3
texld r0, v0, s0
mul_pp r0, r0, c7
mad r2.w, r2, c12.z, c12
mul_pp r2.xyz, r2, r2.w
mul_pp r1.xyz, r1, r2
mul_pp r0.xyz, r0, c6.w
mul_pp r2.xyz, r0, r0.w
mul_pp r0.x, r3.w, r1.w
mul_pp r0.xyz, r0.x, r2
mul_pp r1.xyz, r1, c13.x
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.y
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL_COOKIE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL_COOKIE" }
Vector 4 [_LightColor0]
Vector 5 [_SpecColor]
Vector 6 [_ExposureIBL]
Vector 7 [_Color]
Float 8 [_SpecInt]
Float 9 [_Shininess]
Float 10 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_SpecTex] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 72 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c11, 2.00000000, -1.00000000, 10.00000000, 1.00000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c11.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3_sat r0.x, r2, r1
add r1.x, -r0, c11.w
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.w, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11.w
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
rsq_pp r0.x, r0.x
rcp_pp r0.y, r0.x
texld r1, v0, s2
add_pp r0.x, -r1.w, c11.w
mul_pp r4.xyz, r0.y, c5
mad_pp r0.y, -r0.x, r0.x, c11.w
mad_pp r0.z, -r0.y, c9.x, r0.y
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v2
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r5.xyz, r0.x, v1, r3
add_pp r2.w, -r0.z, c11
pow_pp r0, c11.x, r2.w
dp3_pp r1.w, r5, r5
rsq_pp r0.y, r1.w
mul_pp r5.xyz, r0.y, r5
mov_pp r1.w, r0.x
dp3_pp_sat r2.w, r2, r5
pow r0, r2.w, r1.w
dp3_pp_sat r0.w, r2, r3
mul_pp_sat r0.y, r0.w, c11.z
mul_pp r2.xyz, r4, c6.w
mul_pp r1.xyz, r1, r2
texld r3.w, v3, s3
mul_pp r0.x, r0, r0.y
mul_pp r0.xyz, r0.x, c4
texld r2, v0, s0
mul_pp r2, r2, c7
mad r1.w, r1, c12.z, c12
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r3.w, r0
mul_pp r0.xyz, r0, r1
mul_pp r2.xyz, r2, c6.w
mul_pp r1.xyz, r2, r2.w
mul_pp r0.w, r3, r0
mul_pp r2.xyz, r0, c13.x
mul_pp r1.xyz, r0.w, r1
mul_pp r0.xyz, r1, c4
mad_pp oC0.xyz, r0, c11.x, r2
mov_pp oC0.w, c13.y
"
}

SubProgram "gles " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL_COOKIE" }
"!!GLES"
}

}
	}

#LINE 67

	}
	
	FallBack "Diffuse"
}
