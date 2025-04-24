extends Node

@export var level_state: LevelData

# on load, read in the intial_level_state (export initlization will happen before)
func _ready() -> void:
  # populate rooms based on serialized data
  #   - need a way to figure out where the rooms are in the map
  print(level_state.buildings[0].rooms[0])
  pass
