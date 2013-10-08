// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Transparent/Simple Glass/Specular IBL" {
	Properties {
		_Color   ("Diffuse Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecInt ("Specular Intensity", Float) = 1.0
		_Shininess ("Specular Sharpness", Range(2.0,8.0)) = 4.0
		_Fresnel ("Fresnel Strength", Range(0.0,1.0)) = 0.0
		_MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
		_SpecTex ("Specular(RGB) Gloss(A)", 2D) = "white" {}
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
// Vertex combos: 12
//   d3d9 - ALU: 22 to 78
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;

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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_5);
  x1.y = dot (unity_SHAg, tmpvar_5);
  x1.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_6);
  x2.y = dot (unity_SHBg, tmpvar_6);
  x2.z = dot (unity_SHBb, tmpvar_6);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y))));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD3);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  float tmpvar_9;
  tmpvar_9 = (1.0 - tmpvar_4.w);
  float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  tmpvar_8 = ((7.0 + tmpvar_10) - (_Shininess * tmpvar_10));
  float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - tmpvar_8));
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
  vec4 tmpvar_12;
  tmpvar_12.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_12.w);
  float tmpvar_14;
  tmpvar_14 = (tmpvar_13.w * tmpvar_13.w);
  vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14;
  tmpvar_15.y = (tmpvar_13.w * tmpvar_14);
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
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  float tmpvar_17;
  tmpvar_17 = (tmpvar_16.w * tmpvar_16.w);
  vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17;
  tmpvar_18.y = (tmpvar_16.w * tmpvar_17);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_19;
  tmpvar_19 = normalize (_WorldSpaceLightPos0.xyz);
  float tmpvar_20;
  tmpvar_20 = clamp (dot (xlv_TEXCOORD3, tmpvar_19), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_20) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize ((normalize (xlv_TEXCOORD2) + tmpvar_19))), 0.0, 1.0), tmpvar_11)) * clamp ((10.0 * tmpvar_20), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_11 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_1 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((((tmpvar_13.xyz * dot (vec2(0.7532, 0.2468), tmpvar_15)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_16.xyz * dot (vec2(0.7532, 0.2468), tmpvar_18)) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [_MainTex_ST]
"vs_3_0
; 43 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.w, r1, c4
mov r0.x, r3.w
mov r0.y, r2.w
mov r0.z, c22.x
mul r1, r0.wxyy, r0.xyyw
dp4 r2.z, r0.wxyz, c16
dp4 r2.y, r0.wxyz, c15
dp4 r2.x, r0.wxyz, c14
dp4 r0.z, r1, c19
dp4 r0.x, r1, c17
dp4 r0.y, r1, c18
add r2.xyz, r2, r0
mov r1.w, c22.x
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r1.xyz, r0, c12.w, -v0
mul r0.y, r3.w, r3.w
mad r1.w, r0, r0, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c22.y, -r1
mul r3.xyz, r1.w, c20
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o5.xyz, r2, r3
add o3.xyz, -r0, c13
mov o4.z, r2.w
mov o4.y, r3.w
mov o4.x, r0.w
mad o1.xy, v2, c21, c21.zwzw
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_9;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  tmpvar_9 = ((7.0 + tmpvar_11) - (shininess * tmpvar_11));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - tmpvar_9));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_13;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_9;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_2;
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_1, lightDir), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_18) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_18), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_21;
  frag.xyz = (frag.xyz + (tmpvar_21 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_23;
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_3 = (diff.xyz * diff.w);
  N = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - fresnel_i0);
  tmpvar_11.y = fresnel_i0;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_12;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - spec.w);
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (shininess * tmpvar_14));
  mediump float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  highp float gloss;
  gloss = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_16;
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
  glossLod_i0_i1 = tmpvar_12;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_17.w = glossLod_i0_i1;
  lookup = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19;
  tmpvar_20.y = (spec_i0.w * tmpvar_19);
  highp vec3 tmpvar_21;
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
  tmpvar_21 = ((v_i0_i0.xyz * tmpvar_7.x) + ((v_i0_i1_i0.xyz * tmpvar_7.y) + (v_i0_i1_i2_i0.xyz * tmpvar_7.z)));
  N = tmpvar_21;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_DiffCubeIBL, tmpvar_21);
  diff_i0 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23;
  tmpvar_24.y = (diff_i0.w * tmpvar_23);
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_25;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize (lightDir);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_1, tmpvar_26), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_27) * tmpvar_3) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_26))), 0.0, 1.0);
  specRefl = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = vec3(pow (specRefl, tmpvar_15));
  spec_i0_i1 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_27), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_30;
  frag.xyz = (frag.xyz + (tmpvar_30 * tmpvar_4));
  c = frag;
  mediump vec3 tmpvar_31;
  tmpvar_31 = (c.xyz + (tmpvar_3 * xlv_TEXCOORD4));
  c.xyz = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = (c.xyz + ((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_20)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_24)) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_32;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (tmpvar_1);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  vec4 tmpvar_10;
  tmpvar_10.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_10.w = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, tmpvar_10.xyz, tmpvar_10.w);
  float tmpvar_12;
  tmpvar_12 = (tmpvar_11.w * tmpvar_11.w);
  vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12;
  tmpvar_13.y = (tmpvar_11.w * tmpvar_12);
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
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  float tmpvar_15;
  tmpvar_15 = (tmpvar_14.w * tmpvar_14.w);
  vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15;
  tmpvar_16.y = (tmpvar_14.w * tmpvar_15);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  c.xyz = ((diff.xyz * tmpvar_2.w) * ((8.0 * tmpvar_17.w) * tmpvar_17.xyz));
  c.w = diff.w;
  c.xyz = (c.xyz + ((((tmpvar_11.xyz * dot (vec2(0.7532, 0.2468), tmpvar_13)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * dot (vec2(0.7532, 0.2468), tmpvar_16)) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
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
; 22 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c16, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.xyz, c13
mov r1.w, c16.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c12.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c16.y, -r0
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o3.xyz, -r0, c13
mad o1.xy, v2, c15, c15.zwzw
mad o4.xy, v3, c14, c14.zwzw
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

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_4;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_7;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - spec.w);
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (shininess * tmpvar_9));
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_7;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_10;
  tmpvar_10.xyz = tmpvar_2;
  tmpvar_10.w = glossLod_i0_i1;
  lookup = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_11;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_12;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_13;
  tmpvar_13 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  mediump vec3 tmpvar_14;
  tmpvar_14 = ((diff.xyz * diff.w) * tmpvar_13);
  c.xyz = tmpvar_14;
  c.w = diff.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
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

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_4;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  mediump float tmpvar_3;
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
  tmpvar_3 = diff.w;
  N = tmpvar_1;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  mediump float tmpvar_11;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - spec.w);
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - (tmpvar_12 * tmpvar_12));
  tmpvar_11 = ((7.0 + tmpvar_13) - (shininess * tmpvar_13));
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
  glossLod_i0_i1 = tmpvar_11;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16;
  tmpvar_17.y = (spec_i0.w * tmpvar_16);
  highp vec3 tmpvar_18;
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
  tmpvar_18 = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  N = tmpvar_18;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_DiffCubeIBL, tmpvar_18);
  diff_i0 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20;
  tmpvar_21.y = (diff_i0.w * tmpvar_20);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec3 tmpvar_23;
  tmpvar_23 = ((8.0 * tmpvar_22.w) * tmpvar_22.xyz);
  mediump vec3 tmpvar_24;
  tmpvar_24 = ((diff.xyz * diff.w) * tmpvar_23);
  c.xyz = tmpvar_24;
  c.w = tmpvar_3;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (c.xyz + ((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_17)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_21)) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_25;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;

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
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_6);
  x1.y = dot (unity_SHAg, tmpvar_6);
  x1.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_7);
  x2.y = dot (unity_SHBg, tmpvar_7);
  x2.z = dot (unity_SHBb, tmpvar_7);
  vec4 o_i0;
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_8;
  vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_9 + tmpvar_8.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y))));
  xlv_TEXCOORD5 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD3);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  float tmpvar_9;
  tmpvar_9 = (1.0 - tmpvar_4.w);
  float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  tmpvar_8 = ((7.0 + tmpvar_10) - (_Shininess * tmpvar_10));
  float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - tmpvar_8));
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
  vec4 tmpvar_12;
  tmpvar_12.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_12.w);
  float tmpvar_14;
  tmpvar_14 = (tmpvar_13.w * tmpvar_13.w);
  vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14;
  tmpvar_15.y = (tmpvar_13.w * tmpvar_14);
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
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  float tmpvar_17;
  tmpvar_17 = (tmpvar_16.w * tmpvar_16.w);
  vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17;
  tmpvar_18.y = (tmpvar_16.w * tmpvar_17);
  vec4 tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_20;
  tmpvar_20 = normalize (_WorldSpaceLightPos0.xyz);
  float tmpvar_21;
  tmpvar_21 = clamp (dot (xlv_TEXCOORD3, tmpvar_20), 0.0, 1.0);
  frag.xyz = ((((tmpvar_19.x * 2.0) * tmpvar_21) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize ((normalize (xlv_TEXCOORD2) + tmpvar_20))), 0.0, 1.0), tmpvar_11)) * clamp ((10.0 * tmpvar_21), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_19.x) * 0.5) * (spec.xyz * ((tmpvar_11 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_1 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((((tmpvar_13.xyz * dot (vec2(0.7532, 0.2468), tmpvar_15)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_16.xyz * dot (vec2(0.7532, 0.2468), tmpvar_18)) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [_MainTex_ST]
"vs_3_0
; 49 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c24, 1.00000000, 2.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c14.w
dp3 r1.w, r0, c5
dp3 r0.w, r0, c6
dp3 r3.x, r0, c4
mov r3.y, r1.w
mov r3.z, r0.w
mul r2, r3.xyzz, r3.yzzx
mov r3.w, c24.x
dp4 r0.z, r3, c18
dp4 r0.y, r3, c17
dp4 r0.x, r3, c16
dp4 r1.z, r2, c21
dp4 r1.x, r2, c19
dp4 r1.y, r2, c20
mov r2.xyz, c15
add r1.xyz, r0, r1
mov r2.w, c24.x
dp4 r0.z, r2, c10
dp4 r0.x, r2, c8
dp4 r0.y, r2, c9
mad r0.xyz, r0, c14.w, -v0
dp3 r2.y, v1, -r0
mul r3.yzw, v1.xxyz, r2.y
mad r0.xyz, -r3.yzww, c24.y, -r0
mul r2.x, r1.w, r1.w
mad r2.x, r3, r3, -r2
mul r2.xyz, r2.x, c22
add o5.xyz, r1, r2
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c24.z
mov r0.x, r1
mul r0.y, r1, c12.x
mad o6.xy, r1.z, c13.zwzw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o0, r2
mov o6.zw, r2
add o3.xyz, -r0, c15
mov o4.z, r0.w
mov o4.y, r1.w
mov o4.x, r3
mad o1.xy, v2, c23, c23.zwzw
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_4 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_22;
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_9;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  tmpvar_9 = ((7.0 + tmpvar_11) - (shininess * tmpvar_11));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - tmpvar_9));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_13;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_9;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_2;
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten_i0;
  atten_i0 = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, lightDir), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_19) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_19), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_22;
  frag.xyz = (frag.xyz + (tmpvar_22 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_24;
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_4 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_22;
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_3 = (diff.xyz * diff.w);
  N = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - fresnel_i0);
  tmpvar_11.y = fresnel_i0;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_12;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - spec.w);
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (shininess * tmpvar_14));
  mediump float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  highp float gloss;
  gloss = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_16;
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
  glossLod_i0_i1 = tmpvar_12;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_17.w = glossLod_i0_i1;
  lookup = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19;
  tmpvar_20.y = (spec_i0.w * tmpvar_19);
  highp vec3 tmpvar_21;
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
  tmpvar_21 = ((v_i0_i0.xyz * tmpvar_7.x) + ((v_i0_i1_i0.xyz * tmpvar_7.y) + (v_i0_i1_i2_i0.xyz * tmpvar_7.z)));
  N = tmpvar_21;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_DiffCubeIBL, tmpvar_21);
  diff_i0 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23;
  tmpvar_24.y = (diff_i0.w * tmpvar_23);
  lowp float tmpvar_25;
  tmpvar_25 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_26;
  mediump float atten_i0;
  atten_i0 = tmpvar_25;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize (lightDir);
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_1, tmpvar_27), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_28) * tmpvar_3) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_27))), 0.0, 1.0);
  specRefl = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = vec3(pow (specRefl, tmpvar_15));
  spec_i0_i1 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_28), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_31;
  frag.xyz = (frag.xyz + (tmpvar_31 * tmpvar_4));
  c = frag;
  mediump vec3 tmpvar_32;
  tmpvar_32 = (c.xyz + (tmpvar_3 * xlv_TEXCOORD4));
  c.xyz = tmpvar_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = (c.xyz + ((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_20)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_24)) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_33;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (tmpvar_1);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  vec4 tmpvar_10;
  tmpvar_10.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_10.w = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, tmpvar_10.xyz, tmpvar_10.w);
  float tmpvar_12;
  tmpvar_12 = (tmpvar_11.w * tmpvar_11.w);
  vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_12;
  tmpvar_13.y = (tmpvar_11.w * tmpvar_12);
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
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  float tmpvar_15;
  tmpvar_15 = (tmpvar_14.w * tmpvar_14.w);
  vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15;
  tmpvar_16.y = (tmpvar_14.w * tmpvar_15);
  vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_18;
  tmpvar_18 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec3 tmpvar_19;
  tmpvar_19 = ((8.0 * tmpvar_18.w) * tmpvar_18.xyz);
  c.xyz = ((diff.xyz * tmpvar_2.w) * max (min (tmpvar_19, ((tmpvar_17.x * 2.0) * tmpvar_18.xyz)), (tmpvar_19 * tmpvar_17.x)));
  c.w = diff.w;
  c.xyz = (c.xyz + ((((tmpvar_11.xyz * dot (vec2(0.7532, 0.2468), tmpvar_13)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * dot (vec2(0.7532, 0.2468), tmpvar_16)) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
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
; 27 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 1.00000000, 2.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.xyz, c15
mov r1.w, c18.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c14.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r2.xyz, -r1, c18.y, -r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c18.z
mov o0, r0
mul r1.y, r1, c12.x
mov o5.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.z, r2, c6
dp3 o2.y, r2, c5
dp3 o2.x, r2, c4
mad o5.xy, r1.z, c13.zwzw, r1
add o3.xyz, -r0, c15
mad o1.xy, v2, c17, c17.zwzw
mad o4.xy, v3, c16, c16.zwzw
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_3).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_5;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_7;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - spec.w);
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (shininess * tmpvar_9));
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_7;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_10;
  tmpvar_10.xyz = tmpvar_2;
  tmpvar_10.w = glossLod_i0_i1;
  lookup = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_11;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_12;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_13;
  tmpvar_13 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x * 2.0)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = ((diff.xyz * diff.w) * tmpvar_13);
  c.xyz = tmpvar_14;
  c.w = diff.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_3).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_5;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  mediump float tmpvar_3;
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
  tmpvar_3 = diff.w;
  N = tmpvar_1;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (N);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (tmpvar_6, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  mediump float tmpvar_11;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - spec.w);
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - (tmpvar_12 * tmpvar_12));
  tmpvar_11 = ((7.0 + tmpvar_13) - (shininess * tmpvar_13));
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
  glossLod_i0_i1 = tmpvar_11;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16;
  tmpvar_17.y = (spec_i0.w * tmpvar_16);
  highp vec3 tmpvar_18;
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
  tmpvar_18 = ((v_i0_i0.xyz * tmpvar_6.x) + ((v_i0_i1_i0.xyz * tmpvar_6.y) + (v_i0_i1_i2_i0.xyz * tmpvar_6.z)));
  N = tmpvar_18;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_DiffCubeIBL, tmpvar_18);
  diff_i0 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20;
  tmpvar_21.y = (diff_i0.w * tmpvar_20);
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec3 tmpvar_24;
  tmpvar_24 = ((8.0 * tmpvar_23.w) * tmpvar_23.xyz);
  lowp vec3 tmpvar_25;
  tmpvar_25 = max (min (tmpvar_24, ((tmpvar_22.x * 2.0) * tmpvar_23.xyz)), (tmpvar_24 * tmpvar_22.x));
  mediump vec3 tmpvar_26;
  tmpvar_26 = ((diff.xyz * diff.w) * tmpvar_25);
  c.xyz = tmpvar_26;
  c.w = tmpvar_3;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (c.xyz + ((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_17)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_21)) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_27;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_5);
  x1.y = dot (unity_SHAg, tmpvar_5);
  x1.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_6);
  x2.y = dot (unity_SHBg, tmpvar_6);
  x2.z = dot (unity_SHBb, tmpvar_6);
  vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_8;
  tmpvar_8 = (unity_4LightPosX0 - tmpvar_7.x);
  vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosY0 - tmpvar_7.y);
  vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosZ0 - tmpvar_7.z);
  vec4 tmpvar_11;
  tmpvar_11 = (((tmpvar_8 * tmpvar_8) + (tmpvar_9 * tmpvar_9)) + (tmpvar_10 * tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_8 * tmpvar_4.x) + (tmpvar_9 * tmpvar_4.y)) + (tmpvar_10 * tmpvar_4.z)) * inversesqrt (tmpvar_11))) * (1.0/((1.0 + (tmpvar_11 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y)))) + ((((unity_LightColor[0].xyz * tmpvar_12.x) + (unity_LightColor[1].xyz * tmpvar_12.y)) + (unity_LightColor[2].xyz * tmpvar_12.z)) + (unity_LightColor[3].xyz * tmpvar_12.w)));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD3);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  float tmpvar_9;
  tmpvar_9 = (1.0 - tmpvar_4.w);
  float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  tmpvar_8 = ((7.0 + tmpvar_10) - (_Shininess * tmpvar_10));
  float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - tmpvar_8));
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
  vec4 tmpvar_12;
  tmpvar_12.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_12.w);
  float tmpvar_14;
  tmpvar_14 = (tmpvar_13.w * tmpvar_13.w);
  vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14;
  tmpvar_15.y = (tmpvar_13.w * tmpvar_14);
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
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  float tmpvar_17;
  tmpvar_17 = (tmpvar_16.w * tmpvar_16.w);
  vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17;
  tmpvar_18.y = (tmpvar_16.w * tmpvar_17);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_19;
  tmpvar_19 = normalize (_WorldSpaceLightPos0.xyz);
  float tmpvar_20;
  tmpvar_20 = clamp (dot (xlv_TEXCOORD3, tmpvar_19), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_20) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize ((normalize (xlv_TEXCOORD2) + tmpvar_19))), 0.0, 1.0), tmpvar_11)) * clamp ((10.0 * tmpvar_20), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_11 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_1 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((((tmpvar_13.xyz * dot (vec2(0.7532, 0.2468), tmpvar_15)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_16.xyz * dot (vec2(0.7532, 0.2468), tmpvar_18)) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Vector 29 [_MainTex_ST]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c30, 1.00000000, 2.00000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c12.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c15
dp3 r4.z, r3, c5
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c14
mul r2, r2, r2
mov r5.y, r4.z
mov r5.w, c30.x
dp4 r4.xy, v0, c6
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c16
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c17
add r1, r1, c30.x
mov r5.z, r4.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c24
dp4 r2.y, r5, c23
dp4 r2.x, r5, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c30.z
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mul r1, r5.xyzz, r5.yzzx
mad r0.xyz, r0.w, c21, r0
dp4 r3.z, r1, c27
dp4 r3.x, r1, c25
dp4 r3.y, r1, c26
add r3.xyz, r2, r3
mov r1.w, c30.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.y, r1, c9
dp4 r2.x, r1, c8
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mad r1.xyz, r2, c12.w, -v0
dp3 r0.w, v1, -r1
mul r5.yzw, r1.w, c28.xxyz
add r3.xyz, r3, r5.yzww
add o5.xyz, r3, r0
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c30.y, -r1
mov r3.x, r4.w
mov r3.y, r4
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r3.wxyw, c13
mov o4.z, r4.x
mov o4.y, r4.z
mov o4.x, r5
mad o1.xy, v2, c29, c29.zwzw
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - tmpvar_21.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - tmpvar_21.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - tmpvar_21.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_22 * tmpvar_9.x) + (tmpvar_23 * tmpvar_9.y)) + (tmpvar_24 * tmpvar_9.z)) * inversesqrt (tmpvar_25))) * (1.0/((1.0 + (tmpvar_25 * unity_4LightAtten0)))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_26.x) + (unity_LightColor[1].xyz * tmpvar_26.y)) + (unity_LightColor[2].xyz * tmpvar_26.z)) + (unity_LightColor[3].xyz * tmpvar_26.w)));
  tmpvar_4 = tmpvar_27;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_9;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  tmpvar_9 = ((7.0 + tmpvar_11) - (shininess * tmpvar_11));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - tmpvar_9));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_13;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_9;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_2;
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_1, lightDir), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_18) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_18), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_21;
  frag.xyz = (frag.xyz + (tmpvar_21 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_23;
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - tmpvar_21.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - tmpvar_21.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - tmpvar_21.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_22 * tmpvar_9.x) + (tmpvar_23 * tmpvar_9.y)) + (tmpvar_24 * tmpvar_9.z)) * inversesqrt (tmpvar_25))) * (1.0/((1.0 + (tmpvar_25 * unity_4LightAtten0)))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_26.x) + (unity_LightColor[1].xyz * tmpvar_26.y)) + (unity_LightColor[2].xyz * tmpvar_26.z)) + (unity_LightColor[3].xyz * tmpvar_26.w)));
  tmpvar_4 = tmpvar_27;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_3 = (diff.xyz * diff.w);
  N = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - fresnel_i0);
  tmpvar_11.y = fresnel_i0;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_12;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - spec.w);
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (shininess * tmpvar_14));
  mediump float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  highp float gloss;
  gloss = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_16;
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
  glossLod_i0_i1 = tmpvar_12;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_17.w = glossLod_i0_i1;
  lookup = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19;
  tmpvar_20.y = (spec_i0.w * tmpvar_19);
  highp vec3 tmpvar_21;
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
  tmpvar_21 = ((v_i0_i0.xyz * tmpvar_7.x) + ((v_i0_i1_i0.xyz * tmpvar_7.y) + (v_i0_i1_i2_i0.xyz * tmpvar_7.z)));
  N = tmpvar_21;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_DiffCubeIBL, tmpvar_21);
  diff_i0 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23;
  tmpvar_24.y = (diff_i0.w * tmpvar_23);
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_25;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize (lightDir);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_1, tmpvar_26), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_27) * tmpvar_3) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_26))), 0.0, 1.0);
  specRefl = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = vec3(pow (specRefl, tmpvar_15));
  spec_i0_i1 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_27), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_30;
  frag.xyz = (frag.xyz + (tmpvar_30 * tmpvar_4));
  c = frag;
  mediump vec3 tmpvar_31;
  tmpvar_31 = (c.xyz + (tmpvar_3 * xlv_TEXCOORD4));
  c.xyz = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = (c.xyz + ((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_20)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_24)) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_32;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_6);
  x1.y = dot (unity_SHAg, tmpvar_6);
  x1.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_7);
  x2.y = dot (unity_SHBg, tmpvar_7);
  x2.z = dot (unity_SHBb, tmpvar_7);
  vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosX0 - tmpvar_8.x);
  vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosY0 - tmpvar_8.y);
  vec4 tmpvar_11;
  tmpvar_11 = (unity_4LightPosZ0 - tmpvar_8.z);
  vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_9 * tmpvar_9) + (tmpvar_10 * tmpvar_10)) + (tmpvar_11 * tmpvar_11));
  vec4 tmpvar_13;
  tmpvar_13 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_9 * tmpvar_5.x) + (tmpvar_10 * tmpvar_5.y)) + (tmpvar_11 * tmpvar_5.z)) * inversesqrt (tmpvar_12))) * (1.0/((1.0 + (tmpvar_12 * unity_4LightAtten0)))));
  vec4 o_i0;
  vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_14;
  vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y)))) + ((((unity_LightColor[0].xyz * tmpvar_13.x) + (unity_LightColor[1].xyz * tmpvar_13.y)) + (unity_LightColor[2].xyz * tmpvar_13.z)) + (unity_LightColor[3].xyz * tmpvar_13.w)));
  xlv_TEXCOORD5 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  tmpvar_1 = (diff.xyz * tmpvar_2.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD3);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  float tmpvar_9;
  tmpvar_9 = (1.0 - tmpvar_4.w);
  float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  tmpvar_8 = ((7.0 + tmpvar_10) - (_Shininess * tmpvar_10));
  float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - tmpvar_8));
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
  vec4 tmpvar_12;
  tmpvar_12.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_12.w);
  float tmpvar_14;
  tmpvar_14 = (tmpvar_13.w * tmpvar_13.w);
  vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14;
  tmpvar_15.y = (tmpvar_13.w * tmpvar_14);
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
  vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  float tmpvar_17;
  tmpvar_17 = (tmpvar_16.w * tmpvar_16.w);
  vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17;
  tmpvar_18.y = (tmpvar_16.w * tmpvar_17);
  vec4 tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_20;
  tmpvar_20 = normalize (_WorldSpaceLightPos0.xyz);
  float tmpvar_21;
  tmpvar_21 = clamp (dot (xlv_TEXCOORD3, tmpvar_20), 0.0, 1.0);
  frag.xyz = ((((tmpvar_19.x * 2.0) * tmpvar_21) * tmpvar_1) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize ((normalize (xlv_TEXCOORD2) + tmpvar_20))), 0.0, 1.0), tmpvar_11)) * clamp ((10.0 * tmpvar_21), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_19.x) * 0.5) * (spec.xyz * ((tmpvar_11 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_1 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((((tmpvar_13.xyz * dot (vec2(0.7532, 0.2468), tmpvar_15)) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_16.xyz * dot (vec2(0.7532, 0.2468), tmpvar_18)) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Vector 31 [_MainTex_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c32, 1.00000000, 2.00000000, 0.00000000, 0.50000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c14.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c17
dp3 r4.z, r3, c5
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c16
mul r2, r2, r2
mov r5.y, r4.z
mov r5.w, c32.x
dp4 r4.xy, v0, c6
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c18
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c19
add r1, r1, c32.x
mov r5.z, r4.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c26
dp4 r2.y, r5, c25
dp4 r2.x, r5, c24
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c32.z
mul r0, r0, r1
mul r1.xyz, r0.y, c21
mad r1.xyz, r0.x, c20, r1
mad r0.xyz, r0.z, c22, r1
mul r1, r5.xyzz, r5.yzzx
mad r0.xyz, r0.w, c23, r0
dp4 r3.z, r1, c29
dp4 r3.x, r1, c27
dp4 r3.y, r1, c28
add r3.xyz, r2, r3
mov r1.w, c32.x
mov r1.xyz, c15
dp4 r2.z, r1, c10
dp4 r2.y, r1, c9
dp4 r2.x, r1, c8
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mad r1.xyz, r2, c14.w, -v0
dp3 r0.w, v1, -r1
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c32.y, -r1
mul r5.yzw, r1.w, c30.xxyz
add r3.xyz, r3, r5.yzww
add o5.xyz, r3, r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c32.w
dp3 o2.x, r1, c4
mov r1.x, r2
mul r1.y, r2, c12.x
mov r3.x, r4.w
mov r3.y, r4
mad o6.xy, r2.z, c13.zwzw, r1
mov o0, r0
mov o6.zw, r0
add o3.xyz, -r3.wxyw, c15
mov o4.z, r4.x
mov o4.y, r4.z
mov o4.x, r5
mad o1.xy, v2, c31, c31.zwzw
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_10.x) + (tmpvar_24 * tmpvar_10.y)) + (tmpvar_25 * tmpvar_10.z)) * inversesqrt (tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_4 = tmpvar_28;
  highp vec4 o_i0;
  highp vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_29;
  highp vec2 tmpvar_30;
  tmpvar_30.x = tmpvar_29.x;
  tmpvar_30.y = (tmpvar_29.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_30 + tmpvar_29.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_9;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  tmpvar_9 = ((7.0 + tmpvar_11) - (shininess * tmpvar_11));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - tmpvar_9));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_13;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_9;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_2;
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten_i0;
  atten_i0 = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, lightDir), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_19) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_19), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_22;
  frag.xyz = (frag.xyz + (tmpvar_22 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_24;
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_10.x) + (tmpvar_24 * tmpvar_10.y)) + (tmpvar_25 * tmpvar_10.z)) * inversesqrt (tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_4 = tmpvar_28;
  highp vec4 o_i0;
  highp vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_29;
  highp vec2 tmpvar_30;
  tmpvar_30.x = tmpvar_29.x;
  tmpvar_30.y = (tmpvar_29.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_30 + tmpvar_29.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec4 spec;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (diff * _Color);
  diff = tmpvar_6;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  tmpvar_3 = (diff.xyz * diff.w);
  N = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - fresnel_i0);
  tmpvar_11.y = fresnel_i0;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * specIntensity)) * _ExposureIBL.w));
  mediump float tmpvar_12;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - spec.w);
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (shininess * tmpvar_14));
  mediump float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  highp float gloss;
  gloss = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_4 = tmpvar_16;
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
  glossLod_i0_i1 = tmpvar_12;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_17.w = glossLod_i0_i1;
  lookup = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (spec_i0.w * spec_i0.w);
  mediump vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19;
  tmpvar_20.y = (spec_i0.w * tmpvar_19);
  highp vec3 tmpvar_21;
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
  tmpvar_21 = ((v_i0_i0.xyz * tmpvar_7.x) + ((v_i0_i1_i0.xyz * tmpvar_7.y) + (v_i0_i1_i2_i0.xyz * tmpvar_7.z)));
  N = tmpvar_21;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_DiffCubeIBL, tmpvar_21);
  diff_i0 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23;
  tmpvar_24.y = (diff_i0.w * tmpvar_23);
  lowp float tmpvar_25;
  tmpvar_25 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_26;
  mediump float atten_i0;
  atten_i0 = tmpvar_25;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize (lightDir);
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_1, tmpvar_27), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_28) * tmpvar_3) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_27))), 0.0, 1.0);
  specRefl = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = vec3(pow (specRefl, tmpvar_15));
  spec_i0_i1 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_28), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_31;
  frag.xyz = (frag.xyz + (tmpvar_31 * tmpvar_4));
  c = frag;
  mediump vec3 tmpvar_32;
  tmpvar_32 = (c.xyz + (tmpvar_3 * xlv_TEXCOORD4));
  c.xyz = tmpvar_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = (c.xyz + ((((spec_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_20)) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_24)) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_33;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;

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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_5);
  x1.y = dot (unity_SHAg, tmpvar_5);
  x1.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_6);
  x2.y = dot (unity_SHBg, tmpvar_6);
  x2.z = dot (unity_SHBb, tmpvar_6);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y))));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD3);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  float tmpvar_9;
  tmpvar_9 = (1.0 - tmpvar_4.w);
  float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  tmpvar_8 = ((7.0 + tmpvar_10) - (_Shininess * tmpvar_10));
  float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - tmpvar_8));
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
  vec4 tmpvar_12;
  tmpvar_12.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_12.w);
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
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_15;
  tmpvar_15 = normalize (_WorldSpaceLightPos0.xyz);
  float tmpvar_16;
  tmpvar_16 = clamp (dot (xlv_TEXCOORD3, tmpvar_15), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_16) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize ((normalize (xlv_TEXCOORD2) + tmpvar_15))), 0.0, 1.0), tmpvar_11)) * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_11 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_2 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [_MainTex_ST]
