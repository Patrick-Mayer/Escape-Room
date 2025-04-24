extends Node3D

class_name Casing

func _on_lifetime_timer_timeout() -> void:
	queue_free();
