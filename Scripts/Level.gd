#! Fix issue with line 18, target_noode as Target, and also put SetText() in the proper place

extends Node

var complete: bool = false
@export var targets: Array[Node] = []
@export var target_order: bool = false #if it matters the order the targets are hit
var target_index: int = 0 #for ordered mode
var successful_hits = 0

#when all targets are hit, the level is complete
func _ready():
	#might want to change this to have better organization
	#for child in get_children():
	#	if child.is_in_group("SHOOTABLE"):
	#		targets.append(child)
	for target_node in targets:
		var target = target_node #as Target
		if target != null:
			target.target_hit.connect(_on_target_hit)

func _on_target_hit(target):
	if complete:
		return
		
	if not targets.has(target):
		print("Target not recognized.")
		return
		
	if target.hasBeenHit:
		return
		
	GameManager.hits += 1;
	
	if target_order:
		if targets[target_index] != target:
			print("Wrong target hit! Waiting for the correct one.")
			return
		target_index += 1
		target.finalize_hit()
	else:
		successful_hits += 1
		target.finalize_hit()

	if (target_order and target_index >= targets.size()) or (not target_order and successful_hits >= targets.size()):
		complete = true
		get_node("Pistol").SetText("You completed level soometying" + "!");
		GameMaster.complete_level()
