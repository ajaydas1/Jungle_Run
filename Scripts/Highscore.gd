extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const scorefile = "user://savedata.data" 
var score = 0 setget set_score
# Called when the node enters the scene tree for the first time.
func _ready():
	load_highscore()
	pass # Replace with function body.

func load_highscore():
	var file  = File.new()
	if not file.file_exists(scorefile): return
	file.open(scorefile, File.READ)
	score = file.get_var()
	file.close()
	pass
	
func save_highscore():
	var file = File.new()
	file.open(scorefile, File.WRITE)
	file.store_var(score)
	file.close()
	pass
	
func set_score(new_value):
	score = new_value
	save_highscore()
	pass
