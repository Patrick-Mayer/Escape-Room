extends XRToolsPickable

class_name Magazine

@export var ammo: float = 10;
@export var max_ammo: float = 10
@export var regenerate_rate: float = 2

func HasAmmo():
	return (ammo > 0);
	
	
func _ready():
	pass
