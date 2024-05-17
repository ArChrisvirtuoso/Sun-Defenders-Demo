// Get Inputs
getControls();

// Movement & Animation Control
	// Left Movement & Animation
		if key_left || pad_left  == 1
		{
			x -= 5;
			sprite_index = S_P_Ship_H_Left;
			alarm[0] = key_left || pad_left;
		}
	
	// Right Movement & Animation
		else if key_right || pad_right == 1 
		{
			x += 5;
			sprite_index = S_P_Ship_H_Right;
			alarm[0] = key_right || pad_right;
		}
	
	// Upward Movement
		if key_up || pad_up == 1
		{
			y -= 5;
		}
		
	// Downard Movement
		else if key_down || pad_down == 1
		{
			y += 5;
		}