/// @arg obj

with(argument[0]){
	if (object_index!=o2Dto3D){
		if (!variable_instance_exists(id, "z")){
			z = 0;
		}
		if (!variable_instance_exists(id, "xRot")){
			xRot = 0;
		}
		if (!variable_instance_exists(id, "yRot")){
			yRot = 0;
		}
		if (!variable_instance_exists(id, "zRot")){
			zRot = 0;
		}
		if (!variable_instance_exists(id, "Faces")){
			Faces = 1;
		}
		if (!variable_instance_exists(id, "Billboard")){
			Billboard = 0;
		}
	}
}