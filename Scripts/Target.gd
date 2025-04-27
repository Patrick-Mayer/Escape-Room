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
	self.visible = false
	get_child(1).disabled = true
	#$"../../Pistol".get_script().
	GameManager.Get_Gun().SetText("You just scored " + str(points_worth) + " points");
	#find_no
	
func mark_hit():
	print("trying to mark as hit")
	emit_signal("target_hit", self)
