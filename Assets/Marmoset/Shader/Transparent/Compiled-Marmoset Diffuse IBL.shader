// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Transparent/Diffuse IBL" {
	Properties {
		_Color   ("Diffuse Color", Color) = (1,1,1,1)
		_MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
		//slots for custom lighting cubemaps
		_DiffCubeIBL ("Custom Diffuse Cube", Cube) = "black" {}
		_SpecCubeIBL ("Custom Specular Cube", Cube) = "black" {}
	}
	
	SubShader {
		Blend SrcAlpha OneMinusSrcAlpha
		Fog { Mode Off }
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
			"IgnoreProjector"="True"
		}
		LOD 200
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
//   d3d9 - ALU: 6 to 66
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_2;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_3);
  x1.y = dot (unity_SHAg, tmpvar_3);
  x1.z = dot (unity_SHAb, tmpvar_3);
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2.xyzz * tmpvar_2.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_4);
  x2.y = dot (unity_SHBg, tmpvar_4);
  x2.z = dot (unity_SHBb, tmpvar_4);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_2.x * tmpvar_2.x) - (tmpvar_2.y * tmpvar_2.y))));
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
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
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize (_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = (c.xyz + (((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x));
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
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [_MainTex_ST]
"vs_3_0
; 31 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c18, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c8.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c18.x
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov o2.x, r0
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
mul r1.xyz, r0.y, c16
add r2.xyz, r2, r3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o3.xyz, r2, r1
mov o2.z, r2.w
mov o2.y, r3.w
add o4.xyz, -r0, c9
mad o1.xy, v2, c17, c17.zwzw
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

varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_5;
  tmpvar_5 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_6;
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

varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = (diff_i0.w * tmpvar_7);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (c.xyz + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_8)) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_LightmapST;

uniform vec4 _MainTex_ST;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (tmpvar_1);
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
  vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_3.x) + ((v_i0_i1.xyz * tmpvar_3.y) + (v_i0_i1_i2.xyz * tmpvar_3.z))));
  float tmpvar_5;
  tmpvar_5 = (tmpvar_4.w * tmpvar_4.w);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5;
  tmpvar_6.y = (tmpvar_4.w * tmpvar_5);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  c.xyz = (diff.xyz * ((8.0 * tmpvar_7.w) * tmpvar_7.xyz));
  c.w = diff.w;
  c.xyz = (c.xyz + (((tmpvar_4.xyz * dot (vec2(0.7532, 0.2468), tmpvar_6)) * diff.xyz) * _ExposureIBL.x));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_3_0
; 6 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.xy, v2, c9, c9.zwzw
mad o2.xy, v3, c8, c8.zwzw
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

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5);
  c.xyz = tmpvar_6;
  c.w = diff.w;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_7;
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

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = (diff_i0.w * tmpvar_7);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((8.0 * tmpvar_9.w) * tmpvar_9.xyz);
  mediump vec3 tmpvar_11;
  tmpvar_11 = (diff.xyz * tmpvar_10);
  c.xyz = tmpvar_11;
  c.w = diff.w;
  mediump vec3 tmpvar_12;
  tmpvar_12 = (c.xyz + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_8)) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_12;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
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
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_3;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_4);
  x1.y = dot (unity_SHAg, tmpvar_4);
  x1.z = dot (unity_SHAb, tmpvar_4);
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3.xyzz * tmpvar_3.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_5);
  x2.y = dot (unity_SHBg, tmpvar_5);
  x2.z = dot (unity_SHBb, tmpvar_5);
  vec4 o_i0;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_3.x * tmpvar_3.x) - (tmpvar_3.y * tmpvar_3.y))));
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
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
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = (c.xyz + (((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x));
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
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_SHAr]
Vector 13 [unity_SHAg]
Vector 14 [unity_SHAb]
Vector 15 [unity_SHBr]
Vector 16 [unity_SHBg]
Vector 17 [unity_SHBb]
Vector 18 [unity_SHC]
Vector 19 [_MainTex_ST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c20, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c10.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c20.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c14
dp4 r2.y, r1.wxyz, c13
dp4 r2.x, r1.wxyz, c12
dp4 r1.z, r0, c17
dp4 r1.y, r0, c16
dp4 r1.x, r0, c15
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c18
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c20.y
mov o0, r0
mul r1.y, r1, c8.x
mov o5.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o3.xyz, r3, r2
mad o5.xy, r1.z, c9.zwzw, r1
mov o2.z, r2.w
mov o2.y, r3.w
mov o2.x, r1.w
add o4.xyz, -r0, c11
mad o1.xy, v2, c19, c19.zwzw
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump float atten_i0;
  atten_i0 = tmpvar_5;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_1, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = (diff_i0.w * tmpvar_7);
  lowp float tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump float atten_i0;
  atten_i0 = tmpvar_9;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = (c.xyz + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_8)) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_11;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_LightmapST;

uniform vec4 _ProjectionParams;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_i0;
  vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (tmpvar_1);
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
  vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_3.x) + ((v_i0_i1.xyz * tmpvar_3.y) + (v_i0_i1_i2.xyz * tmpvar_3.z))));
  float tmpvar_5;
  tmpvar_5 = (tmpvar_4.w * tmpvar_4.w);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5;
  tmpvar_6.y = (tmpvar_4.w * tmpvar_5);
  vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  vec3 tmpvar_9;
  tmpvar_9 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  c.xyz = (diff.xyz * max (min (tmpvar_9, ((tmpvar_7.x * 2.0) * tmpvar_8.xyz)), (tmpvar_9 * tmpvar_7.x)));
  c.w = diff.w;
  c.xyz = (c.xyz + (((tmpvar_4.xyz * dot (vec2(0.7532, 0.2468), tmpvar_6)) * diff.xyz) * _ExposureIBL.x));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_3_0
