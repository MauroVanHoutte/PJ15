extends Control
@onready var RatList : VBoxContainer = $"TabContainer/All Rats/RatList"
@onready var OpenCloseButton : Button = $Button
var OpenCloseSpeed : float = 900
var ClosedXCoord : float = 432
var Open : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_post_ready")
	OpenCloseButton.toggled.connect(_button_toggled)

func _post_ready():
	var AllRats = get_tree().get_nodes_in_group("Rats")
	var RatInfoScene = load("res://PJ15/UI/RatInfo.tscn")
	for Rat in AllRats :
		var RatInfo : Control = RatInfoScene.instantiate()
		RatInfo.Rat = Rat
		RatList.add_child(RatInfo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Open :
		position.x = max(0, position.x - OpenCloseSpeed * delta)
	else :
		position.x = min(ClosedXCoord, position.x + OpenCloseSpeed * delta)

func _button_toggled(Pressed : bool):
	Open = !Pressed
	$Button.scale.x = -1 if Open else 1
