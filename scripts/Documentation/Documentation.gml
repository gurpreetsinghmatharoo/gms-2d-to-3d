/*

***********************
3D Converter - 2D to 3D
	--by matharoo
***********************


••• How to use •••

Place object 'o2Dto3D' where you want the 3D effect. You can also create it with instance_create_<> and destroy it with instance_destroy() for switching between 2D and 3D.

You can customize everything in that object's Create event.
You will need to add your background & tile layers to their respective arrays in the same event.

••• Important: •••

• Enable 'Clear Viewport Background' in room viewport settings

• Go to Tools > Texture Groups and disable "Automatically Crop"

• When you delete the o2Dto3D object, the camera will still be 3D. To restore the camera back to the original one, go to the object's Clean Up event and set the camera in the last line, which is commented out.



*/