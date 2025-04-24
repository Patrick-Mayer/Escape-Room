extends Node

var complete: bool = false
var targets: Array[Node] = []
var target_order: bool = false #if it matters the order the targets are hit
var target_index: int = 0 #for ordered mode

#when all targets are hit, the level is complete
func _ready():
	#might want to change this to have better organization
	for child in get_children():
		if child.is_in_group("target"):
			targets.append(child)
	for target in targets:
		target.connect("hit", Callable(self, "_on_target_hit"))

func _on_target_hit(target):
	if complete:
		return

	if target_order:
		if targets[target_index] != target:
			print("Wrong target hit! Waiting for the correct one.")
			return
		target_index += 1
	else:
		targets.erase(target)

	if (target_order and target_index >= targets.size()) or (not target_order and targets.is_empty()):
		complete = true
		GameMaster.CompleteLevel()
