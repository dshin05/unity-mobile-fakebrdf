// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System.Collections;

public class FreeCamera : MonoBehaviour {	
	
	public float thetaSpeed = 250.0f;
	public float phiSpeed = 120.0f;
	public float moveSpeed = 10.0f;
	public float zoomSpeed = 30.0f;
	public float moveBounds = 700f;
	
	public float phiBoundMin = -89f;
	public float phiBoundMax = 89f;
	
	public float rotateSmoothing = 0.5f;
	public float moveSmoothing = 0.7f;
		
	public float distance = 2.0f;
	private Vector2 euler;
	
	private Quaternion targetRot;
	private Vector3 targetLookAt;
	private float targetDist;
	private Vector3 distanceVec = new Vector3(0,0,0);
	
	private Transform target;
	private Rect inputBounds;
	public Rect paramInputBounds = new Rect(0,0,1,1);
	public Vector3 startLookAt = new Vector3(0,2,0);
	
	public bool iOS = true;
	
	public void Start () {
	    Vector3 angles = transform.eulerAngles;
	    euler.x = angles.y;
	    euler.y = angles.x;
		//unity only returns positive euler angles but we need them in -90 to 90
		euler.y = Mathf.Repeat(euler.y+180f, 360f)-180f;
		
		GameObject go = new GameObject("_FreeCameraTarget");
		target = go.transform;
		//target.position = transform.position + transform.forward * distance;
		target.position = startLookAt;		
		targetRot = transform.rotation;
		targetLookAt = target.position;		
		targetDist = (transform.position-target.position).magnitude;
		//targetDist = distance;
	}
	
	public void Update () {
		//NOTE: mouse coordinates have a bottom-left origin, camera top-left
		inputBounds.x = camera.pixelWidth * paramInputBounds.x;
		inputBounds.y = camera.pixelHeight * paramInputBounds.y;
		inputBounds.width = camera.pixelWidth * paramInputBounds.width;
		inputBounds.height = camera.pixelHeight * paramInputBounds.height;
	
	    if(target && inputBounds.Contains(Input.mousePosition)) {
	    	float dx = 0f;
			float dy = 0f;
			if(Input.multiTouchEnabled) {
				if(Input.touchCount > 0) {
					dx = Input.GetTouch(0).deltaPosition.x * 0.01f;
					dy = Input.GetTouch(0).deltaPosition.y * 0.01f;
				}
			} else {
				dx = Input.GetAxis("Mouse X");
	        	dy = Input.GetAxis("Mouse Y");
			}
			bool click1 = Input.GetMouseButton(0) || Input.touchCount == 1;
    		bool click2 = Input.GetMouseButton(1) || Input.touchCount == 2;
    		bool click3 = Input.GetMouseButton(2) || Input.touchCount == 3;
    		bool click4 = Input.touchCount >= 4;
			bool rotInput = click1;
			bool skyInput = click4 || click1 && (Input.GetKey(KeyCode.LeftShift) || Input.GetKey (KeyCode.RightShift));
			bool panInput = click3 || click1 && (Input.GetKey(KeyCode.LeftControl) || Input.GetKey(KeyCode.RightControl));
			bool zoomInput = click2;
			
			if( skyInput ) {
				dx = dx * thetaSpeed * 0.02f;
				Sky.activeSky.transform.Rotate(new Vector3(0,dx,0));
			}
			else if( panInput ) {
				dx = dx * moveSpeed * 0.005f * targetDist;
	        	dy = dy * moveSpeed * 0.005f * targetDist;
	 			targetLookAt -= transform.up*dy + transform.right*dx;
		 		targetLookAt.x = Mathf.Clamp(targetLookAt.x,-moveBounds,moveBounds);
				targetLookAt.y = Mathf.Clamp(targetLookAt.y,-moveBounds,moveBounds);
		 		targetLookAt.z = Mathf.Clamp(targetLookAt.z,-moveBounds,moveBounds);
			}
			else if( zoomInput ) {
				dy = dy * zoomSpeed * 0.005f * targetDist;
		 		targetDist += dy;
		 		targetDist = Mathf.Max(0.1f,targetDist);
	 		}
			else if( rotInput ) {
				dx = dx * thetaSpeed * 0.02f;
				dy = dy * phiSpeed * 0.02f;
				euler.x += dx;
		        euler.y -= dy;				
		        euler.y = ClampAngle(euler.y, phiBoundMin, phiBoundMax);
		        targetRot = Quaternion.Euler(euler.y, euler.x, 0);
			}
	 		
			if( !Input.multiTouchEnabled ) {
				targetDist -= Input.GetAxis("Mouse ScrollWheel") * zoomSpeed * 0.5f;
		 		targetDist = Mathf.Max(0.1f,targetDist);
			}
		}
	}
	
	public void FixedUpdate() {
		distance = moveSmoothing*targetDist + (1-moveSmoothing)*distance;
		
		transform.rotation = Quaternion.Slerp( transform.rotation, targetRot, rotateSmoothing );
	    target.position = Vector3.Lerp(target.position, targetLookAt, moveSmoothing);
		distanceVec.z = distance;
	    transform.position = target.position - transform.rotation * distanceVec;
	}
	
	static float ClampAngle(float angle, float min, float max) {
		if(angle < -360f) angle += 360f;
		if(angle > 360f)	angle -= 360f;
		return Mathf.Clamp(angle, min, max);
	}
}
