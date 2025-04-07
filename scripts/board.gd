extends Node2D

const Piece = preload("res://scenes/piece.tscn")

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var selection_rect: ColorRect = $SelectionRect

const BOARD_SIZE_W = 8
const BOARD_SIZE_H = 8
const CELL_SIZE = 16

var selected_cell = null
var selected_piece = null
var pieces = []

func _ready() -> void:
	draw_board()
	spawn_pieces()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = tile_map_layer.get_local_mouse_position()
			var cell = tile_map_layer.local_to_map(mouse_pos)
			
			if cell.x >= 0 and cell.x < BOARD_SIZE_W and cell.y >= 0 and cell.y < BOARD_SIZE_H:
				if selected_cell == null:
					selected_piece = get_piece_at_cell(cell)
					if selected_piece:
						selected_cell = cell
						selection_rect.position = tile_map_layer.to_global(
							tile_map_layer.map_to_local(cell)
							) - Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
				else:
					try_move_piece(selected_piece, selected_cell, cell)
					selected_piece = null
					selected_cell = null
					selection_rect.position = Vector2(-100, -100)
					
		if event.button_index == MOUSE_BUTTON_RIGHT:
			selected_cell = null
			selection_rect.position = Vector2(-100, -100)
			
func draw_board():
	for x in BOARD_SIZE_W:
		for y in BOARD_SIZE_H:
			var is_light = (x + y) % 2 == 0
			var tile_id = 0 if is_light else 1
			tile_map_layer.set_cell(Vector2i(x, y), 0, Vector2i(tile_id, 0), 0)

func spawn_pieces():
	
	spawn_piece("rook", "white", Vector2i(0, 7))
	spawn_piece("knight", "white", Vector2i(1, 7))
	spawn_piece("bishop", "white", Vector2i(2, 7))
	spawn_piece("queen", "white", Vector2i(3, 7))
	spawn_piece("king", "white", Vector2i(4, 7))
	spawn_piece("bishop", "white", Vector2i(5, 7))
	spawn_piece("knight", "white", Vector2i(6, 7))
	spawn_piece("rook", "white", Vector2i(7, 7))

	for x in 8:
		spawn_piece("pawn", "white", Vector2i(x, 6))

	spawn_piece("rook", "black", Vector2i(0, 0))
	spawn_piece("knight", "black", Vector2i(1, 0))
	spawn_piece("bishop", "black", Vector2i(2, 0))
	spawn_piece("queen", "black", Vector2i(3, 0))
	spawn_piece("king", "black", Vector2i(4, 0))
	spawn_piece("bishop", "black", Vector2i(5, 0))
	spawn_piece("knight", "black", Vector2i(6, 0))
	spawn_piece("rook", "black", Vector2i(7, 0))

	for x in 8:
		spawn_piece("pawn", "black", Vector2i(x, 1))

func spawn_piece(piece_type: String, team: String, position: Vector2i):
	var piece = Piece.instantiate()
	add_child(piece)
	piece.setup(piece_type, team)
	piece.position = tile_map_layer.map_to_local(position)
	pieces.append(piece)

func get_piece_at_cell(cell):
	for piece in pieces:
		var piece_cell = tile_map_layer.local_to_map(piece.position)
		if piece_cell == cell:
			return piece
	return null
	
func try_move_piece(piece, from_cell, to_cell):
	if not piece:
		return false

	var valid_moves = piece.get_valid_moves()
	var move_vector = to_cell - from_cell

	if move_vector in valid_moves:
		var target_piece = get_piece_at_cell(to_cell)
		if target_piece and target_piece.team != piece.team:
			take_piece(target_piece)
			
		piece.position = tile_map_layer.map_to_local(to_cell)
		return true
	return false
	
func take_piece(piece):
	pieces.erase(piece)
	piece.queue_free()
