// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System.Collections;

public class SmallDemo : MonoBehaviour {
	private bool spinning = true;
	
	private float helpAlpha = 0.25f;
	public Sky sky = null;
	public float guiAlpha = 0.8f;	
	public Texture2D helpTex = null;
	public Texture2D watermarkTex = null;	
	
	private Color helpColor = new Color(1f,1f,1f,0f);
	private float targetExposure = 1f;
	private bool firstFrame = false;
	
	// Use this for initialization
	void Start () {
		firstFrame = true;
	}
	
	// Update is called once per frame
	void Update () {
		if(firstFrame) {
			firstFrame = false;
			if(Sky.activeSky) {
				targetExposure = Sky.activeSky.camExposure;
				Sky.activeSky.camExposure = -1f;
			}
		}
		if( Input.GetKeyDown(KeyCode.S) ) spinning = !spinning;
		if( Input.GetKeyDown(KeyCode.B) ) {
			if( sky ) {				
				sky.showSkybox = !sky.showSkybox;
				sky.Apply();
			}
		}
		
		if( Input.GetKeyDown(KeyCode.Equals) || Input.GetKeyDown(KeyCode.KeypadEquals) ) {
			targetExposure = Mathf.Min( targetExposure+0.2f, 2f );
		}
		if( Input.GetKeyDown(KeyCode.Minus) || Input.GetKeyDown(KeyCode.KeypadMinus) ) {
			targetExposure = Mathf.Max( 0.05f, targetExposure-0.2f );
		}
		if( Mathf.Abs( Sky.activeSky.camExposure - targetExposure )  > 0.01f ) {
			Sky.activeSky.camExposure = 0.85f*Sky.activeSky.camExposure + 0.15f*targetExposure;
			Sky.activeSky.Apply();
		} else {
			Sky.activeSky.camExposure = targetExposure;
		}
	}
	
	Vector3 angularVel = new Vector3(0,12f,0);
	void FixedUpdate() {
		if( spinning ) {
			Sky.activeSky.transform.Rotate(angularVel*Time.fixedDeltaTime);
		}
	}
	
	void OnGUI() {
		Rect texRect = camera.pixelRect;
		helpColor.a = guiAlpha;
		
		if( watermarkTex ) {
			texRect.width = 0.75f*watermarkTex.width;
			texRect.height = 0.75f*watermarkTex.height;
			texRect.y = camera.pixelHeight-texRect.height - 10;
			texRect.x = 10;
			GUI.color = Color.white;
			GUI.DrawTexture(texRect, watermarkTex);
		}
		
		if( helpTex ) {
			texRect.width = 0.75f*helpTex.width;
			texRect.height = 0.75f*helpTex.height;
			texRect.y = camera.pixelHeight - texRect.height;
			texRect.x = camera.pixelWidth - texRect.width;
			
			Rect hoverRect = texRect;
			hoverRect.x += 0.5f*hoverRect.width;			
			hoverRect.width *= 0.5f;
			Vector3 mouse = Input.mousePosition;
			mouse.y = camera.pixelHeight-mouse.y;
			if( hoverRect.Contains(mouse) )	helpAlpha = Mathf.Lerp(helpAlpha,2.00f,0.1f);
			else 							helpAlpha = Mathf.Lerp(helpAlpha,0.25f,0.1f);
			helpColor.a = helpAlpha * guiAlpha;
			GUI.color = helpColor;
			GUI.DrawTexture(texRect, helpTex);
		}
	}
}
