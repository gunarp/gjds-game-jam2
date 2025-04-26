extends Node

# store current scene, start pointing at load in menu
# array for level sequences
# consume level complete signal to iterate through the array

var level_scene_uids: Array[String]
var next_level: PackedScene
var current_level_ref: LevelState

@onready var start_button_ref = $LoadInMenu/StartButton
@onready var next_button_ref = $LevelCompleteOverlay/NextLevelButton

var time_elapsed: float = 0.0

const win_screen_uid = "uid://c8y66p74a8jh2"

func _init() -> void:
  level_scene_uids = [
    "uid://bohsecfy8umiy",
    "uid://bohsecfy8umiy"
  ]

  next_level = load(level_scene_uids.pop_front())


func _ready() -> void:
  start_button_ref.connect("pressed", _on_start_pushed)
  next_button_ref.connect("pressed", _on_next_level_requested)
  $LevelCompleteOverlay.z_index = 100


func _scale_to_screen(n: Node2D) -> void:
  n.apply_scale(Vector2(4, 4))


func _switch_next_level() -> void:
  current_level_ref = next_level.instantiate() as LevelState
  add_child(current_level_ref)
  _scale_to_screen(current_level_ref)
  current_level_ref.connect("level_complete", _on_level_completed)
  next_level = null

  time_elapsed = 0.0


func _on_start_pushed() -> void:
  _switch_next_level()
  start_button_ref = null
  $LoadInMenu.hide()
  $LoadInMenu.queue_free()


func _on_level_completed() -> void:
  # Thanks https://gamedevbeginner.com/how-to-make-a-timer-in-godot-count-up-down-in-minutes-seconds/
  var format_time_lambda = func(time: float) -> String:
    var minutes: int = int(time / 60)
    var seconds: int = int(fmod(time, 60))
    var millis: int = int(fmod(time, 1) * 100)

    return "%02d:%02d:%02d" % [minutes, seconds, millis]

  var time_taken = format_time_lambda.call(time_elapsed)

  print("level completed in ", time_taken)
  $LevelCompleteOverlay/TimerDisplay.change_display_time(time_taken)
  $LevelCompleteOverlay.show()
  move_child($LevelCompleteOverlay, -1)

  if not level_scene_uids.is_empty():
    next_level = load(level_scene_uids.pop_front())
  else:
    next_level = null


func _on_next_level_requested() -> void:
  print("next level requested")
  $LevelCompleteOverlay.hide()
  if next_level != null:
    var old_level_ref = current_level_ref
    old_level_ref.disconnect("level_complete", _on_level_completed)

    _switch_next_level()

    remove_child(old_level_ref)
    old_level_ref.queue_free()
  else:
    $WinScreen.z_index = 101
    $WinScreen.show()
    remove_child(current_level_ref)
    current_level_ref.queue_free()


func _process(delta: float) -> void:
  time_elapsed += delta
