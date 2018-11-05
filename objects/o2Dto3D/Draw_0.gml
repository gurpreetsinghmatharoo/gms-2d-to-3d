/// @description 
#region Camera Vars
//Look position
if (instance_exists(camFollow)){
	lookX = camFollow.x;
	lookY = camFollow.y;
	lookZ = camFollow.sprite_height/2;
}

//Get camera position
camX = lookX + (dcos(camYaw) * dcos(camPitch)) * camDist;
camY = lookY + (dsin(camYaw) * dcos(camPitch)) * camDist;
camZ = lookZ + (dsin(camPitch)) * camDist;
#endregion

#region Draw skybox
draw_vbuff_transform(vbCube, -skyDistance, -skyDistance, -skyDistance-1, room_width+skyDistance*2, room_height+skyDistance*2, skyDistance*2, pr_trianglelist, skyTex);
//vertex_submit(vbCube, pr_trianglelist, skyTex);
#endregion

#region Draw background
//Draw backsurf
draw_surface(backSurf, 0, 0);

#endregion

#region Draw objects
//Priority
//var prior = ds_priority_create();
//with(all){
//	if (sprite_exists(sprite_index)){
//		ds_priority_add(prior, id, y);
//	}
//}

//Loop
//while(ds_priority_size(prior)>0){
for(var i=0; i<instance_count; i++){
	//Vars
	//var inst = ds_priority_delete_min(prior);
	var inst = instance_id_get(i);
	if (instance_exists(inst) && sprite_exists(inst.sprite_index) && object_get_parent(inst.object_index)!=o3DObjs){
		var key = string(inst);
		var tex = sprite_get_texture(inst.sprite_index, inst.image_index);
		var arr = vMap[? key];
		
		//Init vars
		if (!variable_instance_exists(inst, "Billboard") || !variable_instance_exists(inst, "zRot")){
			init_3d_vars(inst);
		}
	
		//Vbuff
		if (arr==undefined || arr[pr.spr]!=inst.sprite_index || arr[pr.sub]!=floor(inst.image_index) || ((arr[pr.x]!=inst.x || arr[pr.y]!=inst.y) && !depthOptimization)){
			//Vars
			var uvs = texture_get_uvs(tex);
			
			if (arr==undefined){
				var texW = texture_get_texel_width(tex);
				var texH = texture_get_texel_height(tex);
			}
			else{
				var texW = arr[pr.texw];
				var texH = arr[pr.texh];
			}
			
			var _w = (uvs[2]-uvs[0])/texW;
			var _h = (uvs[3]-uvs[1])/texH;
			
			var pos = [0, 0, _w, _h];
		
			//Vbuff
			var vBuff;
			if (arr=undefined)
				vBuff = vertex_create_buffer();
			else
				vBuff = arr[pr.vbuff];
		
			vertex_begin(vBuff, vFormat);
		
			//Triangle 1
			vertex_position_3d(vBuff, (inst.x*(!depthOptimization)) + pos[uv.x], (inst.y*(!depthOptimization)), pos[uv.h]);
			vertex_texcoord(vBuff, uvs[uv.x], uvs[uv.y]);
			vertex_color(vBuff, c_white, 1);
		
			vertex_position_3d(vBuff, (inst.x*(!depthOptimization)) + pos[uv.w], (inst.y*(!depthOptimization)), pos[uv.h]);
			vertex_texcoord(vBuff, uvs[uv.w], uvs[uv.y]);
			vertex_color(vBuff, c_white, 1);
		
			vertex_position_3d(vBuff, (inst.x*(!depthOptimization)) + pos[uv.x], (inst.y*(!depthOptimization)), pos[uv.y]);
			vertex_texcoord(vBuff, uvs[uv.x], uvs[uv.h]);
			vertex_color(vBuff, c_white, 1);
		
			//Triangle 2
			vertex_position_3d(vBuff, (inst.x*(!depthOptimization)) + pos[uv.w], (inst.y*(!depthOptimization)), pos[uv.y]);
			vertex_texcoord(vBuff, uvs[uv.w], uvs[uv.h]);
			vertex_color(vBuff, c_white, 1);
		
			vertex_position_3d(vBuff, (inst.x*(!depthOptimization)) + pos[uv.w], (inst.y*(!depthOptimization)), pos[uv.h]);
			vertex_texcoord(vBuff, uvs[uv.w], uvs[uv.y]);
			vertex_color(vBuff, c_white, 1);
		
			vertex_position_3d(vBuff, (inst.x*(!depthOptimization)) + pos[uv.x], (inst.y*(!depthOptimization)), pos[uv.y]);
			vertex_texcoord(vBuff, uvs[uv.x], uvs[uv.h]);
			vertex_color(vBuff, c_white, 1);
		
			vertex_end(vBuff);
		
			//Log
			var verb = "modified";
			if (arr=undefined) verb = "created";
			show_debug_message(string(current_time) + ": Vertex buffer " + verb + " for " + key);
		
			//Get offset
			var offset = (sprite_get_xoffset(inst.sprite_index)/sprite_get_width(inst.sprite_index))*_w;
		
			//Array
			if (arr==undefined){
				var arr = [vBuff, inst.sprite_index, inst.image_index, inst.x, inst.y, texW, texH, _w, _h, offset];
		
				vMap[? key] = arr;
			}
			else{
				arr[@ pr.spr] = inst.sprite_index;
				arr[@ pr.sub] = floor(inst.image_index);
				arr[@ pr.x] = inst.x;
				arr[@ pr.y] = inst.y;
				arr[@ pr.w] = _w;
				arr[@ pr.h] = _h;
				arr[@ pr.offset] = offset;
			}
		}
		else{
			//Get info
			var vBuff = arr[pr.vbuff];
			var tex = sprite_get_texture(arr[pr.spr], arr[pr.sub]);
			var _w = arr[pr.w];
			var _h = arr[pr.h];
			var offset = arr[pr.offset];
			
			//Update info
			arr[@ pr.x] = inst.x;
			arr[@ pr.y] = inst.y;
		}
		
		//Vars
		var zCenter = inst.z + inst.sprite_height/2;
		
		//Submit
		for(var f=0; f<inst.Faces; f++){
			//Billboard
			var camDirZ = point_direction(inst.x, inst.y, camX, camY);
			var camDistZ = point_distance(inst.x, inst.y, camX, camY);
			
			if (inst.Billboard){
				//inst.zRot = camDirZ-90;
				inst.zRot = -camYaw-90;
			}
			if (inst.Billboard>1){
				//inst.xRot = point_direction(0, -inst.z, camDistZ, -camZ);
				inst.xRot = camPitch;
			}
			
			//Rotation
			var _rot = inst.zRot + ((180/inst.Faces)*f);
			
			//Offsets
			var _xoff = lengthdir_x(offset, _rot);
			var _yoff = lengthdir_y(offset, _rot);
			
			//Submit
			draw_vbuff_transform(vBuff, (inst.x*depthOptimization)-_xoff, (inst.y*depthOptimization)-_yoff, inst.z, 1, 1, 1, pr_trianglelist, tex, c_white, 1, inst.xRot, inst.yRot, _rot);
		}
	}
	//Special objects
	else if (inst.object_index==oCube){
		with (inst) draw_vbuff_transform(vbCube, x, y, z, sprite_width, sprite_height, zHeight, pr_trianglelist, cubeTex, c_white, 1, xRot, yRot, zRot);
	}
}

#endregion

#region Camera
//Mat lookat
var lookMat = matrix_build_lookat(camX, camY, camZ, lookX, lookY, lookZ, 0, 0, 1);
var projMat = matrix_build_projection_perspective_fov(-camFOV, -16/9, 1, 32000);

camera_set_view_mat(camera, lookMat);
camera_set_proj_mat(camera, projMat);
camera_apply(camera);
#endregion