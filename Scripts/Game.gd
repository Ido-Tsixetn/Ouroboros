extends Node

const SNAKE = 0
const APPLE = 1
var apple_pos

func _ready():
	apple_pos = place_apple()
	draw_apple()
	
func place_apple():
	randomize()
	var x = randi() % 20
	var y = randi() % 20
	return Vector2(x,y)
	
func draw_apple():
	$Ground.set_cell(Vector2i(apple_pos.x, apple_pos.y), APPLE, Vector2i(0,0), 0)
