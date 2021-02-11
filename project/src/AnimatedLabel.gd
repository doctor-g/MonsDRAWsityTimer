class_name AnimatedLabel
extends Label


var focus := false setget _set_focus

func _ready():
	rect_pivot_offset = rect_size / 2

func _set_focus(value):
	focus = value
	if focus:
		$AnimationPlayer.play("highlight")
	else:
		$AnimationPlayer.play_backwards("highlight")