"vs_3_0
; 43 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.w, r1, c4
mov r0.x, r3.w
mov r0.y, r2.w
mov r0.z, c22.x
mul r1, r0.wxyy, r0.xyyw
dp4 r2.z, r0.wxyz, c16
dp4 r2.y, r0.wxyz, c15
dp4 r2.x, r0.wxyz, c14
dp4 r0.z, r1, c19
dp4 r0.x, r1, c17
dp4 r0.y, r1, c18
add r2.xyz, r2, r0
mov r1.w, c22.x
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r1.xyz, r0, c12.w, -v0
mul r0.y, r3.w, r3.w
mad r1.w, r0, r0, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c22.y, -r1
mul r3.xyz, r1.w, c20
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o5.xyz, r2, r3
add o3.xyz, -r0, c13
mov o4.z, r2.w
mov o4.y, r3.w
mov o4.x, r0.w
mad o1.xy, v2, c21, c21.zwzw
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_9;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  tmpvar_9 = ((7.0 + tmpvar_11) - (shininess * tmpvar_11));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - tmpvar_9));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_13;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_9;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_2;
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_1, lightDir), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_18) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_18), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_21;
  frag.xyz = (frag.xyz + (tmpvar_21 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_23;
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - fresnel_i0);
  tmpvar_11.y = fresnel_i0;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_12;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - spec.w);
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (shininess * tmpvar_14));
  mediump float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  highp float gloss;
  gloss = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_16;
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
  glossLod_i0_i1 = tmpvar_12;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_17.w = glossLod_i0_i1;
  lookup = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_18;
  highp vec3 tmpvar_19;
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
  tmpvar_19 = ((v_i0_i0.xyz * tmpvar_7.x) + ((v_i0_i1_i0.xyz * tmpvar_7.y) + (v_i0_i1_i2_i0.xyz * tmpvar_7.z)));
  N = tmpvar_19;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, tmpvar_19);
  diff_i0 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_21;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize (lightDir);
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_1, tmpvar_22), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_23) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_22))), 0.0, 1.0);
  specRefl = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = vec3(pow (specRefl, tmpvar_15));
  spec_i0_i1 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_23), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_26;
  frag.xyz = (frag.xyz + (tmpvar_26 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_28;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (tmpvar_1);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  vec4 tmpvar_10;
  tmpvar_10.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_10.w = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, tmpvar_10.xyz, tmpvar_10.w);
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
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_13;
  tmpvar_13 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  c.xyz = ((diff.xyz * tmpvar_2.w) * ((8.0 * tmpvar_13.w) * tmpvar_13.xyz));
  c.w = diff.w;
  c.xyz = (c.xyz + ((((tmpvar_11.xyz * tmpvar_11.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
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
; 22 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c16, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.xyz, c13
mov r1.w, c16.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c12.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c16.y, -r0
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o3.xyz, -r0, c13
mad o1.xy, v2, c15, c15.zwzw
mad o4.xy, v3, c14, c14.zwzw
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

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_4;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_7;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - spec.w);
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (shininess * tmpvar_9));
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_7;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_10;
  tmpvar_10.xyz = tmpvar_2;
  tmpvar_10.w = glossLod_i0_i1;
  lookup = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_11;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_12;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_13;
  tmpvar_13 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  mediump vec3 tmpvar_14;
  tmpvar_14 = ((diff.xyz * diff.w) * tmpvar_13);
  c.xyz = tmpvar_14;
  c.w = diff.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
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

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_4;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_10;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  tmpvar_10 = ((7.0 + tmpvar_12) - (shininess * tmpvar_12));
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
  glossLod_i0_i1 = tmpvar_10;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_13.w = glossLod_i0_i1;
  lookup = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_14;
  highp vec3 tmpvar_15;
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
  tmpvar_15 = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  N = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, tmpvar_15);
  diff_i0 = tmpvar_16;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_17.w) * tmpvar_17.xyz);
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((diff.xyz * diff.w) * tmpvar_18);
  c.xyz = tmpvar_19;
  c.w = diff.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_20;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;

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
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_6);
  x1.y = dot (unity_SHAg, tmpvar_6);
  x1.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_7);
  x2.y = dot (unity_SHBg, tmpvar_7);
  x2.z = dot (unity_SHBb, tmpvar_7);
  vec4 o_i0;
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_8;
  vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_9 + tmpvar_8.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y))));
  xlv_TEXCOORD5 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD3);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  float tmpvar_9;
  tmpvar_9 = (1.0 - tmpvar_4.w);
  float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  tmpvar_8 = ((7.0 + tmpvar_10) - (_Shininess * tmpvar_10));
  float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - tmpvar_8));
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
  vec4 tmpvar_12;
  tmpvar_12.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_12.w);
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
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_16;
  tmpvar_16 = normalize (_WorldSpaceLightPos0.xyz);
  float tmpvar_17;
  tmpvar_17 = clamp (dot (xlv_TEXCOORD3, tmpvar_16), 0.0, 1.0);
  frag.xyz = ((((tmpvar_15.x * 2.0) * tmpvar_17) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize ((normalize (xlv_TEXCOORD2) + tmpvar_16))), 0.0, 1.0), tmpvar_11)) * clamp ((10.0 * tmpvar_17), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_15.x) * 0.5) * (spec.xyz * ((tmpvar_11 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_2 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [_MainTex_ST]
"vs_3_0
; 49 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c24, 1.00000000, 2.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c14.w
dp3 r1.w, r0, c5
dp3 r0.w, r0, c6
dp3 r3.x, r0, c4
mov r3.y, r1.w
mov r3.z, r0.w
mul r2, r3.xyzz, r3.yzzx
mov r3.w, c24.x
dp4 r0.z, r3, c18
dp4 r0.y, r3, c17
dp4 r0.x, r3, c16
dp4 r1.z, r2, c21
dp4 r1.x, r2, c19
dp4 r1.y, r2, c20
mov r2.xyz, c15
add r1.xyz, r0, r1
mov r2.w, c24.x
dp4 r0.z, r2, c10
dp4 r0.x, r2, c8
dp4 r0.y, r2, c9
mad r0.xyz, r0, c14.w, -v0
dp3 r2.y, v1, -r0
mul r3.yzw, v1.xxyz, r2.y
mad r0.xyz, -r3.yzww, c24.y, -r0
mul r2.x, r1.w, r1.w
mad r2.x, r3, r3, -r2
mul r2.xyz, r2.x, c22
add o5.xyz, r1, r2
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c24.z
mov r0.x, r1
mul r0.y, r1, c12.x
mad o6.xy, r1.z, c13.zwzw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o0, r2
mov o6.zw, r2
add o3.xyz, -r0, c15
mov o4.z, r0.w
mov o4.y, r1.w
mov o4.x, r3
mad o1.xy, v2, c23, c23.zwzw
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_4 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_22;
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_9;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  tmpvar_9 = ((7.0 + tmpvar_11) - (shininess * tmpvar_11));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - tmpvar_9));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_13;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_9;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_2;
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten_i0;
  atten_i0 = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, lightDir), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_19) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_19), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_22;
  frag.xyz = (frag.xyz + (tmpvar_22 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_24;
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_4 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_22;
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - fresnel_i0);
  tmpvar_11.y = fresnel_i0;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_12;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - spec.w);
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (shininess * tmpvar_14));
  mediump float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  highp float gloss;
  gloss = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_16;
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
  glossLod_i0_i1 = tmpvar_12;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_17.w = glossLod_i0_i1;
  lookup = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_18;
  highp vec3 tmpvar_19;
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
  tmpvar_19 = ((v_i0_i0.xyz * tmpvar_7.x) + ((v_i0_i1_i0.xyz * tmpvar_7.y) + (v_i0_i1_i2_i0.xyz * tmpvar_7.z)));
  N = tmpvar_19;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, tmpvar_19);
  diff_i0 = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_22;
  mediump float atten_i0;
  atten_i0 = tmpvar_21;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize (lightDir);
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_1, tmpvar_23), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_24) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_23))), 0.0, 1.0);
  specRefl = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = vec3(pow (specRefl, tmpvar_15));
  spec_i0_i1 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_24), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_27;
  frag.xyz = (frag.xyz + (tmpvar_27 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_28;
  tmpvar_28 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_29;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (tmpvar_1);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  vec4 tmpvar_10;
  tmpvar_10.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_10.w = ((7.0 + tmpvar_9) - (_Shininess * tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, tmpvar_10.xyz, tmpvar_10.w);
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
  vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  vec4 tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  c.xyz = ((diff.xyz * tmpvar_2.w) * max (min (tmpvar_15, ((tmpvar_13.x * 2.0) * tmpvar_14.xyz)), (tmpvar_15 * tmpvar_13.x)));
  c.w = diff.w;
  c.xyz = (c.xyz + ((((tmpvar_11.xyz * tmpvar_11.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_12.xyz * tmpvar_12.w) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
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
; 27 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 1.00000000, 2.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.xyz, c15
mov r1.w, c18.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c14.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r2.xyz, -r1, c18.y, -r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c18.z
mov o0, r0
mul r1.y, r1, c12.x
mov o5.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.z, r2, c6
dp3 o2.y, r2, c5
dp3 o2.x, r2, c4
mad o5.xy, r1.z, c13.zwzw, r1
add o3.xyz, -r0, c15
mad o1.xy, v2, c17, c17.zwzw
mad o4.xy, v3, c16, c16.zwzw
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_3).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_5;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_7;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - spec.w);
  mediump float tmpvar_9;
  tmpvar_9 = (1.0 - (tmpvar_8 * tmpvar_8));
  tmpvar_7 = ((7.0 + tmpvar_9) - (shininess * tmpvar_9));
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_7;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_10;
  tmpvar_10.xyz = tmpvar_2;
  tmpvar_10.w = glossLod_i0_i1;
  lookup = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_11;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_12;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_13;
  tmpvar_13 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x * 2.0)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = ((diff.xyz * diff.w) * tmpvar_13);
  c.xyz = tmpvar_14;
  c.w = diff.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_3).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_5;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_10;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - spec.w);
  mediump float tmpvar_12;
  tmpvar_12 = (1.0 - (tmpvar_11 * tmpvar_11));
  tmpvar_10 = ((7.0 + tmpvar_12) - (shininess * tmpvar_12));
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
  glossLod_i0_i1 = tmpvar_10;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_13.w = glossLod_i0_i1;
  lookup = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_14;
  highp vec3 tmpvar_15;
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
  tmpvar_15 = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  N = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, tmpvar_15);
  diff_i0 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((8.0 * tmpvar_18.w) * tmpvar_18.xyz);
  lowp vec3 tmpvar_20;
  tmpvar_20 = max (min (tmpvar_19, ((tmpvar_17.x * 2.0) * tmpvar_18.xyz)), (tmpvar_19 * tmpvar_17.x));
  mediump vec3 tmpvar_21;
  tmpvar_21 = ((diff.xyz * diff.w) * tmpvar_20);
  c.xyz = tmpvar_21;
  c.w = diff.w;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_22;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_5);
  x1.y = dot (unity_SHAg, tmpvar_5);
  x1.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_6);
  x2.y = dot (unity_SHBg, tmpvar_6);
  x2.z = dot (unity_SHBb, tmpvar_6);
  vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_8;
  tmpvar_8 = (unity_4LightPosX0 - tmpvar_7.x);
  vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosY0 - tmpvar_7.y);
  vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosZ0 - tmpvar_7.z);
  vec4 tmpvar_11;
  tmpvar_11 = (((tmpvar_8 * tmpvar_8) + (tmpvar_9 * tmpvar_9)) + (tmpvar_10 * tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_8 * tmpvar_4.x) + (tmpvar_9 * tmpvar_4.y)) + (tmpvar_10 * tmpvar_4.z)) * inversesqrt (tmpvar_11))) * (1.0/((1.0 + (tmpvar_11 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_2 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_1).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y)))) + ((((unity_LightColor[0].xyz * tmpvar_12.x) + (unity_LightColor[1].xyz * tmpvar_12.y)) + (unity_LightColor[2].xyz * tmpvar_12.z)) + (unity_LightColor[3].xyz * tmpvar_12.w)));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD3);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  float tmpvar_9;
  tmpvar_9 = (1.0 - tmpvar_4.w);
  float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  tmpvar_8 = ((7.0 + tmpvar_10) - (_Shininess * tmpvar_10));
  float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - tmpvar_8));
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
  vec4 tmpvar_12;
  tmpvar_12.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_12.w);
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
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_15;
  tmpvar_15 = normalize (_WorldSpaceLightPos0.xyz);
  float tmpvar_16;
  tmpvar_16 = clamp (dot (xlv_TEXCOORD3, tmpvar_15), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_16) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize ((normalize (xlv_TEXCOORD2) + tmpvar_15))), 0.0, 1.0), tmpvar_11)) * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_11 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_2 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Vector 29 [_MainTex_ST]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c30, 1.00000000, 2.00000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c12.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c15
