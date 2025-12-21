extends Node

const SNAKE = 0
const APPLE = 1
var apple_pos
var snake_body = [Vector2(5,10), Vector2(4,10), Vector2(3,10)]
var snake_direction = Vector2(1,0)
var add_apple = false

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
	#for block in snake_body:
		#$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(7,0), 0)
		
	for block_index in snake_body.size():
		var block = snake_body[block_index]
		
		if block_index == 0:
			var head_dir = relation2(snake_body[0], snake_body[1])
			if (head_dir == 'right'):
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(3,1), 0)
			if (head_dir == 'left'):
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(2,0), 0)
			if (head_dir == 'down'):
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(2,1), 0)
			if (head_dir == 'up'):
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(3,0), 0)
		elif block_index == snake_body.size() - 1:
			var tail_dir = relation2(snake_body[-1], snake_body[-2])
			if (tail_dir == 'right'):
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(0,0), 0)
			if (tail_dir == 'left'):
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(1,0), 0)
			if (tail_dir == 'down'):
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(0,1), 0)
			if (tail_dir == 'up'):
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(1,1), 0)
		else:
			var previous_block = snake_body[block_index + 1] - block
			var next_block = snake_body[block_index - 1] - block
			
			if previous_block.x == next_block.x:
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(4,1), 0)
			elif previous_block.y == next_block.y:
				$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(4,0), 0)			
			else:
				if previous_block.x == -1 and next_block.y == -1 or next_block.x == -1 and previous_block.y == -1:
					$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(6,1), 0)
				elif previous_block.x == -1 and next_block.y == 1 or next_block.x == -1 and previous_block.y == 1:
					$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(6,0), 0)
				elif previous_block.x == 1 and next_block.y == -1 or next_block.x == 1 and previous_block.y == -1:
					$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(5,1), 0)
				elif previous_block.x == 1 and next_block.y == 1 or next_block.x == 1 and previous_block.y == 1:
					$Ground.set_cell(Vector2i(block.x, block.y), SNAKE, Vector2i(5,0), 0)

func relation2 (first_block:Vector2, second_block:Vector2):
	var block_relation = second_block - first_block
	if block_relation == Vector2(-1, 0): return 'left'
	if block_relation == Vector2(1, 0): return 'right'
	if block_relation == Vector2(0, 1): return 'down'
	if block_relation == Vector2(0, -1): return 'up'

func move_snake():
	if add_apple:
		delete_tiles(SNAKE)
		var body_copy = snake_body.slice(0,snake_body.size())
		var new_head = body_copy[0] + snake_direction
		body_copy.insert(0, new_head)
		snake_body = body_copy
		add_apple = false
	else:
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
	if Input.is_action_just_pressed("ui_up"): 
		if not snake_direction == Vector2(0,1):
			snake_direction = Vector2 (0, -1)
	if Input.is_action_just_pressed("ui_down"): 
		if not snake_direction == Vector2(0,-1):
			snake_direction = Vector2 (0, 1)
	if Input.is_action_just_pressed("ui_left"): 
		if not snake_direction == Vector2(1,0):
			snake_direction = Vector2 (-1, 0)
	if Input.is_action_just_pressed("ui_right"): 
		if not snake_direction == Vector2(-1,0):
			snake_direction = Vector2 (1, 0)

func check_apple_eaten ():
	if apple_pos == snake_body[0]:
		apple_pos = place_apple()
		add_apple = true
		get_tree().call_group('ScoreGroup', 'update_score', snake_body.size())

func check_game_over():
	var head = snake_body[0]
	if head.x > 19 or head.x < 0 or head.y < 0 or head.y > 19:
		reset()
		
	for block in snake_body.slice(1, snake_body.size() - 1):
		if block == head:
			reset()
func reset ():
	snake_body = [Vector2(5,10), Vector2(4,10), Vector2(3,10)]
	snake_direction = Vector2(1,0)

func _on_snake_tick_timeout() -> void:
	move_snake()
	draw_apple()
	draw_snake()
	check_apple_eaten()
	
func _process(delta):
	check_game_over()
	if apple_pos in snake_body:
		apple_pos = place_apple()
