extends Node3D

@export var points_worth: int = 5

signal hit

func _ready():
	$Area3D.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	if area.name.begins_with("Bullet"):
		emit_signal("hit")
		#should move to Level..
		GameMaster.hits += 1
		GameMaster.score += points_worth
		area.queue_free()
		disable_target()

func disable_target():
	$MeshInstance3D.visible = false
	$Area3D/CollisionShape3D.disabled = true
