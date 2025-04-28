extends XRToolsPickable

class_name Magazine

@export var ammo: float = 20;
@export var max_ammo: float = 20
@export var regenerate_rate: float = 1		#smaller number means faster regen

func HasAmmo():
	return (ammo > 0);
	
	
func _ready():
	pass
