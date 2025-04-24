extends XRToolsPickable

class_name Gun

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
