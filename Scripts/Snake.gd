extends Node2D

@export var speed = 16
@export var segment_size = 16
@export var segment_color = Color.WHITE

var direction = Vector2.RIGHT
var body = []
var grow_snake = false

func _ready():
	# Clear body segments if reinitializing
	for segment in body:
		remove_child(segment)
		segment.queue_free()

	body.clear()
	self.position = Vector2(160, 160) # Reset initial position
	var head_segment = create_segment(self.position)
	body.append(head_segment)
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_pressed("ui_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT

func move():
	var new_head_position = self.position + direction * speed
	
	# Check collision with screen borders
	if new_head_position.x < segment_size or new_head_position.x >= 320 - segment_size or new_head_position.y < segment_size or new_head_position.y >= 320 - segment_size:
		print("Collision with border at: ", new_head_position)
		get_parent().game_over()
		return

	var new_head_segment = create_segment(new_head_position)
	body.insert(0, new_head_segment)
	self.position = new_head_position
	print("Moving to position: ", new_head_position)

	if not grow_snake:
		var tail_segment = body.pop_back()
		remove_child(tail_segment)
		tail_segment.queue_free()
	else:
		grow_snake = false

	for segment in body:
		print("Segment position: ", segment.position)

	queue_redraw()

func grow():
	print("Growing snake")
	grow_snake = true

func check_collision(screen_width, screen_height):
	if position.x < segment_size or position.x >= screen_width - segment_size or position.y < segment_size or position.y >= screen_height - segment_size:
		return true
	for segment in body.slice(1):  # Slicing the body to exclude the head
		if position == segment.position:
			return true
	return false

func check_berry_collision(berry_position):
	return position == berry_position

func create_segment(position):
	var segment = Node2D.new()
	segment.position = position
	add_child(segment)
	return segment

func _draw():
	for segment in body:
		draw_rect(Rect2(segment.position - self.position, Vector2(segment_size, segment_size)), segment_color)
