// Fullscreen Toggle
if keyboard_check_pressed(vk_f5)
{
	window_set_fullscreen(!window_get_fullscreen());
}

// Exit if no player
if !instance_exists(O_Player) exit;

// Get Camera Size
var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

// Get Camera target Coordinates
var _camX = O_Player.x - _camWidth/2;
var _camY = O_Player.y - _camHeight/2;

// Contrain Camera to Room
_camX = clamp ( _camX, 0, room_width - _camWidth);
_camY = clamp ( _camY, 0, room_height - _camHeight);

// Set Camera coordinate variables
finalCamX += (_camX - finalCamX) * camTrailSpd;
finalCamY += (_camY - finalCamY) * camTrailSpd;

// Set Camera Coordinates
camera_set_view_pos(view_camera[0], _camX, _camY);