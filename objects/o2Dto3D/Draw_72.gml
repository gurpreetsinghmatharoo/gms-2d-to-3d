/// @description 
//Restore surf
if (!surface_exists(backSurf)){
	backSurf = surface_create(room_width, room_height);
	buffer_set_surface(backBuff, backSurf, 0, 0, 0);
}