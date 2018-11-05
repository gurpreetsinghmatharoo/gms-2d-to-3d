/// @description 
z = 0;
xRot = 0;
yRot = 0;
zRot = 0;

#region Create vbuff
//Tex
cubeTex = -1;

if (sprite_exists(cubeSprite)){
	cubeTex = sprite_get_texture(cubeSprite, cubeIndex);
	var uvs = texture_get_uvs(cubeTex);
}
else{
	var uvs = [0, 0, 1, 1];
}

//Vbuff
vbCube = vertex_create_buffer();

vertex_begin(vbCube, global.vFormat);

//Bottom
//Triangle 1
vertex_position_3d(vbCube, 0, 0, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Right
//Triangle 1
vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 1, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Left
//Triangle 1
vertex_position_3d(vbCube, 0, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Triangle 2
vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Front
//Triangle 1
vertex_position_3d(vbCube, 0, 0, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 0, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Back
//Triangle 1
vertex_position_3d(vbCube, 0, 1, 0);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 1, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 1, 0);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Top
//Triangle 1
vertex_position_3d(vbCube, 0, 0, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

//Triangle 2
vertex_position_3d(vbCube, 1, 1, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 1, 0, 1);
vertex_texcoord(vbCube, uvs[uv.w], uvs[uv.y]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_position_3d(vbCube, 0, 1, 1);
vertex_texcoord(vbCube, uvs[uv.x], uvs[uv.h]);
vertex_color(vbCube, cubeColor, cubeAlpha);

vertex_end(vbCube);
vertex_freeze(vbCube);

#endregion