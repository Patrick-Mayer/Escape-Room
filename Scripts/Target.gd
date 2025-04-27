extends Node3D

class_name Target

@export var points_worth: int = 5

signal target_hit(target)
var hasBeenHit = false;

func _ready():
	pass;
	#$Area3D.connect("area_entered", self, "_on_area_entered")

#func _on_area_entered(area):
#	if area.name.begins_with("Bullet"):
#		emit_signal("hit")
#		#should move to Level..
#		GameMaster.hits += 1
#		GameMaster.score += points_worth
#		area.queue_free()
#		disable_target()

func finalize_hit():
	if hasBeenHit:
		return
	hasBeenHit = true
	$MeshInstance3D.visible = false
	$Area3D/CollisionShape3D.disabled = true
	$"../../Pistol".get_script().
	
func mark_hit():
	emit_signal("target_hit", self)
