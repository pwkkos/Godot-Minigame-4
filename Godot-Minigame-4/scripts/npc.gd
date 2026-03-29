extends RigidBody3D

# step 12: make these all tune-able in the Inspector
@export var throwPower: float = 1.0
@export var speed: float = 1.0
@export var maxDistance: float = 2.0
@export var throwFrequency: float = 3.0

@onready var ballScene = preload("res://scenes/ball.tscn")

var ball

var distance: float = 0.0
var xDir: float = 1.0
var points: int = 0
# step 13: add a time variale
var _timer: float = 0.0


# step 4: uncomment the function below

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 3
	
	ball = get_node("Ball")
	ball._pickup()

func _physics_process(delta: float) -> void:
	var movement = speed * delta
	position.x += movement * xDir
	
	distance += movement
	if distance > maxDistance:
		xDir *= -1.0
		distance = 0.0
		
	# step 14: use the delta variable to keep a timer
	# when the timer runs out, have the NPC throw a ball
	_timer += delta
	if _timer > throwFrequency:
		_throw_ball()
		_timer = 0.0

func _throw_ball() -> void:
	if ball == null:
		return

# remove ball from parent while preserving position
	var originalPos = ball.get_global_position()
	remove_child(ball)
	get_parent().add_child(ball)
	ball.set_global_position(originalPos)
	
	# throw ball
	ball._throw(throwPower, 1)
	
	# get a new ball
	var newBall = ballScene.instantiate()
	add_child(newBall)
	newBall._pickup()
	ball = newBall


# step 15: uncomment the function below
func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Ball:
		_hitByBall() 

# step 16: create the _hitByBall() function below here
func _hitByBall() -> void:
	points += 1
	%PointsLabel.text = str(points)
