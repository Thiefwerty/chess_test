extends Area2D

@export var piece_type: String = "pawn"
@export var team: String = "white"

@onready var sprite_2d: Sprite2D = $Sprite2D

func setup(type: String, team_color: String):
	piece_type = type
	team = team_color
	update_sprite()

func update_sprite():
	var texture_path = "res://assets/pieces/%s_%s.png" % [team, piece_type]
	if ResourceLoader.exists(texture_path):
		print(texture_path)
		sprite_2d.texture = load(texture_path)
	else:
		push_error("Текстура не найдена: ", texture_path)

func get_valid_moves():
	print(position.y)
	var moves = []
	if piece_type == "pawn":
		if team == "white":
			moves.append(Vector2i(0, -1))
			if position.y == 6 * 16 + 8: #row * sell size + 1/2 cell size так как спрайт в центре 
				moves.append(Vector2i(0, -2))
		else:
			moves.append(Vector2i(0, 1))
			if position.y == 1 * 16 + 8: #row * sell size + 1/2 cell size так как спрайт в центре 
				moves.append(Vector2i(0, 2))
		
	if piece_type == "rook":
		for i in range(1, 8):
			moves.append(Vector2i(i, 0))
			moves.append(Vector2i(-i, 0))
			moves.append(Vector2i(0, i))
			moves.append(Vector2i(0, -i))
		
	if piece_type == "knight":
		moves.append(Vector2i(1, 2))
		moves.append(Vector2i(2, 1))
		moves.append(Vector2i(2, -1))
		moves.append(Vector2i(1, -2))
		moves.append(Vector2i(-1, -2))
		moves.append(Vector2i(-2, -1))
		moves.append(Vector2i(-2, 1))
		moves.append(Vector2i(-1, 2))
			
	return moves
