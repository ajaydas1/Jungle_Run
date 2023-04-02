extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal gameStarted
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	$Score.set("text", Highscore.score as String)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	if Input.is_action_just_released("ui_select") and get_parent().get_node("MainUI").visible == true:
		_on_Run_pressed()
	
	if Input.is_action_just_released("ui_cancel") and get_parent().get_node("MainUI").visible == true:
		_on_Quit_pressed()
func _on_Run_pressed():
	visible = false
	get_parent().get_node("OnScreenUI").visible = true
	emit_signal("gameStarted")


func _on_Quit_pressed():
	get_tree().quit()
