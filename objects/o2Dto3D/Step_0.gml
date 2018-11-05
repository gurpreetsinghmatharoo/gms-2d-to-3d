/// @description 
#region Skybox
//Skybox animation
if (sprite_exists(skySprite)){
	skyIndex += skySpeed;
	skyIndex = skyIndex mod sprite_get_number(skySprite);
}
#endregion

#region Mouse
if (camRot){
	//Mouse
	mX = device_mouse_x_to_gui(0);
	mY = device_mouse_y_to_gui(0);

	//Move camera
	if (mouse_check_button(mb_right)){
		//Get difference
		var mHsp, mVsp;
		mHsp = mX - mXPrevious;
		mVsp = mY - mYPrevious;
	
		//Apply
		camYaw += mHsp;
		camPitch += mVsp;
		camPitch = clamp(camPitch, 1, 89.9);
	}else{
		//mXPrevious = mX;
		//mYPrevious = mY;
	}

	//Zoom
	var wheel = mouse_wheel_down() - mouse_wheel_up();
	camDist += wheel*32;
}

#endregion