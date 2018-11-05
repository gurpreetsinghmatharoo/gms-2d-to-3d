/// @function game_init
gml_pragma("global", "game_init()");

//Format
vertex_format_begin();

vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_color();

global.vFormat = vertex_format_end();