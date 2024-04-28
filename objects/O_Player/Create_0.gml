// Custom Player Functions
function setOnGround(_val = true)
{
	if _val == true
	{
		onGround = true;
		coyoteHangTimer = coyoteHangFrames;
	} 
	else {
		onGround = false;
		myFloorPLat = noone;
		coyoteHangTimer = 0;
	}
}

function semiSolidCheck (_x, _y)
{
	// Create Return variable
	var _rtrn = noone;
	
	// No upwards movement then normal collision check
	if yspd >= 0 && place_meeting(_x, _y, O_SemiSolidStatic)
	{
		// Create DS list to store all colliding semi-solid wall instances
		var _list = ds_list_create();
		var _listSize = instance_place_list(_x, _y, O_SemiSolidStatic, _list, false)
		
		// Loop through colliding instances & return only one if top is below player
		for ( var i = 0; 1 < _listSize; i++ ) 
		{
			var _listInst = _list[ i];
			if floor(bbox_bottom) <= ceil( _listInst.bbox_top - _listInst.yspd )
			{
				// Return semi-solid ID
				_rtrn = _listInst;
				
				// Exit loop early
				i = _listSize;
			}
		}
		// Destroy ds list to free memory
		ds_list_destroy(_list);
	}
	
	// Return variable
	return _rtrn;
}

depth = -30;

// Control Setup
controlsSetup()

// Sprites
maskSpr = sPlayerIdle;
idleSpr = sPlayerIdle;
walkSpr = sPlayerWalk;
runSpr = sPlayerRun;
jumpSpr = sPlayerJump;

//Movement
face = 1;
moveDir = 0;
runType = 0;
moveSpd[0] = 2;
moveSpd[1] = 3.5;
xSpd = 0;
yspd = 0;

//Jump
grav = .275;
termVel = 4;
onGround = true;
jumpMax = 1;
jumpCount = 2;
jumpHoldTimer = 0;

// successive Jump Values
jumpHoldFrames[0] = 18;
jSpd[0] = -3.15;
jumpHoldFrames[1] = 10;
jSpd[1] = -2.85;

// Coyote Time
	// Hang Time
	coyoteHangFrames = 2;
	coyoteHangTimer = 0;
	
	// Jump Time
	coyoteJumpFrames = 5;
	coyoteJumpTimer = 0;

// Moving Platforms
myFloorPLat = noone;
downslope = noone;
movePlatXspd = 0;
movePlatMaxYspd = termVel; // Can be adjusted above Terminal Velocity if needed. How fast the player follow a downwards moving platform.
