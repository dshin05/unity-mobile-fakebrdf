// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System.Collections;

public class Wireframe : MonoBehaviour {
	private MeshRenderer meshRenderer = null;
	private Material lineMaterial = null;
	public Color lineColor = Color.black;
	Vector3[] linesArray = null;	
	public bool showWireframes = true;
	
	void Start() {
	    meshRenderer = GetComponent<MeshRenderer>();
	    if(!meshRenderer) meshRenderer = gameObject.AddComponent<MeshRenderer>();
	    lineMaterial = new Material(
			"Shader \"Lines/Wireframe\" { Properties { _Color (\"Main Color\", Color) = (0,0,0,1) } SubShader { Pass { " + 
			"ZWrite off " + 
			"ZTest LEqual " +
			"Blend SrcAlpha OneMinusSrcAlpha " + 
			"Lighting Off " +
			"Offset -1, -1 " +
			"Color[_Color] }}}");
	 	//NOTE: line rendering depth offset is ignored in d3d11
		
	    lineMaterial.hideFlags = HideFlags.HideAndDontSave;
	    lineMaterial.shader.hideFlags = HideFlags.HideAndDontSave;
	
		MeshFilter filter = GetComponent<MeshFilter>();
	    if( filter ) {
			Mesh mesh = filter.mesh;
		    Vector3[] vertices = mesh.vertices;
		    int[] triangles = mesh.triangles;
			linesArray = new Vector3[mesh.triangles.Length];
			
			//expand lines I guess?
			for(int i = 0; i < triangles.Length; i++) {
		        linesArray[i] = vertices[triangles[i]];
		    }
		}
	}

	void OnRenderObject() {   
		if( showWireframes ) {
		    lineMaterial.color = lineColor;
			lineMaterial.SetPass(0);
		
		    GL.PushMatrix();
		    GL.MultMatrix(transform.localToWorldMatrix);
		    GL.Begin(GL.LINES);
		    GL.Color(lineColor);
		
		    for(int i = 0; i < linesArray.Length; i+=3) {
		        GL.Vertex(linesArray[i]);
		        GL.Vertex(linesArray[i+1]);
		
				GL.Vertex(linesArray[i+1]);
				GL.Vertex(linesArray[i+2]);
				
				GL.Vertex(linesArray[i+2]);
				GL.Vertex(linesArray[i]);
		    }
		
		    GL.End();
		    GL.PopMatrix();
		}
	}
}
