extends Node2D

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 320

@export var snake_scene: PackedScene
@export var berry_scene: PackedScene

var snake
var berry
var score = 0
var is_game_over = false
var game_over_label

func _ready():
	randomize()
	create_walls()

	snake = snake_scene.instantiate()
	add_child(snake)
	snake.position = Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	print("Snake initialized at position: ", snake.position)

	spawn_berry()

	game_over_label = Label.new()
	game_over_label.text = "Game Over"
	game_over_label.visible = false
	game_over_label.set_position(Vector2(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT / 2 - 10))
	add_child(game_over_label)

	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	timer.start()

func create_walls():
	var top_wall = ColorRect.new()
	top_wall.color = Color.BLACK
	top_wall.position = Vector2(0, 0)
	top_wall.size = Vector2(SCREEN_WIDTH, 16)
	add_child(top_wall)

	var bottom_wall = ColorRect.new()
	bottom_wall.color = Color.BLACK
	bottom_wall.position = Vector2(0, SCREEN_HEIGHT - 16)
	bottom_wall.size = Vector2(SCREEN_WIDTH, 16)
	add_child(bottom_wall)

	var left_wall = ColorRect.new()
	left_wall.color = Color.BLACK
	left_wall.position = Vector2(0, 0)
	left_wall.size = Vector2(16, SCREEN_HEIGHT)
	add_child(left_wall)

	var right_wall = ColorRect.new()
	right_wall.color = Color.BLACK
	right_wall.position = Vector2(SCREEN_WIDTH - 16, 0)
	right_wall.size = Vector2(16, SCREEN_HEIGHT)
	add_child(right_wall)

func spawn_berry():
	if berry != null:
		remove_child(berry)
		berry.queue_free()

	berry = berry_scene.instantiate()
	add_child(berry)
	berry.position = Vector2(randi() % ((SCREEN_WIDTH - 32) / 16) * 16 + 16, randi() % ((SCREEN_HEIGHT - 32) / 16) * 16 + 16)
	print("Berry initialized at position: ", berry.position)

func _process(delta):
	if is_game_over:
		return

	if snake.check_berry_collision(berry.position):
		score += 1
		print("Berry eaten at position: ", berry.position)
		snake.grow()
		spawn_berry()

	if snake.check_collision(SCREEN_WIDTH, SCREEN_HEIGHT):
		is_game_over = true
		game_over()

func _on_Timer_timeout():
	snake.move()

func game_over():
	print("Game over, Score: ", score)
	game_over_label.visible = true
	get_tree().paused = true
