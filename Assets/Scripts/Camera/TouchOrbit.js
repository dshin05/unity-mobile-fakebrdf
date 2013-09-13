    var target : Transform;
    var distance = 10.0;
     
    var xSpeed = 250.0;
    var ySpeed = 120.0;
     
    var yMinLimit = -20;
    var yMaxLimit = 80;
     
    private var x = 0.0;
    private var y = 0.0;
     
    var xsign =1;
     
    @script AddComponentMenu("Camera-Control/Mouse Orbit")
     
    function Start () 
    {
        var angles = transform.eulerAngles;
        x = angles.y;
        y = angles.x;
       
        var rotation = Quaternion.Euler(y, x, 0);
        var position = rotation * Vector3(0.0, 0.0, -distance) + target.position;
           
            transform.rotation = rotation;
            transform.position = position;
     
       
    }
    
    //Old Zoom system
    /*
    function OnGUI() 
    {
		if (GUI.Button(Rect(10,10,100,100),"Zoom In"))
			distance = distance - 1;
			
		if (GUI.Button(Rect(10,120,100,100),"Zoom Out"))
			distance = distance + 1;
	}
	*/
	
    function Update () 
    {
       
       	//Rotation
        //get the rotationsigns       
        var forward = transform.TransformDirection(Vector3.up);
        var forward2 = target.transform.TransformDirection(Vector3.up);
        
        if (Vector3.Dot(forward,forward2) < 0)
			xsign = -1;
			else
			xsign =1;
       
        for (var touch : Touch in Input.touches) 
        {
	        if (Input.touchCount == 1 && touch.phase == TouchPhase.Moved) 
	        {
	            x += xsign * touch.deltaPosition.x * xSpeed *0.02;
	            y -= touch.deltaPosition.y * ySpeed *0.02;
				
			}
			
            var rotation = Quaternion.Euler(y, x, 0);
            var position = rotation * Vector3(0.0, 0.0, -distance) + target.position;
           
            transform.rotation = rotation;
            transform.position = position;
        
        }
        
        //Zoom
    }