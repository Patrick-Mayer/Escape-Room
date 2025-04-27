extends Node3D

@export var target_ammo = 1.0
@export var max_ammo = 1.0

func _process(delta):
	var cam = get_viewport().get_camera_3d()
	#if cam:
		#look_at(cam.global_transform.origin, Vector3.UP)
