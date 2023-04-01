extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var jumpHeight : float
export var jump_peak_time : float
export var jump_decend_time : float

onready var jump_velocity : float = (2.0 * jumpHeight) / jump_peak_time
onready var jump_gravity : float = (-2.0 * jumpHeight) / (jump_peak_time * jump_peak_time)
onready var fall_gravity : float = (-2.0 * jumpHeight) / (jump_decend_time * jump_decend_time)

var snapVector := Vector3.DOWN
var velo := Vector3.ZERO

var material : SpatialMaterial = null

const moveDistance := 1.8
var currentLane := 0

#var collider_height
export var roll_timer = 1
var death_timer = 0

signal player_died
var anim: AnimationNodeStateMachinePlayback
var gameStarted:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $Player/AnimationTree.get("parameters/playback")
	anim.start("Idle")
	 # Replace with function body.

func get_gravity() -> float:
	return jump_gravity if velo.y > 0 else fall_gravity



func _physics_process(delta: float) -> void:
	if gameStarted:
		var moveLeft: bool = Input.is_action_just_pressed("ui_left") 
		var moveRight: bool = Input.is_action_just_pressed("ui_right") 
		
		var _just_landed := is_on_floor() and snapVector == Vector3.ZERO
		var _is_jumping : bool = is_on_floor() and (Input.is_action_just_pressed("ui_up"))
		var _is_rolling : bool = is_on_floor() and (Input.is_action_just_pressed("ui_down"))
		
		get_parent().get_node("Camera").transform.origin.x = transform.origin.x
		velo.y += get_gravity() * delta
		#Jump
		if _is_jumping:
			anim.travel("Jump")
			$voice/jump.play()
			velo.y = jump_velocity
			snapVector = Vector3.ZERO
			
		elif _just_landed:
			anim.travel("Run")
			snapVector = Vector3.DOWN
		elif _is_rolling:
			anim.travel("Slide")
			roll_timer = 1
			$head.disabled = true
		elif !_is_rolling:
			roll_timer -= delta
			if roll_timer <= 0:
				$head.disabled = false
				anim.travel("Run")
			
			

	#Lane Handling
		if currentLane == 0:
			transform.origin = lerp(transform.origin, Vector3(0,velo.y,0), 0.2)
			if moveLeft:
				currentLane = -1
				$voice/dodge.play()
			elif moveRight:
				currentLane = 1
				$voice/dodge.play()
				
		elif currentLane == 1:
			transform.origin = lerp(transform.origin, Vector3(-moveDistance,velo.y,0), 0.2)
			if moveLeft:
				currentLane = 0
				$voice/dodge.play()
			elif moveRight:
				pass
		
		elif currentLane == -1:
			transform.origin = lerp(transform.origin, Vector3(moveDistance,velo.y,0), 0.2)
			if moveLeft:
				pass
			elif moveRight:
				currentLane = 0
				$voice/dodge.play()
		
		velo = move_and_slide_with_snap(velo, snapVector, Vector3.UP, true)

func _process(delta):

	if is_on_wall() or global_transform.origin.y < 0:
		material = $Mesh.get("material/0")
		material.albedo_color = Color.red
		death_timer += delta * 10
		if death_timer > 0.5 or global_transform.origin.y < 0:
			gameStarted = false
			emit_signal("player_died")
			
		
	else: 
		death_timer = 0
		material = $Mesh.get("material/0")
		material.albedo_color = Color.lightblue
	$Mesh.set("material/0", material)
	


func _on_MainUI_gameStarted():
	gameStarted = true
	anim.travel("Run")
	pass # Replace with function body.



