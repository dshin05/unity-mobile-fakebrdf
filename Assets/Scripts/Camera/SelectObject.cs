using UnityEngine;
using System.Collections;

public class SelectObject : MonoBehaviour {
	
	private Transform hitobj;
	// Use this for initialization
	void Start () {
		hitobj = this.gameObject.transform;
	}
	
	void Update () {
		TapSelect();
		this.gameObject.transform.position = Vector3.Lerp(this.gameObject.transform.position, hitobj.position, 1.0f);
	}
 
	void TapSelect() {
		foreach (Touch touch in Input.touches) 
		{
			if (Input.touchCount == 1 && touch.phase == TouchPhase.Began) 
			{
			Ray ray = Camera.main.ScreenPointToRay(touch.position);
			RaycastHit hit ;
				if (Physics.Raycast (ray, out hit)) 
				{
					hitobj = hit.transform;
				}
			}
		}
	}
}