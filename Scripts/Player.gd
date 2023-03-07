extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var jumpForce := 3
export var gravity := 10
export var moveSpeed := 10

var snapVector := Vector3.DOWN
var velo := Vector3.ZERO

var material : SpatialMaterial = null

const moveDistance := 1.8
var currentLane := 0

var collider_height
var mesh_height
export var roll_timer = 1
var death_timer = 0

signal player_died
var anim: AnimationNodeStateMachinePlayback

# Called when the node enters the scene tree for the first time.
func _ready():
	material = $Mesh.get("material/0").duplicate()
	$Mesh.set("material/0", material)
	collider_height = $Collider.scale.y
	print(collider_height)
	mesh_height = $Mesh.scale.z
	anim = $Player/AnimationTree.get("parameters/playback")
	anim.start("Janglu_Run")
	 # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var moveLeft: bool = Input.is_action_just_pressed("ui_left")
	var moveRight: bool = Input.is_action_just_pressed("ui_right")
	
	var _just_landed := is_on_floor() and snapVector == Vector3.ZERO
	var _is_jumping := is_on_floor() and Input.is_action_just_pressed("ui_up")
	var _is_rolling := is_on_floor() and Input.is_action_just_pressed("ui_down")
	
	velo.y -= gravity * delta
	#Jump
	if _is_jumping:
		anim.travel("Jump")
		velo.y = sqrt (gravity * jumpForce)
		snapVector = Vector3.ZERO
		
	elif _just_landed:
		anim.travel("Run")
		snapVector = Vector3.DOWN
	elif _is_rolling:
		anim.travel("Slide")
		$Collider.set("height", collider_height/2)
		$Mesh.scale.z = mesh_height/2
		roll_timer = 1
	elif !_is_rolling and roll_timer <= 0:
		anim.travel("Run")
		$Collider.set("height", collider_height)
		$Mesh.scale.z = mesh_height
		roll_timer = 1
		
		

#Lane Handling
	if currentLane == 0:
		transform.origin = lerp(transform.origin, Vector3(0,velo.y,0), 0.2)
		if moveLeft:
			currentLane = -1
		elif moveRight:
			currentLane = 1
			
	elif currentLane == 1:
		transform.origin = lerp(transform.origin, Vector3(-moveDistance,velo.y,0), 0.2)
		if moveLeft:
			currentLane = 0
		elif moveRight:
			pass
	
	elif currentLane == -1:
		transform.origin = lerp(transform.origin, Vector3(moveDistance,velo.y,0), 0.2)
		if moveLeft:
			pass
		elif moveRight:
			currentLane = 0
	
	velo = move_and_slide_with_snap(velo, snapVector, Vector3.UP, true)

func _process(delta):
	roll_timer -= delta
	if is_on_wall():
		material = $Mesh.get("material/0")
		material.albedo_color = Color.red
		death_timer += delta * 10
		if death_timer > 0.5:
			print("Dead")
			emit_signal("player_died")
		
	else: 
		death_timer = 0
		material = $Mesh.get("material/0")
		material.albedo_color = Color.lightblue
	$Mesh.set("material/0", material)
	
