extends CharacterBody2D
@export var movement_speed : float
var force_coefficient = 20
var apply_gravity : bool
var gravity = ProjectSettings.get("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	if self.motion_mode == 0: # Motion Mode 0 is for "grounded", which is like a platformer
		apply_gravity = true
	else: 
		apply_gravity = false # Motion Mode 1 is for "floating", which is for top-down games
	pass # Replace with function body.

func get_input(delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if apply_gravity:
		velocity.x = input_direction.x * movement_speed
		velocity.y += gravity * delta
	else:
		velocity = input_direction * movement_speed




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input(delta)

	var pre_collision_velocity
	pre_collision_velocity = velocity # velocity goes to 0,0 when we collide, which is why we record the velocity prior to the move_and_slide() func call
	move_and_slide()

	for i in get_slide_collision_count():
		var collision : KinematicCollision2D = get_slide_collision(i)

		if collision.get_collider().get_class() == "RigidBody2D":
			var collision_normal = collision.get_normal()
			if collision_normal.x < 0 and pre_collision_velocity.x > 0:
				collision_normal.x = -collision_normal.x
			if collision_normal.y < 0 and pre_collision_velocity.y > 0:
				collision_normal.y = -collision_normal.y
			collision.get_collider().apply_force(pre_collision_velocity * collision_normal * force_coefficient)

		



func _on_background_tilemap_child_entered_tree(node):

	pass # Replace with function body.


func _on_foreground_tilemap_child_entered_tree(node):
	show()
	pass # Replace with function body.


func _on_static_body_2d_child_exiting_tree(node):
	hide()
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	show()
	pass # Replace with function body.
