extends Node2D

onready var asteroid = preload("res://scenes/asteroid.tscn")

onready var player = get_node("player")
onready var score_text = get_node("CanvasLayer/score")
onready var retry_text = get_node("CanvasLayer/retry")
onready var spawn_timer = get_node("spawn_timer")

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

var score = 0
var is_game_over = false


func _ready():
	player.connect("destroyed", self, "_on_player_destroyed")
	pass


func _on_spawn_timer_timeout():
	# When the spawn timer finishes we create a new asteroid instance and
	# place it to the right just outside of the screen. We also need to
	# connect to the score signal of the asteroid to be notified if the player
	# destroyed the asteroid.
	var asteroid_instance = asteroid.instance()
	asteroid_instance.position = Vector2(SCREEN_WIDTH + 16, rand_range(16, SCREEN_HEIGHT - 16))
	asteroid_instance.connect("score", self, "_on_player_score")
	
	# We can make the game harder by changing the values below:
	#asteroid_instance.health = 4
	#asteroid_instance.speed = 50.0
	#spawn_timer.wait_time = 0.01
	
	add_child(asteroid_instance)
	pass


func _on_player_score():
	# When the player's ship is destroyed show the game over text and
	# allow player to restart the stage by pressing escape
	score += 1
	score_text.text = "Score: " + str(score)
	pass


func _on_player_destroyed():
	# When the player's ship is destroyed show the game over text and
	# allow player to restart the stage by pressing escape
	retry_text.show()
	is_game_over = true
	pass


func _input(event):
	# If the game is over and we press escape we restart the stage
	if is_game_over and Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene("res://stage.tscn")
	pass
