extends Control

enum State {
	NONE, STUDY, DRAW
}

export var studyDuration := 20
export var drawDuration := 120

var _secondsRemaining : int = 0
var _state = State.NONE

onready var _startButton := $VBoxContainer/StartButton
onready var _timer := $Timer
onready var _timeRemainingLabel := $VBoxContainer/TimeRemaining
onready var _beepPlayer := $AudioStreamPlayer


func _on_StartButton_pressed():
	_startButton.disabled = true
	_state = State.STUDY
	_secondsRemaining = studyDuration
	_timeRemainingLabel.text = _formatSecondsRemaining()
	_timer.start(1)


func _on_Timer_timeout():
	_secondsRemaining -= 1
	_timeRemainingLabel.text = _formatSecondsRemaining()	
	if _secondsRemaining == 0:
		_beepPlayer.play()
		match _state:
			State.STUDY:
				_secondsRemaining = drawDuration
			State.DRAW:
				_startButton.disabled = false
				_state = State.NONE
				_timer.stop()


func _formatSecondsRemaining() -> String:
	var result := ''
	result += str(_secondsRemaining / 60)
	result += ":"
	result += "%02d" % (_secondsRemaining % 60)
	return result;
