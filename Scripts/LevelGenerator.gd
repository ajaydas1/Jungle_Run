extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var AllChunks = []
var currentChunks:= []

export var Speed := 10
export var ChunkCount := 4

var chunkPath: String = "res://Chunks"
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	load_chunks(chunkPath)
	print(AllChunks)
	var start = load("res://StartChunk.tscn").instance()
	add_child(start)
	currentChunks.append(start)
		
func _physics_process(delta):
	
	score += delta
	score = ceil(score)
	$Score.set("text", "Score: " + score as String)
	
	
	for block in currentChunks:
		block.transform.origin.z -= Speed * delta
		
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
