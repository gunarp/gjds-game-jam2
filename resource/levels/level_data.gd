extends Resource

class_name LevelData
# Provide some strong typing to make visual level editing possible
# This is some fancy decoration around a dictionary that looks like this:
# {
#   building_1: {
#     floor_1: {
#       room_id
#       [initial_passengers]
#     }
#     floor_2: {
#       room_id
#       [initial_passengers]
#     }
#   }
# }
# Can experiment with a json based solution too, if editing
# through the inspector proves to be too clumsy.

@export var level_visual: Texture2D
@export var buildings: Dictionary[int, SerializedBuilding]

func _init(_visual = null, _buildings = {}) -> void:
  level_visual = _visual
  buildings = _buildings



