// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using mset;
[CustomEditor(typeof(Sky))]
public class SkyInspector : Editor {
	// Singleton cubemap references because Inspectors get
	// allocated like candy and this speeds up selection
	// exponentially.
	private static CubemapGUI _refSKY = null;
	private static CubemapGUI _refDIM = null;
	private static CubemapGUI _refSIM = null;
	private static CubemapGUI refSKY {
		get {
			if(_refSKY == null ) _refSKY = new CubemapGUI(CubemapGUI.Type.SKY,true);
			return _refSKY;
		}
	}
	private static CubemapGUI refDIM {
		get {
			if(_refDIM == null ) _refDIM = new CubemapGUI(CubemapGUI.Type.DIM,true);
			return _refDIM;
		}
	}
	private static CubemapGUI refSIM {
		get {
			if(_refSIM == null ) _refSIM = new CubemapGUI(CubemapGUI.Type.SIM,true);
			return _refSIM;
		}
	}
	
	private float camExposure = 1f;
	private float masterIntensity = 1f;
	private float skyIntensity = 1f;
	private float diffIntensity = 1f;
	private float specIntensity = 1f;
	
	private bool forceDirty = false;
	
	public void OnEnable() {
		Sky sky = target as Sky;
		
		camExposure = sky.camExposure;
		masterIntensity = sky.masterIntensity;
		skyIntensity =  sky.skyIntensity;
		diffIntensity = sky.diffIntensity;
		specIntensity = sky.specIntensity;
		
		refSKY.HDR = sky.hdrSky;
		refSIM.HDR = sky.hdrSpec;
		refDIM.HDR = sky.hdrDiff;
		
		forceDirty = true;
	}
	
	public void OnDisable() {
	}
	
	public void OnDestroy() {
		System.GC.Collect();
	}
	
	private bool updateCube(ref Cubemap skyCube, ref bool skyHDR, CubemapGUI cubeGUI) {
		bool dirty = false;
		bool dirtyGUI = false;
		
		//sky -> cubeGUI
		dirtyGUI |= cubeGUI.HDR != skyHDR;
		cubeGUI.HDR = skyHDR;
		
		if(cubeGUI.cube != skyCube) {
			if(skyCube) {
				string path = AssetDatabase.GetAssetPath(skyCube);
				cubeGUI.setReference(path, cubeGUI.mipmapped);
			} else {
				cubeGUI.clear();
			}
			//dirty = true;
		}
		if( dirtyGUI ) {
			cubeGUI.updatePreview();
		}
		
		
		//cubeGUI -> sky
		bool prevHDR = cubeGUI.HDR;
		Cubemap prevCube = cubeGUI.cube;
		cubeGUI.drawGUI();
		
		skyCube = cubeGUI.cube;
		skyHDR = cubeGUI.HDR;
		
		//return true if the cubeGUI gui changed any parameters
		dirty |= prevHDR != cubeGUI.HDR;
		dirty |= prevCube != cubeGUI.cube;	
		return dirty;
	}
	