dp3 r4.z, r3, c5
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c14
mul r2, r2, r2
mov r5.y, r4.z
mov r5.w, c30.x
dp4 r4.xy, v0, c6
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c16
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c17
add r1, r1, c30.x
mov r5.z, r4.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c24
dp4 r2.y, r5, c23
dp4 r2.x, r5, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c30.z
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mul r1, r5.xyzz, r5.yzzx
mad r0.xyz, r0.w, c21, r0
dp4 r3.z, r1, c27
dp4 r3.x, r1, c25
dp4 r3.y, r1, c26
add r3.xyz, r2, r3
mov r1.w, c30.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.y, r1, c9
dp4 r2.x, r1, c8
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mad r1.xyz, r2, c12.w, -v0
dp3 r0.w, v1, -r1
mul r5.yzw, r1.w, c28.xxyz
add r3.xyz, r3, r5.yzww
add o5.xyz, r3, r0
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c30.y, -r1
mov r3.x, r4.w
mov r3.y, r4
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r3.wxyw, c13
mov o4.z, r4.x
mov o4.y, r4.z
mov o4.x, r5
mad o1.xy, v2, c29, c29.zwzw
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - tmpvar_21.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - tmpvar_21.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - tmpvar_21.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_22 * tmpvar_9.x) + (tmpvar_23 * tmpvar_9.y)) + (tmpvar_24 * tmpvar_9.z)) * inversesqrt (tmpvar_25))) * (1.0/((1.0 + (tmpvar_25 * unity_4LightAtten0)))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_26.x) + (unity_LightColor[1].xyz * tmpvar_26.y)) + (unity_LightColor[2].xyz * tmpvar_26.z)) + (unity_LightColor[3].xyz * tmpvar_26.w)));
  tmpvar_4 = tmpvar_27;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_9;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  tmpvar_9 = ((7.0 + tmpvar_11) - (shininess * tmpvar_11));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - tmpvar_9));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_13;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_9;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_2;
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_1, lightDir), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_18) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_18), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_21;
  frag.xyz = (frag.xyz + (tmpvar_21 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_23;
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - tmpvar_21.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - tmpvar_21.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - tmpvar_21.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_22 * tmpvar_9.x) + (tmpvar_23 * tmpvar_9.y)) + (tmpvar_24 * tmpvar_9.z)) * inversesqrt (tmpvar_25))) * (1.0/((1.0 + (tmpvar_25 * unity_4LightAtten0)))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_26.x) + (unity_LightColor[1].xyz * tmpvar_26.y)) + (unity_LightColor[2].xyz * tmpvar_26.z)) + (unity_LightColor[3].xyz * tmpvar_26.w)));
  tmpvar_4 = tmpvar_27;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - fresnel_i0);
  tmpvar_11.y = fresnel_i0;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_12;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - spec.w);
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (shininess * tmpvar_14));
  mediump float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  highp float gloss;
  gloss = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_16;
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
  glossLod_i0_i1 = tmpvar_12;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_17.w = glossLod_i0_i1;
  lookup = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_18;
  highp vec3 tmpvar_19;
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
  tmpvar_19 = ((v_i0_i0.xyz * tmpvar_7.x) + ((v_i0_i1_i0.xyz * tmpvar_7.y) + (v_i0_i1_i2_i0.xyz * tmpvar_7.z)));
  N = tmpvar_19;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, tmpvar_19);
  diff_i0 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_21;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize (lightDir);
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_1, tmpvar_22), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_23) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_22))), 0.0, 1.0);
  specRefl = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = vec3(pow (specRefl, tmpvar_15));
  spec_i0_i1 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_23), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_26;
  frag.xyz = (frag.xyz + (tmpvar_26 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_28;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
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
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_6);
  x1.y = dot (unity_SHAg, tmpvar_6);
  x1.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_7);
  x2.y = dot (unity_SHBg, tmpvar_7);
  x2.z = dot (unity_SHBb, tmpvar_7);
  vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosX0 - tmpvar_8.x);
  vec4 tmpvar_10;
  tmpvar_10 = (unity_4LightPosY0 - tmpvar_8.y);
  vec4 tmpvar_11;
  tmpvar_11 = (unity_4LightPosZ0 - tmpvar_8.z);
  vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_9 * tmpvar_9) + (tmpvar_10 * tmpvar_10)) + (tmpvar_11 * tmpvar_11));
  vec4 tmpvar_13;
  tmpvar_13 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_9 * tmpvar_5.x) + (tmpvar_10 * tmpvar_5.y)) + (tmpvar_11 * tmpvar_5.z)) * inversesqrt (tmpvar_12))) * (1.0/((1.0 + (tmpvar_12 * unity_4LightAtten0)))));
  vec4 o_i0;
  vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_14;
  vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_3 * reflect ((gl_Vertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), gl_Normal));
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y)))) + ((((unity_LightColor[0].xyz * tmpvar_13.x) + (unity_LightColor[1].xyz * tmpvar_13.y)) + (unity_LightColor[2].xyz * tmpvar_13.z)) + (unity_LightColor[3].xyz * tmpvar_13.w)));
  xlv_TEXCOORD5 = o_i0;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD5;
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform vec4 _SpecColor;
uniform mat4 _SkyMatrix;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = (diff.xyz * tmpvar_1.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD3);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_4;
  vec3 p;
  float tmpvar_5;
  tmpvar_5 = (1.0 - clamp (dot (tmpvar_3, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
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
  float tmpvar_9;
  tmpvar_9 = (1.0 - tmpvar_4.w);
  float tmpvar_10;
  tmpvar_10 = (1.0 - (tmpvar_9 * tmpvar_9));
  tmpvar_8 = ((7.0 + tmpvar_10) - (_Shininess * tmpvar_10));
  float tmpvar_11;
  tmpvar_11 = pow (2.0, (8.0 - tmpvar_8));
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
  vec4 tmpvar_12;
  tmpvar_12.xyz = ((v_i0.xyz * xlv_TEXCOORD1.x) + ((v_i0_i1.xyz * xlv_TEXCOORD1.y) + (v_i0_i1_i2.xyz * xlv_TEXCOORD1.z)));
  tmpvar_12.w = tmpvar_8;
  vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_SpecCubeIBL, tmpvar_12.xyz, tmpvar_12.w);
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
  vec4 tmpvar_14;
  tmpvar_14 = textureCube (_DiffCubeIBL, ((v_i0_i0.xyz * tmpvar_3.x) + ((v_i0_i1_i0.xyz * tmpvar_3.y) + (v_i0_i1_i2_i0.xyz * tmpvar_3.z))));
  vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_16;
  tmpvar_16 = normalize (_WorldSpaceLightPos0.xyz);
  float tmpvar_17;
  tmpvar_17 = clamp (dot (xlv_TEXCOORD3, tmpvar_16), 0.0, 1.0);
  frag.xyz = ((((tmpvar_15.x * 2.0) * tmpvar_17) * tmpvar_2) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD3, normalize ((normalize (xlv_TEXCOORD2) + tmpvar_16))), 0.0, 1.0), tmpvar_11)) * clamp ((10.0 * tmpvar_17), 0.0, 1.0)) * _LightColor0.xyz) * tmpvar_15.x) * 0.5) * (spec.xyz * ((tmpvar_11 * 0.159155) + 0.31831))));
  c = frag;
  c.xyz = (frag.xyz + (tmpvar_2 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((((tmpvar_13.xyz * tmpvar_13.w) * spec.xyz) * _ExposureIBL.y) + (((tmpvar_14.xyz * tmpvar_14.w) * diff.xyz) * _ExposureIBL.x)));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Vector 31 [_MainTex_ST]
"vs_3_0
; 78 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c32, 1.00000000, 2.00000000, 0.00000000, 0.50000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c14.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c17
dp3 r4.z, r3, c5
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c16
mul r2, r2, r2
mov r5.y, r4.z
mov r5.w, c32.x
dp4 r4.xy, v0, c6
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c18
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c19
add r1, r1, c32.x
mov r5.z, r4.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c26
dp4 r2.y, r5, c25
dp4 r2.x, r5, c24
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c32.z
mul r0, r0, r1
mul r1.xyz, r0.y, c21
mad r1.xyz, r0.x, c20, r1
mad r0.xyz, r0.z, c22, r1
mul r1, r5.xyzz, r5.yzzx
mad r0.xyz, r0.w, c23, r0
dp4 r3.z, r1, c29
dp4 r3.x, r1, c27
dp4 r3.y, r1, c28
add r3.xyz, r2, r3
mov r1.w, c32.x
mov r1.xyz, c15
dp4 r2.z, r1, c10
dp4 r2.y, r1, c9
dp4 r2.x, r1, c8
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mad r1.xyz, r2, c14.w, -v0
dp3 r0.w, v1, -r1
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c32.y, -r1
mul r5.yzw, r1.w, c30.xxyz
add r3.xyz, r3, r5.yzww
add o5.xyz, r3, r0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c32.w
dp3 o2.x, r1, c4
mov r1.x, r2
mul r1.y, r2, c12.x
mov r3.x, r4.w
mov r3.y, r4
mad o6.xy, r2.z, c13.zwzw, r1
mov o0, r0
mov o6.zw, r0
add o3.xyz, -r3.wxyw, c15
mov o4.z, r4.x
mov o4.y, r4.z
mov o4.x, r5
mad o1.xy, v2, c31, c31.zwzw
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_10.x) + (tmpvar_24 * tmpvar_10.y)) + (tmpvar_25 * tmpvar_10.z)) * inversesqrt (tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_4 = tmpvar_28;
  highp vec4 o_i0;
  highp vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_29;
  highp vec2 tmpvar_30;
  tmpvar_30.x = tmpvar_29.x;
  tmpvar_30.y = (tmpvar_29.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_30 + tmpvar_29.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_7;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_8;
  tmpvar_8 = (1.0 - clamp (dot (N, xlv_TEXCOORD2), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_8 * (tmpvar_8 * tmpvar_8)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float tmpvar_9;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  tmpvar_9 = ((7.0 + tmpvar_11) - (shininess * tmpvar_11));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - tmpvar_9));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_13;
  highp float glossLod_i0_i1;
  glossLod_i0_i1 = tmpvar_9;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_2;
  tmpvar_14.w = glossLod_i0_i1;
  lookup = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_15;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_18;
  mediump float atten_i0;
  atten_i0 = tmpvar_17;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, lightDir), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_19) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir))), 0.0, 1.0);
  specRefl = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_19), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_22;
  frag.xyz = (frag.xyz + (tmpvar_22 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_23;
  tmpvar_23 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_24;
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_10;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_10.x) + (tmpvar_24 * tmpvar_10.y)) + (tmpvar_25 * tmpvar_10.z)) * inversesqrt (tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_4 = tmpvar_28;
  highp vec4 o_i0;
  highp vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_29;
  highp vec2 tmpvar_30;
  tmpvar_30.x = tmpvar_29.x;
  tmpvar_30.y = (tmpvar_29.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_30 + tmpvar_29.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform samplerCube _SpecCubeIBL;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_1 = xlv_TEXCOORD3;
  mediump vec3 tmpvar_3;
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
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * diff.w);
  N = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (N);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_8;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_9;
  tmpvar_9 = (1.0 - clamp (dot (tmpvar_7, normalize (xlv_TEXCOORD2)), 0.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10.x = 1.0;
  tmpvar_10.y = tmpvar_9;
  tmpvar_10.z = ((tmpvar_9 * tmpvar_9) * tmpvar_9);
  p = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = (1.0 - fresnel_i0);
  tmpvar_11.y = fresnel_i0;
  p.x = dot (tmpvar_10.xy, tmpvar_11);
  p.y = dot (p.yz, tmpvar_11);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_11))) * specIntensity))) * _ExposureIBL.w));
  mediump float tmpvar_12;
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_13;
  tmpvar_13 = (1.0 - spec.w);
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - (tmpvar_13 * tmpvar_13));
  tmpvar_12 = ((7.0 + tmpvar_14) - (shininess * tmpvar_14));
  mediump float tmpvar_15;
  tmpvar_15 = pow (2.0, (8.0 - tmpvar_12));
  highp float gloss;
  gloss = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_3 = tmpvar_16;
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
  glossLod_i0_i1 = tmpvar_12;
  mediump vec4 spec_i0;
  mediump vec4 lookup;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z)));
  tmpvar_17.w = glossLod_i0_i1;
  lookup = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCubeLod (_SpecCubeIBL, lookup.xyz, lookup.w);
  spec_i0 = tmpvar_18;
  highp vec3 tmpvar_19;
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
  tmpvar_19 = ((v_i0_i0.xyz * tmpvar_7.x) + ((v_i0_i1_i0.xyz * tmpvar_7.y) + (v_i0_i1_i2_i0.xyz * tmpvar_7.z)));
  N = tmpvar_19;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_DiffCubeIBL, tmpvar_19);
  diff_i0 = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD2);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec3 viewDir;
  viewDir = tmpvar_22;
  mediump float atten_i0;
  atten_i0 = tmpvar_21;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize (lightDir);
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_1, tmpvar_23), 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * tmpvar_24) * tmpvar_6) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_23))), 0.0, 1.0);
  specRefl = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = vec3(pow (specRefl, tmpvar_15));
  spec_i0_i1 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_24), 0.0, 1.0)) * _LightColor0.xyz) * atten_i0) * 0.5);
  spec_i0_i1 = tmpvar_27;
  frag.xyz = (frag.xyz + (tmpvar_27 * tmpvar_3));
  c = frag;
  mediump vec3 tmpvar_28;
  tmpvar_28 = (c.xyz + (tmpvar_6 * xlv_TEXCOORD4));
  c.xyz = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = (c.xyz + ((((spec_i0.xyz * spec_i0.w) * spec.xyz) * _ExposureIBL.y) + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x)));
  c.xyz = tmpvar_29;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   d3d9 - ALU: 52 to 89, TEX: 5 to 7
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_SpecColor]
Vector 7 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 8 [_Color]
Float 9 [_SpecInt]
Float 10 [_Shininess]
Float 11 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_SpecCubeIBL] CUBE
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 87 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
def c12, 7.00000000, 8.00000000, 2.00000000, 10.00000000
def c13, 1.00000000, 0.95019531, 0.04998779, 0.50000000
def c14, 0.15915494, 0.31830987, 0.75341797, 0.24682617
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3 r0.y, v2, v2
rsq r0.y, r0.y
dp3 r0.x, v3, v3
mul r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v3
dp3_sat r0.w, r0, r1
add r0.w, -r0, c13.x
mul_pp r1.x, r0.w, r0.w
mul_pp r2.y, r0.w, r1.x
mov_pp r1.x, c11
mul r6.xyz, r0.z, c2
add_pp r1.x, c13, -r1
mov_pp r1.y, c11.x
mov_pp r2.x, r0.w
mul_pp r2.xy, r2, r1
mov_pp r1.w, r0
mov_pp r1.z, c13.x
mul_pp r1.zw, r1.xyxy, r1
add_pp r1.z, r1, r1.w
add_pp r1.w, r2.x, r2.y
mul_pp r1.xy, r1.zwzw, r1
add_pp r0.w, r1.x, r1.y
mad_pp r0.w, r0, c13.y, c13.z
mul_pp r2.x, r0.w, c9
texld r1, v0, s1
add_pp r0.w, -r1, c13.x
mul_pp r2.xyz, r2.x, c6
mul_pp r2.xyz, r2, c7.w
mul_pp r4.xyz, r1, r2
mad_pp r0.w, -r0, r0, c13.x
mad_pp r0.w, -r0, c10.x, r0
add_pp r3.w, r0, c12.x
dp3_pp r0.w, c4, c4
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, c4
dp3_pp r1.x, v2, v2
rsq_pp r0.w, r1.x
mad_pp r3.xyz, r0.w, v2, r2
add_pp r2.w, -r3, c12.y
pow_pp r1, c12.z, r2.w
dp3_pp r0.w, r3, r3
rsq_pp r1.y, r0.w
mov_pp r0.w, r1.x
mul_pp r1.xyz, r1.y, r3
mad r1.w, r0, c14.x, c14.y
dp3_pp_sat r2.w, v3, r1
mul_pp r3.xyz, r4, r1.w
pow r1, r2.w, r0.w
dp3_pp_sat r0.w, v3, r2
mul_pp_sat r1.y, r0.w, c12.w
mul_pp r1.x, r1, r1.y
texld r2, v0, s0
mul_pp r2, r2, c8
mul_pp r1.xyz, r1.x, c5
mul_pp r1.xyz, r1, r3
mul_pp r2.xyz, r2, c7.w
mul_pp r5.xyz, r1, c13.w
mul_pp r3.xyz, r2, r2.w
mul_pp r1.xyz, r3, r0.w
mad r0.yzw, r0.y, c1.xxyz, r6.xxyz
mad r0.xyz, r0.x, c0, r0.yzww
mul_pp r1.xyz, r1, c5
mad_pp r5.xyz, r1, c12.z, r5
texld r1, r0, s3
mul_pp r6.x, r1.w, r1.w
mul r0.xyz, v1.z, c2
mad r0.xyz, v1.y, c1, r0
mul_pp r6.y, r1.w, r6.x
mul_pp r6.xy, r6, c14.zwzw
mov_pp r0.w, r3
mad r0.xyz, v1.x, c0, r0
texldl r0, r0, s2
mul_pp r6.z, r0.w, r0.w
mul_pp r6.w, r0, r6.z
add_pp r0.w, r6.x, r6.y
mul_pp r1.xyz, r1, r0.w
mul_pp r6.xy, r6.zwzw, c14.zwzw
add_pp r0.w, r6.x, r6.y
mul_pp r1.xyz, r2, r1
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c7.x
mul_pp r0.xyz, r4, r0
mad_pp r0.xyz, r0, c7.y, r1
mad_pp r1.xyz, r3, v4, r5
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_SpecCubeIBL] CUBE
SetTexture 3 [_DiffCubeIBL] CUBE
SetTexture 4 [unity_Lightmap] 2D
"ps_3_0
; 58 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
def c10, 1.00000000, 0.95019531, 0.04998779, 7.00000000
def c11, 0.75341797, 0.24682617, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r0.xyz, r2.z, c2
mad r0.xyz, r2.y, c1, r0
mad r0.xyz, r2.x, c0, r0
texld r0, r0, s3
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c11
add_pp r1.x, r1, r1.y
mul_pp r0.xyz, r0, r1.x
dp3 r0.w, v2, v2
rsq r0.w, r0.w
mul r3.xyz, r0.w, v2
texld r1, v0, s0
dp3_sat r0.w, r2, r3
mul_pp r2, r1, c6
mul_pp r2.xyz, r2, c5.w
mul_pp r3.xyz, r2, r0
add r1.x, -r0.w, c10
mul_pp r0.x, r1, r1
mul_pp r0.y, r1.x, r0.x
mov_pp r0.z, c9.x
add_pp r1.z, c10.x, -r0
mov_pp r1.w, c9.x
mov_pp r0.x, r1
mul_pp r0.zw, r0.xyxy, r1
mov_pp r0.y, r1.x
mov_pp r0.x, c10
mul_pp r0.xy, r1.zwzw, r0
add_pp r1.y, r0.z, r0.w
add_pp r1.x, r0, r0.y
mul_pp r1.xy, r1, r1.zwzw
texld r0, v0, s1
add_pp r1.z, -r0.w, c10.x
add_pp r0.w, r1.x, r1.y
mad_pp r1.w, -r1.z, r1.z, c10.x
mul r1.xyz, v1.z, c2
mad_pp r1.w, -r1, c8.x, r1
mad r1.xyz, v1.y, c1, r1
mad_pp r0.w, r0, c10.y, c10.z
mul_pp r0.w, r0, c7.x
mul_pp r4.xyz, r0.w, c4
mul_pp r4.xyz, r4, c5.w
mul_pp r3.xyz, r3, c5.x
add_pp r1.w, r1, c10
mad r1.xyz, v1.x, c0, r1
texldl r1, r1, s2
mul_pp r5.x, r1.w, r1.w
mul_pp r5.y, r1.w, r5.x
mul_pp r5.xy, r5, c11
add_pp r0.w, r5.x, r5.y
mul_pp r1.xyz, r1, r0.w
mul_pp r0.xyz, r0, r4
mul_pp r0.xyz, r1, r0
mad_pp r1.xyz, r0, c5.y, r3
texld r0, v3, s4
mul_pp r2.xyz, r2, r2.w
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r2
mad_pp oC0.xyz, r0, c11.z, r1
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
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_SpecColor]
Vector 7 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 8 [_Color]
Float 9 [_SpecInt]
Float 10 [_Shininess]
Float 11 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_SpecCubeIBL] CUBE
SetTexture 3 [_DiffCubeIBL] CUBE
SetTexture 4 [_ShadowMapTexture] 2D
"ps_3_0
; 89 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
def c12, 7.00000000, 8.00000000, 2.00000000, 10.00000000
def c13, 1.00000000, 0.95019531, 0.04998779, 0.50000000
def c14, 0.15915494, 0.31830987, 0.75341797, 0.24682617
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5
dp3 r0.y, v2, v2
rsq r0.y, r0.y
dp3 r0.x, v3, v3
mul r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v3
dp3_sat r0.w, r0, r1
add r0.w, -r0, c13.x
mul_pp r1.x, r0.w, r0.w
mul_pp r2.y, r0.w, r1.x
mov_pp r1.x, c11
texld r3, v0, s1
add_pp r1.x, c13, -r1
mov_pp r1.y, c11.x
mov_pp r2.x, r0.w
mul_pp r2.xy, r2, r1
texldp r6.x, v5, s4
mov_pp r1.w, r0
mov_pp r1.z, c13.x
mul_pp r1.zw, r1.xyxy, r1
add_pp r1.z, r1, r1.w
add_pp r1.w, r2.x, r2.y
mul_pp r1.xy, r1.zwzw, r1
add_pp r0.w, r1.x, r1.y
mad_pp r0.w, r0, c13.y, c13.z
mul_pp r1.x, r0.w, c9
mul_pp r1.xyz, r1.x, c6
mul_pp r4.xyz, r1, c7.w
add_pp r0.w, -r3, c13.x
mad_pp r0.w, -r0, r0, c13.x
mad_pp r1.x, -r0.w, c10, r0.w
add_pp r3.w, r1.x, c12.x
dp3_pp r0.w, c4, c4
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, c4
dp3_pp r1.x, v2, v2
rsq_pp r0.w, r1.x
mad_pp r5.xyz, r0.w, v2, r2
add_pp r2.w, -r3, c12.y
pow_pp r1, c12.z, r2.w
dp3_pp r0.w, r5, r5
rsq_pp r0.w, r0.w
mul_pp r5.xyz, r0.w, r5
mov_pp r2.w, r1.x
dp3_pp_sat r0.w, v3, r5
pow r1, r0.w, r2.w
dp3_pp_sat r0.w, v3, r2
mul_pp_sat r1.y, r0.w, c12.w
mad r1.z, r2.w, c14.x, c14.y
mul_pp r4.xyz, r3, r4
texld r2, v0, s0
mul_pp r2, r2, c8
mul_pp r3.xyz, r4, r1.z
mul_pp r1.x, r1, r1.y
mul_pp r1.xyz, r1.x, c5
mul_pp r1.xyz, r6.x, r1
mul_pp r1.xyz, r1, r3
mul_pp r0.w, r6.x, r0
mul_pp r2.xyz, r2, c7.w
mul r6.xyz, r0.z, c2
mul_pp r5.xyz, r1, c13.w
mul_pp r3.xyz, r2, r2.w
mul_pp r1.xyz, r3, r0.w
mad r0.yzw, r0.y, c1.xxyz, r6.xxyz
mad r0.xyz, r0.x, c0, r0.yzww
mul_pp r1.xyz, r1, c5
mad_pp r5.xyz, r1, c12.z, r5
texld r1, r0, s3
mul_pp r6.x, r1.w, r1.w
mul r0.xyz, v1.z, c2
mad r0.xyz, v1.y, c1, r0
mul_pp r6.y, r1.w, r6.x
mul_pp r6.xy, r6, c14.zwzw
mov_pp r0.w, r3
mad r0.xyz, v1.x, c0, r0
texldl r0, r0, s2
mul_pp r6.z, r0.w, r0.w
mul_pp r6.w, r0, r6.z
add_pp r0.w, r6.x, r6.y
mul_pp r1.xyz, r1, r0.w
mul_pp r6.xy, r6.zwzw, c14.zwzw
add_pp r0.w, r6.x, r6.y
mul_pp r1.xyz, r2, r1
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c7.x
mul_pp r0.xyz, r4, r0
mad_pp r0.xyz, r0, c7.y, r1
mad_pp r1.xyz, r3, v4, r5
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_SpecCubeIBL] CUBE
SetTexture 3 [_DiffCubeIBL] CUBE
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_3_0
; 63 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
dcl_2d s5
def c10, 1.00000000, 0.95019531, 0.04998779, 7.00000000
def c11, 0.75341797, 0.24682617, 8.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r0.xyz, r2.z, c2
mad r0.xyz, r2.y, c1, r0
mad r0.xyz, r2.x, c0, r0
texld r0, r0, s3
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c11
add_pp r1.x, r1, r1.y
mul_pp r0.xyz, r0, r1.x
dp3 r0.w, v2, v2
rsq r0.w, r0.w
mul r3.xyz, r0.w, v2
texld r1, v0, s0
dp3_sat r0.w, r2, r3
mul_pp r2, r1, c6
mul_pp r2.xyz, r2, c5.w
mul_pp r3.xyz, r2, r0
add r1.x, -r0.w, c10
mul_pp r0.x, r1, r1
mul_pp r0.y, r1.x, r0.x
mov_pp r0.z, c9.x
add_pp r1.z, c10.x, -r0
mov_pp r1.w, c9.x
mov_pp r0.x, r1
mul_pp r0.zw, r0.xyxy, r1
mul_pp r3.xyz, r3, c5.x
mov_pp r0.y, r1.x
mov_pp r0.x, c10
mul_pp r0.xy, r1.zwzw, r0
add_pp r1.y, r0.z, r0.w
add_pp r1.x, r0, r0.y
mul_pp r1.xy, r1, r1.zwzw
texld r0, v0, s1
add_pp r1.z, -r0.w, c10.x
add_pp r0.w, r1.x, r1.y
mad_pp r1.w, -r1.z, r1.z, c10.x
mul r1.xyz, v1.z, c2
mad_pp r1.w, -r1, c8.x, r1
mad r1.xyz, v1.y, c1, r1
mad_pp r0.w, r0, c10.y, c10.z
mul_pp r0.w, r0, c7.x
mul_pp r4.xyz, r0.w, c4
mul_pp r4.xyz, r4, c5.w
mul_pp r0.xyz, r0, r4
texldp r4.x, v4, s4
add_pp r1.w, r1, c10
mad r1.xyz, v1.x, c0, r1
texldl r1, r1, s2
mul_pp r5.x, r1.w, r1.w
mul_pp r5.y, r1.w, r5.x
mul_pp r5.xy, r5, c11
add_pp r0.w, r5.x, r5.y
mul_pp r1.xyz, r1, r0.w
mul_pp r0.xyz, r1, r0
mad_pp r1.xyz, r0, c5.y, r3
texld r0, v3, s5
mul_pp r3.xyz, r0.w, r0
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c11.z
mul_pp r0.xyz, r0, c11.w
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mul_pp r2.xyz, r2, r2.w
mad_pp oC0.xyz, r2, r0, r1
mov_pp oC0.w, r2
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
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_SpecColor]
Vector 7 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 8 [_Color]
Float 9 [_SpecInt]
Float 10 [_Shininess]
Float 11 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_SpecCubeIBL] CUBE
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 81 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
def c12, 7.00000000, 8.00000000, 2.00000000, 10.00000000
def c13, 1.00000000, 0.95019531, 0.04998779, 0.50000000
def c14, 0.15915494, 0.31830987, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3 r0.y, v2, v2
rsq r0.y, r0.y
dp3 r0.x, v3, v3
mul r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v3
dp3_sat r0.w, r0, r1
add r0.w, -r0, c13.x
mul_pp r1.x, r0.w, r0.w
mul_pp r2.y, r0.w, r1.x
mul r6.xyz, r0.z, c2
mad r6.xyz, r0.y, c1, r6
mad r0.xyz, r0.x, c0, r6
mov_pp r1.x, c11
add_pp r1.x, c13, -r1
mov_pp r1.y, c11.x
mov_pp r2.x, r0.w
mul_pp r2.xy, r2, r1
mov_pp r1.w, r0
mov_pp r1.z, c13.x
mul_pp r1.zw, r1.xyxy, r1
add_pp r1.z, r1, r1.w
add_pp r1.w, r2.x, r2.y
mul_pp r1.xy, r1.zwzw, r1
add_pp r0.w, r1.x, r1.y
mad_pp r0.w, r0, c13.y, c13.z
mul_pp r0.w, r0, c9.x
rsq_pp r0.w, r0.w
rcp_pp r2.x, r0.w
texld r1, v0, s1
add_pp r0.w, -r1, c13.x
mul_pp r2.xyz, r2.x, c6
mul_pp r2.xyz, r2, c7.w
mul_pp r3.xyz, r1, r2
mad_pp r0.w, -r0, r0, c13.x
mad_pp r0.w, -r0, c10.x, r0
add_pp r2.w, r0, c12.x
dp3_pp r0.w, c4, c4
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, c4
dp3_pp r1.x, v2, v2
rsq_pp r0.w, r1.x
mad_pp r4.xyz, r0.w, v2, r2
add_pp r3.w, -r2, c12.y
pow_pp r1, c12.z, r3.w
dp3_pp r0.w, r4, r4
rsq_pp r1.y, r0.w
mov_pp r0.w, r1.x
mul_pp r1.xyz, r1.y, r4
mad r1.w, r0, c14.x, c14.y
mul_pp r4.xyz, r3, r1.w
dp3_pp_sat r3.w, v3, r1
pow r1, r3.w, r0.w
dp3_pp_sat r0.w, v3, r2
mul_pp_sat r1.y, r0.w, c12.w
mul_pp r2.x, r1, r1.y
mul_pp r2.xyz, r2.x, c5
mul_pp r4.xyz, r2, r4
texld r1, v0, s0
mul_pp r1, r1, c8
mul_pp r2.xyz, r1, c7.w
mul_pp r5.xyz, r4, c13.w
mul_pp r1.xyz, r2, r1.w
mul_pp r4.xyz, r1, r0.w
mul_pp r4.xyz, r4, c5
mad_pp r4.xyz, r4, c12.z, r5
texld r0, r0, s3
mul_pp r5.xyz, r0, r0.w
mul r6.xyz, v1.z, c2
mad r0.xyz, v1.y, c1, r6
mul_pp r2.xyz, r2, r5
mov_pp r0.w, r2
mad r0.xyz, v1.x, c0, r0
texldl r0, r0, s2
mul_pp r0.xyz, r0, r0.w
mul_pp r2.xyz, r2, c7.x
mul_pp r0.xyz, r3, r0
mad_pp r0.xyz, r0, c7.y, r2
mad_pp r1.xyz, r1, v4, r4
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, r1
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_SpecCubeIBL] CUBE
SetTexture 3 [_DiffCubeIBL] CUBE
SetTexture 4 [unity_Lightmap] 2D
"ps_3_0
; 52 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
def c10, 1.00000000, 0.95019531, 0.04998779, 7.00000000
def c11, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, v2, v2
rsq r1.x, r1.x
mul r0.xyz, r0.w, r0
mul r1.xyz, r1.x, v2
dp3_sat r0.w, r0, r1
add r0.w, -r0, c10.x
mul_pp r1.x, r0.w, r0.w
mul_pp r2.y, r0.w, r1.x
mov_pp r1.x, c9
add_pp r1.x, c10, -r1
mov_pp r1.y, c9.x
mov_pp r2.x, r0.w
mul_pp r2.xy, r2, r1
mov_pp r1.w, r0
mov_pp r1.z, c10.x
mul_pp r1.zw, r1.xyxy, r1
add_pp r1.z, r1, r1.w
add_pp r1.w, r2.x, r2.y
mul_pp r1.xy, r1.zwzw, r1
add_pp r0.w, r1.x, r1.y
mul r1.xyz, r0.z, c2
mad_pp r0.z, r0.w, c10.y, c10
mad r1.xyz, r0.y, c1, r1
mul_pp r3.x, r0.z, c7
mad r0.xyz, r0.x, c0, r1
texld r1, v0, s0
mul_pp r2, r1, c6
texld r0, r0, s3
mul_pp r0.xyz, r0, r0.w
mul_pp r2.xyz, r2, c5.w
mul_pp r1.xyz, r2, r0
rsq_pp r0.x, r3.x
mul_pp r3.xyz, r1, c5.x
rcp_pp r1.x, r0.x
texld r0, v0, s1
mul_pp r1.xyz, r1.x, c4
mul_pp r4.xyz, r1, c5.w
add_pp r0.w, -r0, c10.x
mad_pp r0.w, -r0, r0, c10.x
mad_pp r0.w, -r0, c8.x, r0
mul r1.xyz, v1.z, c2
mad r1.xyz, v1.y, c1, r1
add_pp r1.w, r0, c10
mad r1.xyz, v1.x, c0, r1
texldl r1, r1, s2
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r0, r4
mul_pp r0.xyz, r1, r0
mad_pp r1.xyz, r0, c5.y, r3
texld r0, v3, s4
mul_pp r2.xyz, r2, r2.w
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r2
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, r2
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
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_SpecColor]
Vector 7 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 8 [_Color]
Float 9 [_SpecInt]
Float 10 [_Shininess]
Float 11 [_Fresnel]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_SpecCubeIBL] CUBE
SetTexture 3 [_DiffCubeIBL] CUBE
SetTexture 4 [_ShadowMapTexture] 2D
"ps_3_0
; 83 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
def c12, 7.00000000, 8.00000000, 2.00000000, 10.00000000
def c13, 1.00000000, 0.95019531, 0.04998779, 0.50000000
def c14, 0.15915494, 0.31830987, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5
dp3 r0.y, v2, v2
rsq r0.y, r0.y
dp3 r0.x, v3, v3
mul r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v3
dp3_sat r0.w, r0, r1
add r0.w, -r0, c13.x
mul_pp r1.x, r0.w, r0.w
mul_pp r2.y, r0.w, r1.x
mov_pp r1.x, c11
add_pp r1.x, c13, -r1
mov_pp r1.y, c11.x
mov_pp r2.x, r0.w
mul_pp r2.xy, r2, r1
texld r3, v0, s1
texldp r6.x, v5, s4
mov_pp r1.w, r0
mov_pp r1.z, c13.x
mul_pp r1.zw, r1.xyxy, r1
add_pp r1.z, r1, r1.w
add_pp r1.w, r2.x, r2.y
mul_pp r1.xy, r1.zwzw, r1
add_pp r0.w, r1.x, r1.y
mad_pp r0.w, r0, c13.y, c13.z
mul_pp r0.w, r0, c9.x
rsq_pp r0.w, r0.w
rcp_pp r1.x, r0.w
mul_pp r1.xyz, r1.x, c6
mul_pp r4.xyz, r1, c7.w
add_pp r0.w, -r3, c13.x
mad_pp r0.w, -r0, r0, c13.x
mad_pp r1.x, -r0.w, c10, r0.w
add_pp r2.w, r1.x, c12.x
dp3_pp r0.w, c4, c4
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, c4
dp3_pp r1.x, v2, v2
rsq_pp r0.w, r1.x
mad_pp r5.xyz, r0.w, v2, r2
add_pp r3.w, -r2, c12.y
pow_pp r1, c12.z, r3.w
dp3_pp r0.w, r5, r5
rsq_pp r0.w, r0.w
mul_pp r5.xyz, r0.w, r5
mov_pp r3.w, r1.x
dp3_pp_sat r0.w, v3, r5
pow r1, r0.w, r3.w
dp3_pp_sat r0.w, v3, r2
mul_pp_sat r1.y, r0.w, c12.w
mul_pp r1.x, r1, r1.y
mul_pp r2.xyz, r1.x, c5
mul_pp r3.xyz, r3, r4
mad r1.z, r3.w, c14.x, c14.y
mul_pp r4.xyz, r3, r1.z
mul_pp r2.xyz, r6.x, r2
mul_pp r4.xyz, r2, r4
mul_pp r0.w, r6.x, r0
mul r6.xyz, r0.z, c2
mad r6.xyz, r0.y, c1, r6
mad r0.xyz, r0.x, c0, r6
texld r1, v0, s0
mul_pp r1, r1, c8
mul_pp r2.xyz, r1, c7.w
mul_pp r5.xyz, r4, c13.w
mul_pp r1.xyz, r2, r1.w
mul_pp r4.xyz, r1, r0.w
mul_pp r4.xyz, r4, c5
mad_pp r4.xyz, r4, c12.z, r5
texld r0, r0, s3
mul_pp r5.xyz, r0, r0.w
mul r6.xyz, v1.z, c2
mad r0.xyz, v1.y, c1, r6
mul_pp r2.xyz, r2, r5
mov_pp r0.w, r2
mad r0.xyz, v1.x, c0, r0
texldl r0, r0, s2
mul_pp r0.xyz, r0, r0.w
mul_pp r2.xyz, r2, c7.x
mul_pp r0.xyz, r3, r0
mad_pp r0.xyz, r0, c7.y, r2
mad_pp r1.xyz, r1, v4, r4
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, r1
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_SpecCubeIBL] CUBE
SetTexture 3 [_DiffCubeIBL] CUBE
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_3_0
; 57 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_cube s3
dcl_2d s4
dcl_2d s5
def c10, 1.00000000, 0.95019531, 0.04998779, 7.00000000
def c11, 8.00000000, 2.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, v2, v2
rsq r1.x, r1.x
mul r0.xyz, r0.w, r0
mul r1.xyz, r1.x, v2
dp3_sat r0.w, r0, r1
add r0.w, -r0, c10.x
mul_pp r1.x, r0.w, r0.w
mul_pp r2.y, r0.w, r1.x
mov_pp r1.x, c9
add_pp r1.x, c10, -r1
mov_pp r1.y, c9.x
mov_pp r2.x, r0.w
mul_pp r2.xy, r2, r1
mov_pp r1.w, r0
mov_pp r1.z, c10.x
mul_pp r1.zw, r1.xyxy, r1
add_pp r1.z, r1, r1.w
add_pp r1.w, r2.x, r2.y
mul_pp r1.xy, r1.zwzw, r1
add_pp r0.w, r1.x, r1.y
mul r1.xyz, r0.z, c2
mad_pp r0.z, r0.w, c10.y, c10
mad r1.xyz, r0.y, c1, r1
mul_pp r3.x, r0.z, c7
mad r0.xyz, r0.x, c0, r1
texld r1, v0, s0
mul_pp r2, r1, c6
texld r0, r0, s3
mul_pp r0.xyz, r0, r0.w
mul_pp r2.xyz, r2, c5.w
mul_pp r1.xyz, r2, r0
rsq_pp r0.x, r3.x
mul_pp r3.xyz, r1, c5.x
rcp_pp r1.x, r0.x
texld r0, v0, s1
mul_pp r1.xyz, r1.x, c4
mul_pp r4.xyz, r1, c5.w
mul_pp r0.xyz, r0, r4
add_pp r0.w, -r0, c10.x
mad_pp r0.w, -r0, r0, c10.x
mad_pp r0.w, -r0, c8.x, r0
mul r1.xyz, v1.z, c2
mad r1.xyz, v1.y, c1, r1
add_pp r1.w, r0, c10
mad r1.xyz, v1.x, c0, r1
texldl r1, r1, s2
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, r1, r0
mad_pp r1.xyz, r0, c5.y, r3
texld r0, v3, s5
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v4, s4
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c11.x
mul_pp r0.xyz, r0, c11.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mul_pp r2.xyz, r2, r2.w
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
//   d3d9 - ALU: 14 to 19
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "POINT" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD4;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  float atten;
  atten = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (normalize (xlv_TEXCOORD3));
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c14
mad o1.xy, v2, c15, c15.zwzw
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTexture0, tmpvar_13);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_12;
  mediump float atten;
  atten = tmpvar_14.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_15) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_15), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_18;
  frag.xyz = (frag.xyz + (tmpvar_18 * tmpvar_2));
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_16;
  tmpvar_16 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_15;
  mediump float atten;
  atten = tmpvar_17.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize (lightDir_i0);
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, tmpvar_18), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_19) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_18))), 0.0, 1.0);
  specRefl = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = vec3(pow (specRefl, tmpvar_12));
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

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = _WorldSpaceLightPos0.xyz;
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
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD3);
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [_MainTex_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c8.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o2.xyz, -r0, c9
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mov o4.xyz, c10
mad o1.xy, v2, c11, c11.zwzw
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

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  lightDir = xlv_TEXCOORD3;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_11;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_12;
  tmpvar_12 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_12) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_12), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_15;
  frag.xyz = (frag.xyz + (tmpvar_15 * tmpvar_2));
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

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  lightDir = xlv_TEXCOORD3;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_14;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize (lightDir_i0);
  mediump float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_1, tmpvar_15), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_16) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_17;
  tmpvar_17 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_15))), 0.0, 1.0);
  specRefl = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_19;
  frag.xyz = (frag.xyz + (tmpvar_19 * tmpvar_2));
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
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD4;
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
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (normalize (xlv_TEXCOORD3));
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.w, r0, c11
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c14
mad o1.xy, v2, c15, c15.zwzw
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

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_14;
  tmpvar_14 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, tmpvar_14);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_12;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_13.w) * tmpvar_15.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_16) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_17;
  tmpvar_17 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_19;
  frag.xyz = (frag.xyz + (tmpvar_19 * tmpvar_2));
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

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_17;
  tmpvar_17 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, tmpvar_17);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_15;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_16.w) * tmpvar_18.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (lightDir_i0);
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, tmpvar_19), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_20) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_19))), 0.0, 1.0);
  specRefl = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_20), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_23;
  frag.xyz = (frag.xyz + (tmpvar_23 * tmpvar_2));
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD4;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  float atten;
  atten = (texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (normalize (xlv_TEXCOORD3));
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c14
mad o1.xy, v2, c15, c15.zwzw
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, tmpvar_13);
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_12;
  mediump float atten;
  atten = (tmpvar_14.w * tmpvar_15.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_16) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_17;
  tmpvar_17 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_19;
  frag.xyz = (frag.xyz + (tmpvar_19 * tmpvar_2));
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_16;
  tmpvar_16 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, tmpvar_16);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_15;
  mediump float atten;
  atten = (tmpvar_17.w * tmpvar_18.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (lightDir_i0);
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, tmpvar_19), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_20) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_19))), 0.0, 1.0);
  specRefl = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_20), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_23;
  frag.xyz = (frag.xyz + (tmpvar_23 * tmpvar_2));
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
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD4;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt)) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  float atten;
  atten = texture2D (_LightTexture0, xlv_TEXCOORD4).w;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD3);
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mov o4.xyz, c14
mad o1.xy, v2, c15, c15.zwzw
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

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  lightDir = xlv_TEXCOORD3;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_11;
  mediump float atten;
  atten = tmpvar_12.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_14;
  tmpvar_14 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_16;
  frag.xyz = (frag.xyz + (tmpvar_16 * tmpvar_2));
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

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * ((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity)) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  lightDir = xlv_TEXCOORD3;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_14;
  mediump float atten;
  atten = tmpvar_15.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize (lightDir_i0);
  mediump float tmpvar_17;
  tmpvar_17 = clamp (dot (tmpvar_1, tmpvar_16), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_17) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_16))), 0.0, 1.0);
  specRefl = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_17), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_20;
  frag.xyz = (frag.xyz + (tmpvar_20 * tmpvar_2));
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD4;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  float atten;
  atten = texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (normalize (xlv_TEXCOORD3));
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c14
mad o1.xy, v2, c15, c15.zwzw
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTexture0, tmpvar_13);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_12;
  mediump float atten;
  atten = tmpvar_14.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_15) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_15), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_18;
  frag.xyz = (frag.xyz + (tmpvar_18 * tmpvar_2));
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_16;
  tmpvar_16 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_15;
  mediump float atten;
  atten = tmpvar_17.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize (lightDir_i0);
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_1, tmpvar_18), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_19) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_18))), 0.0, 1.0);
  specRefl = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = vec3(pow (specRefl, tmpvar_12));
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

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = _WorldSpaceLightPos0.xyz;
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
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD3);
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + ((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [_MainTex_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c8.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o2.xyz, -r0, c9
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mov o4.xyz, c10
mad o1.xy, v2, c11, c11.zwzw
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

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  lightDir = xlv_TEXCOORD3;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_11;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_12;
  tmpvar_12 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_12) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_12), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_15;
  frag.xyz = (frag.xyz + (tmpvar_15 * tmpvar_2));
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

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp mat4 _SkyMatrix;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  lightDir = xlv_TEXCOORD3;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD1);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_14;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize (lightDir_i0);
  mediump float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_1, tmpvar_15), 0.0, 1.0);
  frag.xyz = (((2.0 * tmpvar_16) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_17;
  tmpvar_17 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_15))), 0.0, 1.0);
  specRefl = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (((spec_i0_i1 * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * 0.5);
  spec_i0_i1 = tmpvar_19;
  frag.xyz = (frag.xyz + (tmpvar_19 * tmpvar_2));
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
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec4 xlv_TEXCOORD4;
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
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (normalize (xlv_TEXCOORD3));
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.w, r0, c11
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c14
mad o1.xy, v2, c15, c15.zwzw
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

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_14;
  tmpvar_14 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, tmpvar_14);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_12;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_13.w) * tmpvar_15.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_16) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_17;
  tmpvar_17 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_19;
  frag.xyz = (frag.xyz + (tmpvar_19 * tmpvar_2));
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

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_17;
  tmpvar_17 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, tmpvar_17);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_15;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_16.w) * tmpvar_18.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (lightDir_i0);
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, tmpvar_19), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_20) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_19))), 0.0, 1.0);
  specRefl = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_20), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_23;
  frag.xyz = (frag.xyz + (tmpvar_23 * tmpvar_2));
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
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec3 xlv_TEXCOORD4;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  float atten;
  atten = (texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (normalize (xlv_TEXCOORD3));
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c14
mad o1.xy, v2, c15, c15.zwzw
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, tmpvar_13);
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_12;
  mediump float atten;
  atten = (tmpvar_14.w * tmpvar_15.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_16;
  tmpvar_16 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_16) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_17;
  tmpvar_17 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_16), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_19;
  frag.xyz = (frag.xyz + (tmpvar_19 * tmpvar_2));
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD1);
  highp vec2 tmpvar_16;
  tmpvar_16 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, tmpvar_16);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_15;
  mediump float atten;
  atten = (tmpvar_17.w * tmpvar_18.w);
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize (lightDir_i0);
  mediump float tmpvar_20;
  tmpvar_20 = clamp (dot (tmpvar_1, tmpvar_19), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_20) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_19))), 0.0, 1.0);
  specRefl = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_20), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_23;
  frag.xyz = (frag.xyz + (tmpvar_23 * tmpvar_2));
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
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD3 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
varying vec2 xlv_TEXCOORD4;
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
uniform float _Fresnel;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 spec;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_2;
  vec3 p;
  float tmpvar_3;
  tmpvar_3 = (1.0 - clamp (dot (normalize (xlv_TEXCOORD2), normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  vec3 tmpvar_4;
  tmpvar_4.x = 1.0;
  tmpvar_4.y = tmpvar_3;
  tmpvar_4.z = ((tmpvar_3 * tmpvar_3) * tmpvar_3);
  p = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = (1.0 - _Fresnel);
  tmpvar_5.y = _Fresnel;
  p.x = dot (tmpvar_4.xy, tmpvar_5);
  p.y = dot (p.yz, tmpvar_5);
  spec.xyz = (tmpvar_2.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_5))) * _SpecInt))) * _ExposureIBL.w));
  float tmpvar_6;
  tmpvar_6 = (1.0 - tmpvar_2.w);
  float tmpvar_7;
  tmpvar_7 = (1.0 - (tmpvar_6 * tmpvar_6));
  float tmpvar_8;
  tmpvar_8 = pow (2.0, (8.0 - ((7.0 + tmpvar_7) - (_Shininess * tmpvar_7))));
  float atten;
  atten = texture2D (_LightTexture0, xlv_TEXCOORD4).w;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD3);
  float tmpvar_10;
  tmpvar_10 = clamp (dot (xlv_TEXCOORD2, tmpvar_9), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_10) * (diff.xyz * tmpvar_1.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  frag.xyz = (frag.xyz + (((((vec3(pow (clamp (dot (xlv_TEXCOORD2, normalize ((normalize (xlv_TEXCOORD1) + tmpvar_9))), 0.0, 1.0), tmpvar_8)) * clamp ((10.0 * tmpvar_10), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5) * (spec.xyz * ((tmpvar_8 * 0.159155) + 0.31831))));
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
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mov o4.xyz, c14
mad o1.xy, v2, c15, c15.zwzw
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

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _SpecTex;
uniform highp float _SpecInt;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_5;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  float tmpvar_6;
  tmpvar_6 = (1.0 - clamp (dot (N, xlv_TEXCOORD1), 0.0, 1.0));
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * (specIntensity * mix (1.0, (tmpvar_6 * (tmpvar_6 * tmpvar_6)), (fresnel_i0 * 0.9)))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_7;
  tmpvar_7 = (1.0 - spec.w);
  mediump float tmpvar_8;
  tmpvar_8 = (1.0 - (tmpvar_7 * tmpvar_7));
  mediump float tmpvar_9;
  tmpvar_9 = pow (2.0, (8.0 - ((7.0 + tmpvar_8) - (shininess * tmpvar_8))));
  highp float gloss;
  gloss = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_10;
  lightDir = xlv_TEXCOORD3;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_11;
  mediump float atten;
  atten = tmpvar_12.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump float tmpvar_13;
  tmpvar_13 = clamp (dot (tmpvar_1, lightDir_i0), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_13) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_14;
  tmpvar_14 = clamp (dot (tmpvar_1, normalize ((viewDir + lightDir_i0))), 0.0, 1.0);
  specRefl = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = vec3(pow (specRefl, tmpvar_9));
  spec_i0_i1 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_13), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_16;
  frag.xyz = (frag.xyz + (tmpvar_16 * tmpvar_2));
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

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
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
uniform highp float _Fresnel;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD2;
  mediump vec3 tmpvar_2;
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
  N = tmpvar_1;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (N);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_SpecTex, xlv_TEXCOORD0);
  spec = tmpvar_6;
  mediump float specIntensity;
  specIntensity = _SpecInt;
  mediump float fresnel_i0;
  fresnel_i0 = _Fresnel;
  mediump vec3 p;
  float tmpvar_7;
  tmpvar_7 = (1.0 - clamp (dot (tmpvar_5, normalize (xlv_TEXCOORD1)), 0.0, 1.0));
  mediump vec3 tmpvar_8;
  tmpvar_8.x = 1.0;
  tmpvar_8.y = tmpvar_7;
  tmpvar_8.z = ((tmpvar_7 * tmpvar_7) * tmpvar_7);
  p = tmpvar_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = (1.0 - fresnel_i0);
  tmpvar_9.y = fresnel_i0;
  p.x = dot (tmpvar_8.xy, tmpvar_9);
  p.y = dot (p.yz, tmpvar_9);
  spec.xyz = (spec.xyz * ((_SpecColor.xyz * sqrt (((0.05 + (0.95 * dot (p.xy, tmpvar_9))) * specIntensity))) * _ExposureIBL.w));
  mediump float shininess;
  shininess = _Shininess;
  mediump float tmpvar_10;
  tmpvar_10 = (1.0 - spec.w);
  mediump float tmpvar_11;
  tmpvar_11 = (1.0 - (tmpvar_10 * tmpvar_10));
  mediump float tmpvar_12;
  tmpvar_12 = pow (2.0, (8.0 - ((7.0 + tmpvar_11) - (shininess * tmpvar_11))));
  highp float gloss;
  gloss = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (spec.xyz * ((gloss * 0.159155) + 0.31831));
  tmpvar_2 = tmpvar_13;
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
  N = ((v_i0_i0.xyz * tmpvar_5.x) + ((v_i0_i1_i0.xyz * tmpvar_5.y) + (v_i0_i1_i2_i0.xyz * tmpvar_5.z)));
  lightDir = xlv_TEXCOORD3;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD1);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec3 viewDir;
  viewDir = tmpvar_14;
  mediump float atten;
  atten = tmpvar_15.w;
  mediump vec3 spec_i0_i1;
  highp float specRefl;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize (lightDir_i0);
  mediump float tmpvar_17;
  tmpvar_17 = clamp (dot (tmpvar_1, tmpvar_16), 0.0, 1.0);
  frag.xyz = ((((atten * 2.0) * tmpvar_17) * (diff.xyz * diff.w)) * _LightColor0.xyz);
  frag.w = diff.w;
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_1, normalize ((viewDir + tmpvar_16))), 0.0, 1.0);
  specRefl = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = vec3(pow (specRefl, tmpvar_12));
  spec_i0_i1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = ((((spec_i0_i1 * clamp ((10.0 * tmpvar_17), 0.0, 1.0)) * _LightColor0.xyz) * atten) * 0.5);
  spec_i0_i1 = tmpvar_20;
  frag.xyz = (frag.xyz + (tmpvar_20 * tmpvar_2));
  c = frag;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 10