; 11 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mul r1.y, r1, c8.x
mad o3.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o3.zw, r0
mad o1.xy, v2, c11, c11.zwzw
mad o2.xy, v3, c10, c10.zwzw
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x * 2.0)));
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5);
  c.xyz = tmpvar_6;
  c.w = diff.w;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = (diff_i0.w * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  lowp vec3 tmpvar_12;
  tmpvar_12 = max (min (tmpvar_11, ((tmpvar_9.x * 2.0) * tmpvar_10.xyz)), (tmpvar_11 * tmpvar_9.x));
  mediump vec3 tmpvar_13;
  tmpvar_13 = (diff.xyz * tmpvar_12);
  c.xyz = tmpvar_13;
  c.w = diff.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c.xyz + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_8)) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_14;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_2;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_3);
  x1.y = dot (unity_SHAg, tmpvar_3);
  x1.z = dot (unity_SHAb, tmpvar_3);
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2.xyzz * tmpvar_2.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_4);
  x2.y = dot (unity_SHBg, tmpvar_4);
  x2.z = dot (unity_SHBb, tmpvar_4);
  vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_6;
  tmpvar_6 = (unity_4LightPosX0 - tmpvar_5.x);
  vec4 tmpvar_7;
  tmpvar_7 = (unity_4LightPosY0 - tmpvar_5.y);
  vec4 tmpvar_8;
  tmpvar_8 = (unity_4LightPosZ0 - tmpvar_5.z);
  vec4 tmpvar_9;
  tmpvar_9 = (((tmpvar_6 * tmpvar_6) + (tmpvar_7 * tmpvar_7)) + (tmpvar_8 * tmpvar_8));
  vec4 tmpvar_10;
  tmpvar_10 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_6 * tmpvar_2.x) + (tmpvar_7 * tmpvar_2.y)) + (tmpvar_8 * tmpvar_2.z)) * inversesqrt (tmpvar_9))) * (1.0/((1.0 + (tmpvar_9 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_2.x * tmpvar_2.x) - (tmpvar_2.y * tmpvar_2.y)))) + ((((unity_LightColor[0].xyz * tmpvar_10.x) + (unity_LightColor[1].xyz * tmpvar_10.y)) + (unity_LightColor[2].xyz * tmpvar_10.z)) + (unity_LightColor[3].xyz * tmpvar_10.w)));
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
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
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize (_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = (c.xyz + (((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x));
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
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [_MainTex_ST]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c26, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c8.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c11
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c10
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c26.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c12
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c13
add r1, r1, c26.x
mov o2.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c20
dp4 r2.y, r5, c19
dp4 r2.x, r5, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c26.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c23
dp4 r5.z, r0, c22
dp4 r5.y, r0, c21
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add o3.xyz, r0, r1
mov o2.y, r4.z
mov o2.x, r5
add o4.xyz, -r3.wxyw, c9
mad o1.xy, v2, c25, c25.zwzw
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

varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_5;
  tmpvar_5 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_6;
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

varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = (diff_i0.w * tmpvar_7);
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (c.xyz + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_8)) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
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
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_3;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_4);
  x1.y = dot (unity_SHAg, tmpvar_4);
  x1.z = dot (unity_SHAb, tmpvar_4);
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3.xyzz * tmpvar_3.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_5);
  x2.y = dot (unity_SHBg, tmpvar_5);
  x2.z = dot (unity_SHBb, tmpvar_5);
  vec3 tmpvar_6;
  tmpvar_6 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_7;
  tmpvar_7 = (unity_4LightPosX0 - tmpvar_6.x);
  vec4 tmpvar_8;
  tmpvar_8 = (unity_4LightPosY0 - tmpvar_6.y);
  vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosZ0 - tmpvar_6.z);
  vec4 tmpvar_10;
  tmpvar_10 = (((tmpvar_7 * tmpvar_7) + (tmpvar_8 * tmpvar_8)) + (tmpvar_9 * tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_7 * tmpvar_3.x) + (tmpvar_8 * tmpvar_3.y)) + (tmpvar_9 * tmpvar_3.z)) * inversesqrt (tmpvar_10))) * (1.0/((1.0 + (tmpvar_10 * unity_4LightAtten0)))));
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_3.x * tmpvar_3.x) - (tmpvar_3.y * tmpvar_3.y)))) + ((((unity_LightColor[0].xyz * tmpvar_11.x) + (unity_LightColor[1].xyz * tmpvar_11.y)) + (unity_LightColor[2].xyz * tmpvar_11.z)) + (unity_LightColor[3].xyz * tmpvar_11.w)));
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
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
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z))));
  float tmpvar_4;
  tmpvar_4 = (tmpvar_3.w * tmpvar_3.w);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = (tmpvar_3.w * tmpvar_4);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = (c.xyz + (((tmpvar_3.xyz * dot (vec2(0.7532, 0.2468), tmpvar_5)) * diff.xyz) * _ExposureIBL.x));
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
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_4LightPosX0]
Vector 13 [unity_4LightPosY0]
Vector 14 [unity_4LightPosZ0]
Vector 15 [unity_4LightAtten0]
Vector 16 [unity_LightColor0]
Vector 17 [unity_LightColor1]
Vector 18 [unity_LightColor2]
Vector 19 [unity_LightColor3]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Vector 27 [_MainTex_ST]
"vs_3_0
; 66 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c28, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c10.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c13
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c12
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c28.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c14
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c15
add r1, r1, c28.x
mov o2.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c22
dp4 r2.y, r5, c21
dp4 r2.x, r5, c20
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c28.y
mul r0, r0, r1
mul r1.xyz, r0.y, c17
mad r1.xyz, r0.x, c16, r1
mad r0.xyz, r0.z, c18, r1
mad r1.xyz, r0.w, c19, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c25
dp4 r5.z, r0, c24
dp4 r5.y, r0, c23
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c26
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c28.z
add o3.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mov r3.x, r4.w
mov r3.y, r4
mad o5.xy, r2.z, c9.zwzw, r1
mov o0, r0
mov o5.zw, r0
mov o2.y, r4.z
mov o2.x, r5
add o4.xyz, -r3.wxyw, c11
mad o1.xy, v2, c27, c27.zwzw
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosX0 - tmpvar_17.x);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosY0 - tmpvar_17.y);
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_4LightPosZ0 - tmpvar_17.z);
  highp vec4 tmpvar_21;
  tmpvar_21 = (((tmpvar_18 * tmpvar_18) + (tmpvar_19 * tmpvar_19)) + (tmpvar_20 * tmpvar_20));
  highp vec4 tmpvar_22;
  tmpvar_22 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_18 * tmpvar_5.x) + (tmpvar_19 * tmpvar_5.y)) + (tmpvar_20 * tmpvar_5.z)) * inversesqrt (tmpvar_21))) * (1.0/((1.0 + (tmpvar_21 * unity_4LightAtten0)))));
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_22.x) + (unity_LightColor[1].xyz * tmpvar_22.y)) + (unity_LightColor[2].xyz * tmpvar_22.z)) + (unity_LightColor[3].xyz * tmpvar_22.w)));
  tmpvar_2 = tmpvar_23;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump float atten_i0;
  atten_i0 = tmpvar_5;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_1, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosX0 - tmpvar_17.x);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosY0 - tmpvar_17.y);
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_4LightPosZ0 - tmpvar_17.z);
  highp vec4 tmpvar_21;
  tmpvar_21 = (((tmpvar_18 * tmpvar_18) + (tmpvar_19 * tmpvar_19)) + (tmpvar_20 * tmpvar_20));
  highp vec4 tmpvar_22;
  tmpvar_22 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_18 * tmpvar_5.x) + (tmpvar_19 * tmpvar_5.y)) + (tmpvar_20 * tmpvar_5.z)) * inversesqrt (tmpvar_21))) * (1.0/((1.0 + (tmpvar_21 * unity_4LightAtten0)))));
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_22.x) + (unity_LightColor[1].xyz * tmpvar_22.y)) + (unity_LightColor[2].xyz * tmpvar_22.z)) + (unity_LightColor[3].xyz * tmpvar_22.w)));
  tmpvar_2 = tmpvar_23;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = (diff_i0.w * diff_i0.w);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = (diff_i0.w * tmpvar_7);
  lowp float tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump float atten_i0;
  atten_i0 = tmpvar_9;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = (c.xyz + (((diff_i0.xyz * dot (vec2(0.7532, 0.2468), tmpvar_8)) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_11;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_2;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_3);
  x1.y = dot (unity_SHAg, tmpvar_3);
  x1.z = dot (unity_SHAb, tmpvar_3);
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2.xyzz * tmpvar_2.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_4);
  x2.y = dot (unity_SHBg, tmpvar_4);
  x2.z = dot (unity_SHBb, tmpvar_4);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_2.x * tmpvar_2.x) - (tmpvar_2.y * tmpvar_2.y))));
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
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
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z))));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize (_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = (c.xyz + (((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x));
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
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [_MainTex_ST]
"vs_3_0
; 31 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c18, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c8.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c18.x
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov o2.x, r0
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
mul r1.xyz, r0.y, c16
add r2.xyz, r2, r3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o3.xyz, r2, r1
mov o2.z, r2.w
mov o2.y, r3.w
add o4.xyz, -r0, c9
mad o1.xy, v2, c17, c17.zwzw
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

varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_5;
  tmpvar_5 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_6;
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

varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_8;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_LightmapST;

uniform vec4 _MainTex_ST;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (tmpvar_1);
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
  vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_3.x) + ((v_i0_i1.xyz * tmpvar_3.y) + (v_i0_i1_i2.xyz * tmpvar_3.z))));
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  c.xyz = (diff.xyz * ((8.0 * tmpvar_5.w) * tmpvar_5.xyz));
  c.w = diff.w;
  c.xyz = (c.xyz + (((tmpvar_4.xyz * tmpvar_4.w) * diff.xyz) * _ExposureIBL.x));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_3_0
