extends XRToolsPickable

class_name Gun

@export var casingPrefab : PackedScene;
#@export var magazinePrefab : PackedScene;
@onready var magazinePrefab = load("res://Prefabs/pistol_magazine.tscn") as PackedScene
@export var bulletPrefab : PackedScene;

@export var animator : AnimationPlayer;
@export var shootSFX : AudioStreamPlayer3D;
@export var clickSFX : AudioStreamPlayer3D;



var currentMagazine : Magazine;


const BULLET_SPEED = 100.0;


func _ready():
	currentMagazine = magazinePrefab.instantiate() as Magazine;

#this is how we handle trigger input on VR controller
func action():
	Shoot();

func Shoot():
	if animator.is_playing():
		return;
	
	if (currentMagazine.HasAmmo()):
		FireBullet();
		shootSFX.play();
		animator.play("Shoot");
		EjectCasing();
		currentMagazine.ammo -= 1;
	else:
		clickSFX.play();
		animator.play("Empty");
		
	
func FireBullet():
	if bulletPrefab != null:
		var tempPrefab = bulletPrefab.instantiate() as Bullet;
		#adds it to our scene
		add_child(tempPrefab);
		
		tempPrefab.transform = $BulletSpawn.global_transform;
		tempPrefab.linear_velocity = tempPrefab.transform.basis.z * BULLET_SPEED;


func EjectCasing():
	if casingPrefab != null:
		var tempPrefab = casingPrefab.instantiate() as Casing;
		add_child(tempPrefab);
		
		tempPrefab.transform = $Pistol/Pistol/slide/CasingSpawn.global_transform;
		tempPrefab.get_child(0);
		#tempPrefab.GetChild(0).linear_velocity = tempPrefab.transform.basis.y * 10.0;
