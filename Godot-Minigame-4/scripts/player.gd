extends CharacterBody3D

@export var throwPower: float = 1.0
@export var speed: float = 5.0
@export var jump: float = 4.5

# step 1: add member variables for ball and points here
var ball
var points: int = 0


# step 2: uncomment the function below

func _ready() -> void:
# step 3: find the ball Node
	ball = get_node("Ball")
	ball._pickup()



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()

	# step 8: uncomment the code below to handle collisions
	
	var collision_info = move_and_collide(velocity * delta, true)
	if collision_info:
		var obj = collision_info.get_collider()
		if obj is Ball:
			# step 9: add if statement here
			if obj.on_ground:
				_pickup_ball(obj)
			else:
				_hit(obj)
	
	# handle mouse click
	if Input.is_action_just_pressed("left_mouse_button"):
		_throw_ball()


# step 6: uncomment the function below

func _hit(obj: Ball) -> void:
	points -= 1
	print(points)
	
	# delete the ball
	obj.queue_free()
	
	# step 11: update the points text
	%PointsLabel.text = str(points)

func _pickup_ball (obj: Ball) -> void:
	# don't pick up a new ball if we already have one
	if ball != null:
		return
	
	# change ball parent
	obj.get_parent().remove_child(obj)
	add_child(obj)
	obj._pickup()
	
	# save reference to new ball
	ball = obj


func _throw_ball() -> void:
	print("throw")
	# step 7: uncomment the body of this function
	
	# don't try to throw the ball if we don't have one!
	if ball == null:
		return
	
	# remove ball from parent while preserving position
	var originalPos = ball.get_global_position()
	remove_child(ball)
	get_parent().add_child(ball)
	ball.set_global_position(originalPos)
	
	# throw ball
	ball._throw(throwPower, -1)
	
	# let go of our reference to the ball
	ball = null
	
