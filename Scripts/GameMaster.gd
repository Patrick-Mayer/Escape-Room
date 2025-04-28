extends Node

class_name GameMaster

static var timer: int = 0
static var shots: int = 0
static var hits: int = 0
static var lvl_current: int = 0
static var lvl_cleared: int = 0
static var score: int = 0
static var gun: Node;

#hardcoding it cause we have 1 day left
static var levels: Array[Node] = [null, null, null];

func _ready():
	pass;
	#gun = get_tree().get_root().find_child("Pistol")

static func complete_level():
	lvl_current += 1
	lvl_cleared += 1
	#get_node("Pistol").SetText("You completed level soometying" + "!");

static func Get_Gun():
	return gun;
