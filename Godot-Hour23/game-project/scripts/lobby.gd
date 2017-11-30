extends Control

onready var title_screen = get_node("PanelTitleScreen")
onready var wait_players_screen = get_node("PanelWaitPlayers")


func _ready():
	gamestate.connect("game_ended", self, "_reset_lobby")
	gamestate.connect("waiting_for_players", self, "_show_wait_players")
	gamestate.connect("game_started", self, "_hide_lobby")
	gamestate.connect("player_list_updated", self, "_update_player_list")


func _set_status(text):
	get_node("PanelTitleScreen/LabelStatus").text = text


func _update_player_list(players):
	var player_list = ""
	for p_id in players:
		player_list += "%s\n" % players[p_id]
	get_node("PanelWaitPlayers/LabelPlayerList").text = player_list
	get_node("PanelWaitPlayers/LabelPlayerCount").text = "%s/4" % len(players)


func _show_wait_players():
	# Only server can decide to start the game
	get_node("PanelWaitPlayers/ButtonStart").visible = is_network_master()
	get_node("PanelTitleScreen").hide()
	get_node("PanelWaitPlayers").show()


func _hide_lobby():
	hide()


func _reset_lobby(msg=""):
	show()
	title_screen.show()
	wait_players_screen.hide()
	get_node("PanelTitleScreen/ButtonHost").disabled = false
	get_node("PanelTitleScreen/ButtonJoin").disabled = false
	_set_status(msg)


func _on_ButtonHost_pressed():
	var name = get_node("PanelTitleScreen/PlayerName").get_text()
	if name == "":
		_set_status("Invalid name")
		return
	gamestate.host_game(name)


func _on_ButtonJoin_pressed():
	var ip = get_node("PanelTitleScreen/JoinAddress").get_text()
	if not ip.is_valid_ip_address():
		_set_status("Invalid IP address")
		return
	var name = get_node("PanelTitleScreen/PlayerName").get_text()
	if name == "":
		_set_status("Invalid name")
		return
	get_node("PanelTitleScreen/ButtonHost").disabled = false
	get_node("PanelTitleScreen/ButtonJoin").disabled = true
	gamestate.join_game(ip, name)


func _on_ButtonStart_pressed():
	# Stop waiting for players and actually start the game
	gamestate.rpc("start_game")
