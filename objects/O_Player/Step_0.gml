// Get Inputs
getControls();

//Movement
	//X Direction
	moveDir = (key_right - key_left) - (pad_left - pad_right);

	// Get moving face
	if moveDir != 0 {face = moveDir};

	//X Speed
	runType = key_run;
	xSpd = moveDir * moveSpd[runType];

	//X Collision
	var _subPixel = .5;
	if place_meeting(x + xSpd, y, O_Wall )
	{
		// check for slope
		if !place_meeting( x + xSpd, y - abs(xSpd)-1, O_Wall)
		{
			while place_meeting( x + xSpd, y, O_Wall){ y -= _subPixel };
		}
		// Check for ceiling slopes, oftherwise, regular collsion
		else 
		{
			// Ceiling slopes
			if !place_meeting(x + xSpd, y + abs(xSpd)+1 , O_Wall)
			{
				while place_meeting(x +xSpd, y, O_Wall) { y += _subPixel};
			}
			
			//Normal X collision
			else {
			
				// precise collision
				var _pixelCheck = _subPixel * sign(xSpd);
				while !place_meeting(x + _pixelCheck, y , O_Wall)
				{
					x += _pixelCheck;
				}
			
				// Set xSpd to zero when "collision" with wall
				xSpd = 0;
			}
		}
	}
	
	// Move down slopes
	downslope = noone;
	if yspd >= 0 && !place_meeting( x + xSpd, y + 1, O_Wall) && place_meeting( x + xSpd, y + abs(xSpd)+1, O_Wall)
	{
		// Semi-solid blocked path check
		downslope = semiSolidCheck( x + xSpd, y + abs(xSpd) +1 );
		
		//Move down slope precisely if no semi-solid
		if !instance_exists(downslope){ 
			while !place_meeting( x + xSpd, y + _subPixel, O_Wall){ y += _subPixel };
			}
	}
	

	//Move
	x += xSpd;


