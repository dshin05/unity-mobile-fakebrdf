// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Self-Illumin/Bumped Diffuse IBL" {
	Properties {
		_Color   ("Diffuse Color", Color) = (1,1,1,1)
		_MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
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
// Vertex combos: 12
//   d3d9 - ALU: 23 to 94
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_3[0].x;
  v_i0.y = tmpvar_3[1].x;
  v_i0.z = tmpvar_3[2].x;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_4[0].y;
  v_i0_i1.y = tmpvar_4[1].y;
  v_i0_i1.z = tmpvar_4[2].y;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_5[0].z;
  v_i0_i1_i2.y = tmpvar_5[1].z;
  v_i0_i1_i2.z = tmpvar_5[2].z;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_7;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_9);
  x1.y = dot (unity_SHAg, tmpvar_9);
  x1.z = dot (unity_SHAb, tmpvar_9);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_10);
  x2.y = dot (unity_SHBg, tmpvar_10);
  x2.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_2 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_2 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_2 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
  xlv_TEXCOORD6 = (tmpvar_2 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_6;
  glow.xyz = (tmpvar_6.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_6.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_2, normalize (xlv_TEXCOORD4)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
; 58 ALU
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
mov r0.w, c23.x
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c17
dp4 r2.y, r0, c16
dp4 r2.x, r0, c15
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c20
dp4 r0.y, r1, c19
dp4 r0.x, r1, c18
mul r1.xyz, r0.w, c21
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov r0.w, c23.x
mov r0.xyz, c13
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c12.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c12.w
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c12.w
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o5.y, r2, r4
dp3 o7.y, r2, r3
mul o4.xyz, r0, c12.w
dp3 o5.z, v2, r4
dp3 o5.x, v1, r4
dp3 o7.z, v2, r3
dp3 o7.x, v1, r3
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_10[0].x;
  v_i0.y = tmpvar_10[1].x;
  v_i0.z = tmpvar_10[2].x;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_9 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_12[0].y;
  v_i0_i1.y = tmpvar_12[1].y;
  v_i0_i1.z = tmpvar_12[2].y;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_9 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_14[0].z;
  v_i0_i1_i2.y = tmpvar_14[1].z;
  v_i0_i1_i2.z = tmpvar_14[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_9 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = (tmpvar_16 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_20;
  mediump vec4 normal;
  normal = tmpvar_19;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal);
  x1.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal);
  x1.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal);
  x1.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC);
  x3 = tmpvar_29;
  tmpvar_20 = ((x1 + x2) + x3);
  shlight = tmpvar_20;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_9 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_7;
  tmpvar_4 = N;
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_1, N);
  tmpvar_8.y = dot (tmpvar_2, N);
  tmpvar_8.z = dot (tmpvar_3, N);
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_4, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_10[0].x;
  v_i0.y = tmpvar_10[1].x;
  v_i0.z = tmpvar_10[2].x;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_9 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_12[0].y;
  v_i0_i1.y = tmpvar_12[1].y;
  v_i0_i1.z = tmpvar_12[2].y;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_9 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_14[0].z;
  v_i0_i1_i2.y = tmpvar_14[1].z;
  v_i0_i1_i2.z = tmpvar_14[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_9 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = (tmpvar_16 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_20;
  mediump vec4 normal;
  normal = tmpvar_19;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal);
  x1.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal);
  x1.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal);
  x1.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC);
  x3 = tmpvar_29;
  tmpvar_20 = ((x1 + x2) + x3);
  shlight = tmpvar_20;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_9 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  tmpvar_4 = tmpvar_7;
  highp vec3 tmpvar_8;
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
  tmpvar_8 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_7)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_7)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_7))));
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (diff_i0.w * tmpvar_10);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (glow.w * _EmissionLM);
  glow.w = tmpvar_15;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_4, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = (c.xyz + ((((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_17;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;

uniform mat4 _Object2World;
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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_3[0].x;
  v_i0.y = tmpvar_3[1].x;
  v_i0.z = tmpvar_3[2].x;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_4[0].y;
  v_i0_i1.y = tmpvar_4[1].y;
  v_i0_i1.z = tmpvar_4[2].y;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_5[0].z;
  v_i0_i1_i2.y = tmpvar_5[1].z;
  v_i0_i1_i2.z = tmpvar_5[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_2 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_2 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_2 * v_i0_i1_i2) * unity_Scale.w);
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
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_6;
  glow.xyz = (tmpvar_6.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_6.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  c.xyz = (diff.xyz * ((8.0 * tmpvar_7.w) * tmpvar_7.xyz));
  c.w = diff.w;
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
Matrix 4 [_Object2World]
Vector 13 [unity_LightmapST]
Vector 14 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
dp3 r0.y, r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c12.w
dp3 r0.y, r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c12.w
dp3 r0.y, r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o4.xyz, r0, c12.w
mad o1.xy, v3, c14, c14.zwzw
mad o5.xy, v4, c13, c13.zwzw
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

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp mat3 tmpvar_6;
  tmpvar_6[0] = tmpvar_1.xyz;
  tmpvar_6[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_6[2] = tmpvar_2;
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_6[0].x;
  tmpvar_7[0].y = tmpvar_6[1].x;
  tmpvar_7[0].z = tmpvar_6[2].x;
  tmpvar_7[1].x = tmpvar_6[0].y;
  tmpvar_7[1].y = tmpvar_6[1].y;
  tmpvar_7[1].z = tmpvar_6[2].y;
  tmpvar_7[2].x = tmpvar_6[0].z;
  tmpvar_7[2].y = tmpvar_6[1].z;
  tmpvar_7[2].z = tmpvar_6[2].z;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_8[0].x;
  v_i0.y = tmpvar_8[1].x;
  v_i0.z = tmpvar_8[2].x;
  highp vec3 tmpvar_9;
  tmpvar_9 = ((tmpvar_7 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_10[0].y;
  v_i0_i1.y = tmpvar_10[1].y;
  v_i0_i1.z = tmpvar_10[2].y;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_7 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_12[0].z;
  v_i0_i1_i2.y = tmpvar_12[1].z;
  v_i0_i1_i2.z = tmpvar_12[2].z;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_13;
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
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1, N);
  tmpvar_7.y = dot (tmpvar_2, N);
  tmpvar_7.z = dot (tmpvar_3, N);
  N = tmpvar_7;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, tmpvar_7);
  diff_i0 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow.w * _EmissionLM);
  glow.w = tmpvar_12;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_13;
  tmpvar_13 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  mediump vec3 tmpvar_14;
  tmpvar_14 = (diff.xyz * tmpvar_13);
  c.xyz = tmpvar_14;
  c.w = diff.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp mat3 tmpvar_6;
  tmpvar_6[0] = tmpvar_1.xyz;
  tmpvar_6[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_6[2] = tmpvar_2;
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_6[0].x;
  tmpvar_7[0].y = tmpvar_6[1].x;
  tmpvar_7[0].z = tmpvar_6[2].x;
  tmpvar_7[1].x = tmpvar_6[0].y;
  tmpvar_7[1].y = tmpvar_6[1].y;
  tmpvar_7[1].z = tmpvar_6[2].y;
  tmpvar_7[2].x = tmpvar_6[0].z;
  tmpvar_7[2].y = tmpvar_6[1].z;
  tmpvar_7[2].z = tmpvar_6[2].z;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_8[0].x;
  v_i0.y = tmpvar_8[1].x;
  v_i0.z = tmpvar_8[2].x;
  highp vec3 tmpvar_9;
  tmpvar_9 = ((tmpvar_7 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_10[0].y;
  v_i0_i1.y = tmpvar_10[1].y;
  v_i0_i1.z = tmpvar_10[2].y;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_7 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_12[0].z;
  v_i0_i1_i2.y = tmpvar_12[1].z;
  v_i0_i1_i2.z = tmpvar_12[2].z;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_13;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  highp vec3 tmpvar_7;
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
  tmpvar_7 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_6)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_6)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_6))));
  N = tmpvar_7;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, tmpvar_7);
  diff_i0 = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9;
  tmpvar_10.y = (diff_i0.w * tmpvar_9);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (glow.w * _EmissionLM);
  glow.w = tmpvar_14;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  lowp vec3 tmpvar_16;
  tmpvar_16 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  mediump vec3 tmpvar_17;
  tmpvar_17 = (diff.xyz * tmpvar_16);
  c.xyz = tmpvar_17;
  c.w = diff.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = (c.xyz + ((((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_10)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_18;
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = TANGENT.xyz;
  tmpvar_2[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_2[2] = gl_Normal;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_4[0].x;
  v_i0.y = tmpvar_4[1].x;
  v_i0.z = tmpvar_4[2].x;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_5[0].y;
  v_i0_i1.y = tmpvar_5[1].y;
  v_i0_i1.z = tmpvar_5[2].y;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_6[0].z;
  v_i0_i1_i2.y = tmpvar_6[1].z;
  v_i0_i1_i2.z = tmpvar_6[2].z;
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
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_10);
  x1.y = dot (unity_SHAg, tmpvar_10);
  x1.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_8.xyzz * tmpvar_8.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_11);
  x2.y = dot (unity_SHBg, tmpvar_11);
  x2.z = dot (unity_SHBb, tmpvar_11);
  vec4 o_i0;
  vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_12;
  vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_13 + tmpvar_12.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_3 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_8.x * tmpvar_8.x) - (tmpvar_8.y * tmpvar_8.y))));
  xlv_TEXCOORD6 = (tmpvar_3 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_6;
  glow.xyz = (tmpvar_6.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_6.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0) * clamp (dot (tmpvar_2, normalize (xlv_TEXCOORD4)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
; 63 ALU
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
mov r0.w, c25.x
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c19
dp4 r2.y, r0, c18
dp4 r2.x, r0, c17
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c22
dp4 r0.y, r1, c21
dp4 r0.x, r1, c20
mul r1.xyz, r0.w, c23
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov r0.w, c25.x
mov r0.xyz, c15
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c14.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1, c8
dp4 r4.x, c16, r1
dp4 r0.w, v0, c3
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c14.w
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c14.w
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o4.xyz, r0, c14.w
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c12.x
dp3 o5.y, r2, r4
dp3 o7.y, r2, r3
dp3 o5.z, v2, r4
dp3 o5.x, v1, r4
dp3 o7.z, v2, r3
dp3 o7.x, v1, r3
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
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
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
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_11[0].x;
  v_i0.y = tmpvar_11[1].x;
  v_i0.z = tmpvar_11[2].x;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_10 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_13[0].y;
  v_i0_i1.y = tmpvar_13[1].y;
  v_i0_i1.z = tmpvar_13[2].y;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_10 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_15[0].z;
  v_i0_i1_i2.y = tmpvar_15[1].z;
  v_i0_i1_i2.z = tmpvar_15[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((tmpvar_10 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = _Object2World[0].xyz;
  tmpvar_17[1] = _Object2World[1].xyz;
  tmpvar_17[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = (tmpvar_17 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_21;
  mediump vec4 normal;
  normal = tmpvar_20;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal);
  x1.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal);
  x1.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal);
  x1.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC);
  x3 = tmpvar_30;
  tmpvar_21 = ((x1 + x2) + x3);
  shlight = tmpvar_21;
  tmpvar_7 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_31;
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = (tmpvar_31.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_32 + tmpvar_31.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_10 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_7;
  tmpvar_4 = N;
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_1, N);
  tmpvar_8.y = dot (tmpvar_2, N);
  tmpvar_8.z = dot (tmpvar_3, N);
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump float atten_i0;
  atten_i0 = tmpvar_14;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_4, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_16;
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
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
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
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_11[0].x;
  v_i0.y = tmpvar_11[1].x;
  v_i0.z = tmpvar_11[2].x;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_10 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_13[0].y;
  v_i0_i1.y = tmpvar_13[1].y;
  v_i0_i1.z = tmpvar_13[2].y;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_10 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_15[0].z;
  v_i0_i1_i2.y = tmpvar_15[1].z;
  v_i0_i1_i2.z = tmpvar_15[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((tmpvar_10 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = _Object2World[0].xyz;
  tmpvar_17[1] = _Object2World[1].xyz;
  tmpvar_17[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = (tmpvar_17 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_21;
  mediump vec4 normal;
  normal = tmpvar_20;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal);
  x1.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal);
  x1.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal);
  x1.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC);
  x3 = tmpvar_30;
  tmpvar_21 = ((x1 + x2) + x3);
  shlight = tmpvar_21;
  tmpvar_7 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_31;
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = (tmpvar_31.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_32 + tmpvar_31.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_10 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  tmpvar_4 = tmpvar_7;
  highp vec3 tmpvar_8;
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
  tmpvar_8 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_7)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_7)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_7))));
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (diff_i0.w * tmpvar_10);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (glow.w * _EmissionLM);
  glow.w = tmpvar_15;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump float atten_i0;
  atten_i0 = tmpvar_16;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_4, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_17;
  tmpvar_17 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = (c.xyz + ((((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_18;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;

uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = TANGENT.xyz;
  tmpvar_2[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_2[2] = gl_Normal;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_4[0].x;
  v_i0.y = tmpvar_4[1].x;
  v_i0.z = tmpvar_4[2].x;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_5[0].y;
  v_i0_i1.y = tmpvar_5[1].y;
  v_i0_i1.z = tmpvar_5[2].y;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_6[0].z;
  v_i0_i1_i2.y = tmpvar_6[1].z;
  v_i0_i1_i2.z = tmpvar_6[2].z;
  vec4 o_i0;
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_7;
  vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_8 + tmpvar_7.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_3 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_i0;
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
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_6;
  glow.xyz = (tmpvar_6.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_6.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec3 tmpvar_9;
  tmpvar_9 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  c.xyz = (diff.xyz * max (min (tmpvar_9, ((tmpvar_7.x * 2.0) * tmpvar_8.xyz)), (tmpvar_9 * tmpvar_7.x)));
  c.w = diff.w;
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
Matrix 4 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c17, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
dp3 r1.y, r0, c4
dp3 r2.y, r0, c6
dp4 r0.w, v0, c3
dp3 r1.x, v1, c4
dp3 r1.z, v2, c4
mul o2.xyz, r1, c14.w
dp3 r1.y, r0, c5
dp4 r0.z, v0, c2
dp3 r1.x, v1, c5
dp3 r1.z, v2, c5
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul o3.xyz, r1, c14.w
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
dp3 r2.x, v1, c6
dp3 r2.z, v2, c6
mul o4.xyz, r2, c14.w
mad o6.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov o6.zw, r0
mad o1.xy, v3, c16, c16.zwzw
mad o5.xy, v4, c15, c15.zwzw
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

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = tmpvar_1.xyz;
  tmpvar_7[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_7[2] = tmpvar_2;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_9[0].x;
  v_i0.y = tmpvar_9[1].x;
  v_i0.z = tmpvar_9[2].x;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_8 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_11[0].y;
  v_i0_i1.y = tmpvar_11[1].y;
  v_i0_i1.z = tmpvar_11[2].y;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_8 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_13[0].z;
  v_i0_i1_i2.y = tmpvar_13[1].z;
  v_i0_i1_i2.z = tmpvar_13[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_8 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_14;
  highp vec4 o_i0;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_i0;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1, N);
  tmpvar_7.y = dot (tmpvar_2, N);
  tmpvar_7.z = dot (tmpvar_3, N);
  N = tmpvar_7;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, tmpvar_7);
  diff_i0 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow.w * _EmissionLM);
  glow.w = tmpvar_12;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_13;
  tmpvar_13 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x * 2.0)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = (diff.xyz * tmpvar_13);
  c.xyz = tmpvar_14;
  c.w = diff.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = tmpvar_1.xyz;
  tmpvar_7[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_7[2] = tmpvar_2;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_9[0].x;
  v_i0.y = tmpvar_9[1].x;
  v_i0.z = tmpvar_9[2].x;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_8 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_11[0].y;
  v_i0_i1.y = tmpvar_11[1].y;
  v_i0_i1.z = tmpvar_11[2].y;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_8 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_13[0].z;
  v_i0_i1_i2.y = tmpvar_13[1].z;
  v_i0_i1_i2.z = tmpvar_13[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_8 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_14;
  highp vec4 o_i0;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_i0;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  highp vec3 tmpvar_7;
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
  tmpvar_7 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_6)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_6)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_6))));
  N = tmpvar_7;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, tmpvar_7);
  diff_i0 = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9;
  tmpvar_10.y = (diff_i0.w * tmpvar_9);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (glow.w * _EmissionLM);
  glow.w = tmpvar_14;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((8.0 * tmpvar_16.w) * tmpvar_16.xyz);
  lowp vec3 tmpvar_18;
  tmpvar_18 = max (min (tmpvar_17, ((tmpvar_15.x * 2.0) * tmpvar_16.xyz)), (tmpvar_17 * tmpvar_15.x));
  mediump vec3 tmpvar_19;
  tmpvar_19 = (diff.xyz * tmpvar_18);
  c.xyz = tmpvar_19;
  c.w = diff.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c.xyz + ((((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_10)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_20;
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_3[0].x;
  v_i0.y = tmpvar_3[1].x;
  v_i0.z = tmpvar_3[2].x;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_4[0].y;
  v_i0_i1.y = tmpvar_4[1].y;
  v_i0_i1.z = tmpvar_4[2].y;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_5[0].z;
  v_i0_i1_i2.y = tmpvar_5[1].z;
  v_i0_i1_i2.z = tmpvar_5[2].z;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_7;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_9);
  x1.y = dot (unity_SHAg, tmpvar_9);
  x1.z = dot (unity_SHAb, tmpvar_9);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_10);
  x2.y = dot (unity_SHBg, tmpvar_10);
  x2.z = dot (unity_SHBb, tmpvar_10);
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
  tmpvar_16 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_12 * tmpvar_7.x) + (tmpvar_13 * tmpvar_7.y)) + (tmpvar_14 * tmpvar_7.z)) * inversesqrt (tmpvar_15))) * (1.0/((1.0 + (tmpvar_15 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_2 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_2 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_2 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y)))) + ((((unity_LightColor[0].xyz * tmpvar_16.x) + (unity_LightColor[1].xyz * tmpvar_16.y)) + (unity_LightColor[2].xyz * tmpvar_16.z)) + (unity_LightColor[3].xyz * tmpvar_16.w)));
  xlv_TEXCOORD6 = (tmpvar_2 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_6;
  glow.xyz = (tmpvar_6.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_6.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_2, normalize (xlv_TEXCOORD4)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
; 89 ALU
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
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov r1.w, c31.x
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.y, r1, c9
dp4 r0.x, r1, c8
mad r3.xyz, r0, c12.w, -v0
mov r1.xyz, v1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r1.yzxw
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c12.w
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c12.w
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o5.y, r2, r4
dp3 o7.y, r2, r3
mul o4.xyz, r0, c12.w
dp3 o5.z, v2, r4
dp3 o5.x, v1, r4
dp3 o7.z, v2, r3
dp3 o7.x, v1, r3
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_10[0].x;
  v_i0.y = tmpvar_10[1].x;
  v_i0.z = tmpvar_10[2].x;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_9 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_12[0].y;
  v_i0_i1.y = tmpvar_12[1].y;
  v_i0_i1.z = tmpvar_12[2].y;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_9 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_14[0].z;
  v_i0_i1_i2.y = tmpvar_14[1].z;
  v_i0_i1_i2.z = tmpvar_14[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_9 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_17;
  mediump vec3 tmpvar_21;
  mediump vec4 normal;
  normal = tmpvar_20;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal);
  x1.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal);
  x1.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal);
  x1.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC);
  x3 = tmpvar_30;
  tmpvar_21 = ((x1 + x2) + x3);
  shlight = tmpvar_21;
  tmpvar_7 = shlight;
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
  tmpvar_36 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_32 * tmpvar_17.x) + (tmpvar_33 * tmpvar_17.y)) + (tmpvar_34 * tmpvar_17.z)) * inversesqrt (tmpvar_35))) * (1.0/((1.0 + (tmpvar_35 * unity_4LightAtten0)))));
  highp vec3 tmpvar_37;
  tmpvar_37 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_36.x) + (unity_LightColor[1].xyz * tmpvar_36.y)) + (unity_LightColor[2].xyz * tmpvar_36.z)) + (unity_LightColor[3].xyz * tmpvar_36.w)));
  tmpvar_7 = tmpvar_37;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_9 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_7;
  tmpvar_4 = N;
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_1, N);
  tmpvar_8.y = dot (tmpvar_2, N);
  tmpvar_8.z = dot (tmpvar_3, N);
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_4, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_10[0].x;
  v_i0.y = tmpvar_10[1].x;
  v_i0.z = tmpvar_10[2].x;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_9 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_12[0].y;
  v_i0_i1.y = tmpvar_12[1].y;
  v_i0_i1.z = tmpvar_12[2].y;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_9 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_14[0].z;
  v_i0_i1_i2.y = tmpvar_14[1].z;
  v_i0_i1_i2.z = tmpvar_14[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_9 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_17;
  mediump vec3 tmpvar_21;
  mediump vec4 normal;
  normal = tmpvar_20;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal);
  x1.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal);
  x1.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal);
  x1.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC);
  x3 = tmpvar_30;
  tmpvar_21 = ((x1 + x2) + x3);
  shlight = tmpvar_21;
  tmpvar_7 = shlight;
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
  tmpvar_36 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_32 * tmpvar_17.x) + (tmpvar_33 * tmpvar_17.y)) + (tmpvar_34 * tmpvar_17.z)) * inversesqrt (tmpvar_35))) * (1.0/((1.0 + (tmpvar_35 * unity_4LightAtten0)))));
  highp vec3 tmpvar_37;
  tmpvar_37 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_36.x) + (unity_LightColor[1].xyz * tmpvar_36.y)) + (unity_LightColor[2].xyz * tmpvar_36.z)) + (unity_LightColor[3].xyz * tmpvar_36.w)));
  tmpvar_7 = tmpvar_37;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_9 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  tmpvar_4 = tmpvar_7;
  highp vec3 tmpvar_8;
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
  tmpvar_8 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_7)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_7)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_7))));
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (diff_i0.w * tmpvar_10);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (glow.w * _EmissionLM);
  glow.w = tmpvar_15;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_4, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = (c.xyz + ((((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_17;
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = TANGENT.xyz;
  tmpvar_2[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_2[2] = gl_Normal;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_4[0].x;
  v_i0.y = tmpvar_4[1].x;
  v_i0.z = tmpvar_4[2].x;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_5[0].y;
  v_i0_i1.y = tmpvar_5[1].y;
  v_i0_i1.z = tmpvar_5[2].y;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_6[0].z;
  v_i0_i1_i2.y = tmpvar_6[1].z;
  v_i0_i1_i2.z = tmpvar_6[2].z;
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
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_10);
  x1.y = dot (unity_SHAg, tmpvar_10);
  x1.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_8.xyzz * tmpvar_8.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_11);
  x2.y = dot (unity_SHBg, tmpvar_11);
  x2.z = dot (unity_SHBb, tmpvar_11);
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
  tmpvar_17 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_13 * tmpvar_8.x) + (tmpvar_14 * tmpvar_8.y)) + (tmpvar_15 * tmpvar_8.z)) * inversesqrt (tmpvar_16))) * (1.0/((1.0 + (tmpvar_16 * unity_4LightAtten0)))));
  vec4 o_i0;
  vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_18;
  vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_18.x;
  tmpvar_19.y = (tmpvar_18.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_19 + tmpvar_18.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_3 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_8.x * tmpvar_8.x) - (tmpvar_8.y * tmpvar_8.y)))) + ((((unity_LightColor[0].xyz * tmpvar_17.x) + (unity_LightColor[1].xyz * tmpvar_17.y)) + (unity_LightColor[2].xyz * tmpvar_17.z)) + (unity_LightColor[3].xyz * tmpvar_17.w)));
  xlv_TEXCOORD6 = (tmpvar_3 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_6;
  glow.xyz = (tmpvar_6.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_6.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0) * clamp (dot (tmpvar_2, normalize (xlv_TEXCOORD4)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
; 94 ALU
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
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov r1.w, c33.x
mov r1.xyz, c15
dp4 r0.z, r1, c10
dp4 r0.y, r1, c9
dp4 r0.x, r1, c8
mad r3.xyz, r0, c14.w, -v0
mov r1.xyz, v1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r1.yzxw
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1, c8
dp4 r4.x, c16, r1
dp4 r0.w, v0, c3
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c14.w
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c14.w
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o4.xyz, r0, c14.w
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c33.z
mul r1.y, r1, c12.x
dp3 o5.y, r2, r4
dp3 o7.y, r2, r3
dp3 o5.z, v2, r4
dp3 o5.x, v1, r4
dp3 o7.z, v2, r3
dp3 o7.x, v1, r3
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
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
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
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_11[0].x;
  v_i0.y = tmpvar_11[1].x;
  v_i0.z = tmpvar_11[2].x;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_10 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_13[0].y;
  v_i0_i1.y = tmpvar_13[1].y;
  v_i0_i1.z = tmpvar_13[2].y;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_10 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_15[0].z;
  v_i0_i1_i2.y = tmpvar_15[1].z;
  v_i0_i1_i2.z = tmpvar_15[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((tmpvar_10 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = _Object2World[0].xyz;
  tmpvar_17[1] = _Object2World[1].xyz;
  tmpvar_17[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_18;
  mediump vec3 tmpvar_22;
  mediump vec4 normal;
  normal = tmpvar_21;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAr, normal);
  x1.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAg, normal);
  x1.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAb, normal);
  x1.z = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBr, tmpvar_26);
  x2.x = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBg, tmpvar_26);
  x2.y = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBb, tmpvar_26);
  x2.z = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (unity_SHC.xyz * vC);
  x3 = tmpvar_31;
  tmpvar_22 = ((x1 + x2) + x3);
  shlight = tmpvar_22;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosX0 - tmpvar_32.x);
  highp vec4 tmpvar_34;
  tmpvar_34 = (unity_4LightPosY0 - tmpvar_32.y);
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosZ0 - tmpvar_32.z);
  highp vec4 tmpvar_36;
  tmpvar_36 = (((tmpvar_33 * tmpvar_33) + (tmpvar_34 * tmpvar_34)) + (tmpvar_35 * tmpvar_35));
  highp vec4 tmpvar_37;
  tmpvar_37 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_33 * tmpvar_18.x) + (tmpvar_34 * tmpvar_18.y)) + (tmpvar_35 * tmpvar_18.z)) * inversesqrt (tmpvar_36))) * (1.0/((1.0 + (tmpvar_36 * unity_4LightAtten0)))));
  highp vec3 tmpvar_38;
  tmpvar_38 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_37.x) + (unity_LightColor[1].xyz * tmpvar_37.y)) + (unity_LightColor[2].xyz * tmpvar_37.z)) + (unity_LightColor[3].xyz * tmpvar_37.w)));
  tmpvar_7 = tmpvar_38;
  highp vec4 o_i0;
  highp vec4 tmpvar_39;
  tmpvar_39 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_39;
  highp vec2 tmpvar_40;
  tmpvar_40.x = tmpvar_39.x;
  tmpvar_40.y = (tmpvar_39.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_40 + tmpvar_39.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_10 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_7;
  tmpvar_4 = N;
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_1, N);
  tmpvar_8.y = dot (tmpvar_2, N);
  tmpvar_8.z = dot (tmpvar_3, N);
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump float atten_i0;
  atten_i0 = tmpvar_14;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_4, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_16;
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
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
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
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_11[0].x;
  v_i0.y = tmpvar_11[1].x;
  v_i0.z = tmpvar_11[2].x;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_10 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_13[0].y;
  v_i0_i1.y = tmpvar_13[1].y;
  v_i0_i1.z = tmpvar_13[2].y;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_10 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_15[0].z;
  v_i0_i1_i2.y = tmpvar_15[1].z;
  v_i0_i1_i2.z = tmpvar_15[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((tmpvar_10 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = _Object2World[0].xyz;
  tmpvar_17[1] = _Object2World[1].xyz;
  tmpvar_17[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_18;
  mediump vec3 tmpvar_22;
  mediump vec4 normal;
  normal = tmpvar_21;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAr, normal);
  x1.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAg, normal);
  x1.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAb, normal);
  x1.z = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBr, tmpvar_26);
  x2.x = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBg, tmpvar_26);
  x2.y = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBb, tmpvar_26);
  x2.z = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (unity_SHC.xyz * vC);
  x3 = tmpvar_31;
  tmpvar_22 = ((x1 + x2) + x3);
  shlight = tmpvar_22;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosX0 - tmpvar_32.x);
  highp vec4 tmpvar_34;
  tmpvar_34 = (unity_4LightPosY0 - tmpvar_32.y);
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosZ0 - tmpvar_32.z);
  highp vec4 tmpvar_36;
  tmpvar_36 = (((tmpvar_33 * tmpvar_33) + (tmpvar_34 * tmpvar_34)) + (tmpvar_35 * tmpvar_35));
  highp vec4 tmpvar_37;
  tmpvar_37 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_33 * tmpvar_18.x) + (tmpvar_34 * tmpvar_18.y)) + (tmpvar_35 * tmpvar_18.z)) * inversesqrt (tmpvar_36))) * (1.0/((1.0 + (tmpvar_36 * unity_4LightAtten0)))));
  highp vec3 tmpvar_38;
  tmpvar_38 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_37.x) + (unity_LightColor[1].xyz * tmpvar_37.y)) + (unity_LightColor[2].xyz * tmpvar_37.z)) + (unity_LightColor[3].xyz * tmpvar_37.w)));
  tmpvar_7 = tmpvar_38;
  highp vec4 o_i0;
  highp vec4 tmpvar_39;
  tmpvar_39 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_39;
  highp vec2 tmpvar_40;
  tmpvar_40.x = tmpvar_39.x;
  tmpvar_40.y = (tmpvar_39.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_40 + tmpvar_39.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_10 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  tmpvar_4 = tmpvar_7;
  highp vec3 tmpvar_8;
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
  tmpvar_8 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_7)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_7)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_7))));
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10;
  tmpvar_11.y = (diff_i0.w * tmpvar_10);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (glow.w * _EmissionLM);
  glow.w = tmpvar_15;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump float atten_i0;
  atten_i0 = tmpvar_16;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_4, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_17;
  tmpvar_17 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = (c.xyz + ((((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_11)) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_18;
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_3[0].x;
  v_i0.y = tmpvar_3[1].x;
  v_i0.z = tmpvar_3[2].x;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_4[0].y;
  v_i0_i1.y = tmpvar_4[1].y;
  v_i0_i1.z = tmpvar_4[2].y;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_5[0].z;
  v_i0_i1_i2.y = tmpvar_5[1].z;
  v_i0_i1_i2.z = tmpvar_5[2].z;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_7;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_9);
  x1.y = dot (unity_SHAg, tmpvar_9);
  x1.z = dot (unity_SHAb, tmpvar_9);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_10);
  x2.y = dot (unity_SHBg, tmpvar_10);
  x2.z = dot (unity_SHBb, tmpvar_10);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_2 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_2 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_2 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y))));
  xlv_TEXCOORD6 = (tmpvar_2 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_4;
  glow.xyz = (tmpvar_4.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_4.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_2, normalize (xlv_TEXCOORD4)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
; 58 ALU
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
mov r0.w, c23.x
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c17
dp4 r2.y, r0, c16
dp4 r2.x, r0, c15
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c20
dp4 r0.y, r1, c19
dp4 r0.x, r1, c18
mul r1.xyz, r0.w, c21
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov r0.w, c23.x
mov r0.xyz, c13
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c12.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c12.w
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c12.w
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o5.y, r2, r4
dp3 o7.y, r2, r3
mul o4.xyz, r0, c12.w
dp3 o5.z, v2, r4
dp3 o5.x, v1, r4
dp3 o7.z, v2, r3
dp3 o7.x, v1, r3
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_10[0].x;
  v_i0.y = tmpvar_10[1].x;
  v_i0.z = tmpvar_10[2].x;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_9 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_12[0].y;
  v_i0_i1.y = tmpvar_12[1].y;
  v_i0_i1.z = tmpvar_12[2].y;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_9 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_14[0].z;
  v_i0_i1_i2.y = tmpvar_14[1].z;
  v_i0_i1_i2.z = tmpvar_14[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_9 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = (tmpvar_16 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_20;
  mediump vec4 normal;
  normal = tmpvar_19;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal);
  x1.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal);
  x1.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal);
  x1.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC);
  x3 = tmpvar_29;
  tmpvar_20 = ((x1 + x2) + x3);
  shlight = tmpvar_20;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_9 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_7;
  tmpvar_4 = N;
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_1, N);
  tmpvar_8.y = dot (tmpvar_2, N);
  tmpvar_8.z = dot (tmpvar_3, N);
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_4, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_10[0].x;
  v_i0.y = tmpvar_10[1].x;
  v_i0.z = tmpvar_10[2].x;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_9 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_12[0].y;
  v_i0_i1.y = tmpvar_12[1].y;
  v_i0_i1.z = tmpvar_12[2].y;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_9 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_14[0].z;
  v_i0_i1_i2.y = tmpvar_14[1].z;
  v_i0_i1_i2.z = tmpvar_14[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_9 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = (tmpvar_16 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_20;
  mediump vec4 normal;
  normal = tmpvar_19;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal);
  x1.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal);
  x1.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal);
  x1.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC);
  x3 = tmpvar_29;
  tmpvar_20 = ((x1 + x2) + x3);
  shlight = tmpvar_20;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_9 * (((_World2Object * tmpvar_18).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  tmpvar_4 = tmpvar_7;
  highp vec3 tmpvar_8;
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
  tmpvar_8 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_7)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_7)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_7))));
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_4, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;

