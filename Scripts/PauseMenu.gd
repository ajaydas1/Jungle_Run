extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gamestart: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	gamestart = false
	$Menu/Resume.grab_focus()
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("pause") and $"../DeadScreen".visible == false and gamestart:
		toggle_pause_menu()



func _on_Resume_pressed():
	toggle_pause_menu()

	
func toggle_pause_menu():
	var pause_screen = not get_tree().paused
	$Menu/Resume.grab_focus()
	get_tree().paused = pause_screen
	visible = pause_screen


func _on_MainMenu_pressed():
	get_parent().get_node("OnScreenUI").visible = false
	get_tree().reload_current_scene()
	
func _on_Quit_pressed():
	get_tree().quit()



func _on_PauseButton_pressed():
	toggle_pause_menu()
	pass # Replace with function body.


func _on_MainUI_gameStarted():
	gamestart = true
	pass # Replace with function body.