// Y collision & Movement
	// Gravity
	if coyoteHangTimer > 0 
	{
		// Timer Countdown
		coyoteHangTimer--;
	} else {
			// Applay Gravity to player
			yspd += grav;
			
			// no longer on the ground
			setOnGround(false);
	}
	
	
	
	//Reset/ Prep jumpinng variables
	if onGround
	{
		jumpCount = 0;
		coyoteJumpTimer = coyoteJumpFrames;
		
	} else {
		// remove extra jump if player is in the air
		coyoteJumpTimer--;
		
		if jumpCount == 0 && coyoteJumpTimer <= 0 { jumpCount = 1; };
		
	}
	
	// Cap falling speed
	if yspd > termVel 
	{ 
		yspd = termVel
		};
		
	// Initiate Jump 
	var _floorIsSolid = false;
	if instance_exists(myFloorPLat)
	&& (myFloorPLat.object_index == O_Wall || object_is_ancestor(myFloorPLat.object_index, O_Wall))
	{
		_floorIsSolid = true;
	}
	
	if jumpKeyBuffered && jumpCount < jumpMax && (!key_down || _floorIsSolid )
	{
		// Reset Buffer
		jumpKeyBuffered = false;
		jumpKeyBufferTimer = 0;
		
		//Increase number of performed jumps
		jumpCount++;
		
		// Set jump hold timer
		jumpHoldTimer = jumpHoldFrames[jumpCount-1];
		
		// when no longer on the ground
		setOnGround(false);
		
	}
	// cut jump by button release
	if !key_jump
	{
		jumpHoldTimer = 0;
	}
	// Jump based on timer / button hold
	if jumpHoldTimer > 0
	{
		// ySpd set constantly to jumping speed
		yspd = jSpd[jumpCount-1];
		
		// Timer Count down
		jumpHoldTimer--;
	}
	
	// Y Collision
	
	//Upwards Y collision (with ceiling slopes)
	if yspd < 0 && place_meeting( x, y + yspd, O_Wall)
	{
		// Jump into sloped ceilings
		
		var slope_Slide = false;
		
		// slide up left slope
		if moveDir == 0 && !place_meeting(x - abs(yspd) - 1, y + yspd, O_Wall )
		{
			while place_meeting( x, y + yspd, O_Wall) { x -= 1; };
			slope_Slide = true;
		}
		
		// Slide up Right slope
		if moveDir == 0 && !place_meeting( x + abs(yspd) + 1, y + yspd, O_Wall)
		{
			while place_meeting( x, y + yspd, O_Wall){ x += 1; };
			slope_Slide = true;
		}
		
		// Normal Y collision
		if !slope_Slide
		{
			if place_meeting( x, y + yspd, O_Wall)
			{
				// Wall Precision
				var _pixelCheck = _subPixel * sign(yspd);
				while !place_meeting( x, y + _pixelCheck, O_Wall)
				{
					y += _pixelCheck;
				}
		
				// Bonk (OPTIONAL)
				// if ySpd < 0 { jumpHoldTimer = 0;}
		
				// Set ySpd to 0
				yspd = 0;
			}
		}
	}
	
	// Floor Y collision
	
		// Check solid and semi-solid platforms under player
		var _clampYspd = max ( 0, yspd);
		var _list = ds_list_create(); // Create a DS list to store all objects ran into by player
		var _array = array_create(0);
		array_push ( _array, O_Wall, O_SemiSolidStatic );

		// Check and Add objects to list
		var _listSize = instance_place_list( x, y +1 + _clampYspd + movePlatMaxYspd, _array, _list, false );
		
			//// ( HIGH RES/ HIGH SPEED PROJECT FIX)
			var _yCheck = y+1 + _clampYspd;
			if instance_exists(myFloorPLat) { _yCheck += max( 0, myFloorPLat.yspd); };
			var _semiSolid = semiSolidCheck( x, _yCheck);
		
		// Loop through colliding instances and only return one if it's top is below the player
		for (var i = 0; i < _listSize; i++)
		{
			// Get an instance of O_Wall or O_Semisolidstatic form list
			var _listInst = _list[| i];
			
			// Avoid Magnetism
			if _listInst != forgetSemiSolid
			&& (_listInst.yspd <= yspd || instance_exists(myFloorPLat) )
			&& ( _listInst.yspd > 0 || place_meeting( x, y +1 + _clampYspd, _listInst) )
			|| ( _listInst == _semiSolid  )//// (HIGH SPEED FIX)
			{
				// Return a solid wall or semi-solid wall below the player
				if _listInst.object_index == O_Wall 
				|| object_is_ancestor( _listInst.object_index, O_Wall)
				|| floor(bbox_bottom) <= ceil( _listInst.bbox_top - _listInst.yspd )
				{
					// Return "Highest" wall object
					if !instance_exists(myFloorPLat)
					|| _listInst.bbox_top + _listInst.yspd <= myFloorPLat.bbox_top + myFloorPLat.yspd
					|| _listInst.bbox_top + _listInst.yspd <= bbox_bottom
					{
						myFloorPLat = _listInst;
					}
				}	
			}
		}
		// Destroy DS List to avoid memory leak
		ds_list_destroy(_list);
		
		// Downslope check 
		if instance_exists(downslope) { myFloorPLat = downslope; };
		
		// FINAL check for floor platform below player
		if instance_exists(myFloorPLat) && !place_meeting( x, y + movePlatMaxYspd, myFloorPLat)
		{
			myFloorPLat = noone;
		}
		
		// Land on ground if it exists
		if instance_exists(myFloorPLat)
		{
			// Precise Wall positioning
			while !place_meeting( x, y + _subPixel, myFloorPLat ) && !place_meeting( x, y, O_Wall) { y += _subPixel; }
			
			// Ensure player doesn't end up below the top of the semi-solid
			if myFloorPLat.object_index == O_SemiSolidStatic || object_is_ancestor(myFloorPLat.object_index, O_SemiSolidStatic)
			{
				while place_meeting( x, y, myFloorPLat){y -= _subPixel};
			}
			// Floor Y variable
			y = floor(y);
			
			// Collide with ground
			yspd = 0;
			setOnGround(true);
		}
	
	// Manually fall through semi-solid platform
	if key_down && key_jump_pressed
	{
		// Make sure we have a semi-solid floor platform
		if instance_exists(myFloorPLat)
		&& ( myFloorPLat.object_index == O_SemiSolidStatic || object_is_ancestor(myFloorPLat.object_index, O_SemiSolidStatic))
		{
			// Check if possible to move below semi-solid
			var _yCheck = max( 1, myFloorPLat.yspd +1 );
			if !place_meeting( x, y +_yCheck, O_Wall)
			{
				// Move below platform
				y += 1;
				
				// Inherit downward speed from floor platform so it doesn't catch player
				yspd = _yCheck-1;
				
				// Forget this platform briefly to not get caught again
				forgetSemiSolid = myFloorPLat;
				
				// No more floor platfrom
				setOnGround(false);
			}
		}
	}
	
	// Move
	y += yspd;
	
	// Reset forgetSemiSolid variable
	if instance_exists(forgetSemiSolid) && !place_meeting(x, y, forgetSemiSolid)
	{
		forgetSemiSolid = noone;
	}
	
