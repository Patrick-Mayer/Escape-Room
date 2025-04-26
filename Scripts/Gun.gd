#TODO
#1. Fix gun snapping issue
#5. Add haptic feedback when player shoots gun.

extends XRToolsPickable

class_name Gun

@export var casingPrefab : PackedScene;
#@export var magazinePrefab : PackedScene;
@onready var magazinePrefab = load("res://Prefabs/pistol_magazine.tscn") as PackedScene
@export var bulletPrefab : PackedScene;

@export var animator : AnimationPlayer;
@export var shootSFX : AudioStreamPlayer3D;
@export var clickSFX : AudioStreamPlayer3D;
@export var barrelRaycast : RayCast3D;


var interface : XRInterface;
var currentMagazine : Magazine;


const BULLET_SPEED = 1.0;		#previously 100


func _ready():
	interface = XRServer.find_interface("OpenXR");
	currentMagazine = magazinePrefab.instantiate() as Magazine;

#this is how we handle trigger input on VR controller
func action():
	Shoot();
	
func Shoot():
	if animator.is_playing():
		return;
	
	if (currentMagazine.HasAmmo()):
		#haptic feedback
		print(XRServer.get_tracker("right_hand"));
		const DEFAULT_FREQUENCY = 0.0;
		var amplitude = 1;		#must be between 0 and 1
		var duration = 0.1;
		var durationDelay = 0.05;
		
		interface.trigger_haptic_pulse("haptic", "right_hand", DEFAULT_FREQUENCY, amplitude, duration, durationDelay);
		#interface.trigger_haptic_pulse("haptic", "right_hand", 300, 1, 0.2, 0);
		

		FireBullet();
		shootSFX.play();
		animator.play("Shoot");
		EjectCasing();
		currentMagazine.ammo -= 1;
	else:
		clickSFX.play();
		animator.play("Empty");
		
	
func FireBullet():
	if barrelRaycast.is_colliding() and barrelRaycast.get_collider().is_in_group("SHOOTABLE"):
		#var collider = barrelRaycast.get_collider()
		barrelRaycast.get_collider().free();
	
	#if bulletPrefab != null:
		#var tempPrefab = bulletPrefab.instantiate() as Bullet;
		##adds it to our scene
		#get_tree().get_root().add_child(tempPrefab)
		#
		#tempPrefab.transform = $BulletSpawn.global_transform;
		#tempPrefab.linear_velocity = tempPrefab.transform.basis.z * BULLET_SPEED;


func EjectCasing():
	if casingPrefab != null:
		var tempPrefab = casingPrefab.instantiate() as Casing;
		get_tree().get_root().add_child(tempPrefab)
		
		tempPrefab.transform = $Pistol/Pistol/slide/CasingSpawn.global_transform;
		tempPrefab.get_child(0);
		#tempPrefab.GetChild(0).linear_velocity = tempPrefab.transform.basis.y * 10.0;
