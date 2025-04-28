extends Node

var complete: bool = false
@export var targets: Array[Node] = []
@export var target_order: bool = false #if it matters the order the targets are hit
var target_index: int = 0 #for ordered mode
var successful_hits = 0
@export var levelNum : int;

var isActive : bool = false;

#when all targets are hit, the level is complete
func _ready():
	#might want to change this to have better organization
	#for child in get_children():
	#	if child.is_in_group("SHOOTABLE"):
	#		targets.append(child)
	
	#GameManager.levels[levelNum] = self;
	
	#if GameManager.lvl_current != levelNum:
		#queue_free();
	
	for target_node in targets:
		var target = target_node as Target;
		if target != null:
			target.target_hit.connect(_on_target_hit)
			
func _process(delta: float) -> void:
	if isActive and !complete:
		GameManager.timer += delta;
		print("Timer: " + str(GameManager.timer));

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
		#GameManager.Get_Gun().SetText("You completed level" + str(GameMaster.lvl_current) + "!");
		#good 'ole format specifiers
		GameManager.Get_Gun().SetText("You completed the level in %.2f seconds!" % GameManager.timer);
		GameMaster.complete_level();
		
		if GameManager.lvl_current < 2:
			await get_tree().create_timer(3.0).timeout;
			var nextLevelTarget = GameManager.nextLevelTargetPrefab;
			var nextLevelTargetInstance = nextLevelTarget.instantiate();
			get_tree().get_root().add_child(nextLevelTargetInstance);
		else:
			await get_tree().create_timer(5.0).timeout;
			GameManager.Get_Gun().SetText("Congratulations, you beat the game!");
