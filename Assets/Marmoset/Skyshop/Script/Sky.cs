// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System.Collections;

public class Sky : MonoBehaviour {
	public static Sky activeSky = null;
	
	public Cubemap diffuseCube = null;
	public Cubemap specularCube = null;
	public Cubemap skyboxCube = null;
	
	public float masterIntensity = 1f;
	public float skyIntensity = 1f;
	public float specIntensity = 1f;
	public float diffIntensity = 1f;
	public float camExposure = 1f;
	
	public bool hdrSky = false;
	public bool hdrSpec = false;
	public bool hdrDiff = false;
	
	public bool showSkybox = true;
	public bool linearSpace = true;
	public bool autoDetectColorSpace = true; //for inspector use
		
	private Matrix4x4 skyMatrix = Matrix4x4.identity;
	private Vector4 exposures = Vector4.one;
	
	//Skybox material, allocated only if requested
	private Material _skyboxMaterial = null;
	private Material skyboxMaterial {
		get {
			if( _skyboxMaterial == null ) {
				Shader shader = Shader.Find("Hidden/Marmoset/Skybox IBL");
				if( shader ) {
					_skyboxMaterial = new Material( shader );
					_skyboxMaterial.name = "Internal IBL Skybox";
				} else {
					Debug.LogError("Failed to create IBL Skybox material. Missing shader?");
				}
			}
			return _skyboxMaterial;
		}
	}
	
	//A black cubemap texture only allocated if requested
	private Cubemap _blackCube = null;
	private Cubemap blackCube {
		get {
			if( _blackCube == null ) {
				_blackCube = new Cubemap(16,TextureFormat.ARGB32,true);
				for(int f=0; f<6; ++f)
				for(int x=0; x<16; ++x)
				for(int y=0; y<16; ++y) {
					_blackCube.SetPixel((CubemapFace)f,x,y,Color.black);
				}
				_blackCube.Apply(true);
			}
			return _blackCube;
		}
	}
	
	public void toggleChildLights( bool enable ) {
		//NOTE: this causes scene changes on sky selection, may not be desireable in the editor!
		Light[] lights = this.GetComponentsInChildren<Light>();
		for(int i=0; i<lights.Length; ++i){
			lights[i].enabled = enable;
		}
	}
	
	private void UnApply() {
		toggleChildLights(false);
	}
		
	// Binds IBL data, exposure, and a skybox texture globally.
	public void Apply() {
	#if UNITY_3_5
		if( this.enabled && this.gameObject.active ) {
	#else
		if( this.enabled && this.gameObject.activeInHierarchy ) {
	#endif
			//turn off previously bound sky
			if(Sky.activeSky != null) Sky.activeSky.UnApply();
			Sky.activeSky = this;
			
			//bind cubemaps
			if(diffuseCube) Shader.SetGlobalTexture("_DiffCubeIBL", diffuseCube);
			else 			Shader.SetGlobalTexture("_DiffCubeIBL", blackCube);
			
			if(specularCube)Shader.SetGlobalTexture("_SpecCubeIBL", specularCube);
			else 			Shader.SetGlobalTexture("_SpecCubeIBL", blackCube);
			
			if(showSkybox) {
				if(skyboxCube)	Shader.SetGlobalTexture("_SkyCubeIBL", skyboxCube);
				else 			Shader.SetGlobalTexture("_SkyCubeIBL", blackCube);
			}
			
			//build exposure values for shader, HDR skies need the RGBM expansion constant 6.0 in there
			exposures.x = masterIntensity*diffIntensity;
			exposures.y = masterIntensity*specIntensity;
			exposures.z = masterIntensity*skyIntensity*camExposure; //exposure baked right into skybox exposure
			exposures.w = camExposure;
			
			//prepare exposure values for gamma correction
			float toLinear = 2.2f;
			float toSRGB = 1/toLinear;
			float hdrScale = 6f;
			if(linearSpace) {
				//HDR scale needs to be applied in linear space
				hdrScale = Mathf.Pow(6f,toLinear);
			} else {
				//Exposure values are treated as being in linear space, but the shader is working in sRGB space.
				//Move exposure into sRGB as well before applying.
				exposures.x = Mathf.Pow(exposures.x,toSRGB);
				exposures.y = Mathf.Pow(exposures.y,toSRGB);
				exposures.z = Mathf.Pow(exposures.z,toSRGB);
				exposures.w = Mathf.Pow(exposures.w,toSRGB);
			}
			//RGBM cubemaps need a scalar added to their exposure
			if( hdrDiff ) exposures.x *= hdrScale;
			if( hdrSpec ) exposures.y *= hdrScale;
			if( hdrSky )  exposures.z *= hdrScale;
			
			Shader.SetGlobalVector("_ExposureIBL",exposures);
			
			//upload the sky transform to the shader
			ApplySkyTransform();
			
			//enable any lights parented to this sky
			toggleChildLights(true);
			
			//NOTE: this causes scene changes on sky selection, may not be desireable in the editor!
			if(showSkybox) {
				RenderSettings.skybox = skyboxMaterial;
			} else {
				if(	RenderSettings.skybox &&
					RenderSettings.skybox.name == "Internal IBL Skybox") {
					RenderSettings.skybox = null;
				}
			}
			
			//toggle between linear-space (gamma-corrected) and gamma-space (uncorrected) shader permutations
			Shader.DisableKeyword("MARMO_GAMMA");
			Shader.DisableKeyword("MARMO_LINEAR");			
			if(linearSpace) Shader.EnableKeyword("MARMO_LINEAR");
			else 			Shader.EnableKeyword("MARMO_GAMMA");
			
			//this is a hint for the Beast Lightmapper, rendering is unaffected
			Shader.SetGlobalFloat("_EmissionLM",1f);
		}
	}
	
	public void ApplySkyTransform() {
	#if UNITY_3_5
		if( this.enabled && this.gameObject.active ) {
	#else
		if( this.enabled && this.gameObject.activeInHierarchy ) {
	#endif
			skyMatrix.SetTRS(Vector3.zero,transform.rotation,Vector3.one);		
			Shader.SetGlobalMatrix("_SkyMatrix", skyMatrix);
		}
	}

	public void Reset() {
		diffuseCube = specularCube = skyboxCube = null;
		masterIntensity = skyIntensity = specIntensity = diffIntensity = 1f;
		hdrSky = hdrSpec = hdrDiff = false;
		//Apply(); //Reset
	}
	
	private void Awake() {
		//Apply(); //Awake
	}

	private void Start() {
		Apply(); //Start
	}
		
	public void OnEnable() {
		//Apply(); //OnEnable
	}
	
	public void OnDisable() {
	}

	private void OnLevelWasLoaded( int level ) {
		//Apply(); //OnLevelWasLoaded
	}
	
	public void Update() {
		if( Sky.activeSky == this ) {
		#if UNITY_3_5 || UNITY_4_0 || UNITY_4_0_1
			ApplySkyTransform();
		#else
			if( transform.hasChanged ) ApplySkyTransform();
		#endif
		}
	}
	
	public void OnDestroy() {
		UnityEngine.Object.DestroyImmediate(_skyboxMaterial,false);
		_skyboxMaterial = null;
	}
	
	private void OnDrawGizmos () {
		//HACK: the most reliable place to bind shader variables in the editor
		if( Sky.activeSky == null ) Apply();
		Gizmos.DrawIcon(transform.position, "Marmoset/Gizmos/cubelight.tga", true);
	}
}
