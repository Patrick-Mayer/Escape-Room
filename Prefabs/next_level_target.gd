extends Node3D

class_name Next_Level_Target

func _ready():
	pass;
	#target_hit.connect(_on_target_hit);
		
func mark_hit():
	self.visible = false
	get_child(1).disabled = true
	
	GameManager.lvl_current += 1;
	var nextLevelScene = GameManager.levels[GameManager.lvl_current];
	var nextLevelInstance = nextLevelScene.instantiate();
	get_tree().get_root().add_child(nextLevelInstance);
