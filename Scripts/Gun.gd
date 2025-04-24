extends XRToolsPickable

class_name Gun

@export var casingPrefab : PackedScene;
@export var magazinePrefab : PackedScene;

@export var animator : AnimationPlayer;
@export var shootSFX : AudioStreamPlayer3D;
@export var clickSFX : AudioStreamPlayer3D;



var currentMagazine : Magazine;


func _ready():
	var currentMagazine = magazinePrefab.instantiate() as Magazine;


func Shoot():
	if animator.is_playing():
		return;
	
	if (currentMagazine.HasAmmo()):
		#fire projectile
		shootSFX.play();
		EjectCasing();
		currentMagazine.ammo -= 1;
	else:
		clickSFX.play();
		
	
func EjectCasing():
	if casingPrefab != null:
		var tempPrefab = casingPrefab.instantiate() as Casing;
		#adds it to our scene
		add_child(tempPrefab);
		
		tempPrefab.transform = $Pistol/Pistol/slide/CasingSpawn.global_transform;
		tempPrefab.linear_velocity = tempPrefab.transform.basis.y * 10.0;

#this is how we handle trigger input on VR controller
func action():
	pass
