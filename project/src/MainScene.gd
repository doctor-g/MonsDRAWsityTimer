extends Control

enum State {
	NONE, STUDY, DRAW, PAUSED
}

export var study_duration := 20
export var draw_duration := 120

var _seconds_remaining : int = 0 setget _set_seconds_remaining
var _state = State.NONE

onready var _start_button := $VBoxContainer/StartButton
onready var _fullscreen_button := $VBoxContainer/FullscreenButton
onready var _timer := $Timer
onready var _time_remaining_label := $TimeRemaining
onready var _cancel_button := $VBoxContainer/CancelButton
onready var _pause_button := $VBoxContainer/PauseButton
onready var _animation_player := $AnimationPlayer

onready var _ready_label := $StatusRow/ReadyLabel
onready var _study_label := $StatusRow/StudyLabel
onready var _draw_label := $StatusRow/DrawLabel

onready var _start_sound := $StartSound
onready var _alarm_sound := $AlarmSound


func _ready():
	# Do not show the fullscreen button on Android
	_fullscreen_button.visible = (OS.get_name() != "Android")
	
	# Configure the rest of the application
	_ready_label.focus = true
	_seconds_remaining = study_duration
	_update_time_remaining_label()
	

func _on_StartButton_pressed():
	_start_sound.play()
	_start_button.disabled = true
	_cancel_button.disabled = false
	_pause_button.disabled = false
	_state = State.STUDY
	self._seconds_remaining = study_duration
	_timer.start(1)
	_ready_label.focus = false
	_study_label.focus = true
	 # In case the timer was previously paused, make sure to unpause it.
	_timer.paused = false


func _set_seconds_remaining(value):
	_seconds_remaining = value
	_update_time_remaining_label()


func _update_time_remaining_label()->void:
	var label_text := "%d:%02d" % [_seconds_remaining / 60, _seconds_remaining % 60]
	_time_remaining_label.text = label_text
	

func _on_Timer_timeout():
	self._seconds_remaining -= 1
	if _seconds_remaining == 0:
		_alarm_sound.play()
		match _state:
			State.STUDY:
				self._seconds_remaining = draw_duration
				_state = State.DRAW
				_study_label.focus = false
				_draw_label.focus = true
			State.DRAW:
				_start_button.disabled = false
				_pause_button.disabled = true
				_state = State.NONE
				_cancel_button.disabled = true
				_draw_label.focus = false
				_ready_label.focus = true
				_timer.stop()


func _on_CancelButton_pressed():
	_start_sound.play()
	self._seconds_remaining = study_duration
	_timer.stop()
	_start_button.disabled = false
	_cancel_button.disabled = true
	_pause_button.disabled = true
	_ready_label.focus = true
	_study_label.focus = false
	_draw_label.focus = false
	if _timer.paused:
		_pause_button.pressed = false
		_stop_blink_animation()


func _on_PauseButton_pressed():
	if _timer.paused:
		_timer.paused = false
		_stop_blink_animation()
	else:
		_timer.paused = true
		_animation_player.play("blink")

		
func _stop_blink_animation():
	_animation_player.seek(0, true)
	_animation_player.stop()


func _on_FullscreenButton_pressed():
	OS.window_fullscreen = not OS.window_fullscreen
