// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System.Collections;

public class SkySwab : MonoBehaviour {	
	public Sky targetSky = null;
	Vector3 scale = new Vector3(1.0f,1.01f,1.0f);
	Vector3 bigScale = new Vector3(1.2f,1.21f,1.2f);
	Vector3 littleScale = new Vector3(0.75f,0.76f,0.75f);
	Quaternion baseRot = Quaternion.identity;
		
	// Use this for initialization
	void Start () {
		baseRot = transform.localRotation;
		scale = littleScale;
	}
	
	void OnMouseDown() {
		if(targetSky) targetSky.Apply();
	}
	
	void OnMouseOver() {
		scale = Vector3.one;
	}
	
	void OnMouseExit() {
		scale = littleScale;
	}
	
	// Update is called once per frame
	void Update () {
		if( Sky.activeSky == targetSky ) {
			transform.Rotate(0,200f*Time.deltaTime,0);
			transform.localScale = bigScale;
		} else {
			transform.localRotation = baseRot;
			transform.localScale = scale;
		}
	}
}