uniform mat4 _Object2World;
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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_3[0].x;
  v_i0.y = tmpvar_3[1].x;
  v_i0.z = tmpvar_3[2].x;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_4[0].y;
  v_i0_i1.y = tmpvar_4[1].y;
  v_i0_i1.z = tmpvar_4[2].y;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_5[0].z;
  v_i0_i1_i2.y = tmpvar_5[1].z;
  v_i0_i1_i2.z = tmpvar_5[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_2 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_2 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_2 * v_i0_i1_i2) * unity_Scale.w);
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
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_4;
  glow.xyz = (tmpvar_4.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_4.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  c.xyz = (diff.xyz * ((8.0 * tmpvar_5.w) * tmpvar_5.xyz));
  c.w = diff.w;
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
Matrix 4 [_Object2World]
Vector 13 [unity_LightmapST]
Vector 14 [_MainTex_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
dp3 r0.y, r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c12.w
dp3 r0.y, r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c12.w
dp3 r0.y, r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o4.xyz, r0, c12.w
mad o1.xy, v3, c14, c14.zwzw
mad o5.xy, v4, c13, c13.zwzw
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

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp mat3 tmpvar_6;
  tmpvar_6[0] = tmpvar_1.xyz;
  tmpvar_6[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_6[2] = tmpvar_2;
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_6[0].x;
  tmpvar_7[0].y = tmpvar_6[1].x;
  tmpvar_7[0].z = tmpvar_6[2].x;
  tmpvar_7[1].x = tmpvar_6[0].y;
  tmpvar_7[1].y = tmpvar_6[1].y;
  tmpvar_7[1].z = tmpvar_6[2].y;
  tmpvar_7[2].x = tmpvar_6[0].z;
  tmpvar_7[2].y = tmpvar_6[1].z;
  tmpvar_7[2].z = tmpvar_6[2].z;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_8[0].x;
  v_i0.y = tmpvar_8[1].x;
  v_i0.z = tmpvar_8[2].x;
  highp vec3 tmpvar_9;
  tmpvar_9 = ((tmpvar_7 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_10[0].y;
  v_i0_i1.y = tmpvar_10[1].y;
  v_i0_i1.z = tmpvar_10[2].y;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_7 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_12[0].z;
  v_i0_i1_i2.y = tmpvar_12[1].z;
  v_i0_i1_i2.z = tmpvar_12[2].z;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_13;
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
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1, N);
  tmpvar_7.y = dot (tmpvar_2, N);
  tmpvar_7.z = dot (tmpvar_3, N);
  N = tmpvar_7;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, tmpvar_7);
  diff_i0 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow.w * _EmissionLM);
  glow.w = tmpvar_12;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_13;
  tmpvar_13 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  mediump vec3 tmpvar_14;
  tmpvar_14 = (diff.xyz * tmpvar_13);
  c.xyz = tmpvar_14;
  c.w = diff.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp mat3 tmpvar_6;
  tmpvar_6[0] = tmpvar_1.xyz;
  tmpvar_6[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_6[2] = tmpvar_2;
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_6[0].x;
  tmpvar_7[0].y = tmpvar_6[1].x;
  tmpvar_7[0].z = tmpvar_6[2].x;
  tmpvar_7[1].x = tmpvar_6[0].y;
  tmpvar_7[1].y = tmpvar_6[1].y;
  tmpvar_7[1].z = tmpvar_6[2].y;
  tmpvar_7[2].x = tmpvar_6[0].z;
  tmpvar_7[2].y = tmpvar_6[1].z;
  tmpvar_7[2].z = tmpvar_6[2].z;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_8[0].x;
  v_i0.y = tmpvar_8[1].x;
  v_i0.z = tmpvar_8[2].x;
  highp vec3 tmpvar_9;
  tmpvar_9 = ((tmpvar_7 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_10[0].y;
  v_i0_i1.y = tmpvar_10[1].y;
  v_i0_i1.z = tmpvar_10[2].y;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_7 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_12[0].z;
  v_i0_i1_i2.y = tmpvar_12[1].z;
  v_i0_i1_i2.z = tmpvar_12[2].z;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_13;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  highp vec3 tmpvar_7;
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
  tmpvar_7 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_6)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_6)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_6))));
  N = tmpvar_7;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, tmpvar_7);
  diff_i0 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow.w * _EmissionLM);
  glow.w = tmpvar_12;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  lowp vec3 tmpvar_14;
  tmpvar_14 = ((8.0 * tmpvar_13.w) * tmpvar_13.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = (diff.xyz * tmpvar_14);
  c.xyz = tmpvar_15;
  c.w = diff.w;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_16;
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = TANGENT.xyz;
  tmpvar_2[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_2[2] = gl_Normal;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_4[0].x;
  v_i0.y = tmpvar_4[1].x;
  v_i0.z = tmpvar_4[2].x;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_5[0].y;
  v_i0_i1.y = tmpvar_5[1].y;
  v_i0_i1.z = tmpvar_5[2].y;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_6[0].z;
  v_i0_i1_i2.y = tmpvar_6[1].z;
  v_i0_i1_i2.z = tmpvar_6[2].z;
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
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_10);
  x1.y = dot (unity_SHAg, tmpvar_10);
  x1.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_8.xyzz * tmpvar_8.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_11);
  x2.y = dot (unity_SHBg, tmpvar_11);
  x2.z = dot (unity_SHBb, tmpvar_11);
  vec4 o_i0;
  vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_12;
  vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12.x;
  tmpvar_13.y = (tmpvar_12.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_13 + tmpvar_12.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_3 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_8.x * tmpvar_8.x) - (tmpvar_8.y * tmpvar_8.y))));
  xlv_TEXCOORD6 = (tmpvar_3 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_4;
  glow.xyz = (tmpvar_4.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_4.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0) * clamp (dot (tmpvar_2, normalize (xlv_TEXCOORD4)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
; 63 ALU
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
mov r0.w, c25.x
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c19
dp4 r2.y, r0, c18
dp4 r2.x, r0, c17
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c22
dp4 r0.y, r1, c21
dp4 r0.x, r1, c20
mul r1.xyz, r0.w, c23
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov r0.w, c25.x
mov r0.xyz, c15
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c14.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1, c8
dp4 r4.x, c16, r1
dp4 r0.w, v0, c3
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c14.w
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c14.w
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o4.xyz, r0, c14.w
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c12.x
dp3 o5.y, r2, r4
dp3 o7.y, r2, r3
dp3 o5.z, v2, r4
dp3 o5.x, v1, r4
dp3 o7.z, v2, r3
dp3 o7.x, v1, r3
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
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
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
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_11[0].x;
  v_i0.y = tmpvar_11[1].x;
  v_i0.z = tmpvar_11[2].x;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_10 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_13[0].y;
  v_i0_i1.y = tmpvar_13[1].y;
  v_i0_i1.z = tmpvar_13[2].y;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_10 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_15[0].z;
  v_i0_i1_i2.y = tmpvar_15[1].z;
  v_i0_i1_i2.z = tmpvar_15[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((tmpvar_10 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = _Object2World[0].xyz;
  tmpvar_17[1] = _Object2World[1].xyz;
  tmpvar_17[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = (tmpvar_17 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_21;
  mediump vec4 normal;
  normal = tmpvar_20;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal);
  x1.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal);
  x1.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal);
  x1.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC);
  x3 = tmpvar_30;
  tmpvar_21 = ((x1 + x2) + x3);
  shlight = tmpvar_21;
  tmpvar_7 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_31;
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = (tmpvar_31.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_32 + tmpvar_31.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_10 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_7;
  tmpvar_4 = N;
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_1, N);
  tmpvar_8.y = dot (tmpvar_2, N);
  tmpvar_8.z = dot (tmpvar_3, N);
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump float atten_i0;
  atten_i0 = tmpvar_14;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_4, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_16;
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
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
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
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_11[0].x;
  v_i0.y = tmpvar_11[1].x;
  v_i0.z = tmpvar_11[2].x;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_10 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_13[0].y;
  v_i0_i1.y = tmpvar_13[1].y;
  v_i0_i1.z = tmpvar_13[2].y;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_10 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_15[0].z;
  v_i0_i1_i2.y = tmpvar_15[1].z;
  v_i0_i1_i2.z = tmpvar_15[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((tmpvar_10 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = _Object2World[0].xyz;
  tmpvar_17[1] = _Object2World[1].xyz;
  tmpvar_17[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = (tmpvar_17 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_21;
  mediump vec4 normal;
  normal = tmpvar_20;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal);
  x1.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal);
  x1.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal);
  x1.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC);
  x3 = tmpvar_30;
  tmpvar_21 = ((x1 + x2) + x3);
  shlight = tmpvar_21;
  tmpvar_7 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_31;
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = (tmpvar_31.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_32 + tmpvar_31.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_10 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  tmpvar_4 = tmpvar_7;
  highp vec3 tmpvar_8;
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
  tmpvar_8 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_7)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_7)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_7))));
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump float atten_i0;
  atten_i0 = tmpvar_14;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_4, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_16;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;

uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = TANGENT.xyz;
  tmpvar_2[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_2[2] = gl_Normal;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_4[0].x;
  v_i0.y = tmpvar_4[1].x;
  v_i0.z = tmpvar_4[2].x;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_5[0].y;
  v_i0_i1.y = tmpvar_5[1].y;
  v_i0_i1.z = tmpvar_5[2].y;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_6[0].z;
  v_i0_i1_i2.y = tmpvar_6[1].z;
  v_i0_i1_i2.z = tmpvar_6[2].z;
  vec4 o_i0;
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_7;
  vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_8 + tmpvar_7.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_3 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_i0;
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
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_4;
  glow.xyz = (tmpvar_4.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_4.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  vec3 tmpvar_7;
  tmpvar_7 = ((8.0 * tmpvar_6.w) * tmpvar_6.xyz);
  c.xyz = (diff.xyz * max (min (tmpvar_7, ((tmpvar_5.x * 2.0) * tmpvar_6.xyz)), (tmpvar_7 * tmpvar_5.x)));
  c.w = diff.w;
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
Matrix 4 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c17, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
dp3 r1.y, r0, c4
dp3 r2.y, r0, c6
dp4 r0.w, v0, c3
dp3 r1.x, v1, c4
dp3 r1.z, v2, c4
mul o2.xyz, r1, c14.w
dp3 r1.y, r0, c5
dp4 r0.z, v0, c2
dp3 r1.x, v1, c5
dp3 r1.z, v2, c5
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul o3.xyz, r1, c14.w
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
dp3 r2.x, v1, c6
dp3 r2.z, v2, c6
mul o4.xyz, r2, c14.w
mad o6.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov o6.zw, r0
mad o1.xy, v3, c16, c16.zwzw
mad o5.xy, v4, c15, c15.zwzw
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

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = tmpvar_1.xyz;
  tmpvar_7[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_7[2] = tmpvar_2;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_9[0].x;
  v_i0.y = tmpvar_9[1].x;
  v_i0.z = tmpvar_9[2].x;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_8 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_11[0].y;
  v_i0_i1.y = tmpvar_11[1].y;
  v_i0_i1.z = tmpvar_11[2].y;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_8 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_13[0].z;
  v_i0_i1_i2.y = tmpvar_13[1].z;
  v_i0_i1_i2.z = tmpvar_13[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_8 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_14;
  highp vec4 o_i0;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_i0;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_1, N);
  tmpvar_7.y = dot (tmpvar_2, N);
  tmpvar_7.z = dot (tmpvar_3, N);
  N = tmpvar_7;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, tmpvar_7);
  diff_i0 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow.w * _EmissionLM);
  glow.w = tmpvar_12;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_13;
  tmpvar_13 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x * 2.0)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = (diff.xyz * tmpvar_13);
  c.xyz = tmpvar_14;
  c.w = diff.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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