; 6 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.xy, v2, c9, c9.zwzw
mad o2.xy, v3, c8, c8.zwzw
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

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5);
  c.xyz = tmpvar_6;
  c.w = diff.w;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_7;
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

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((8.0 * tmpvar_7.w) * tmpvar_7.xyz);
  mediump vec3 tmpvar_9;
  tmpvar_9 = (diff.xyz * tmpvar_8);
  c.xyz = tmpvar_9;
  c.w = diff.w;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
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
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_3;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_4);
  x1.y = dot (unity_SHAg, tmpvar_4);
  x1.z = dot (unity_SHAb, tmpvar_4);
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3.xyzz * tmpvar_3.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_5);
  x2.y = dot (unity_SHBg, tmpvar_5);
  x2.z = dot (unity_SHBb, tmpvar_5);
  vec4 o_i0;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_6;
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_3.x * tmpvar_3.x) - (tmpvar_3.y * tmpvar_3.y))));
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
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
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z))));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = (c.xyz + (((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x));
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
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_SHAr]
Vector 13 [unity_SHAg]
Vector 14 [unity_SHAb]
Vector 15 [unity_SHBr]
Vector 16 [unity_SHBg]
Vector 17 [unity_SHBb]
Vector 18 [unity_SHC]
Vector 19 [_MainTex_ST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c20, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c10.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c20.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c14
dp4 r2.y, r1.wxyz, c13
dp4 r2.x, r1.wxyz, c12
dp4 r1.z, r0, c17
dp4 r1.y, r0, c16
dp4 r1.x, r0, c15
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c18
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c20.y
mov o0, r0
mul r1.y, r1, c8.x
mov o5.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o3.xyz, r3, r2
mad o5.xy, r1.z, c9.zwzw, r1
mov o2.z, r2.w
mov o2.y, r3.w
mov o2.x, r1.w
add o4.xyz, -r0, c11
mad o1.xy, v2, c19, c19.zwzw
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump float atten_i0;
  atten_i0 = tmpvar_5;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_1, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump float atten_i0;
  atten_i0 = tmpvar_7;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_9;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 unity_LightmapST;

uniform vec4 _ProjectionParams;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_i0;
  vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec3 tmpvar_1;
  vec4 diff;
  vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_2;
  diff.xyz = (tmpvar_2.xyz * _ExposureIBL.w);
  vec3 tmpvar_3;
  tmpvar_3 = normalize (tmpvar_1);
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
  vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_3.x) + ((v_i0_i1.xyz * tmpvar_3.y) + (v_i0_i1_i2.xyz * tmpvar_3.z))));
  vec4 tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  vec3 tmpvar_7;
  tmpvar_7 = ((8.0 * tmpvar_6.w) * tmpvar_6.xyz);
  c.xyz = (diff.xyz * max (min (tmpvar_7, ((tmpvar_5.x * 2.0) * tmpvar_6.xyz)), (tmpvar_7 * tmpvar_5.x)));
  c.w = diff.w;
  c.xyz = (c.xyz + (((tmpvar_4.xyz * tmpvar_4.w) * diff.xyz) * _ExposureIBL.x));
  gl_FragData[0] = c;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_3_0
