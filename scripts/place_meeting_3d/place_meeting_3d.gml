/// @function place_meeting_3d
/// @description 3D Collision Checking
/// @arg x_add
/// @arg y_add
/// @arg z_add
/// @arg obj
 
//Exit
if (!instance_exists(o2Dto3D)){
	return false;
}
 
//Args
var _x = argument[0];
var _y = argument[1];
var _z = argument[2];
var _obj = argument[3];

//Vars
var map = o2Dto3D.vMap;
var keySelf = string(id);
var arrSelf = map[? keySelf];

//Exit
if (arrSelf==undefined) {
	return false;
}

//Vars
var x1Self = (arrSelf[pr.x]-arrSelf[pr.offset]) + _x;
var x2Self = x1Self + arrSelf[pr.w];
var y1Self = (arrSelf[pr.y]) + _y;
var y2Self = y1Self + 1;

//Check
with (_obj){
	//Vars
	var key = string(id);
	var arr = map[? key];
	var isCube = object_index==oCube;
	
	//Exit
	if (arr==undefined && !isCube){
		return false;
	}
	
	//Vars
	if (!isCube){
		var x1 = arr[pr.x]-arr[pr.offset];
		var x2 = x1 + arr[pr.w];
		var y1 = arr[pr.y];
		var y2 = y1 + 1;
		var height = arr[pr.h];
	}
	
	//Cube
	if (isCube){
		var x1 = x;
		var x2 = x1 + sprite_width;
		var y1 = y;
		var y2 = y1 + sprite_height;
		height = zHeight;
	}
	
	//Check XY
	var xyCol = rectangle_in_rectangle(x1, y1, x2, y2, x1Self, y1Self, x2Self, y2Self);

	//Check Z
	var zCol = rectangle_in_rectangle(0, z, 1, z+height, 0, other.z + _z, 1, (other.z+arrSelf[pr.h])+_z);
	
	//Return
	if (xyCol && zCol) return true;
}

return false;