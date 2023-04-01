extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var AllChunks = []
var currentChunks:= []

export var Speed := 20
export var ChunkCount := 4

var chunkPath: String = "res://Chunks"
var score
var dead
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/Player.visible = true
	$Player/Player/Janglu_Rig/Skeleton.physical_bones_stop_simulation()
	$DeadScreen.visible = false
	score = 0
	dead = false
	load_chunks(chunkPath)
	
	print(AllChunks)
	var start = $ChunkStart
	currentChunks.append(start)
	spawn_chunks()
		
func _physics_process(delta):
	if $MainUI.visible == false and dead == false:
		score += delta
		score = ceil(score)
		$OnScreenUI/Score.set("text", "Score: " + score as String)
	
		spawn_chunks()
		for block in currentChunks:
			block.transform.origin.z -= Speed * delta
		
	if dead:
		$Player.rotate_object_local(Vector3.UP, 2.0 * delta)
		if $Player.transform.origin.y < 3.5:
			$Player.transform.origin.y += delta * 2
		

func spawn_chunks():
		#Delete old Chunk
	if currentChunks[0].transform.origin < Vector3(0,0,-100):
		var delchunk = currentChunks.pop_front()
		print(delchunk.name)
		delchunk.queue_free()
	
	if currentChunks.size() < ChunkCount:
		var newBlock = load(AllChunks[randi() % AllChunks.size()]).instance()
		add_child(newBlock)
		newBlock.transform.origin.z = currentChunks[currentChunks.size()-1].get_node("ChunkEnd").global_transform.origin.z
		print(currentChunks[currentChunks.size()-1].get_node("ChunkEnd").transform.origin.z, newBlock.global_transform.origin.z)
		currentChunks.append(newBlock)



func load_chunks(targetPath: String) -> void:
	var dir = Directory.new()
	dir.open(targetPath)
	if dir:
		dir.list_dir_begin(true,true)
		var filename = dir.get_next()
		while filename != "":
			print(filename)
			AllChunks.append(targetPath+"/" +filename)
			filename = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_player_died():
	var deadboi = load("res://Characters/Dead.tscn").instance()
	deadboi.scale *= 1.5
	$Player.add_child(deadboi)
	
	
	#$Player/Player/Janglu_Rig/Skeleton.physical_bones_start_simulation()
	$Player/Player.visible = false
	$DeadScreen.visible = true
	$OnScreenUI.visible = false
	$DeadScreen/Score.text = score as String
	dead = true
	Speed = 0
	
	if score > Highscore.score:
		Highscore.set_score(score)
	pass # Replace with function body.
