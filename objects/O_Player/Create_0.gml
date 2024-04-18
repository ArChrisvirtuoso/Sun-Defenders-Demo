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
		coyoteHangTimer = 0;
	}
}

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
ySpd = 0;

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
