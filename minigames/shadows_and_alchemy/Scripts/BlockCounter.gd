extends Node
class_name BlockCounter

var block_list : Array
@export var max_blocks : int = 3
func add_block(block_ref : Node):
	block_list.append(block_ref)
	if block_list.size() > max_blocks:
		var last_block = block_list[0]
		if last_block is Node:
			last_block.queue_free()
			block_list.remove_at(0)
		
