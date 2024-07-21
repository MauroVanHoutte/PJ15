extends Control
@onready var RatNameLabel : Label = $HBoxContainer/TextBox/NameContainer/RatName
@onready var RatAssignmentLabel : Label = $HBoxContainer/TextBox/AssignmentContainer/RatAssignment
@onready var RatStatusLabel : Label = $HBoxContainer/TextBox/StatusContainer/RatStatus
@onready var HoverButton : Button = $Button
@onready var DetailWindow = $DetailWindow
@export var Rat : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if Rat :
		_set_rat_name()
		Rat.OnNameChanged.connect(_set_rat_name)
		var RatFur = $HBoxContainer/PanelContainer/RatFur
		RatFur.texture = Rat.RatFur.texture
		RatFur.modulate = Rat.RatFur.modulate
	HoverButton.mouse_entered.connect(_on_mouse_entered)
	HoverButton.mouse_exited.connect(_on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_rat_name():
	RatNameLabel.set_text(Rat.rat_name)
func _set_rat_status(RatStatus : String):
	RatStatusLabel.set_text(RatStatus)
func _set_rat_assignment(RatAssignment : String):
	RatAssignmentLabel.set_text(RatAssignment)

func _on_mouse_entered():
	DetailWindow.visible = true

func _on_mouse_exited():
	DetailWindow.visible = false
