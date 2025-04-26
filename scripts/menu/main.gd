extends Node

# Maps level scene uid to relevant startig json
var level_scene_info: Dictionary[String, String]
var curr_level_ref: LevelState
var next_level: LevelState

@onready var start_button_ref = $LoadInMenu/StartButton
@onready var next_button_ref = $LevelCompleteOverlay/NextLevelButton
@onready var shuffle_button_ref = $WinScreen/Reshuffle

var time_elapsed: float = 0.0
var time_elapsed_this_circuit: float = 0.0
var ngp: bool = false

const win_screen_uid = "uid://c8y66p74a8jh2"

const level_map: Dictionary[String, String] = {
    "uid://bohsecfy8umiy": "res://resource/levels/level_1.json",
    "uid://wm47v8wk118d": "res://resource/levels/level_2.json",
    "uid://bt5hute0hfd2s": "res://resource/levels/level_3.json",
}


func _setup_next_level():
  if level_scene_info.is_empty():
    return

  var head = level_scene_info.keys()[0]
  var init_state
  if ngp:
    init_state = LevelGenerator.generate_level(3 - (level_scene_info.size() - 1))
  else:
    var json_text = FileAccess.get_file_as_string(level_scene_info[head])
    init_state = JSON.parse_string(json_text)

  next_level = LevelState.make_level(init_state, head)
  level_scene_info.erase(head)


func _init() -> void:
  level_scene_info = level_map.duplicate() as Dictionary[String, String]
  _setup_next_level()


func _ready() -> void:
  start_button_ref.connect("pressed", _on_start_pushed)
  next_button_ref.connect("pressed", _on_next_level_requested)
  shuffle_button_ref.connect("pressed", _on_reshuffle)

  $LevelCompleteOverlay.z_index = 100


func _scale_to_screen(n: Node2D) -> void:
  n.apply_scale(Vector2(4, 4))


func _switch_next_level() -> void:
  curr_level_ref = next_level
  add_child(curr_level_ref)
  _scale_to_screen(curr_level_ref)
  curr_level_ref.connect("level_complete", _on_level_completed)

  next_level = null
  time_elapsed_this_circuit += time_elapsed
  time_elapsed = 0.0


func _on_start_pushed() -> void:
  _switch_next_level()
  start_button_ref = null
  $LoadInMenu.hide()
  $LoadInMenu.queue_free()


func _on_level_completed() -> void:

  # Sound Effect from pixabay
  # "https://pixabay.com/users/u_8g40a9z0la-45586904/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=234709"
  $tada.play()

  $LevelCompleteOverlay/TimerDisplay.change_display_time(time_elapsed)
  $LevelCompleteOverlay.show()
  move_child($LevelCompleteOverlay, -1)

  _setup_next_level()


func _on_next_level_requested() -> void:
  print("next level requested")
  $LevelCompleteOverlay.hide()
  if next_level != null:
    var old_level_ref = curr_level_ref
    old_level_ref.disconnect("level_complete", _on_level_completed)

    _switch_next_level()

    remove_child(old_level_ref)
    old_level_ref.queue_free()
  else:
    $WinScreen.z_index = 101
    $WinScreen/TimerDisplay.change_display_time(time_elapsed_this_circuit)
    $WinScreen.show()
    move_child($WinScreen, -1)
    remove_child(curr_level_ref)
    curr_level_ref.queue_free()


func _on_reshuffle() -> void:
  $WinScreen.hide()
  ngp = true
  level_scene_info = level_map.duplicate() as Dictionary[String, String]
  time_elapsed_this_circuit = 0.0
  _setup_next_level()
  _switch_next_level()


func _process(delta: float) -> void:
  time_elapsed += delta
