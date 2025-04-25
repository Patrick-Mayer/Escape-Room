extends Node3D

class_name Bullet

func _on_lifetime_timer_timeout() -> void:
	queue_free();
