extends Node

# Default game port
const PORT = 8080
const MAX_PLAYERS = 4


onready var player_scene = preload("res://scenes/player.tscn")


signal game_started()
signal game_ended(msg)
signal waiting_for_players()
signal player_list_updated(players)
signal player_killed(killed_id, killer_id)


var game_started = false
# Current player name, note that this value will be different on
# each peer
var player_nickname = "Player"
# Store players id and name here
var players = {}


func _update_scoresboard():
	# Retrieve each player node and extract it score and nickname
	var text_scores = ""
	for player in get_node("/root/Arena/Players").get_children():
		text_scores += "%s %s\n" % [player.nickname, player.score]
	get_node("/root/Arena/ScoresBoard").text = text_scores


func _player_killed(killed_id, killer_id):
	# Retrieve the player node and update is score
	var player_node = get_node("/root/Arena/Players/%s" % killer_id)
	if killed_id != killer_id:
		player_node.score += 100
	else:
		# Suicide doesn't give any point
		player_node.score -= 50
	_update_scoresboard()


func _ready():
	connect("player_killed", self, "_player_killed")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func _player_connected(id):
	# Each peer will get this notification so we could use it to
	# register the new player here (and the new player can also
	# register the existing players this way).
	# However we would only get the players id where we also need
	# their nicknames...
	pass


func _player_disconnected(id):
	# Each peer get this notification when a peer diseapers,
	# so we remove the corresponding player data.
	var player_node = get_node("/root/Arena/Players/%s" % id)
	if player_node:
		# If we have started the game yet, the player node won't be present
		player_node.queue_free()
	players.erase(id)
	emit_signal("player_list_updated", players)


func _connected_ok():
	# This method is only called from the newly connected
	# client. Hence we register ourself to the server.
	var player_id = get_tree().get_network_unique_id()
	# Note given this call
	rpc("register_player_to_server", player_id, player_nickname)
	# Now just wait for the server to start the game
	emit_signal("waiting_for_players")


func _connected_fail():
	_stop_game("Cannot connect to server")


func _server_disconnected():
	_stop_game("Server connection lost")


slave func _kicked_by_server(reason):
	_stop_game(reason)


master func register_player_to_server(id, name):
	# As server, we notify here if the new client is allowed to join the game
	if game_started:
		rpc_id(id, "_kicked_by_server", "Game already started")
	elif len(players) == MAX_PLAYERS:
		rpc_id(id, "_kicked_by_server", "Server is full")
	# Send to the newcomer the already present players
	for p_id in players:
		rpc_id(id, "register_player", p_id, players[p_id])
	# Now register the newcomer everywhere, note the newcomer's peer will
	# also be called
	rpc("register_player", id, name)
	# register_player is slave, so rpc won't call it on our peer
	# (of course we could have set it sync to avoid this)
	register_player(id, name)


slave func register_player(id, name):
	players[id] = name
	emit_signal("player_list_updated", players)


func host_game(name):
	# We are the server
	var host = NetworkedMultiplayerENet.new()
	host.create_server(PORT)
	get_tree().set_network_peer(host)
	player_nickname = name
	# First player is ourself
	# Note we don't call register_player as rpc given no client are
	# connected for the moment
	register_player(1, name)
	emit_signal("waiting_for_players")


func join_game(ip, nickname):
	# We are a client, thus we should wait for connection with the
	# server before starting the game
	player_nickname = nickname
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, PORT)
	get_tree().set_network_peer(host)
	# Note we wait for server to respond before sending
	# waiting_for_players signal


sync func start_game():
	# Load the main game scene
	var arena = load("res://scenes/arena.tscn").instance()
	get_tree().get_root().add_child(arena)
	var spawn_positions = arena.get_node("SpawnPositions").get_children()
	# Populate each player
	var i = 0
	for p_id in players:
		var player_node = player_scene.instance()
		player_node.set_name(str(p_id))  # Useful to retrieve the player node with a node path
		player_node.id = p_id
		player_node.nickname = players[p_id]
		# Configure player color and initial position according to it
		# order in the list
		player_node.spawn_pos = spawn_positions[i].position
		player_node.position = spawn_positions[i].position
		player_node.color_index = i
		# Don't forget to specify that a player should is
		# controlled by it corresponding peer
		player_node.set_network_master(p_id)
		arena.get_node("Players").add_child(player_node)
		i += 1
	_update_scoresboard()
	# Finally send signal to hide the lobby
	game_started = true
	emit_signal("game_started")


func _stop_game(msg):
	# Destroy networking system
	get_tree().set_network_peer(null)
	# Remove the arena scene and forget about the players
	players.clear()
	if game_started:
		get_node("/root/Arena").queue_free()
	game_started = false
	emit_signal("game_ended", msg)
