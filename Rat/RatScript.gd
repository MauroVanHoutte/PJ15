extends Node2D
@onready var NavAgent : NavigationAgent2D = $NavigationAgent2D
@onready var SpriteRoot : Node2D = $SpriteRoot
@onready var RatFur : Sprite2D = $SpriteRoot/Fur
@onready var RatStatic : Sprite2D = $SpriteRoot/Static
var movement_speed: float = 32
@export var rat_name : String = "UnnamedRat"

signal OnNameChanged

func _init():
	add_to_group("Rats")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if NavAgent.is_navigation_finished() :
		return
	
	var CurrentPos = global_position
	var NextPathPosition = NavAgent.get_next_path_position()
	var Direction = CurrentPos.direction_to(NextPathPosition)
	global_translate(Direction * movement_speed * delta)
	if (Direction.x > 0) :
		SpriteRoot.scale.x = 1
	else :
		SpriteRoot.scale.x = -1

func _input(event):
	if Input.is_action_just_pressed("RMB"):
		var MousePos = get_global_mouse_position()
		NavAgent.target_position = MousePos
