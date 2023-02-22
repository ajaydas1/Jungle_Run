extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var AllChunks = []
var currentChunks:= []

export var Speed := 10
export var ChunkCount := 4

var chunkPath: String = "res://Chunks"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	load_chunks(chunkPath)
	print(AllChunks)
	var start = load("res://StartChunk.tscn").instance()
	add_child(start)
	currentChunks.append(start)
		
func _physics_process(delta):
	for block in currentChunks:
		block.transform.origin.z -= Speed * delta
		
		#Delete old Chunk
	if currentChunks[0].transform.origin < Vector3(0,0,-100):
		var delchunk = currentChunks.pop_front()
		print(delchunk.name)
		delchunk.queue_free()
	
	if currentChunks.size() < ChunkCount:
		var newBlock = load(AllChunks[randi() % AllChunks.size()]).instance()
		newBlock.transform.origin.z = currentChunks[currentChunks.size()-1].transform.origin.z + 50
		add_child(newBlock)
		currentChunks.append(newBlock)
			
func load_chunks(targetPath: String) -> void:
	var dir = Directory.new()
	dir.open(targetPath)
	if dir:
		dir.list_dir_begin(true,true)
		var filename = dir.get_next()
		while filename != "":
			AllChunks.append(targetPath+"/" +filename)
			filename = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
