extends Node

class_name GameMaster

static var timer: int = 0
static var shots: int = 0
static var hits: int = 0
static var lvl_current: int = 0
static var lvl_cleared: int = 0
static var score: int = 0

static func complete_level():
	lvl_current += 1
	lvl_cleared += 1
	pass
