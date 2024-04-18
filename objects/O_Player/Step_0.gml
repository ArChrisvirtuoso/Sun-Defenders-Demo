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
		// If there is no slope, then regular collsion
		else 
		{
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
			ySpd += grav;
			
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
	if ySpd > termVel 
	{ 
		ySpd = termVel
		};
		
	// Initiate Jump 
	if jumpKeyBuffered && jumpCount < jumpMax
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
		ySpd = jSpd[jumpCount-1];
		
		// Timer Count down
		jumpHoldTimer--;
	}
	
	// Collision
	var _subPixel = .5;
	if place_meeting( x, y + ySpd, O_Wall)
	{
		// Wall Precision
		var _pixelCheck = _subPixel * sign(ySpd);
		while !place_meeting( x, y + _pixelCheck, O_Wall)
		{
			y += _pixelCheck;
		}
		
		// Bonk Code (*Optional*) [ Play test first]
		if ySpd < 0
		{
			jumpHoldTimer = 0;
		}
		
		// Set ySpd to 0
		ySpd = 0;
	}
	
	// Set if on Ground
	if ySpd >= 0 && place_meeting(x, y + 1, O_Wall)
	{
		setOnGround(true);
	} 
	
	
	// Move
	y += ySpd;
	
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