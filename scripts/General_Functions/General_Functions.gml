function controlsSetup()
{
	bufferTime = 3;
	
	jumpKeyBuffered = 0;
	
	jumpKeyBufferTimer = 0;
}

function getControls()
{
	// keyboard Controls:
		// Direction Inputs
	key_left = keyboard_check(vk_left) + keyboard_check(ord("A"));
		key_left = clamp( key_left, 0 , 1);
	key_right = keyboard_check(vk_right) + keyboard_check(ord("D"));
		key_right = clamp( key_right, 0, 1);
	key_up = keyboard_check(vk_up) + keyboard_check(ord("W"));
		key_up = clamp( key_up, 0, 1);
	key_down = keyboard_check(vk_down) + keyboard_check(ord("S"));
		key_down = clamp( key_down, 0, 1);
		
		//Action Inputs
	key_jump_pressed = 	keyboard_check_pressed(vk_space);
		key_jump_pressed = clamp( key_jump_pressed, 0, 1);
	key_jump = keyboard_check(vk_space);
		key_jump = clamp(key_jump, 0, 1);
	key_run = keyboard_check(vk_lshift) + gamepad_button_check(0, gp_face3);
		key_run = clamp( key_run, 0, 1);

	
	// Gamepad Controls:
		// Direction Inputs
	pad_left = gamepad_button_check(0,gp_padl) || gamepad_axis_value(0, gp_axislh) < -0.5;
		pad_left = clamp(pad_left, 0, 1);
	pad_right = gamepad_button_check(0,gp_padr) ||  gamepad_axis_value(0, gp_axislh) > 0.5;
		pad_right = clamp( pad_right, 0, 1);
	pad_up = gamepad_button_check(0,gp_padu);
		pad_up = clamp( pad_up, 0, 1);
	pad_down = gamepad_button_check(0,gp_padd);
		pad_down = clamp( pad_down, 0, 1);
	
		// Action Inputs
	pad_jump_pressed =  gamepad_button_check_pressed(0, gp_face1);
		pad_jump_pressed = clamp(pad_jump_pressed, 0, 1);
		
	pad_jump =  gamepad_button_check(0,gp_face1);
		pad_jump = clamp( pad_jump, 0, 1);
		
			// Making keyboard and controller jump interchangeable
			key_jump = key_jump || pad_jump;
			key_jump_pressed = key_jump_pressed || pad_jump_pressed;
		
	
	// Jump buffering
	if key_jump_pressed || pad_jump_pressed
	{
		jumpKeyBufferTimer = bufferTime;
		
	}
	
	if jumpKeyBufferTimer > 0
	{
		jumpKeyBuffered = 1;
		jumpKeyBufferTimer--;
	} 
	else 
	{
		jumpKeyBuffered = 0;	
	}
}