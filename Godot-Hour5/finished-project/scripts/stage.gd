extends Node2D

var asteroid = preload("res://scenes/asteroid.tscn")

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180

var score = 0
var is_game_over = false


func _ready():
	# Make it so that the pseudo-random number generator produces a different
	# number sequence each time the game starts
	randomize()
	
	# Connect to the player ship's destroyed signal to be notified when to
	# show the game-over screen
	get_node("player").connect("destroyed", self, "_on_player_destroyed")
	get_node("spawn_timer").connect("timeout", self, "_on_spawn_timer_timeout")


func _input(event):
	# If the escape key is pressed we quit the game to desktop
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	# If the game is over and we press escape we restart the stage
	if is_game_over and Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://scenes/stage.tscn")


func _on_player_destroyed():
	# When the player's ship is destroyed show the game over text and
	# allow player to restart the stage by pressing escape
	get_node("ui/retry").show()
	is_game_over = true


func _on_spawn_timer_timeout():
	# When the spawn timer finishes we create a new asteroid instance and
	# place it to the right just outside of the screen. We also need to
	# connect to the score signal of the asteroid to be notified if the player
	# destroyed the asteroid.
	var asteroid_instance = asteroid.instance()
	asteroid_instance.position = Vector2(SCREEN_WIDTH + 8, rand_range(0, SCREEN_HEIGHT))
	asteroid_instance.connect("score", self, "_on_player_score")
	add_child(asteroid_instance)


func _on_player_score():
	# When the player's ship destroys an asteroid increase the score and update
	# the UI to reflect the score change
	score += 1
	get_node("ui/score").text = "Score: " + str(score)
