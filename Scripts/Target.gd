extends Node3D

class_name Target

@export var points_worth: int = 5
@export var isMoving: bool = false;

const X_RANGE: int = 50;
const Y_RANGE: int = 40;

var xVelocity: float;
var yVelocity: float;

signal target_hit(target)
var hasBeenHit = false;

func _ready():
	var randIntX = randi_range(0, 1);
	var randIntY = randi_range(0, 1);
	
	if randIntX == 0:
		xVelocity = -0.75;
	else:
		xVelocity = 0.75;
		
	if randIntY == 0:
		yVelocity = -0.5;
	else:
		yVelocity = 0.5;
		
func _process(delta: float) -> void:
	if !isMoving:
		return;
		
	global_position.x += xVelocity;
	if abs(global_position.x) > X_RANGE:
		#global_position.x = X_RANGE * -xVelocity;
		xVelocity *= -1.0;
		
	global_position.y += yVelocity;
	if global_position.y < 1:
		#global_position.y = Y_RANGE;
		yVelocity *= -1.0;
		return;
	if global_position.y > Y_RANGE:
		#global_position.y = 2;
		yVelocity *= -1.0;
		return;
	
	
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