	public override void OnInspectorGUI() {
		bool dirty = false;
		Sky sky = target as Sky;
		
		//sync GUI from sky
		camExposure = sky.camExposure;
		masterIntensity = sky.masterIntensity;
		skyIntensity = sky.skyIntensity;
		diffIntensity = sky.diffIntensity;
		specIntensity = sky.specIntensity;
				
		//sync and sync from CubeGUIs
		dirty |= updateCube(ref sky.skyboxCube, ref sky.hdrSky, refSKY);
		dirty |= updateCube(ref sky.diffuseCube, ref sky.hdrDiff, refDIM);
		dirty |= updateCube(ref sky.specularCube, ref sky.hdrSpec, refSIM);
		
		bool showSkybox = EditorGUILayout.Toggle(new GUIContent("Show Skybox","Toggles rendering the background image"), sky.showSkybox);
		if( showSkybox != sky.showSkybox ){
			Undo.RegisterUndo(sky,"Skybox Toggle");
			sky.showSkybox = showSkybox;			
			// if we're toggling skyboxes off, clear the render settings material
			if( !sky.showSkybox ) RenderSettings.skybox = null;
			dirty = true;
		}
		
		bool detect = EditorGUILayout.Toggle(new GUIContent("Auto-Detect Color Space","If enabled, attempts to detect the project's gamma correction setting and enables/disables the Linear Space option accordingly"), sky.autoDetectColorSpace);
		if( detect != sky.autoDetectColorSpace ) {
			Undo.RegisterUndo(sky,"Color-Space Detection Change");
			sky.autoDetectColorSpace = detect;
		}
		
		bool prevLinear = sky.linearSpace;
		if( sky.autoDetectColorSpace ) {
			sky.linearSpace = PlayerSettings.colorSpace == ColorSpace.Linear;
		}
		EditorGUI.BeginDisabledGroup(sky.autoDetectColorSpace);
			bool userLinearSpace = EditorGUILayout.Toggle(new GUIContent("Linear Space","Enable if gamma correction is enabled for this project (Edit -> Project Settings -> Player -> Color Space: Linear)"), sky.linearSpace);
			if( userLinearSpace != sky.linearSpace ) {
				Undo.RegisterUndo(sky, "Color-Space Change");
				sky.linearSpace = userLinearSpace;
			}
		EditorGUI.EndDisabledGroup();
		if( prevLinear != sky.linearSpace ){
			dirty = true;
		}
		
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		
		//sync sky from GUI
		EditorGUILayout.LabelField(new GUIContent("Master Intensity","Multiplier on the Sky, Diffuse, and Specular cube intensities"));
		masterIntensity = EditorGUILayout.Slider(masterIntensity, 0f, 10f);
		if(sky.masterIntensity != masterIntensity) {
			Undo.RegisterUndo(sky,"Intensity Change");
			sky.masterIntensity = masterIntensity;
			dirty = true;
		}
		
		EditorGUILayout.LabelField(new GUIContent("Skybox Intensity", "Brightness of the skybox"));
		skyIntensity = EditorGUILayout.Slider(skyIntensity, 0f, 10f);
		if(sky.skyIntensity != skyIntensity) {
			Undo.RegisterUndo(sky,"Intensity Change");
			sky.skyIntensity = skyIntensity;
			dirty = true;
		}
		
		EditorGUILayout.LabelField(new GUIContent("Diffuse Intensity", "Multiplier on the diffuse light put out by this sky"));
		diffIntensity = EditorGUILayout.Slider(diffIntensity, 0f, 10f);
		if(sky.diffIntensity != diffIntensity) {
			Undo.RegisterUndo(sky,"Intensity Change");
			sky.diffIntensity = diffIntensity;
			dirty = true;
		}
		
		EditorGUILayout.LabelField(new GUIContent("Specular Intensity", "Multiplier on the specular light put out by this sky"));
		specIntensity = EditorGUILayout.Slider(specIntensity, 0f, 10f);
		if(sky.specIntensity != specIntensity) {
			Undo.RegisterUndo(sky,"Intensity Change");
			sky.specIntensity = specIntensity;
			dirty = true;
		}
		
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		
		EditorGUILayout.LabelField(new GUIContent("Camera Exposure","Multiplier on all light coming into the camera, including IBL, direct light, and glow maps"));
		camExposure = EditorGUILayout.Slider(camExposure, 0f, 10f);
		if(sky.camExposure != camExposure) {
			Undo.RegisterUndo(sky,"Exposure Change");
			sky.camExposure = camExposure;
			dirty = true;
		}
		
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		
		dirty |= GUI.changed;
		
		if( forceDirty ) {
			forceDirty = false;
			dirty = true;
		}
				
		//guess input path
		if( dirty ) {
			string inPath = refSKY.fullPath;
			if( inPath.Length == 0 ) inPath = refDIM.fullPath;
			if( inPath.Length == 0 ) inPath = refSIM.fullPath;
			if( inPath.Length > 0 ) {
				int uscore = inPath.LastIndexOf("_");
				if( uscore > -1 ) {
					inPath = inPath.Substring(0,uscore);
				} else {
					inPath = Path.GetDirectoryName(inPath) + "/" + Path.GetFileNameWithoutExtension(inPath);
				}
				refSKY.inputPath = 
				refDIM.inputPath = 
				refSIM.inputPath = inPath;
			} else {
				refSKY.inputPath = 
				refDIM.inputPath = 
				refSIM.inputPath = "";
			}
		}
		
		//if the active sky is not whats selected, see whats up with that and try rebinding (catches re-activating disabled skies)
		if( Sky.activeSky != sky ) dirty = true;
		
		if( !Application.isPlaying ) {
			//if any of the cubemaps have changed, refresh the viewport
			if( dirty ) {
				sky.Apply(); //SkyInspector dirty
				SceneView.RepaintAll();
			} else {
				sky.ApplySkyTransform();
			}
		}
	}
};