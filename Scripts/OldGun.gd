extends Node


class_name OldGun

@export var casingPrefab : PackedScene;

func Shoot():
	EjectCasing();
	
	
func EjectCasing():
	if casingPrefab != null:
		var tempPrefab = casingPrefab.instantiate() as Casing;
		tempPrefab.transform = $Pistol/Pistol/slide/CasingSpawn.global_transform;
		#adds it to our scene
		add_child(tempPrefab);
		
		tempPrefab.linear_velocity = tempPrefab.transform.basis.y;


@export var regenerate_rate: int = 1
@export var max_ammo: int = 10
@export var ammo: int = 10

@export var bullet: PackedScene
@export var target : Node3D
@export var lead_target: bool = false
@export var bullet_drop := 0.0
var elevation_angle : float = 0.0 # For compensating for bullet drop

@onready var bullet_spawn_loc: Node3D = $Pivot/blasterF2/BulletSpawnLoc
@onready var muzzle_flash: GPUParticles3D = $Pivot/blasterF2/BulletSpawnLoc/MuzzleFlash
@onready var pivot: Node3D = $Pivot

func _ready():
	# Create a bullet just to ask it for its speed
	var b = bullet.instantiate()
	#projectile_speed = b.speed
	b.queue_free()

func _process(delta):
	if ammo < max_ammo:
		ammo += regenerate_rate * delta
		if ammo > max_ammo:
			ammo = max_ammo

#if in contact with target
func hit_target():
	#GameMaster.hits += 1
	pass

#reference:

func _physics_process(_delta: float) -> void:
	var target_pos := target.global_position
	if lead_target:
		pass
		# If you don't care about bullet drop then
		# elevation_angle should be zero and 
		# cos(elevation_angle) should be one.
		#target_pos = get_intercept(
			#bullet_spawn_loc.global_position,
			#projectile_speed * cos(elevation_angle), #CHANGED
			#target.global_position,
			#target.velocity)
	# Face the target
	if bullet_drop != 0.0:
		pass
		# Account for bullet drop
		# Look at target, but don't elevate toward it.
		# This is rotating the gun, not the position where
		# the bullet is instantiated.
		#var temp := Vector3(target_pos.x, global_position.y, target_pos.z)
		#look_at(temp, Vector3.UP)
		#set_firing_angle(target_pos)
		#pivot.rotation.x = elevation_angle
	else:
		pass
		# No bullet drop
		#pivot.rotation.x = 0
		#look_at(target_pos, Vector3.UP)
	# Shoot automatically, as often as you can
	#if Input.is_action_pressed("ui_accept"):
	#shoot()

func shoot() -> void:
	if ammo > 0:
		ammo -= 1
		#GameMaster.shots += 1
		muzzle_flash.emitting = true
		# Create and fire the bullet
		var b = bullet.instantiate()
		# Add bullet to root node otherwise queue free
		# on shooter will queue free the bullet
		get_tree().get_root().add_child(b)
		# Fire from the position and orientation of the gun
		b.transform = bullet_spawn_loc.global_transform
		b.origin = bullet_spawn_loc.global_position
		b.set_movement_vector()
		if "gravity" in b:
			b.gravity = bullet_drop

func set_firing_angle(target_pos:Vector3):
	# Avoid divide by zero. Also there's no
	# elevation needed if there's no bullet drop.
	if bullet_drop == 0.0:
		elevation_angle = 0.0
		return
	# Initial horizontal velocity
	#var v0:float = projectile_speed
	# Horizontal distance, x
	var tempx:float = bullet_spawn_loc.global_position.x - target_pos.x
	var tempz:float = bullet_spawn_loc.global_position.z - target_pos.z
	var x:float = sqrt(tempx**2 + tempz**2)
	# Avoid divide by zero
	if x == 0:
		# In this case the target is either directly above
		# or below. Here I assume above, but more thorough
		# code would check and possibly set elevation_angle
		# to PI/2
		elevation_angle = PI/2
		return
	# Vertical distance y
	var y:float = target_pos.y - bullet_spawn_loc.global_position.y
	# Gravity
	var g:float = -bullet_drop #Negative needed
	# Avoid imaginary solutions
	#if v0**4 < g*(g*x**2+2*y*v0**2):
		# No real solutions. Bullet cannot reach target
		# so fire at a 45 degree angle.
		#elevation_angle = PI/4
		#return
	# Solutions:
	#var angle1:float = atan( (v0**2 + sqrt(v0**4 - g*(g*x**2+2*y*v0**2))) / (g*x) )
	#var angle2:float = atan( (v0**2 - sqrt(v0**4 - g*(g*x**2+2*y*v0**2))) / (g*x) )
	#print(rad_to_deg(angle1))
	#print(rad_to_deg(angle2))
	#elevation_angle = angle1
	# Choose the smaller magnitude angle
	#if abs(angle2) < abs(angle1):
#		elevation_angle = angle2

func get_intercept(shooter_pos:Vector3,
					bullet_speed:float,
					target_position:Vector3,
					target_velocity:Vector3) -> Vector3:
	var a:float = bullet_speed*bullet_speed - target_velocity.dot(target_velocity)
	var b:float = 2*target_velocity.dot(target_position-shooter_pos)
	var c:float = (target_position-shooter_pos).dot(target_position-shooter_pos)
	# Protect against divide by zero and/or imaginary results
	# which occur when bullet speed is slower than target speed
	var time:float = 0.0
	if bullet_speed > target_velocity.length():
		time = (b+sqrt(b*b+4*a*c)) / (2*a)
	return target_position+time*target_velocity