; 11 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mul r1.y, r1, c8.x
mad o3.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o3.zw, r0
mad o1.xy, v2, c11, c11.zwzw
mad o2.xy, v3, c10, c10.zwzw
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec3 tmpvar_5;
  tmpvar_5 = min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x * 2.0)));
  mediump vec3 tmpvar_6;
  tmpvar_6 = (diff.xyz * tmpvar_5);
  c.xyz = tmpvar_6;
  c.w = diff.w;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  lowp vec3 tmpvar_10;
  tmpvar_10 = max (min (tmpvar_9, ((tmpvar_7.x * 2.0) * tmpvar_8.xyz)), (tmpvar_9 * tmpvar_7.x));
  mediump vec3 tmpvar_11;
  tmpvar_11 = (diff.xyz * tmpvar_10);
  c.xyz = tmpvar_11;
  c.w = diff.w;
  mediump vec3 tmpvar_12;
  tmpvar_12 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_12;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = _Object2World[0].xyz;
  tmpvar_1[1] = _Object2World[1].xyz;
  tmpvar_1[2] = _Object2World[2].xyz;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_2;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_3);
  x1.y = dot (unity_SHAg, tmpvar_3);
  x1.z = dot (unity_SHAb, tmpvar_3);
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2.xyzz * tmpvar_2.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_4);
  x2.y = dot (unity_SHBg, tmpvar_4);
  x2.z = dot (unity_SHBb, tmpvar_4);
  vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_6;
  tmpvar_6 = (unity_4LightPosX0 - tmpvar_5.x);
  vec4 tmpvar_7;
  tmpvar_7 = (unity_4LightPosY0 - tmpvar_5.y);
  vec4 tmpvar_8;
  tmpvar_8 = (unity_4LightPosZ0 - tmpvar_5.z);
  vec4 tmpvar_9;
  tmpvar_9 = (((tmpvar_6 * tmpvar_6) + (tmpvar_7 * tmpvar_7)) + (tmpvar_8 * tmpvar_8));
  vec4 tmpvar_10;
  tmpvar_10 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_6 * tmpvar_2.x) + (tmpvar_7 * tmpvar_2.y)) + (tmpvar_8 * tmpvar_2.z)) * inversesqrt (tmpvar_9))) * (1.0/((1.0 + (tmpvar_9 * unity_4LightAtten0)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_2.x * tmpvar_2.x) - (tmpvar_2.y * tmpvar_2.y)))) + ((((unity_LightColor[0].xyz * tmpvar_10.x) + (unity_LightColor[1].xyz * tmpvar_10.y)) + (unity_LightColor[2].xyz * tmpvar_10.z)) + (unity_LightColor[3].xyz * tmpvar_10.w)));
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
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
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z))));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize (_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = (c.xyz + (((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x));
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
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [_MainTex_ST]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c26, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c8.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c11
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c10
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c26.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c12
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c13
add r1, r1, c26.x
mov o2.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c20
dp4 r2.y, r5, c19
dp4 r2.x, r5, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c26.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c23
dp4 r5.z, r0, c22
dp4 r5.y, r0, c21
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add o3.xyz, r0, r1
mov o2.y, r4.z
mov o2.x, r5
add o4.xyz, -r3.wxyw, c9
mad o1.xy, v2, c25, c25.zwzw
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

varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_5;
  tmpvar_5 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_6;
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

varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (tmpvar_1, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_8;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "MARMO_GAMMA" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
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
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (gl_Normal * unity_Scale.w));
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_3;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_4);
  x1.y = dot (unity_SHAg, tmpvar_4);
  x1.z = dot (unity_SHAb, tmpvar_4);
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3.xyzz * tmpvar_3.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_5);
  x2.y = dot (unity_SHBg, tmpvar_5);
  x2.z = dot (unity_SHBb, tmpvar_5);
  vec3 tmpvar_6;
  tmpvar_6 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_7;
  tmpvar_7 = (unity_4LightPosX0 - tmpvar_6.x);
  vec4 tmpvar_8;
  tmpvar_8 = (unity_4LightPosY0 - tmpvar_6.y);
  vec4 tmpvar_9;
  tmpvar_9 = (unity_4LightPosZ0 - tmpvar_6.z);
  vec4 tmpvar_10;
  tmpvar_10 = (((tmpvar_7 * tmpvar_7) + (tmpvar_8 * tmpvar_8)) + (tmpvar_9 * tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_7 * tmpvar_3.x) + (tmpvar_8 * tmpvar_3.y)) + (tmpvar_9 * tmpvar_3.z)) * inversesqrt (tmpvar_10))) * (1.0/((1.0 + (tmpvar_10 * unity_4LightAtten0)))));
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_3.x * tmpvar_3.x) - (tmpvar_3.y * tmpvar_3.y)))) + ((((unity_LightColor[0].xyz * tmpvar_11.x) + (unity_LightColor[1].xyz * tmpvar_11.y)) + (unity_LightColor[2].xyz * tmpvar_11.z)) + (unity_LightColor[3].xyz * tmpvar_11.w)));
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
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
  tmpvar_3 = textureCube (_DiffCubeIBL, ((v_i0.xyz * tmpvar_2.x) + ((v_i0_i1.xyz * tmpvar_2.y) + (v_i0_i1_i2.xyz * tmpvar_2.z))));
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (_WorldSpaceLightPos0.xyz)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  c.xyz = (frag.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = (c.xyz + (((tmpvar_3.xyz * tmpvar_3.w) * diff.xyz) * _ExposureIBL.x));
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
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_4LightPosX0]
Vector 13 [unity_4LightPosY0]
Vector 14 [unity_4LightPosZ0]
Vector 15 [unity_4LightAtten0]
Vector 16 [unity_LightColor0]
Vector 17 [unity_LightColor1]
Vector 18 [unity_LightColor2]
Vector 19 [unity_LightColor3]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Vector 27 [_MainTex_ST]
"vs_3_0
; 66 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c28, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c10.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c13
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c12
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c28.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c14
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c15
add r1, r1, c28.x
mov o2.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c22
dp4 r2.y, r5, c21
dp4 r2.x, r5, c20
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c28.y
mul r0, r0, r1
mul r1.xyz, r0.y, c17
mad r1.xyz, r0.x, c16, r1
mad r0.xyz, r0.z, c18, r1
mad r1.xyz, r0.w, c19, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c25
dp4 r5.z, r0, c24
dp4 r5.y, r0, c23
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c26
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c28.z
add o3.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mov r3.x, r4.w
mov r3.y, r4
mad o5.xy, r2.z, c9.zwzw, r1
mov o0, r0
mov o5.zw, r0
mov o2.y, r4.z
mov o2.x, r5
add o4.xyz, -r3.wxyw, c11
mad o1.xy, v2, c27, c27.zwzw
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosX0 - tmpvar_17.x);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosY0 - tmpvar_17.y);
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_4LightPosZ0 - tmpvar_17.z);
  highp vec4 tmpvar_21;
  tmpvar_21 = (((tmpvar_18 * tmpvar_18) + (tmpvar_19 * tmpvar_19)) + (tmpvar_20 * tmpvar_20));
  highp vec4 tmpvar_22;
  tmpvar_22 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_18 * tmpvar_5.x) + (tmpvar_19 * tmpvar_5.y)) + (tmpvar_20 * tmpvar_5.z)) * inversesqrt (tmpvar_21))) * (1.0/((1.0 + (tmpvar_21 * unity_4LightAtten0)))));
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_22.x) + (unity_LightColor[1].xyz * tmpvar_22.y)) + (unity_LightColor[2].xyz * tmpvar_22.z)) + (unity_LightColor[3].xyz * tmpvar_22.w)));
  tmpvar_2 = tmpvar_23;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_DiffCubeIBL, N);
  diff_i0 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump float atten_i0;
  atten_i0 = tmpvar_5;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_1, lightDir), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
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

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosX0 - tmpvar_17.x);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosY0 - tmpvar_17.y);
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_4LightPosZ0 - tmpvar_17.z);
  highp vec4 tmpvar_21;
  tmpvar_21 = (((tmpvar_18 * tmpvar_18) + (tmpvar_19 * tmpvar_19)) + (tmpvar_20 * tmpvar_20));
  highp vec4 tmpvar_22;
  tmpvar_22 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_18 * tmpvar_5.x) + (tmpvar_19 * tmpvar_5.y)) + (tmpvar_20 * tmpvar_5.z)) * inversesqrt (tmpvar_21))) * (1.0/((1.0 + (tmpvar_21 * unity_4LightAtten0)))));
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_22.x) + (unity_LightColor[1].xyz * tmpvar_22.y)) + (unity_LightColor[2].xyz * tmpvar_22.z)) + (unity_LightColor[3].xyz * tmpvar_22.w)));
  tmpvar_2 = tmpvar_23;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
  highp vec3 tmpvar_5;
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
  tmpvar_5 = ((v_i0.xyz * tmpvar_4.x) + ((v_i0_i1.xyz * tmpvar_4.y) + (v_i0_i1_i2.xyz * tmpvar_4.z)));
  N = tmpvar_5;
  mediump vec4 diff_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = textureCube (_DiffCubeIBL, tmpvar_5);
  diff_i0 = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  mediump vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  mediump float atten_i0;
  atten_i0 = tmpvar_7;
  mediump vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((atten_i0 * 2.0) * clamp (dot (tmpvar_1, normalize (lightDir)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
  frag.w = diff.w;
  c = frag;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (c.xyz + (diff.xyz * xlv_TEXCOORD2));
  c.xyz = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (c.xyz + (((diff_i0.xyz * diff_i0.w) * diff.xyz) * _ExposureIBL.x));
  c.xyz = tmpvar_9;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   d3d9 - ALU: 15 to 25, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "MARMO_LINEAR" "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 7 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DiffCubeIBL] CUBE
"ps_3_0
; 24 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c8, 0.75341797, 0.24682617, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c8
add_pp r0.w, r1.x, r1.y
mul_pp r1.xyz, r0, r0.w
dp3_pp r1.w, c4, c4
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, c4
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c6.w
dp3_pp_sat r1.w, v1, r2
mul_pp r2.xyz, r0, r1.w
mul_pp r3.xyz, r0, v2
mul_pp r2.xyz, r2, c5
mad_pp r2.xyz, r2, c8.z, r3
mul_pp r0.xyz, r1, r0
mad_pp oC0.xyz, r0, c6.x, r2
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DiffCubeIBL] CUBE
SetTexture 2 [unity_Lightmap] 2D
"ps_3_0
; 19 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c6, 0.75341797, 0.24682617, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r1, r0, s1
mul_pp r0.x, r1.w, r1.w
mul_pp r0.y, r1.w, r0.x
mul_pp r0.xy, r0, c6
add_pp r1.w, r0.x, r0.y
texld r0, v0, s0
mul_pp r2.xyz, r1, r1.w
mul_pp r1, r0, c5
mul_pp r1.xyz, r1, c4.w
texld r0, v1, s2
mul_pp r2.xyz, r1, r2
mul_pp r0.xyz, r0.w, r0
mul_pp r2.xyz, r2, c4.x
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c6.z, r2
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
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 7 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DiffCubeIBL] CUBE
SetTexture 2 [_ShadowMapTexture] 2D
"ps_3_0
; 25 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c8, 0.75341797, 0.24682617, 2.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r1.xy, r1, c8
add_pp r0.w, r1.x, r1.y
mul_pp r1.xyz, r0, r0.w
dp3_pp r1.w, c4, c4
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, c4
dp3_pp_sat r1.w, v1, r2
texldp r2.x, v4, s2
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c6.w
mul_pp r1.w, r2.x, r1
mul_pp r2.xyz, r0, r1.w
mul_pp r3.xyz, r0, v2
mul_pp r2.xyz, r2, c5
mad_pp r2.xyz, r2, c8.z, r3
mul_pp r0.xyz, r1, r0
mad_pp oC0.xyz, r0, c6.x, r2
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DiffCubeIBL] CUBE
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
"ps_3_0
; 24 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c6, 0.75341797, 0.24682617, 8.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
dcl_texcoord2 v2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.x, r0.w, r0.w
mul_pp r1.y, r0.w, r1.x
mul_pp r2.xy, r1, c6
add_pp r0.w, r2.x, r2.y
texld r1, v0, s0
mul_pp r1, r1, c5
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c4.w
mul_pp r0.xyz, r1, r0
mul_pp r2.xyz, r0, c4.x
texld r0, v1, s3
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v2, s2
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c6.z
mul_pp r0.xyz, r0, c6.w
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
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 7 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DiffCubeIBL] CUBE
"ps_3_0
; 20 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c8, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.xyz, r0, r0.w
dp3_pp r1.w, c4, c4
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, c4
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c6.w
dp3_pp_sat r1.w, v1, r2
mul_pp r2.xyz, r0, r1.w
mul_pp r3.xyz, r0, v2
mul_pp r2.xyz, r2, c5
mad_pp r2.xyz, r2, c8.x, r3
mul_pp r0.xyz, r1, r0
mad_pp oC0.xyz, r0, c6.x, r2
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DiffCubeIBL] CUBE
SetTexture 2 [unity_Lightmap] 2D
"ps_3_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c6, 8.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r1, r0, s1
texld r0, v0, s0
mul_pp r2.xyz, r1, r1.w
mul_pp r1, r0, c5
mul_pp r1.xyz, r1, c4.w
texld r0, v1, s2
mul_pp r2.xyz, r1, r2
mul_pp r0.xyz, r0.w, r0
mul_pp r2.xyz, r2, c4.x
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c6.x, r2
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
Vector 4 [_WorldSpaceLightPos0]
Vector 5 [_LightColor0]
Vector 6 [_ExposureIBL]
Matrix 0 [_SkyMatrix]
Vector 7 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DiffCubeIBL] CUBE
SetTexture 2 [_ShadowMapTexture] 2D
"ps_3_0
; 21 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c8, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
mul_pp r1.xyz, r0, r0.w
dp3_pp r1.w, c4, c4
rsq_pp r1.w, r1.w
mul_pp r2.xyz, r1.w, c4
dp3_pp_sat r1.w, v1, r2
texldp r2.x, v4, s2
texld r0, v0, s0
mul_pp r0, r0, c7
mul_pp r0.xyz, r0, c6.w
mul_pp r1.w, r2.x, r1
mul_pp r2.xyz, r0, r1.w
mul_pp r3.xyz, r0, v2
mul_pp r2.xyz, r2, c5
mad_pp r2.xyz, r2, c8.x, r3
mul_pp r0.xyz, r1, r0
mad_pp oC0.xyz, r0, c6.x, r2
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DiffCubeIBL] CUBE
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
"ps_3_0
; 20 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c6, 8.00000000, 2.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
dcl_texcoord2 v2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul r1.xyz, r0.z, c2
mad r1.xyz, r0.y, c1, r1
mad r0.xyz, r0.x, c0, r1
texld r0, r0, s1
texld r1, v0, s0
mul_pp r1, r1, c5
mul_pp r0.xyz, r0, r0.w
mul_pp r1.xyz, r1, c4.w
mul_pp r0.xyz, r1, r0
mul_pp r2.xyz, r0, c4.x
texld r0, v1, s3
mul_pp r3.xyz, r0.w, r0
texldp r4.x, v2, s2
mul_pp r0.xyz, r0, r4.x
mul_pp r3.xyz, r3, c6.x
mul_pp r0.xyz, r0, c6.y
mul_pp r4.xyz, r3, r4.x
min_pp r0.xyz, r3, r0
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r1, r0, r2
mov_pp oC0.w, r1
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (normalize (xlv_TEXCOORD2))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c14
add o4.xyz, -r0, c13
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_LightTexture0, tmpvar_5);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_6.w;
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, tmpvar_6);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_7.w;
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize (xlv_TEXCOORD2)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
mul r0.xyz, v1, c8.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o3.xyz, c10
add o4.xyz, -r0, c9
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lightDir = xlv_TEXCOORD2;
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

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  lightDir = xlv_TEXCOORD2;
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w) * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (normalize (xlv_TEXCOORD2))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c14
add o4.xyz, -r0, c13
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_6;
  tmpvar_6 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTextureB0, tmpvar_6);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_5.w) * tmpvar_7.w);
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

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_7;
  tmpvar_7 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_LightTextureB0, tmpvar_7);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_6.w) * tmpvar_8.w);
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((((texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w) * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (normalize (xlv_TEXCOORD2))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c14
add o4.xyz, -r0, c13
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_LightTextureB0, tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_6.w * tmpvar_7.w);
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTextureB0, tmpvar_6);
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_7.w * tmpvar_8.w);
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2D (_LightTexture0, xlv_TEXCOORD4).w * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (xlv_TEXCOORD2)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c14
add o4.xyz, -r0, c13
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lightDir = xlv_TEXCOORD2;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_4.w;
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

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  lightDir = xlv_TEXCOORD2;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_5.w;
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2D (_LightTexture0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (normalize (xlv_TEXCOORD2))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c14
add o4.xyz, -r0, c13
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_LightTexture0, tmpvar_5);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_6.w;
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTexture0, tmpvar_6);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_7.w;
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((2.0 * clamp (dot (xlv_TEXCOORD1, normalize (xlv_TEXCOORD2)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
mul r0.xyz, v1, c8.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o3.xyz, c10
add o4.xyz, -r0, c9
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lightDir = xlv_TEXCOORD2;
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

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  lightDir = xlv_TEXCOORD2;
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex));
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w) * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (normalize (xlv_TEXCOORD2))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c14
add o4.xyz, -r0, c13
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_6;
  tmpvar_6 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTextureB0, tmpvar_6);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_5.w) * tmpvar_7.w);
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

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_7;
  tmpvar_7 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_LightTextureB0, tmpvar_7);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * tmpvar_6.w) * tmpvar_8.w);
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = (_WorldSpaceLightPos0.xyz - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = (((((texture2D (_LightTextureB0, vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4))).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w) * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (normalize (xlv_TEXCOORD2))), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c14
add o4.xyz, -r0, c13
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  mediump vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_LightTextureB0, tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_6.w * tmpvar_7.w);
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

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_LightTextureB0, tmpvar_6);
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_7.w * tmpvar_8.w);
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
  xlv_TEXCOORD1 = (tmpvar_1 * (gl_Normal * unity_Scale.w));
  xlv_TEXCOORD2 = _WorldSpaceLightPos0.xyz;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * gl_Vertex).xyz);
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * gl_Vertex)).xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _ExposureIBL;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 diff;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  diff = tmpvar_1;
  diff.xyz = (tmpvar_1.xyz * _ExposureIBL.w);
  vec4 frag;
  frag = vec4(0.0, 0.0, 0.0, 1.0);
  frag.xyz = ((((texture2D (_LightTexture0, xlv_TEXCOORD4).w * 2.0) * clamp (dot (xlv_TEXCOORD1, normalize (xlv_TEXCOORD2)), 0.0, 1.0)) * diff.xyz) * _LightColor0.xyz);
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
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c14
add o4.xyz, -r0, c13
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
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  lightDir = xlv_TEXCOORD2;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_4.w;
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

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _SkyMatrix;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump vec4 _ExposureIBL;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  mediump vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD1;
  highp vec3 N;
  mediump vec4 diff;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  diff = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (diff * _Color);
  diff = tmpvar_3;
  diff.xyz = (diff.xyz * _ExposureIBL.w);
  N = tmpvar_1;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (N);
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
  lightDir = xlv_TEXCOORD2;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_LightTexture0, xlv_TEXCOORD4);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_5.w;
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
//   d3d9 - ALU: 10 to 20, TEX: 1 to 3
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
SetTexture 2 [_LightTexture0] 2D
"ps_3_0
; 15 ALU, 2 TEX
dcl_2d s0
dcl_2d s2
def c7, 2.00000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
texld r0.xyz, v0, s0
dp3_pp_sat r0.w, v1, r1
mul_pp r1.xyz, r0, c6
dp3 r0.x, v4, v4
texld r0.x, r0.x, s2
mul_pp r1.xyz, r1, c5.w
mul_pp r0.x, r0, r0.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7.y
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
"ps_3_0
; 10 ALU, 1 TEX
dcl_2d s0
def c7, 2.00000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dp3_pp r0.w, v2, v2
rsq_pp r0.w, r0.w
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
mul_pp r1.xyz, r0.w, v2
mul_pp r0.xyz, r0, c5.w
dp3_pp_sat r0.w, v1, r1
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7.y
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
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"ps_3_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
def c7, 0.50000000, 0.00000000, 1.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp_sat r0.y, v1, r0
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c7.x
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c6
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c5.w
texld r0.w, r2, s2
cmp r0.z, -v4, c7.y, c7
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s3
mul_pp r0.x, r0.z, r0
mul_pp r0.x, r0, r0.y
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.w
mov_pp oC0.w, c7.y
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
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"ps_3_0
; 16 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
dcl_cube s3
def c7, 2.00000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r0.x, r1, r1
rsq_pp r0.w, r0.x
mul_pp r1.xyz, r0.w, r1
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
dp3_pp_sat r1.w, v1, r1
mul_pp r1.xyz, r0, c5.w
dp3 r0.x, v4, v4
texld r0.w, v4, s3
texld r0.x, r0.x, s2
mul r0.x, r0, r0.w
mul_pp r0.x, r0, r1.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7.y
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
SetTexture 2 [_LightTexture0] 2D
"ps_3_0
; 11 ALU, 2 TEX
dcl_2d s0
dcl_2d s2
def c7, 2.00000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xy
dp3_pp r0.w, v2, v2
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, v2
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
mul_pp r0.xyz, r0, c5.w
dp3_pp_sat r1.x, v1, r1
texld r0.w, v4, s2
mul_pp r0.w, r0, r1.x
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7.y
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
SetTexture 1 [_LightTexture0] 2D
"ps_3_0
; 15 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c7, 2.00000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
texld r0.xyz, v0, s0
dp3_pp_sat r0.w, v1, r1
mul_pp r1.xyz, r0, c6
dp3 r0.x, v4, v4
texld r0.x, r0.x, s1
mul_pp r1.xyz, r1, c5.w
mul_pp r0.x, r0, r0.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7.y
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
"ps_3_0
; 10 ALU, 1 TEX
dcl_2d s0
def c7, 2.00000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dp3_pp r0.w, v2, v2
rsq_pp r0.w, r0.w
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
mul_pp r1.xyz, r0.w, v2
mul_pp r0.xyz, r0, c5.w
dp3_pp_sat r0.w, v1, r1
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7.y
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
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_3_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 0.50000000, 0.00000000, 1.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, v2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp_sat r0.y, v1, r0
rcp r0.x, v4.w
mad r2.xy, v4, r0.x, c7.x
texld r1.xyz, v0, s0
mul_pp r1.xyz, r1, c6
dp3 r0.x, v4, v4
mul_pp r1.xyz, r1, c5.w
texld r0.w, r2, s1
cmp r0.z, -v4, c7.y, c7
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s2
mul_pp r0.x, r0.z, r0
mul_pp r0.x, r0, r0.y
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.w
mov_pp oC0.w, c7.y
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
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_3_0
; 16 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c7, 2.00000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v2
dp3_pp r0.x, r1, r1
rsq_pp r0.w, r0.x
mul_pp r1.xyz, r0.w, r1
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
dp3_pp_sat r1.w, v1, r1
mul_pp r1.xyz, r0, c5.w
dp3 r0.x, v4, v4
texld r0.w, v4, s2
texld r0.x, r0.x, s1
mul r0.x, r0, r0.w
mul_pp r0.x, r0, r1.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7.y
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
SetTexture 1 [_LightTexture0] 2D
"ps_3_0
; 11 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c7, 2.00000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord4 v4.xy
dp3_pp r0.w, v2, v2
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, v2
texld r0.xyz, v0, s0
mul_pp r0.xyz, r0, c6
mul_pp r0.xyz, r0, c5.w
dp3_pp_sat r1.x, v1, r1
texld r0.w, v4, s1
mul_pp r0.w, r0, r1.x
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c4
mul_pp oC0.xyz, r0, c7.x
mov_pp oC0.w, c7.y
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

#LINE 57

	}
	
	FallBack "Diffuse"
}
