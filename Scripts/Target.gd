extends Node3D
class_name Target

@export var points_worth: int = 5
@export var isMoving: bool = false
@export var circleMovement: bool = false;

const X_RANGE: float = 50.0
const Z_RANGE: float = 30.0  # adjust how “wide” it is in Z
const Y_RANGE: float = 40.0;
const Y_MIN: float = 1.0
const Y_MAX: float = 40.0



var xVelocity: float;

@export var angular_speed: float = 1.0  # radians per second

var _angle: float
var yVelocity: float

signal target_hit(target)
var hasBeenHit: bool = false

func _ready():
	var playerPos = GameManager.Get_Gun().global_position;
	var xDiff = global_position.x - playerPos.x;
	points_worth += int(abs(xDiff) / 10);
	
	if circleMovement:
		# start at a random angle around the player
		_angle = randf_range(0, TAU)
		# randomize your y-bounce direction
		yVelocity = -0.5 + int(randi_range(0,1) == 0)
		
		
		
	elif isMoving:
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
	if not (isMoving or circleMovement):
		return;
		
	if circleMovement:
		# 1) advance orbit angle
		_angle += angular_speed * delta

		# 2) get the player (gun) position to orbit around
		var center = GameManager.Get_Gun().global_position
		self.look_at(center);
		rotate_y(deg_to_rad(90));

		# 3) compute new X & Z via parametric ellipse
		global_position.x = center.x + cos(_angle) * X_RANGE
		global_position.z = center.z + sin(_angle) * Z_RANGE

		# 4) your original Y-bounce logic
		global_position.y += yVelocity
		if global_position.y < Y_MIN:
			global_position.y = Y_MIN
			yVelocity *= -1.0
		elif global_position.y > Y_MAX:
			global_position.y = Y_MAX
			yVelocity *= -1.0
	elif isMoving:
		global_position.x += xVelocity

		# Bounce off the X limits
		if global_position.x > X_RANGE:
			global_position.x = X_RANGE
			xVelocity *= -1.0
		elif global_position.x < -X_RANGE:
			global_position.x = -X_RANGE
			xVelocity *= -1.0

		global_position.y += yVelocity

		# Bounce off Y limits
		if global_position.y < Y_MIN:
			global_position.y = Y_MIN
			yVelocity *= -1.0
		elif global_position.y > Y_MAX:
			global_position.y = Y_MAX
			yVelocity *= -1.0

	
	#$Area3D.connect("area_entered", self, "_on_area_entered")

#func _on_area_entered(area):
#    if area.name.begins_with("Bullet"):
#        emit_signal("hit")
#        #should move to Level..
#        GameMaster.hits += 1
#        GameMaster.score += points_worth
#        area.queue_free()
#        disable_target()

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
