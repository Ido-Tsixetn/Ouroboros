extends Node

const SNAKE = 0
const APPLE = 1
var apple_pos
var snake_body = [Vector2(5,10), Vector2(4,10), Vector2(3,10)]
var snake_direction = Vector2(1,0)

func _ready():
	apple_pos = place_apple()
	
func place_apple():
	randomize()
	var x = randi() % 20
	var y = randi() % 20
	return Vector2(x,y)
	
func draw_apple():
	$Ground.set_cell(Vector2i(apple_pos.x, apple_pos.y), APPLE, Vector2i(0,0), 0)

func draw_snake():
	for block in snake_body:
		$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(7,0), 0)

func move_snake():
	delete_tiles(SNAKE)
	var body_copy = snake_body.slice(0,snake_body.size() - 1)
	var new_head = body_copy[0] + snake_direction
	body_copy.insert(0, new_head)
	snake_body = body_copy

func delete_tiles(id:int):
	var cells = $Ground.get_used_cells_by_id(id)
	for cell in cells:
		$Ground.set_cell(Vector2i(cell.x, cell.y), -1)
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"): snake_direction = Vector2 (0, -1)
	if Input.is_action_just_pressed("ui_down"): snake_direction = Vector2 (0, 1)
	if Input.is_action_just_pressed("ui_left"): snake_direction = Vector2 (-1, 0)
	if Input.is_action_just_pressed("ui_right"): snake_direction = Vector2 (1, 0)

func _on_snake_tick_timeout() -> void:
	move_snake()
	draw_apple()
	draw_snake()
