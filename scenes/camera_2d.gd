extends Camera2D

func _ready():
	make_current()

func _process(_delta):
	var player = get_parent().get_node("Player")
	if player:
		position.y = player.position.y
