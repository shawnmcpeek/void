extends TextureRect

var nebula_files = [
	"res://assets/backgrounds/nebulae/NebulaBlue1.png",
	"res://assets/backgrounds/nebulae/NebulaBlue2.png",
	"res://assets/backgrounds/nebulae/NebulaBlue3.png",
	"res://assets/backgrounds/nebulae/NebulaBlue4.png",
	"res://assets/backgrounds/nebulae/NebulaBlue5.png",
	"res://assets/backgrounds/nebulae/NebulaBlue6.png",
	"res://assets/backgrounds/nebulae/NebulaBlue7.png",
	"res://assets/backgrounds/nebulae/NebulaBlue8.png",
	"res://assets/backgrounds/nebulae/NebulaBlue9.png",
	"res://assets/backgrounds/nebulae/NebulaBlue10.png",
	"res://assets/backgrounds/nebulae/NebulaGreen1.png",
	"res://assets/backgrounds/nebulae/NebulaGreen2.png",
	"res://assets/backgrounds/nebulae/NebulaGreen3.png",
	"res://assets/backgrounds/nebulae/NebulaGreen4.png",
	"res://assets/backgrounds/nebulae/NebulaGreen5.png",
	"res://assets/backgrounds/nebulae/NebulaGreen6.png",
	"res://assets/backgrounds/nebulae/NebulaGreen7.png",
	"res://assets/backgrounds/nebulae/NebulaGreen8.png",
	"res://assets/backgrounds/nebulae/NebulaGreen9.png",
	"res://assets/backgrounds/nebulae/NebulaGreen10.png",
	"res://assets/backgrounds/nebulae/NebulaOrange1.png",
	"res://assets/backgrounds/nebulae/NebulaOrange2.png",
	"res://assets/backgrounds/nebulae/NebulaOrange3.png",
	"res://assets/backgrounds/nebulae/NebulaOrange4.png",
	"res://assets/backgrounds/nebulae/NebulaOrange5.png",
	"res://assets/backgrounds/nebulae/NebulaOrange6.png",
	"res://assets/backgrounds/nebulae/NebulaOrange7.png",
	"res://assets/backgrounds/nebulae/NebulaOrange8.png",
	"res://assets/backgrounds/nebulae/NebulaOrange9.png",
	"res://assets/backgrounds/nebulae/NebulaOrange10.png",
	"res://assets/backgrounds/nebulae/NebulaPurple1.png",
	"res://assets/backgrounds/nebulae/NebulaPurple2.png",
	"res://assets/backgrounds/nebulae/NebulaPurple3.png",
	"res://assets/backgrounds/nebulae/NebulaPurple4.png",
	"res://assets/backgrounds/nebulae/NebulaPurple5.png",
	"res://assets/backgrounds/nebulae/NebulaPurple6.png",
	"res://assets/backgrounds/nebulae/NebulaPurple7.png",
	"res://assets/backgrounds/nebulae/NebulaPurple8.png",
	"res://assets/backgrounds/nebulae/NebulaPurple9.png",
	"res://assets/backgrounds/nebulae/NebulaPurple10.png",
	"res://assets/backgrounds/nebulae/NebulaRed1.png",
	"res://assets/backgrounds/nebulae/NebulaRed2.png",
	"res://assets/backgrounds/nebulae/NebulaRed3.png",
	"res://assets/backgrounds/nebulae/NebulaRed4.png",
	"res://assets/backgrounds/nebulae/NebulaRed5.png",
	"res://assets/backgrounds/nebulae/NebulaRed6.png",
	"res://assets/backgrounds/nebulae/NebulaRed7.png",
	"res://assets/backgrounds/nebulae/NebulaRed8.png",
	"res://assets/backgrounds/nebulae/NebulaRed9.png",
	"res://assets/backgrounds/nebulae/NebulaRed10.png",
	"res://assets/backgrounds/nebulae/NebulaYellow1.png",
	"res://assets/backgrounds/nebulae/NebulaYellow2.png",
	"res://assets/backgrounds/nebulae/NebulaYellow3.png",
	"res://assets/backgrounds/nebulae/NebulaYellow4.png",
	"res://assets/backgrounds/nebulae/NebulaYellow5.png",
	"res://assets/backgrounds/nebulae/NebulaYellow6.png",
	"res://assets/backgrounds/nebulae/NebulaYellow7.png",
	"res://assets/backgrounds/nebulae/NebulaYellow8.png",
	"res://assets/backgrounds/nebulae/NebulaYellow9.png",
	"res://assets/backgrounds/nebulae/NebulaYellow10.png"
]

func _ready():
	randomize()
	var random_index = randi() % nebula_files.size()
	var path = nebula_files[random_index]
	print("Trying to load: ", path)
	var tex = load(path)
	if tex:
		texture = tex
		print("Loaded texture: ", path)
	else:
		print("FAILED TO LOAD: ", path)
