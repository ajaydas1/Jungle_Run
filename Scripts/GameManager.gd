extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/Resume.grab_focus()
	get_tree().paused = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause_menu()



func _on_Resume_pressed():
	print("Pressed")
	if not is_dead:
		toggle_pause_menu()
	elif is_dead:
		toggle_pause_menu()
		get_tree().reload_current_scene()
	
func toggle_pause_menu():
	var pause_screen = not get_tree().paused
	get_tree().paused = pause_screen
	visible = pause_screen


func _on_MainMenu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Player_script_changed():
	
	pass # Replace with function body.


func _on_Player_player_died():
	is_dead = true
	$Menu/Resume.text = "Restart"
	toggle_pause_menu()
	
