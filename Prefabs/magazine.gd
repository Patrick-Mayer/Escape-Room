extends XRToolsPickable

class_name Magazine

var ammo = 10;

func HasAmmo():
	return (ammo > 0);
	
	
func _ready():
	pass
