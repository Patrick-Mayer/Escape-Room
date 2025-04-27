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
var _timer = 0.0
var _popup_timer = 0.0

@onready var bar = $Ammo_Bar #/UI_3D/SubViewport/Control/TextureProgressBar
@onready var popupText = $PopupText

func _ready():
	interface = XRServer.find_interface("OpenXR");
	currentMagazine = magazinePrefab.instantiate() as Magazine;
	GameMaster.gun = self;

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
		bar.scale.z = max(currentMagazine.ammo, 0)
		#bar.value = (currentMagazine.ammo / currentMagazine.max_ammo) * 100.0
	else:
		clickSFX.play();
		animator.play("Empty");
		
	
func FireBullet():
	if barrelRaycast.is_colliding() and barrelRaycast.get_collider().is_in_group("SHOOTABLE"):
		var collider = barrelRaycast.get_collider()
		var target : Target = collider as Target
		if target != null:
			#SetText("You got " + str(target.points_worth) + "!")
			target.mark_hit()
		#barrelRaycast.get_collider().free();
	
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
		
		
func _process(delta):
	if currentMagazine.ammo < currentMagazine.max_ammo:
		_timer += delta
		if _timer >= currentMagazine.regenerate_rate:
			_timer -= currentMagazine.regenerate_rate
			currentMagazine.ammo += 1
			print("ammo replenished to ", currentMagazine.ammo)
			bar.scale.z = max(currentMagazine.ammo, 0);
			#bar.value = currentMagazine.ammo / currentMagazine.max_ammo * 100.0
			#print("current bar level ", bar.value)
			
	if _popup_timer > 0:
		_popup_timer -= delta
		if _popup_timer <= 0:
			_popup_timer = 0
			popupText.visible = false

func SetText(text):
	print("trying to set text to", text)
	popupText.text = text
	popupText.visible = true
	_popup_timer = 3;
