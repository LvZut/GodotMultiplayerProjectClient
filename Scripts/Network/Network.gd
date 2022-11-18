extends Node

# Network script on server and client must have same rpc methods or connection will fail

const DEFAULT_PORT = 8006

@onready var player_controller : Node = $PlayerController
const Player = preload("res://Scenes/Network/PlayerNode.tscn")
var player_slots = [0, 0, 0, 0, 0, 0, 0, 0]

var peer = ENetMultiplayerPeer.new()


func start_client(ip):
	var create_client_res
	if ip == "":
		print("connecting to localhost")
		create_client_res = peer.create_client("localhost", DEFAULT_PORT)
	else:
		create_client_res = peer.create_client(ip, DEFAULT_PORT)
	print('res: ', create_client_res)
	multiplayer.set_multiplayer_peer(peer)


func set_player_slots():
	print("player slots updated! ", player_slots)
	if get_parent().has_node('MenuControlNode'):
		get_parent().get_node('MenuControlNode').update_player_list()


func get_player_node():
	# return self playernode
	print("players children: ", player_controller.get_children())
	return player_controller.get_node(str(multiplayer.get_unique_id()))
	

func get_player_node_id(id):
	return player_controller.get_node(str(id))


@rpc
func update_lobby_player_list(slots):
#	print("RPC called by: ", multiplayer.get_remote_sender_id())
	player_slots = slots
	print("RPC received by: ", multiplayer.get_unique_id())
	set_player_slots()
	

@rpc(any_peer)
func order_move(_position):
	pass
