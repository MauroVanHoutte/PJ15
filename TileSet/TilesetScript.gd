extends Node2D

@export var MoneySpent : Label
@onready var Tilemap : TileMap = $"."
var LastHoveredTile = null
var EmptyTileAtlasCoord : Vector2i = Vector2i(10,1)
var EmptyTileSource : int = 1
var PressTile
var EditingEnabled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Clear highlight
	Tilemap.clear_layer(3)
	if EditingEnabled :
		var MousePos = get_local_mouse_position()
		var HoveredTile = Tilemap.local_to_map(MousePos)
		Tilemap.set_cell(3, HoveredTile, 2, Vector2i(0,0))
		
		#Highlight all tiles inside selection
		if PressTile :
			var XStepSize = 1 if PressTile.x <= HoveredTile.x else -1
			var YStepSize = 1 if PressTile.y <= HoveredTile.y else -1
			for x in range(PressTile.x, HoveredTile.x + XStepSize, XStepSize) :
				for y in range(PressTile.y, HoveredTile.y + YStepSize, YStepSize) :
					if (!Tilemap.get_cell_tile_data(2, Vector2i(x,y))) :
						Tilemap.set_cell(3, Vector2i(x,y), 2, Vector2i(0,0))
		LastHoveredTile = HoveredTile

func _input(event):
	if EditingEnabled :
		if Input.is_action_just_pressed("LMB"):
			var MousePos = get_local_mouse_position()
			PressTile = Tilemap.local_to_map(MousePos)
		if Input.is_action_just_released("LMB"):
			if PressTile :
				#Set UsableTile
				var XStepSize = 1 if PressTile.x <= LastHoveredTile.x else -1
				var YStepSize = 1 if PressTile.y <= LastHoveredTile.y else -1
				for x in range(PressTile.x, LastHoveredTile.x + XStepSize, XStepSize) :
					for y in range(PressTile.y, LastHoveredTile.y + YStepSize, YStepSize) :
						Tilemap.set_cell(2, Vector2i(x,y), EmptyTileSource, EmptyTileAtlasCoord)
				#Set Wall terrain and ground
				var Selection : Array[Vector2i]
				for x in range(PressTile.x - 1 * XStepSize, LastHoveredTile.x + 2 * XStepSize, XStepSize) :
					for y in range(PressTile.y - 1 * YStepSize, LastHoveredTile.y + 2 * YStepSize, YStepSize) :
						Tilemap.set_cell(0, Vector2i(x,y), 2, Vector2i(0,0))
						Selection.append(Vector2i(x,y))
				Tilemap.set_cells_terrain_connect(1, Selection, 0, 0)

				PressTile = null

func _get_neighbouring_terrain_tiles_count(coords : Vector2i, terrain : int, terrain_set : int) -> int:
	var Count : int = 0
	var Neighbours = Tilemap.get_surrounding_cells(coords)
	Neighbours.append(coords + Vector2i(1,1))
	Neighbours.append(coords + Vector2i(-1,1))
	Neighbours.append(coords + Vector2i(1,-1))
	Neighbours.append(coords + Vector2i(-1,-1))
	Neighbours.append(coords)
	for neighbour in Neighbours :
		var neighbourTileData = Tilemap.get_cell_tile_data(1, neighbour)
		if neighbourTileData && neighbourTileData.get_terrain() == terrain && neighbourTileData.get_terrain_set() == terrain_set :
			Count = Count + 1
	return Count

func _get_neighbouring_source_tiles_count(coords : Vector2i, layer : int, source : int, atlasCoords : Vector2i) -> int:
	var Count : int = 0
	var Neighbours = Tilemap.get_surrounding_cells(coords)
	Neighbours.append(coords + Vector2i(1,1))
	Neighbours.append(coords + Vector2i(-1,1))
	Neighbours.append(coords + Vector2i(1,-1))
	Neighbours.append(coords + Vector2i(-1,-1))
	Neighbours.append(coords)
	
	for n in Neighbours :
		if Tilemap.get_cell_source_id(layer, n) == source && Tilemap.get_cell_atlas_coords(layer, n) == atlasCoords:
			Count = Count + 1
	return Count
