#Last minute things to do:
#2. Make level with moving targets (not circles though, that's an AL job if he wants to try and cram that in there last min)
#5. Tutorial text over NextLevelTarget
#6. Audiosource SFX for hitting target
#7. Export project

extends Node

class_name GameMaster

static var timer: float = 0
static var shots: int = 0
static var hits: int = 0
static var lvl_current: int = -1
static var lvl_cleared: int = 0
static var score: int = 0
static var gun: Node;

static var nextLevelTargetPrefab : PackedScene = preload("res://Prefabs/NextLevelTarget.tscn");

var tutorialLevel : PackedScene = preload("res://Prefabs/tutorialLevel.tscn");
var level1 : PackedScene = preload("res://Prefabs/level1.tscn");
var level2 : PackedScene = preload("res://Prefabs/level2.tscn");


#hardcoding it cause we have 1 day left
static var levels: Array[PackedScene] = [null, null, null];

func _ready():
	levels[0] = tutorialLevel;
	levels[1] = level1;
	levels[2] = level2;
	#gun = get_tree().get_root().find_child("Pistol")

static func complete_level():
	#lvl_current += 1
	lvl_cleared += 1
	timer = 0;
	#get_node("Pistol").SetText("You completed level soometying" + "!");

static func Get_Gun():
	return gun;
