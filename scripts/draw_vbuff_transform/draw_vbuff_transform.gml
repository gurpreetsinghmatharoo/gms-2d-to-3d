/// @function draw_vbuff_transform
/// @arg vbuff
/// @arg x
/// @arg y
/// @arg z
/// @arg x_size
/// @arg y_size
/// @arg z_height
/// @arg [prim]
/// @arg [tex]
/// @arg [color]
/// @arg [alpha]
/// @arg [x_rot]
/// @arg [y_rot]
/// @arg [z_rot]

//Args
var _vBuff = argument[0];
var _x = argument[1];
var _y = argument[2];
var _z = argument[3];
var _xS = argument[4];
var _yS = argument[5];
var _zS = argument[6];

//Prim
var _prim = argument_count>7 ? argument[7] : pr_trianglelist;

//Tex
var _tex = argument_count>8 ? argument[8] : -1;

//Color
var _color = argument_count>9 ? argument[9] : c_white;

//Alpha
var _alpha = argument_count>10 ? argument[10] : 1;

//Rotations
var _xRot = argument_count>11 ? argument[11] : 0;
var _yRot = argument_count>12 ? argument[12] : 0;
var _zRot = argument_count>13 ? argument[13] : 0;

//Matrix
var _mat = matrix_build(_x, _y, _z, _xRot, _yRot, _zRot, _xS, _yS, _zS);

matrix_set(matrix_world, _mat);

//BM
//gpu_set_blendmode_ext(bm_src_alpha, bm_zero);

#region Old
//Shader
/*if (_color!=c_white){
	shader_set(shVertex);
	
	shader_set_uniform_f(global.uniColor, color_get_red(_color)/255, color_get_green(_color)/255, color_get_blue(_color)/255);
}
//Reset
if (_color!=c_white){
	shader_reset();
}*/
#endregion

//Color
draw_set_color(_color);
draw_set_alpha(_alpha);

vertex_submit(_vBuff, _prim, _tex);

//Reset
draw_set_color(c_white);
draw_set_alpha(1);

//gpu_set_blendmode(bm_normal);

matrix_set(matrix_world, matrix_build_identity());
