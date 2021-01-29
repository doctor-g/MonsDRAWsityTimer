extends Control


export var studyDuration := 5

var _secondsRemaining : int = 0

onready var _startButton := $VBoxContainer/StartButton
onready var _timer := $Timer
onready var _timeRemainingLabel := $VBoxContainer/TimeRemaining
onready var _beepPlayer := $AudioStreamPlayer


func _on_StartButton_pressed():
	_startButton.disabled = true
	_secondsRemaining = studyDuration
	_timeRemainingLabel.text = _formatSecondsRemaining()
	_timer.start(1)


func _on_Timer_timeout():
	_secondsRemaining -= 1
	_timeRemainingLabel.text = _formatSecondsRemaining()	
	if _secondsRemaining == 0:
		_beepPlayer.play()
		_startButton.disabled = false
		_timer.stop()


func _formatSecondsRemaining() -> String:
	var result := ''
	result += str(_secondsRemaining / 60)
	result += ":"
	result += "%02d" % (_secondsRemaining % 60)
	return result;
