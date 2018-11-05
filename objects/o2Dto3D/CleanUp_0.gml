/// @description 
if (surface_exists(backSurf)) surface_free(backSurf);
buffer_delete(backBuff);

//Make visible
with (all){
	visible = true;
}

//Make background layers invisible
for(var i=0; i<array_length_1d(background_layers); i++){
	layer_set_visible(background_layers[i], true);
}

//Make tile layers invisible
for(var i=0; i<array_length_1d(tile_layers); i++){
	layer_set_visible(tile_layers[i], true);
}

//Restore camera
view_set_camera(0, o2Dto3DPlayer.cam);