// Final Moving platform collsions and movement
	// X - myFloorPlat horizontal snapping
		// Get MoveplatXspd
		movePlatXspd = 0;
		myFloorPLat = noone;
		if instance_exists(myFloorPLat) { movePlatXspd = myFloorPLat.xSpd; };
		
		// moveplatXspd Move 
		if place_meeting( x + movePlatXspd, y, O_Wall)
		{ 
			// Wall pixel precision
			var _subpixel = .5;
			var _pixelCheck = _subPixel * sign(movePlatXspd);
				while !place_meeting(x + _pixelCheck, y , O_Wall)
				{
					x += _pixelCheck;
				}
				
				// Set MovePlatXspd to 0
				movePlatXspd = 0;
		}
		// Move
		x += movePlatXspd;
		
	
	
	// Y - MyFloorPlat vertical snapping
	if instance_exists(myFloorPLat) 
	&& (myFloorPLat.yspd != 0
	|| myFloorplat.object_index == O_moveplat
	|| object_is_ancestor( myFloorPlat.object_index, O_moveplat)
	|| myFloorPLat.object_index == O_SemiSolidMover
	|| object_is_ancestor(myFloorPLat.object_index, O_SemiSolidMover))
	{
		// Snap to top of floor platform ( un-floor y variable to combat choppiness)
		if !place_meeting( x, myFloorPLat.bbox_top, O_Wall )
		&& myFloorPLat.bbox_top >= bbox_bottom - movePlatMaxYspd
		{
			y = myFloorPLat.bbox_top;
		}
		// moving into solid walls while on semi-solid platforms
		if myFloorPLat.yspd < 0 && place_meeting( x, y + myFloorPLat.yspd, O_Wall)
		{
			// Get pushed down through semi-solid floor platform
			if myFloorPLat.object_index == O_SemiSolidStatic || object_is_ancestor(myFloorPLat.object_index, O_SemiSolidStatic)
			{
				// Get Pushed Down
				var _subPixel = .25;
				while place_meeting( x, y + myFloorPLat.yspd, O_Wall){ y += _subPixel; };
				
				// If pushed into solid wall while moving downwards, push back out
				while place_meeting( x, y, O_Wall) { y -= _subPixel };
				
				y = round(y);
			}
			
			/* // Cancel myFloorPlat variable  
			setOnGround(false);*/
		}
	}
	
// Animation Control
	// Walking
	if abs(xSpd) > 0 { sprite_index = walkSpr; };
	// Running
	if abs(xSpd) >= moveSpd[1] { sprite_index = runSpr};
	// Not moving
	if xSpd == 0 { sprite_index = idleSpr; };
	// in the air
	if !onGround { sprite_index = jumpSpr; };
	
		// Set Collision Mask
		mask_index = idleSpr;