//   d3d9 - ALU: 63 to 75, TEX: 2 to 4
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
SetTexture 1 [_SpecTex] 2D
SetTexture 4 [_LightTexture0] 2D
"ps_3_0
; 68 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s4
def c11, 2.00000000, 10.00000000, 1.00000000, 0.50000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
add r1.x, -r0, c11.z
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.z, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
texld r1, v0, s1
add_pp r0.w, -r1, c11.z
mad_pp r1.w, -r0, r0, c11.z
mad_pp r2.w, -r1, c9.x, r1
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
mul_pp r0.xyz, r0.x, c5
mul_pp r2.xyz, r0, c6.w
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v3
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, v1, v1
rsq_pp r0.x, r1.w
mad_pp r4.xyz, r0.x, v1, r3
add_pp r2.w, -r2, c11.z
pow_pp r0, c11.x, r2.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
mov_pp r1.w, r0.x
dp3_pp_sat r2.w, v2, r4
pow r0, r2.w, r1.w
dp3_pp_sat r0.y, v2, r3
mul_pp_sat r0.z, r0.y, c11.y
mul_pp r1.xyz, r1, r2
mul_pp r0.x, r0, r0.z
mad r0.w, r1, c12.z, c12
mul_pp r3.xyz, r1, r0.w
mul_pp r2.xyz, r0.x, c4
texld r1, v0, s0
mul_pp r1, r1, c7
dp3 r0.x, v4, v4
texld r0.x, r0.x, s4
mul_pp r2.xyz, r0.x, r2
mul_pp r1.xyz, r1, c6.w
mul_pp r1.xyz, r1, r1.w
mul_pp r0.x, r0, r0.y
mul_pp r0.xyz, r0.x, r1
mul_pp r2.xyz, r2, r3
mul_pp r1.xyz, r2, c11.w
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.x
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
SetTexture 1 [_SpecTex] 2D
"ps_3_0
; 63 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c11, 2.00000000, 10.00000000, 1.00000000, 0.50000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
add r1.x, -r0, c11.z
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.z, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
mul_pp r1.xyz, r0.x, c5
texld r0, v0, s1
mul_pp r1.xyz, r1, c6.w
mul_pp r3.xyz, r0, r1
add_pp r0.w, -r0, c11.z
mad_pp r0.y, -r0.w, r0.w, c11.z
mad_pp r0.z, -r0.y, c9.x, r0.y
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v3
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r2.xyz, r0.x, v1, r1
add_pp r2.w, -r0.z, c11.z
pow_pp r0, c11.x, r2.w
dp3_pp r1.w, r2, r2
rsq_pp r0.y, r1.w
mul_pp r2.xyz, r0.y, r2
mov_pp r2.w, r0.x
dp3_pp_sat r1.w, v2, r2
pow r0, r1.w, r2.w
mad r0.y, r2.w, c12.z, c12.w
dp3_pp_sat r1.w, v2, r1
mul_pp r2.xyz, r3, r0.y
mov r2.w, r0.x
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp_sat r1.x, r1.w, c11.y
mul_pp r0.xyz, r0, c6.w
mul_pp r1.x, r2.w, r1
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1.x, c4
mul_pp r1.xyz, r1, r2
mul_pp r0.xyz, r1.w, r0
mul_pp r1.xyz, r1, c11.w
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.x
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
SetTexture 1 [_SpecTex] 2D
SetTexture 4 [_LightTexture0] 2D
SetTexture 5 [_LightTextureB0] 2D
"ps_3_0
; 73 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s4
dcl_2d s5
def c11, 0.00000000, 1.00000000, 0.50000000, 2.00000000
def c12, 10.00000000, 0.95019531, 0.04998779, 0
def c13, 0.15915494, 0.31830987, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
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
texld r1, v0, s1
add_pp r0.w, -r1, c11.y
mad_pp r1.w, -r0, r0, c11.y
mad_pp r2.w, -r1, c9.x, r1
mad_pp r0.x, r0, c12.y, c12.z
mul_pp r0.x, r0, c8
mul_pp r0.xyz, r0.x, c5
mul_pp r2.xyz, r0, c6.w
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v3
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, v1, v1
rsq_pp r0.x, r1.w
mad_pp r4.xyz, r0.x, v1, r3
add_pp r2.w, -r2, c11.y
pow_pp r0, c11.w, r2.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
mov_pp r1.w, r0.x
dp3_pp_sat r2.w, v2, r4
pow r0, r2.w, r1.w
dp3_pp_sat r2.w, v2, r3
mul_pp_sat r0.y, r2.w, c12.x
rcp r3.w, v4.w
mul_pp r1.xyz, r1, r2
mad r0.z, r1.w, c13.x, c13.y
mul_pp r0.x, r0, r0.y
mul_pp r3.xyz, r1, r0.z
mul_pp r2.xyz, r0.x, c4
texld r0, v0, s0
mul_pp r1, r0, c7
mad r4.xy, v4, r3.w, c11.z
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c6.w
texld r0.w, r4, s4
cmp r0.y, -v4.z, c11.x, c11
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s5
mul_pp r0.w, r0.y, r0.x
mul_pp r0.xyz, r0.w, r2
mul_pp r0.xyz, r0, r3
mul_pp r2.xyz, r0, c11.z
mul_pp r1.xyz, r1, r1.w
mul_pp r0.w, r0, r2
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
SetTexture 1 [_SpecTex] 2D
SetTexture 4 [_LightTextureB0] 2D
SetTexture 5 [_LightTexture0] CUBE
"ps_3_0
; 70 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s4
dcl_cube s5
def c11, 2.00000000, 10.00000000, 1.00000000, 0.50000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
add r1.x, -r0, c11.z
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.z, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
mul_pp r0.xyz, r0.x, c5
mul_pp r1.xyz, r0, c6.w
texld r0, v0, s1
mul_pp r3.xyz, r0, r1
add_pp r0.y, -r0.w, c11.z
mad_pp r0.w, -r0.y, r0.y, c11.z
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v3
dp3_pp r1.x, r0, r0
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r1.x, r0
dp3_pp r1.y, v1, v1
rsq_pp r1.x, r1.y
mad_pp r0.w, -r0, c9.x, r0
mad_pp r2.xyz, r1.x, v1, r0
dp3_pp_sat r2.w, v2, r0
add_pp r0.w, -r0, c11.z
pow_pp r1, c11.x, r0.w
dp3_pp r0.w, r2, r2
rsq_pp r1.y, r0.w
mov_pp r0.w, r1.x
mul_pp r1.xyz, r1.y, r2
mad r1.w, r0, c12.z, c12
dp3_pp_sat r2.x, v2, r1
mul_pp r3.xyz, r3, r1.w
pow r1, r2.x, r0.w
mov r0.x, r1
mul_pp_sat r0.y, r2.w, c11
mul_pp r1.x, r0, r0.y
texld r0, v0, s0
mul_pp r2.xyz, r1.x, c4
mul_pp r1, r0, c7
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c6.w
texld r0.x, r0.x, s4
texld r0.w, v4, s5
mul r0.w, r0.x, r0
mul_pp r0.xyz, r0.w, r2
mul_pp r0.xyz, r0, r3
mul_pp r1.xyz, r1, r1.w
mul_pp r0.w, r0, r2
mul_pp r1.xyz, r0.w, r1
mul_pp r0.xyz, r0, c11.w
mul_pp r1.xyz, r1, c4
mad_pp oC0.xyz, r1, c11.x, r0
mov_pp oC0.w, c13.x
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
SetTexture 1 [_SpecTex] 2D
SetTexture 4 [_LightTexture0] 2D
"ps_3_0
; 64 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s4
def c11, 2.00000000, 10.00000000, 1.00000000, 0.50000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
add r1.x, -r0, c11.z
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.z, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r1.x, r0, c8
texld r0, v0, s1
mul_pp r1.xyz, r1.x, c5
mul_pp r1.xyz, r1, c6.w
mul_pp r3.xyz, r0, r1
add_pp r0.w, -r0, c11.z
mad_pp r0.w, -r0, r0, c11.z
mad_pp r0.y, -r0.w, c9.x, r0.w
add_pp r1.w, -r0.y, c11.z
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v3
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r2.xyz, r0.x, v1, r1
pow_pp r0, c11.x, r1.w
dp3_pp r0.y, r2, r2
mov_pp r1.w, r0.x
rsq_pp r0.y, r0.y
mul_pp r0.xyz, r0.y, r2
mad r0.w, r1, c12.z, c12
dp3_pp_sat r2.w, v2, r0
mul_pp r2.xyz, r3, r0.w
pow r0, r2.w, r1.w
dp3_pp_sat r1.w, v2, r1
mul_pp_sat r0.y, r1.w, c11
mul_pp r1.x, r0, r0.y
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c6.w
mul_pp r0.xyz, r0, r0.w
texld r2.w, v4, s4
mul_pp r1.xyz, r1.x, c4
mul_pp r1.xyz, r2.w, r1
mul_pp r1.xyz, r1, r2
mul_pp r0.w, r2, r1
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r1, c11.w
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.x
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
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_3_0
; 70 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c11, 2.00000000, 10.00000000, 1.00000000, 0.50000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
add r1.x, -r0, c11.z
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.z, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
texld r1, v0, s1
add_pp r0.w, -r1, c11.z
mad_pp r1.w, -r0, r0, c11.z
mad_pp r2.w, -r1, c9.x, r1
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
rsq_pp r0.x, r0.x
rcp_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, c5
mul_pp r2.xyz, r0, c6.w
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v3
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, v1, v1
rsq_pp r0.x, r1.w
mad_pp r4.xyz, r0.x, v1, r3
add_pp r2.w, -r2, c11.z
pow_pp r0, c11.x, r2.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
mov_pp r1.w, r0.x
dp3_pp_sat r2.w, v2, r4
pow r0, r2.w, r1.w
dp3_pp_sat r0.y, v2, r3
mul_pp_sat r0.z, r0.y, c11.y
mul_pp r1.xyz, r1, r2
mul_pp r0.x, r0, r0.z
mad r0.w, r1, c12.z, c12
mul_pp r3.xyz, r1, r0.w
mul_pp r2.xyz, r0.x, c4
texld r1, v0, s0
mul_pp r1, r1, c7
dp3 r0.x, v4, v4
texld r0.x, r0.x, s2
mul_pp r2.xyz, r0.x, r2
mul_pp r1.xyz, r1, c6.w
mul_pp r1.xyz, r1, r1.w
mul_pp r0.x, r0, r0.y
mul_pp r0.xyz, r0.x, r1
mul_pp r2.xyz, r2, r3
mul_pp r1.xyz, r2, c11.w
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.x
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
SetTexture 1 [_SpecTex] 2D
"ps_3_0
; 65 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c11, 2.00000000, 10.00000000, 1.00000000, 0.50000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
add r1.x, -r0, c11.z
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.z, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
rsq_pp r0.x, r0.x
rcp_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, c5
texld r0, v0, s1
mul_pp r1.xyz, r1, c6.w
mul_pp r3.xyz, r0, r1
add_pp r0.w, -r0, c11.z
mad_pp r0.y, -r0.w, r0.w, c11.z
mad_pp r0.z, -r0.y, c9.x, r0.y
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v3
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r2.xyz, r0.x, v1, r1
add_pp r2.w, -r0.z, c11.z
pow_pp r0, c11.x, r2.w
dp3_pp r1.w, r2, r2
rsq_pp r0.y, r1.w
mul_pp r2.xyz, r0.y, r2
mov_pp r2.w, r0.x
dp3_pp_sat r1.w, v2, r2
pow r0, r1.w, r2.w
mad r0.y, r2.w, c12.z, c12.w
dp3_pp_sat r1.w, v2, r1
mul_pp r2.xyz, r3, r0.y
mov r2.w, r0.x
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp_sat r1.x, r1.w, c11.y
mul_pp r0.xyz, r0, c6.w
mul_pp r1.x, r2.w, r1
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1.x, c4
mul_pp r1.xyz, r1, r2
mul_pp r0.xyz, r1.w, r0
mul_pp r1.xyz, r1, c11.w
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.x
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
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"ps_3_0
; 75 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c11, 0.00000000, 1.00000000, 0.50000000, 2.00000000
def c12, 10.00000000, 0.95019531, 0.04998779, 0
def c13, 0.15915494, 0.31830987, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
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
texld r1, v0, s1
add_pp r0.w, -r1, c11.y
mad_pp r1.w, -r0, r0, c11.y
mad_pp r2.w, -r1, c9.x, r1
mad_pp r0.x, r0, c12.y, c12.z
mul_pp r0.x, r0, c8
rsq_pp r0.x, r0.x
rcp_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, c5
mul_pp r2.xyz, r0, c6.w
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v3
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, v1, v1
rsq_pp r0.x, r1.w
mad_pp r4.xyz, r0.x, v1, r3
add_pp r2.w, -r2, c11.y
pow_pp r0, c11.w, r2.w
dp3_pp r1.w, r4, r4
rsq_pp r0.y, r1.w
mul_pp r4.xyz, r0.y, r4
mov_pp r1.w, r0.x
dp3_pp_sat r2.w, v2, r4
pow r0, r2.w, r1.w
dp3_pp_sat r2.w, v2, r3
mul_pp_sat r0.y, r2.w, c12.x
rcp r3.w, v4.w
mul_pp r1.xyz, r1, r2
mad r0.z, r1.w, c13.x, c13.y
mul_pp r0.x, r0, r0.y
mul_pp r3.xyz, r1, r0.z
mul_pp r2.xyz, r0.x, c4
texld r0, v0, s0
mul_pp r1, r0, c7
mad r4.xy, v4, r3.w, c11.z
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c6.w
texld r0.w, r4, s2
cmp r0.y, -v4.z, c11.x, c11
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s3
mul_pp r0.w, r0.y, r0.x
mul_pp r0.xyz, r0.w, r2
mul_pp r0.xyz, r0, r3
mul_pp r2.xyz, r0, c11.z
mul_pp r1.xyz, r1, r1.w
mul_pp r0.w, r0, r2
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
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"ps_3_0
; 72 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c11, 2.00000000, 10.00000000, 1.00000000, 0.50000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
add r1.x, -r0, c11.z
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.z, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
rsq_pp r0.x, r0.x
rcp_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, c5
mul_pp r1.xyz, r0, c6.w
texld r0, v0, s1
mul_pp r3.xyz, r0, r1
add_pp r0.y, -r0.w, c11.z
mad_pp r0.w, -r0.y, r0.y, c11.z
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v3
dp3_pp r1.x, r0, r0
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r1.x, r0
dp3_pp r1.y, v1, v1
rsq_pp r1.x, r1.y
mad_pp r0.w, -r0, c9.x, r0
mad_pp r2.xyz, r1.x, v1, r0
dp3_pp_sat r2.w, v2, r0
add_pp r0.w, -r0, c11.z
pow_pp r1, c11.x, r0.w
dp3_pp r0.w, r2, r2
rsq_pp r1.y, r0.w
mov_pp r0.w, r1.x
mul_pp r1.xyz, r1.y, r2
mad r1.w, r0, c12.z, c12
dp3_pp_sat r2.x, v2, r1
mul_pp r3.xyz, r3, r1.w
pow r1, r2.x, r0.w
mov r0.x, r1
mul_pp_sat r0.y, r2.w, c11
mul_pp r1.x, r0, r0.y
texld r0, v0, s0
mul_pp r2.xyz, r1.x, c4
mul_pp r1, r0, c7
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c6.w
texld r0.x, r0.x, s2
texld r0.w, v4, s3
mul r0.w, r0.x, r0
mul_pp r0.xyz, r0.w, r2
mul_pp r0.xyz, r0, r3
mul_pp r1.xyz, r1, r1.w
mul_pp r0.w, r0, r2
mul_pp r1.xyz, r0.w, r1
mul_pp r0.xyz, r0, c11.w
mul_pp r1.xyz, r1, c4
mad_pp oC0.xyz, r1, c11.x, r0
mov_pp oC0.w, c13.x
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
SetTexture 1 [_SpecTex] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_3_0
; 66 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c11, 2.00000000, 10.00000000, 1.00000000, 0.50000000
def c12, 0.95019531, 0.04998779, 0.15915494, 0.31830987
def c13, 0.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dp3 r0.y, v1, v1
rsq r0.y, r0.y
dp3 r0.x, v2, v2
mul r1.xyz, r0.y, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v2
dp3_sat r0.x, r0, r1
add r1.x, -r0, c11.z
mul_pp r0.x, r1, r1
mul_pp r1.y, r1.x, r0.x
mov_pp r0.x, c10
add_pp r0.x, c11.z, -r0
mov_pp r0.y, c10.x
mov_pp r0.w, r1.x
mov_pp r0.z, c11
mul_pp r0.zw, r0.xyxy, r0
mul_pp r1.xy, r1, r0
add_pp r0.z, r0, r0.w
add_pp r0.w, r1.x, r1.y
mul_pp r0.xy, r0.zwzw, r0
add_pp r0.x, r0, r0.y
mad_pp r0.x, r0, c12, c12.y
mul_pp r0.x, r0, c8
rsq_pp r0.x, r0.x
rcp_pp r1.x, r0.x
texld r0, v0, s1
mul_pp r1.xyz, r1.x, c5
mul_pp r1.xyz, r1, c6.w
mul_pp r3.xyz, r0, r1
add_pp r0.w, -r0, c11.z
mad_pp r0.w, -r0, r0, c11.z
mad_pp r0.y, -r0.w, c9.x, r0.w
add_pp r1.w, -r0.y, c11.z
dp3_pp r0.x, v3, v3
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v3
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mad_pp r2.xyz, r0.x, v1, r1
pow_pp r0, c11.x, r1.w
dp3_pp r0.y, r2, r2
mov_pp r1.w, r0.x
rsq_pp r0.y, r0.y
mul_pp r0.xyz, r0.y, r2
mad r0.w, r1, c12.z, c12
dp3_pp_sat r2.w, v2, r0
mul_pp r2.xyz, r3, r0.w
pow r0, r2.w, r1.w
dp3_pp_sat r1.w, v2, r1
mul_pp_sat r0.y, r1.w, c11
mul_pp r1.x, r0, r0.y
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c6.w
mul_pp r0.xyz, r0, r0.w
texld r2.w, v4, s2
mul_pp r1.xyz, r1.x, c4
mul_pp r1.xyz, r2.w, r1
mul_pp r1.xyz, r1, r2
mul_pp r0.w, r2, r1
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r1, c11.w
mul_pp r0.xyz, r0, c4
mad_pp oC0.xyz, r0, c11.x, r1
mov_pp oC0.w, c13.x
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

#LINE 62

	}
	
	FallBack "Diffuse"
}