varying highp vec4 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = tmpvar_1.xyz;
  tmpvar_7[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_7[2] = tmpvar_2;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_9[0].x;
  v_i0.y = tmpvar_9[1].x;
  v_i0.z = tmpvar_9[2].x;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_8 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_10;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_11[0].y;
  v_i0_i1.y = tmpvar_11[1].y;
  v_i0_i1.z = tmpvar_11[2].y;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_8 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_13[0].z;
  v_i0_i1_i2.y = tmpvar_13[1].z;
  v_i0_i1_i2.z = tmpvar_13[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_8 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_14;
  highp vec4 o_i0;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD5 = o_i0;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (diff * _Color);
  diff = tmpvar_5;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  highp vec3 tmpvar_7;
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
  tmpvar_7 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_6)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_6)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_6))));
  N = tmpvar_7;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_DiffCubeIBL, tmpvar_7);
  diff_i0 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (glow.w * _EmissionLM);
  glow.w = tmpvar_12;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  lowp vec3 tmpvar_16;
  tmpvar_16 = max (min (tmpvar_15, ((tmpvar_13.x * 2.0) * tmpvar_14.xyz)), (tmpvar_15 * tmpvar_13.x));
  mediump vec3 tmpvar_17;
  tmpvar_17 = (diff.xyz * tmpvar_16);
  c.xyz = tmpvar_17;
  c.w = diff.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_18;
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_3[0].x;
  v_i0.y = tmpvar_3[1].x;
  v_i0.z = tmpvar_3[2].x;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_4[0].y;
  v_i0_i1.y = tmpvar_4[1].y;
  v_i0_i1.z = tmpvar_4[2].y;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_5[0].z;
  v_i0_i1_i2.y = tmpvar_5[1].z;
  v_i0_i1_i2.z = tmpvar_5[2].z;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_7;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_9);
  x1.y = dot (unity_SHAg, tmpvar_9);
  x1.z = dot (unity_SHAb, tmpvar_9);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyzz * tmpvar_7.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_10);
  x2.y = dot (unity_SHBg, tmpvar_10);
  x2.z = dot (unity_SHBb, tmpvar_10);
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
  tmpvar_16 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_12 * tmpvar_7.x) + (tmpvar_13 * tmpvar_7.y)) + (tmpvar_14 * tmpvar_7.z)) * inversesqrt (tmpvar_15))) * (1.0/((1.0 + (tmpvar_15 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_2 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_2 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_2 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_7.x * tmpvar_7.x) - (tmpvar_7.y * tmpvar_7.y)))) + ((((unity_LightColor[0].xyz * tmpvar_16.x) + (unity_LightColor[1].xyz * tmpvar_16.y)) + (unity_LightColor[2].xyz * tmpvar_16.z)) + (unity_LightColor[3].xyz * tmpvar_16.w)));
  xlv_TEXCOORD6 = (tmpvar_2 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_4;
  glow.xyz = (tmpvar_4.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_4.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_2, normalize (xlv_TEXCOORD4)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
; 89 ALU
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
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov r1.w, c31.x
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.y, r1, c9
dp4 r0.x, r1, c8
mad r3.xyz, r0, c12.w, -v0
mov r1.xyz, v1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r1.yzxw
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c12.w
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c12.w
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o5.y, r2, r4
dp3 o7.y, r2, r3
mul o4.xyz, r0, c12.w
dp3 o5.z, v2, r4
dp3 o5.x, v1, r4
dp3 o7.z, v2, r3
dp3 o7.x, v1, r3
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_10[0].x;
  v_i0.y = tmpvar_10[1].x;
  v_i0.z = tmpvar_10[2].x;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_9 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_12[0].y;
  v_i0_i1.y = tmpvar_12[1].y;
  v_i0_i1.z = tmpvar_12[2].y;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_9 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_14[0].z;
  v_i0_i1_i2.y = tmpvar_14[1].z;
  v_i0_i1_i2.z = tmpvar_14[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_9 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_17;
  mediump vec3 tmpvar_21;
  mediump vec4 normal;
  normal = tmpvar_20;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal);
  x1.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal);
  x1.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal);
  x1.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC);
  x3 = tmpvar_30;
  tmpvar_21 = ((x1 + x2) + x3);
  shlight = tmpvar_21;
  tmpvar_7 = shlight;
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
  tmpvar_36 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_32 * tmpvar_17.x) + (tmpvar_33 * tmpvar_17.y)) + (tmpvar_34 * tmpvar_17.z)) * inversesqrt (tmpvar_35))) * (1.0/((1.0 + (tmpvar_35 * unity_4LightAtten0)))));
  highp vec3 tmpvar_37;
  tmpvar_37 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_36.x) + (unity_LightColor[1].xyz * tmpvar_36.y)) + (unity_LightColor[2].xyz * tmpvar_36.z)) + (unity_LightColor[3].xyz * tmpvar_36.w)));
  tmpvar_7 = tmpvar_37;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_9 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_7;
  tmpvar_4 = N;
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_1, N);
  tmpvar_8.y = dot (tmpvar_2, N);
  tmpvar_8.z = dot (tmpvar_3, N);
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_4, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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

varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_10[0].x;
  v_i0.y = tmpvar_10[1].x;
  v_i0.z = tmpvar_10[2].x;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((tmpvar_9 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_12[0].y;
  v_i0_i1.y = tmpvar_12[1].y;
  v_i0_i1.z = tmpvar_12[2].y;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_9 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_13;
  mat3 tmpvar_14;
  tmpvar_14[0] = _Object2World[0].xyz;
  tmpvar_14[1] = _Object2World[1].xyz;
  tmpvar_14[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_14[0].z;
  v_i0_i1_i2.y = tmpvar_14[1].z;
  v_i0_i1_i2.z = tmpvar_14[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_9 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_15;
  mat3 tmpvar_16;
  tmpvar_16[0] = _Object2World[0].xyz;
  tmpvar_16[1] = _Object2World[1].xyz;
  tmpvar_16[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_17;
  mediump vec3 tmpvar_21;
  mediump vec4 normal;
  normal = tmpvar_20;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAr, normal);
  x1.x = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAg, normal);
  x1.y = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAb, normal);
  x1.z = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBr, tmpvar_25);
  x2.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBg, tmpvar_25);
  x2.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBb, tmpvar_25);
  x2.z = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (unity_SHC.xyz * vC);
  x3 = tmpvar_30;
  tmpvar_21 = ((x1 + x2) + x3);
  shlight = tmpvar_21;
  tmpvar_7 = shlight;
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
  tmpvar_36 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_32 * tmpvar_17.x) + (tmpvar_33 * tmpvar_17.y)) + (tmpvar_34 * tmpvar_17.z)) * inversesqrt (tmpvar_35))) * (1.0/((1.0 + (tmpvar_35 * unity_4LightAtten0)))));
  highp vec3 tmpvar_37;
  tmpvar_37 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_36.x) + (unity_LightColor[1].xyz * tmpvar_36.y)) + (unity_LightColor[2].xyz * tmpvar_36.z)) + (unity_LightColor[3].xyz * tmpvar_36.w)));
  tmpvar_7 = tmpvar_37;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_9 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  tmpvar_4 = tmpvar_7;
  highp vec3 tmpvar_8;
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
  tmpvar_8 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_7)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_7)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_7))));
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_4, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_15;
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
  mat3 tmpvar_2;
  tmpvar_2[0] = TANGENT.xyz;
  tmpvar_2[1] = (cross (gl_Normal, TANGENT.xyz) * TANGENT.w);
  tmpvar_2[2] = gl_Normal;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_4[0].x;
  v_i0.y = tmpvar_4[1].x;
  v_i0.z = tmpvar_4[2].x;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_5[0].y;
  v_i0_i1.y = tmpvar_5[1].y;
  v_i0_i1.z = tmpvar_5[2].y;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_6[0].z;
  v_i0_i1_i2.y = tmpvar_6[1].z;
  v_i0_i1_i2.z = tmpvar_6[2].z;
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
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_10);
  x1.y = dot (unity_SHAg, tmpvar_10);
  x1.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_8.xyzz * tmpvar_8.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_11);
  x2.y = dot (unity_SHBg, tmpvar_11);
  x2.z = dot (unity_SHBb, tmpvar_11);
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
  tmpvar_17 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_13 * tmpvar_8.x) + (tmpvar_14 * tmpvar_8.y)) + (tmpvar_15 * tmpvar_8.z)) * inversesqrt (tmpvar_16))) * (1.0/((1.0 + (tmpvar_16 * unity_4LightAtten0)))));
  vec4 o_i0;
  vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_18;
  vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_18.x;
  tmpvar_19.y = (tmpvar_18.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_19 + tmpvar_18.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_3 * v_i0) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_3 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_3 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = (tmpvar_3 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD5 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_8.x * tmpvar_8.x) - (tmpvar_8.y * tmpvar_8.y)))) + ((((unity_LightColor[0].xyz * tmpvar_17.x) + (unity_LightColor[1].xyz * tmpvar_17.y)) + (unity_LightColor[2].xyz * tmpvar_17.z)) + (unity_LightColor[3].xyz * tmpvar_17.w)));
  xlv_TEXCOORD6 = (tmpvar_3 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec3 tmpvar_2;
  tmpvar_2 = normalize (normal);
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
  vec4 tmpvar_3;
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * dot (xlv_TEXCOORD1, tmpvar_2)) + ((v_i0_i1.xyz * dot (xlv_TEXCOORD2, tmpvar_2)) + (v_i0_i1_i2.xyz * dot (xlv_TEXCOORD3, tmpvar_2)))));
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_4;
  glow.xyz = (tmpvar_4.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_4.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x * 2.0) * clamp (dot (tmpvar_2, normalize (xlv_TEXCOORD4)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = (c.xyz + ((((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
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
; 94 ALU
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
add r0.xyz, r2, r0
add o6.xyz, r0, r1
mov r1.w, c33.x
mov r1.xyz, c15
dp4 r0.z, r1, c10
dp4 r0.y, r1, c9
dp4 r0.x, r1, c8
mad r3.xyz, r0, c14.w, -v0
mov r1.xyz, v1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r1.yzxw
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1, c8
dp4 r4.x, c16, r1
dp4 r0.w, v0, c3
dp3 r0.y, r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c14.w
dp3 r0.y, r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c14.w
dp3 r0.y, r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o4.xyz, r0, c14.w
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c33.z
mul r1.y, r1, c12.x
dp3 o5.y, r2, r4
dp3 o7.y, r2, r3
dp3 o5.z, v2, r4
dp3 o5.x, v1, r4
dp3 o7.z, v2, r3
dp3 o7.x, v1, r3
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
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
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
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_11[0].x;
  v_i0.y = tmpvar_11[1].x;
  v_i0.z = tmpvar_11[2].x;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_10 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_13[0].y;
  v_i0_i1.y = tmpvar_13[1].y;
  v_i0_i1.z = tmpvar_13[2].y;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_10 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_15[0].z;
  v_i0_i1_i2.y = tmpvar_15[1].z;
  v_i0_i1_i2.z = tmpvar_15[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((tmpvar_10 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = _Object2World[0].xyz;
  tmpvar_17[1] = _Object2World[1].xyz;
  tmpvar_17[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_18;
  mediump vec3 tmpvar_22;
  mediump vec4 normal;
  normal = tmpvar_21;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAr, normal);
  x1.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAg, normal);
  x1.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAb, normal);
  x1.z = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBr, tmpvar_26);
  x2.x = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBg, tmpvar_26);
  x2.y = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBb, tmpvar_26);
  x2.z = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (unity_SHC.xyz * vC);
  x3 = tmpvar_31;
  tmpvar_22 = ((x1 + x2) + x3);
  shlight = tmpvar_22;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosX0 - tmpvar_32.x);
  highp vec4 tmpvar_34;
  tmpvar_34 = (unity_4LightPosY0 - tmpvar_32.y);
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosZ0 - tmpvar_32.z);
  highp vec4 tmpvar_36;
  tmpvar_36 = (((tmpvar_33 * tmpvar_33) + (tmpvar_34 * tmpvar_34)) + (tmpvar_35 * tmpvar_35));
  highp vec4 tmpvar_37;
  tmpvar_37 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_33 * tmpvar_18.x) + (tmpvar_34 * tmpvar_18.y)) + (tmpvar_35 * tmpvar_18.z)) * inversesqrt (tmpvar_36))) * (1.0/((1.0 + (tmpvar_36 * unity_4LightAtten0)))));
  highp vec3 tmpvar_38;
  tmpvar_38 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_37.x) + (unity_LightColor[1].xyz * tmpvar_37.y)) + (unity_LightColor[2].xyz * tmpvar_37.z)) + (unity_LightColor[3].xyz * tmpvar_37.w)));
  tmpvar_7 = tmpvar_38;
  highp vec4 o_i0;
  highp vec4 tmpvar_39;
  tmpvar_39 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_39;
  highp vec2 tmpvar_40;
  tmpvar_40.x = tmpvar_39.x;
  tmpvar_40.y = (tmpvar_39.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_40 + tmpvar_39.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_10 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_7;
  tmpvar_4 = N;
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_1, N);
  tmpvar_8.y = dot (tmpvar_2, N);
  tmpvar_8.z = dot (tmpvar_3, N);
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump float atten_i0;
  atten_i0 = tmpvar_14;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_4, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_16;
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
varying highp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
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
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  vec3 v_i0;
  v_i0.x = tmpvar_11[0].x;
  v_i0.y = tmpvar_11[1].x;
  v_i0.z = tmpvar_11[2].x;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_10 * v_i0) * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  mat3 tmpvar_13;
  tmpvar_13[0] = _Object2World[0].xyz;
  tmpvar_13[1] = _Object2World[1].xyz;
  tmpvar_13[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_13[0].y;
  v_i0_i1.y = tmpvar_13[1].y;
  v_i0_i1.z = tmpvar_13[2].y;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_10 * v_i0_i1) * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  mat3 tmpvar_15;
  tmpvar_15[0] = _Object2World[0].xyz;
  tmpvar_15[1] = _Object2World[1].xyz;
  tmpvar_15[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_15[0].z;
  v_i0_i1_i2.y = tmpvar_15[1].z;
  v_i0_i1_i2.z = tmpvar_15[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((tmpvar_10 * v_i0_i1_i2) * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = _Object2World[0].xyz;
  tmpvar_17[1] = _Object2World[1].xyz;
  tmpvar_17[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_18;
  mediump vec3 tmpvar_22;
  mediump vec4 normal;
  normal = tmpvar_21;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAr, normal);
  x1.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAg, normal);
  x1.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAb, normal);
  x1.z = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBr, tmpvar_26);
  x2.x = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBg, tmpvar_26);
  x2.y = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBb, tmpvar_26);
  x2.z = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (unity_SHC.xyz * vC);
  x3 = tmpvar_31;
  tmpvar_22 = ((x1 + x2) + x3);
  shlight = tmpvar_22;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosX0 - tmpvar_32.x);
  highp vec4 tmpvar_34;
  tmpvar_34 = (unity_4LightPosY0 - tmpvar_32.y);
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosZ0 - tmpvar_32.z);
  highp vec4 tmpvar_36;
  tmpvar_36 = (((tmpvar_33 * tmpvar_33) + (tmpvar_34 * tmpvar_34)) + (tmpvar_35 * tmpvar_35));
  highp vec4 tmpvar_37;
  tmpvar_37 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_33 * tmpvar_18.x) + (tmpvar_34 * tmpvar_18.y)) + (tmpvar_35 * tmpvar_18.z)) * inversesqrt (tmpvar_36))) * (1.0/((1.0 + (tmpvar_36 * unity_4LightAtten0)))));
  highp vec3 tmpvar_38;
  tmpvar_38 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_37.x) + (unity_LightColor[1].xyz * tmpvar_37.y)) + (unity_LightColor[2].xyz * tmpvar_37.z)) + (unity_LightColor[3].xyz * tmpvar_37.w)));
  tmpvar_7 = tmpvar_38;
  highp vec4 o_i0;
  highp vec4 tmpvar_39;
  tmpvar_39 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_39;
  highp vec2 tmpvar_40;
  tmpvar_40.x = tmpvar_39.x;
  tmpvar_40.y = (tmpvar_39.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_40 + tmpvar_39.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = (tmpvar_10 * (((_World2Object * tmpvar_20).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD7 = o_i0;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD1;
  tmpvar_2 = xlv_TEXCOORD2;
  tmpvar_3 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_4;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  tmpvar_4 = tmpvar_7;
  highp vec3 tmpvar_8;
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
  tmpvar_8 = ((v_i0.xyz * dot (tmpvar_1, tmpvar_7)) + ((v_i0_i1.xyz * dot (tmpvar_2, tmpvar_7)) + (v_i0_i1_i2.xyz * dot (tmpvar_3, tmpvar_7))));
  N = tmpvar_8;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_DiffCubeIBL, tmpvar_8);
  diff_i0 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (glow.w * _EmissionLM);
  glow.w = tmpvar_13;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD4;
  mediump float atten_i0;
  atten_i0 = tmpvar_14;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_4, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + (diff.xyz * xlv_TEXCOORD5));
  c.xyz = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + ((((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x) + (glow.xyz * _ExposureIBL.w)));
  c.xyz = tmpvar_16;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   d3d9 - ALU: 29 to 40, TEX: 4 to 6
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 4 [_LightColor0]
Vector 5 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 6 [_Color]
Vector 7 [_GlowColor]
Float 8 [_GlowStrength]
Float 9 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_DiffCubeIBL] CUBE
SetTexture 3 [_Illum] 2D
"ps_3_0
; 39 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c10, 2.00000000, -1.00000000, 1.00000000, 0
def c11, 0.75341797, 0.24682617, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c10.x, c10.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c10
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r0.x, r2, v3
mul r1.xyz, r0.x, c2
dp3_pp r0.x, r2, v2
mad r1.xyz, r0.x, c1, r1
dp3_pp r0.x, r2, v1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s2
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c11
add_pp r0.w, r1.x, r1.y
texld r1, v0, s3
mul_pp r3.xyz, r0, r0.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r0.xyz, r0, c5.w
mul_pp r1.w, r1, c9.x
mul_pp r4.xyz, r0, r1.w
mul_pp r1.xyz, r1, c7
mad_pp r4.xyz, r1, c8.x, r4
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, v4
dp3_pp_sat r1.x, r2, r1
mul_pp r1.xyz, r1.x, r0
mul_pp r3.xyz, r0, r3
mul_pp r4.xyz, r4, c5.w
mad_pp r2.xyz, r3, c5.x, r4
mul_pp r0.xyz, r0, v5
mul_pp r1.xyz, r1, c4
mad_pp r0.xyz, r1, c10.x, r0
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, r0
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
Vector 4 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 5 [_Color]
Vector 6 [_GlowColor]
Float 7 [_GlowStrength]
Float 8 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_DiffCubeIBL] CUBE
SetTexture 3 [_Illum] 2D
SetTexture 4 [unity_Lightmap] 2D
"ps_3_0
; 33 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
def c9, 2.00000000, -1.00000000, 1.00000000, 8.00000000
def c10, 0.75341797, 0.24682617, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c9.x, c9.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_pp r0.w, r0, v3
mul r1.xyz, r0.w, c2
dp3_pp r0.w, r0, v2
mad r1.xyz, r0.w, c1, r1
dp3_pp r0.x, v1, r0
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s2
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c10
add_pp r0.w, r1.x, r1.y
mul_pp r2.xyz, r0, r0.w
texld r0, v0, s3
texld r1, v0, s0
mul_pp r1, r1, c5
mul_pp r1.xyz, r1, c4.w
mul_pp r0.w, r0, c8.x
mul_pp r3.xyz, r1, r0.w
mul_pp r0.xyz, r0, c6
mad_pp r3.xyz, r0, c7.x, r3
texld r0, v4, s4
mul_pp r0.xyz, r0.w, r0
mul_pp r2.xyz, r1, r2
mul_pp r3.xyz, r3, c4.w
mad_pp r2.xyz, r2, c4.x, r3
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c9.w, r2
mov_pp oC0.w, r1
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
Vector 5 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 6 [_Color]
Vector 7 [_GlowColor]
Float 8 [_GlowStrength]
Float 9 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_DiffCubeIBL] CUBE
SetTexture 3 [_Illum] 2D
SetTexture 4 [_ShadowMapTexture] 2D
"ps_3_0
; 40 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
def c10, 2.00000000, -1.00000000, 1.00000000, 0
def c11, 0.75341797, 0.24682617, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord7 v7
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c10.x, c10.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c10
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r0.x, r2, v3
mul r1.xyz, r0.x, c2
dp3_pp r0.x, r2, v2
mad r1.xyz, r0.x, c1, r1
dp3_pp r0.x, r2, v1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s2
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c11
add_pp r0.w, r1.x, r1.y
texld r1, v0, s3
mul_pp r3.xyz, r0, r0.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r0.xyz, r0, c5.w
mul_pp r1.w, r1, c9.x
mul_pp r4.xyz, r0, r1.w
mul_pp r1.xyz, r1, c7
mad_pp r4.xyz, r1, c8.x, r4
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, v4
dp3_pp_sat r1.y, r2, r1
texldp r1.x, v7, s4
mul_pp r1.x, r1, r1.y
mul_pp r1.xyz, r1.x, r0
mul_pp r3.xyz, r0, r3
mul_pp r4.xyz, r4, c5.w
mad_pp r2.xyz, r3, c5.x, r4
mul_pp r0.xyz, r0, v5
mul_pp r1.xyz, r1, c4
mad_pp r0.xyz, r1, c10.x, r0
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, r0
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
Vector 4 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 5 [_Color]
Vector 6 [_GlowColor]
Float 7 [_GlowStrength]
Float 8 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_DiffCubeIBL] CUBE
SetTexture 3 [_Illum] 2D
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_3_0
; 38 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c9, 8.00000000, 2.00000000, -1.00000000, 1.00000000
def c10, 0.75341797, 0.24682617, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c9.y, c9.z
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_pp r0.w, r0, v3
mul r1.xyz, r0.w, c2
dp3_pp r0.w, r0, v2
mad r1.xyz, r0.w, c1, r1
dp3_pp r0.x, v1, r0
mad r0.xyz, r0.x, c0, r1
texld r2, r0, s2
mul_pp r0.x, r2.w, r2.w
mul_pp r0.y, r2.w, r0.x
mul_pp r0.xy, r0, c10
add_pp r2.w, r0.x, r0.y
texld r0, v0, s3
texld r1, v0, s0
mul_pp r1, r1, c5
mul_pp r1.xyz, r1, c4.w
mul_pp r0.w, r0, c8.x
mul_pp r2.xyz, r2, r2.w
mul_pp r3.xyz, r1, r0.w
mul_pp r0.xyz, r0, c6
mad_pp r0.xyz, r0, c7.x, r3
mul_pp r0.xyz, r0, c4.w
mul_pp r2.xyz, r1, r2
mad_pp r2.xyz, r2, c4.x, r0
texld r0, v4, s5
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v5, s4
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c9.x
mul_pp r0.xyz, r0, c9.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r1, r0, r2
mov_pp oC0.w, r1
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
Vector 5 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 6 [_Color]
Vector 7 [_GlowColor]
Float 8 [_GlowStrength]
Float 9 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_DiffCubeIBL] CUBE
SetTexture 3 [_Illum] 2D
"ps_3_0
; 35 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c10, 2.00000000, -1.00000000, 1.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c10.x, c10.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c10
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r0.x, r2, v3
mul r1.xyz, r0.x, c2
dp3_pp r0.x, r2, v2
mad r1.xyz, r0.x, c1, r1
dp3_pp r0.x, r2, v1
mad r0.xyz, r0.x, c0, r1
texld r1, v0, s3
texld r0, r0, s2
mul_pp r3.xyz, r0, r0.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r0.xyz, r0, c5.w
mul_pp r1.w, r1, c9.x
mul_pp r4.xyz, r0, r1.w
mul_pp r1.xyz, r1, c7
mad_pp r4.xyz, r1, c8.x, r4
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, v4
dp3_pp_sat r1.x, r2, r1
mul_pp r1.xyz, r1.x, r0
mul_pp r3.xyz, r0, r3
mul_pp r4.xyz, r4, c5.w
mad_pp r2.xyz, r3, c5.x, r4
mul_pp r0.xyz, r0, v5
mul_pp r1.xyz, r1, c4
mad_pp r0.xyz, r1, c10.x, r0
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, r0
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
Vector 4 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 5 [_Color]
Vector 6 [_GlowColor]
Float 7 [_GlowStrength]
Float 8 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_DiffCubeIBL] CUBE
SetTexture 3 [_Illum] 2D
SetTexture 4 [unity_Lightmap] 2D
"ps_3_0
; 29 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
def c9, 2.00000000, -1.00000000, 1.00000000, 8.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c9.x, c9.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_pp r0.w, r0, v3
mul r1.xyz, r0.w, c2
dp3_pp r0.w, r0, v2
mad r1.xyz, r0.w, c1, r1
dp3_pp r0.x, v1, r0
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s2
mul_pp r2.xyz, r0, r0.w
texld r0, v0, s3
texld r1, v0, s0
mul_pp r1, r1, c5
mul_pp r1.xyz, r1, c4.w
mul_pp r0.w, r0, c8.x
mul_pp r3.xyz, r1, r0.w
mul_pp r0.xyz, r0, c6
mad_pp r3.xyz, r0, c7.x, r3
texld r0, v4, s4
mul_pp r0.xyz, r0.w, r0
mul_pp r2.xyz, r1, r2
mul_pp r3.xyz, r3, c4.w
mad_pp r2.xyz, r2, c4.x, r3
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c9.w, r2
mov_pp oC0.w, r1
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
Vector 5 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 6 [_Color]
Vector 7 [_GlowColor]
Float 8 [_GlowStrength]
Float 9 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_DiffCubeIBL] CUBE
SetTexture 3 [_Illum] 2D
SetTexture 4 [_ShadowMapTexture] 2D
"ps_3_0
; 36 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
def c10, 2.00000000, -1.00000000, 1.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord7 v7
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c10.x, c10.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c10
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r0.x, r2, v3
mul r1.xyz, r0.x, c2
dp3_pp r0.x, r2, v2
mad r1.xyz, r0.x, c1, r1
dp3_pp r0.x, r2, v1
mad r0.xyz, r0.x, c0, r1
texld r1, v0, s3
texld r0, r0, s2
mul_pp r3.xyz, r0, r0.w
texld r0, v0, s0
mul_pp r0, r0, c6
mul_pp r0.xyz, r0, c5.w
mul_pp r1.w, r1, c9.x
mul_pp r4.xyz, r0, r1.w
mul_pp r1.xyz, r1, c7
mad_pp r4.xyz, r1, c8.x, r4
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, v4
dp3_pp_sat r1.y, r2, r1
texldp r1.x, v7, s4
mul_pp r1.x, r1, r1.y
mul_pp r1.xyz, r1.x, r0
mul_pp r3.xyz, r0, r3
mul_pp r4.xyz, r4, c5.w
mad_pp r2.xyz, r3, c5.x, r4
mul_pp r0.xyz, r0, v5
mul_pp r1.xyz, r1, c4
mad_pp r0.xyz, r1, c10.x, r0
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, r0
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
Vector 4 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 5 [_Color]
Vector 6 [_GlowColor]
Float 7 [_GlowStrength]
Float 8 [_EmissionLM]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_DiffCubeIBL] CUBE
SetTexture 3 [_Illum] 2D
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_3_0
; 34 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c9, 8.00000000, 2.00000000, -1.00000000, 1.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dcl_texcoord5 v5
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c9.y, c9.z
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_pp r0.w, r0, v3
mul r1.xyz, r0.w, c2
dp3_pp r0.w, r0, v2
texld r2, v0, s0
mul_pp r2, r2, c5
mad r1.xyz, r0.w, c1, r1
dp3_pp r0.x, v1, r0
mad r0.xyz, r0.x, c0, r1
texld r1, v0, s3
texld r0, r0, s2
mul_pp r2.xyz, r2, c4.w
mul_pp r0.xyz, r0, r0.w
mul_pp r1.w, r1, c8.x
mul_pp r3.xyz, r2, r1.w
mul_pp r1.xyz, r1, c6
mad_pp r1.xyz, r1, c7.x, r3
mul_pp r0.xyz, r2, r0
mul_pp r1.xyz, r1, c4.w
mad_pp r1.xyz, r0, c4.x, r1
texld r0, v4, s5
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v5, s4
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c9.x
mul_pp r0.xyz, r0, c9.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r2, r0, r1
mov_pp oC0.w, r2
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
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * 2.0) * clamp (dot (normalize (normal), normalize (normalize (xlv_TEXCOORD1))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c20.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTexture0, tmpvar_10);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_11.w;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTexture0, tmpvar_10);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_11.w;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (normalize (normal), normalize (xlv_TEXCOORD1)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c12.x
mov r0.xyz, c9
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
mad r3.xyz, r1, c8.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c6
dp4 r4.z, c10, r0
mov r0, c5
mov r1, c4
dp4 r4.y, c10, r0
dp4 r4.x, c10, r1
dp3 o2.y, r4, r2
dp3 o3.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lightDir = xlv_TEXCOORD1;
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lightDir = xlv_TEXCOORD1;
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w) * 2.0) * clamp (dot (normalize (normal), normalize (normalize (xlv_TEXCOORD1))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c20.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp4 r0.w, v0, c7
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_11;
  tmpvar_11 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTextureB0, tmpvar_11);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_10.w) * tmpvar_12.w);
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_11;
  tmpvar_11 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTextureB0, tmpvar_11);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_10.w) * tmpvar_12.w);
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((((texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w) * 2.0) * clamp (dot (normalize (normal), normalize (normalize (xlv_TEXCOORD1))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c20.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTextureB0, tmpvar_10);
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_11.w * tmpvar_12.w);
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTextureB0, tmpvar_10);
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_11.w * tmpvar_12.w);
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2D (_LightTexture0, xlv_TEXCOORD3).w * 2.0) * clamp (dot (normalize (normal), normalize (xlv_TEXCOORD1)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c20.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r4, r2
dp3 o3.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lightDir = xlv_TEXCOORD1;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_9.w;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lightDir = xlv_TEXCOORD1;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_9.w;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * 2.0) * clamp (dot (normalize (normal), normalize (normalize (xlv_TEXCOORD1))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c20.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTexture0, tmpvar_10);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_11.w;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTexture0, tmpvar_10);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_11.w;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (normalize (normal), normalize (xlv_TEXCOORD1)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c12.x
mov r0.xyz, c9
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
mad r3.xyz, r1, c8.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c6
dp4 r4.z, c10, r0
mov r0, c5
mov r1, c4
dp4 r4.y, c10, r0
dp4 r4.x, c10, r1
dp3 o2.y, r4, r2
dp3 o3.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lightDir = xlv_TEXCOORD1;
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lightDir = xlv_TEXCOORD1;
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w) * 2.0) * clamp (dot (normalize (normal), normalize (normalize (xlv_TEXCOORD1))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c20.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp4 r0.w, v0, c7
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_11;
  tmpvar_11 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTextureB0, tmpvar_11);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_10.w) * tmpvar_12.w);
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_11;
  tmpvar_11 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTextureB0, tmpvar_11);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * tmpvar_10.w) * tmpvar_12.w);
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((((texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3))).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w) * 2.0) * clamp (dot (normalize (normal), normalize (normalize (xlv_TEXCOORD1))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c20.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTextureB0, tmpvar_10);
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_11.w * tmpvar_12.w);
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD1);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTextureB0, tmpvar_10);
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_11.w * tmpvar_12.w);
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
  xlv_TEXCOORD1 = (tmpvar_2 * (_World2Object * _WorldSpaceLightPos0).xyz);
  xlv_TEXCOORD2 = (tmpvar_2 * (((_World2Object * tmpvar_3).xyz * unity_Scale.w) - gl_Vertex.xyz));
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform sampler2D _Illum;
uniform float _GlowStrength;
uniform vec4 _GlowColor;
uniform vec4 _ExposureIBL;
uniform float _EmissionLM;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 c;
  vec4 glow;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_2;
  glow.xyz = (tmpvar_2.xyz * _GlowColor.xyz);
  glow.xyz = (glow.xyz * _GlowStrength);
  glow.w = (tmpvar_2.w * _EmissionLM);
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2D (_LightTexture0, xlv_TEXCOORD3).w * 2.0) * clamp (dot (normalize (normal), normalize (xlv_TEXCOORD1)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
mov r0.w, c20.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r4, r2
dp3 o3.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  N = tmpvar_4;
  tmpvar_1 = N;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lightDir = xlv_TEXCOORD1;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_9.w;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
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
varying mediump vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_4;
  highp mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_5[2] = tmpvar_2;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_9;
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
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform highp float _GlowStrength;
uniform highp vec4 _GlowColor;
uniform mediump vec4 _ExposureIBL;
uniform highp float _EmissionLM;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  mediump vec4 glow;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  N = normal;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  tmpvar_1 = tmpvar_4;
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
  N = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_Illum, xlv_TEXCOORD0);
  glow = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (glow.xyz * _GlowColor.xyz);
  glow.xyz = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (glow.xyz * _GlowStrength);
  glow.xyz = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (glow.w * _EmissionLM);
  glow.w = tmpvar_8;
  glow.xyz = (glow.xyz + (diff.xyz * glow.w));
  lightDir = xlv_TEXCOORD1;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_9.w;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir_i0)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 10
