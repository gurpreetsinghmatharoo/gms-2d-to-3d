/// @description 
switch(state){
	case st.idle: case st.move:
		//Input
		var inputX, inputY;

		inputX = (keyboard_check(ord("D"))||keyboard_check(vk_right)) - (keyboard_check(ord("A"))||keyboard_check(vk_left));
		inputY = (keyboard_check(ord("S"))||keyboard_check(vk_down)) - (keyboard_check(ord("W"))||keyboard_check(vk_up));

		//Movement
		moveX = inputX * moveSpeed;
		moveY = inputY * moveSpeed;
		
		//Collisions
		if (place_meeting_3d(moveX, 0, 0, oCube)){
			moveX = 0;
		}
		if (place_meeting_3d(0, moveY, 0, oCube)){
			moveY = 0;
		}
		
		x += moveX;
		y += moveY;
		
		//State
		if (abs(moveX)+abs(moveY)==0){
			state = st.idle;
		}
		else{
			state = st.move;
		}
		
		//Direction
		if (state==st.move) moveDir = point_direction(0, 0, moveX, moveY) div 90;
		
		//Jump
		if (keyboard_check_pressed(vk_space)){
			moveZ = 10;
		}
		
		//Gravity
		if (moveZ>-10) moveZ--;
		
		//Ground collision
		if (z + moveZ < 0){
			z = 0;
			moveZ = 0;
		}
			
		//Add
		if (place_meeting_3d(0, 0, moveZ, oCube)){
			moveZ = 0;
		}

		z += moveZ;
		
		//Rotate
		var rot = keyboard_check(vk_pagedown) - keyboard_check(vk_delete);
		zRot += rot*4;
	break;
}

//Sprite
sprite_index = sprites[state, moveDir];

//3D
if (keyboard_check_pressed(vk_enter)){
	if (instance_exists(o2Dto3D)){
		instance_destroy(o2Dto3D);
	}
	else{
		instance_create_depth(0, 0, 0, o2Dto3D);
	}
}