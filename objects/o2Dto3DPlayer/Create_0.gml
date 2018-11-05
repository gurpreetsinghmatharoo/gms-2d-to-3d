/// @description 
//Properties
moveSpeed = 2;

//Variables
z = 0;
zRot = 0;

moveX = 0;
moveY = 0;
moveZ = 0;
moveDir = 0;

//States
enum st{
	idle, move
}

state = st.idle;

//Sprites
sprites[st.idle, 0] = sPlayer_Idle_Right;
sprites[st.idle, 1] = sPlayer_Idle_Up;
sprites[st.idle, 2] = sPlayer_Idle_Left;
sprites[st.idle, 3] = sPlayer_Idle_Down;

sprites[st.move, 0] = sPlayer_Move_Right;
sprites[st.move, 1] = sPlayer_Move_Up;
sprites[st.move, 2] = sPlayer_Move_Left;
sprites[st.move, 3] = sPlayer_Move_Down;

//Camera
view_enabled = true;
view_visible[0] = true;

var width = 480, height = 270, scale = 2;

cam = camera_create_view(0, 0, width, height, 0, id, -1, -1, width/2, height/2);
view_set_camera(0, cam);

window_set_size(width*scale, height*scale);
surface_resize(application_surface, width*scale, height*scale);