//   d3d9 - ALU: 19 to 29, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "POINT" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "POINT" }
Vector 4 [_LightColor0]
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 24 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.x, r1.y, r1.y
mad_pp r0.x, -r1, r1, -r0
add_pp r0.x, r0, c7.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3_pp r0.y, v1, v1
rsq_pp r0.y, r0.y
mul_pp r0.xyz, r0.y, v1
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, r0
mul r1.xyz, r0.w, r1
texld r0.xyz, v0, s0
dp3_pp_sat r0.w, r1, r2
mul_pp r1.xyz, r0, c6
dp3 r0.x, v3, v3
texld r0.x, r0.x, s3
mul_pp r1.xyz, r1, c5.w
mul_pp r0.x, r0, r0.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_3_0
; 19 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c7
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
texld r0.xyz, v0, s0
mul_pp r2.xyz, r0, c6
dp3_pp r0.w, v1, v1
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, v1
mul_pp r2.xyz, r2, c5.w
dp3_pp_sat r0.x, r1, r0
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_3_0
; 29 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_2d s4
def c7, 0.00000000, 1.00000000, 0.50000000, 2.00000000
def c8, 2.00000000, -1.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord3 v3
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c8.x, c8.y
mul_pp r0.x, r1.y, r1.y
mad_pp r0.x, -r1, r1, -r0
add_pp r0.x, r0, c7.y
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3_pp r0.y, v1, v1
rsq_pp r0.y, r0.y
mul_pp r0.xyz, r0.y, v1
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, r0
mul r1.xyz, r0.w, r1
texld r0.xyz, v0, s0
dp3_pp_sat r1.w, r1, r2
mul_pp r1.xyz, r0, c6
rcp r0.x, v3.w
mad r2.xy, v3, r0.x, c7.z
dp3 r0.x, v3, v3
mul_pp r1.xyz, r1, c5.w
texld r0.w, r2, s3
cmp r0.y, -v3.z, c7.x, c7
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s4
mul_pp r0.x, r0.y, r0
mul_pp r0.x, r0, r1.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.w
mov_pp oC0.w, c7.x
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_3_0
; 25 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_cube s4
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
dp3_pp r0.w, v1, v1
rsq_pp r1.x, r0.w
mul_pp r2.xyz, r1.x, v1
add_pp r0.z, r0, c7
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
dp3_pp r1.w, r2, r2
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, r2
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
dp3_pp_sat r1.w, r1, r2
mul_pp r1.xyz, r0, c5.w
dp3 r0.x, v3, v3
texld r0.w, v3, s4
texld r0.x, r0.x, s3
mul r0.x, r0, r0.w
mul_pp r0.x, r0, r1.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord3 v3.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c7
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
dp3_pp r1.w, v1, v1
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, v1
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
dp3_pp_sat r1.x, r1, r2
mul_pp r2.xyz, r0, c5.w
texld r0.w, v3, s3
mul_pp r0.x, r0.w, r1
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_3_0
; 24 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.x, r1.y, r1.y
mad_pp r0.x, -r1, r1, -r0
add_pp r0.x, r0, c7.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3_pp r0.y, v1, v1
rsq_pp r0.y, r0.y
mul_pp r0.xyz, r0.y, v1
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, r0
mul r1.xyz, r0.w, r1
texld r0.xyz, v0, s0
dp3_pp_sat r0.w, r1, r2
mul_pp r1.xyz, r0, c6
dp3 r0.x, v3, v3
texld r0.x, r0.x, s2
mul_pp r1.xyz, r1, c5.w
mul_pp r0.x, r0, r0.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_3_0
; 19 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c7
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
texld r0.xyz, v0, s0
mul_pp r2.xyz, r0, c6
dp3_pp r0.w, v1, v1
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, v1
mul_pp r2.xyz, r2, c5.w
dp3_pp_sat r0.x, r1, r0
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"ps_3_0
; 29 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c7, 0.00000000, 1.00000000, 0.50000000, 2.00000000
def c8, 2.00000000, -1.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord3 v3
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c8.x, c8.y
mul_pp r0.x, r1.y, r1.y
mad_pp r0.x, -r1, r1, -r0
add_pp r0.x, r0, c7.y
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3_pp r0.y, v1, v1
rsq_pp r0.y, r0.y
mul_pp r0.xyz, r0.y, v1
dp3_pp r1.w, r0, r0
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, r0
mul r1.xyz, r0.w, r1
texld r0.xyz, v0, s0
dp3_pp_sat r1.w, r1, r2
mul_pp r1.xyz, r0, c6
rcp r0.x, v3.w
mad r2.xy, v3, r0.x, c7.z
dp3 r0.x, v3, v3
mul_pp r1.xyz, r1, c5.w
texld r0.w, r2, s2
cmp r0.y, -v3.z, c7.x, c7
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s3
mul_pp r0.x, r0.y, r0
mul_pp r0.x, r0, r1.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.w
mov_pp oC0.w, c7.x
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"ps_3_0
; 25 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord3 v3.xyz
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
dp3_pp r0.w, v1, v1
rsq_pp r1.x, r0.w
mul_pp r2.xyz, r1.x, v1
add_pp r0.z, r0, c7
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
dp3_pp r1.w, r2, r2
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, r2
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
dp3_pp_sat r1.w, r1, r2
mul_pp r1.xyz, r0, c5.w
dp3 r0.x, v3, v3
texld r0.w, v3, s3
texld r0.x, r0.x, s2
mul r0.x, r0, r0.w
mul_pp r0.x, r0, r1.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7
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
Vector 5 [_ExposureIBL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_3_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord3 v3.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c7
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
dp3_pp r1.w, v1, v1
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, v1
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
dp3_pp_sat r1.x, r1, r2
mul_pp r2.xyz, r0, c5.w
texld r0.w, v3, s2
mul_pp r0.x, r0.w, r1
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7
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

#LINE 59

	}
	
	FallBack "Diffuse"
}
