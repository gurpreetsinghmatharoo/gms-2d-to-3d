/// @description 

#region Customize
//Layers to use
background_layers = ["Background"]; //Your background layers
tile_layers = ["Tiles_Main"]; //Your tile layers

//View propeties
var width = 960;
var height = 540;
var scale = 1; //Window scale as compared to view size

//Camera properties
camDist = 220; //Distance of camera from object
camYaw = 90; //How much sideways turned it is
camPitch = 30; //How much vertically rotated the camera is (don't use 90!)
camFOV = 60; //Field of view
camFollow = o2Dto3DPlayer; //Object to follow
camRot = true; //Middle mouse button controls the mouse

//Options

//Skybox
skyColor = c_white; //Color of the skybox
skyAlpha = 1; //Alpha of the skybox
skySprite = sSky; //Sprite used for the skybox, -1 for no sprite
skyIndex = 0; //Subimage index for skybox
skySpeed = 1; //Animation speed for skybox
skyDistance = 640; //Distance of the skybox from the room

#endregion

#region Scrapped customization
depthOptimization = true;
#endregion

#region Constants
enum uv{
	x,
	y,
	w,
	h
}

enum pr{
	vbuff,
	spr,
	sub,
	x,
	y,
	texw,
	texh,
	w,
	h,
	offset
}
#endregion

#region Variables
//Mouse
mXPrevious = 0;
mYPrevious = 0;
mX = 0;
mY = 0;

//Misc
firstStep = true;
init_3d_vars(all);
#endregion

#region Misc
show_debug_overlay(true);

#region Draw backs and tiles to surface
//Surface
backSurf = surface_create(room_width, room_height);

//Add layers to priority ds
var prior = ds_priority_create();

for(var i=0; i<array_length_1d(tile_layers); i++){
	ds_priority_add(prior, tile_layers[i], layer_get_depth(tile_layers[i]));
}

for(var i=0; i<array_length_1d(background_layers); i++){
	ds_priority_add(prior, background_layers[i], layer_get_depth(background_layers[i]));
}

surface_set_target(backSurf);
draw_clear_alpha(0, 0);

//Draw layers
while(ds_priority_size(prior)>0){
	var lyr = layer_get_id(ds_priority_delete_max(prior));
	
	//background
	var arr = layer_get_all_elements(lyr);
	if (layer_get_element_type(arr[0])==layerelementtype_background){
		var bk_spr = layer_background_get_sprite(arr[0]);
		
		//color
		if (bk_spr<0){
			var bk_clr = layer_background_get_blend(arr[0]);
			
			draw_set_color(bk_clr);
			draw_rectangle(0, 0, room_width, room_height, false);
			draw_set_color(c_white);
		}
		//sprite
		else{
			var bk_ind = layer_background_get_index(arr[0]);
	        var tex = sprite_get_texture(bk_spr, bk_ind);
			var tiled = layer_background_get_htiled(arr[0]);
			
			if (tiled){
				draw_sprite_tiled_ext(bk_spr, bk_ind, layer_get_x(lyr), layer_get_y(lyr),
					layer_background_get_xscale(arr[0]), layer_background_get_yscale(arr[0]),
					layer_background_get_blend(arr[0]), layer_background_get_alpha(arr[0]));
			}
			else{
				draw_sprite_ext(bk_spr, bk_ind, layer_get_x(lyr), layer_get_y(lyr),
					layer_background_get_xscale(arr[0]), layer_background_get_yscale(arr[0]),
					0, layer_background_get_blend(arr[0]), layer_background_get_alpha(arr[0]));
			}
		}
	}
	//tiles
	else if (layer_get_element_type(arr[0])==layerelementtype_tilemap){
		draw_tilemap(arr[0], layer_get_x(lyr), layer_get_y(lyr));
	}
}

surface_reset_target();

//Buffer
backBuff = buffer_create(room_width*room_height*4, buffer_fixed, 1);
buffer_get_surface(backBuff, backSurf, 0, 0, 0);

#endregion

#region Invisible
//Make objects invisible
with (all){
	if (object_index != o2Dto3D) visible = false;
}

//Make background layers invisible
for(var i=0; i<array_length_1d(background_layers); i++){
	layer_set_visible(background_layers[i], false);
}

//Make tile layers invisible
for(var i=0; i<array_length_1d(tile_layers); i++){
	layer_set_visible(tile_layers[i], false);
}
#endregion

#endregion

#region Camera
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);

//Lookat pos
lookX = room_width/2;
lookY = room_height/2;
lookZ = 0;

//Create camera
view_enabled = true;
view_visible[0] = true;

camera = camera_create_view(0, 0, width, height, 0, -1, -1, -1, width/2, height/2);
view_set_camera(0, camera);

window_set_size(width*scale, height*scale);
surface_resize(application_surface, width*scale, height*scale);

//Matrix projection
var projMat = matrix_build_projection_perspective_fov(-camFOV, -16/9, 1, 32000);

camera_set_proj_mat(camera, projMat);
#endregion

#region Vbuff
vFormat = global.vFormat;

//Vbuff map
vMap = ds_map_create();

#endregion

#region Skybox
gpu_set_texrepeat(true);

//Texture
skyTex = -1;

if (sprite_exists(skySprite)){
	skyTex = sprite_get_texture(skySprite, skyIndex);
	var uvs = texture_get_uvs(skyTex);
}
else{
	var uvs = [0, 0, 1, 1];
}

//Vbuff
vbCube = vertex_create_buffer();

vertex_begin(vbCube, vFormat);

//Bottom
//Triangle 1
vertex_position_3d(vbCube, 0, 0, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

//Right
//Triangle 1
vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 1, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

//Left
//Triangle 1
vertex_position_3d(vbCube, 0, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

//Triangle 2
vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

//Front
//Triangle 1
vertex_position_3d(vbCube, 0, 0, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

//Back
//Triangle 1
vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 1, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

//Top
//Triangle 1
vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 1, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, skyColor, skyAlpha);

vertex_end(vbCube);
vertex_freeze(vbCube);
#endregion