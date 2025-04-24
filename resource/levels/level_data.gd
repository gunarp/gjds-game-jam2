extends Resource

@export var level_visual: Texture2D
@export var initial_level_state: Dictionary

# Dictionary layout of initial level state
# {
#   building_id: {
#     floor: {
#       [initial_passengers]
#     }
#   }
# }

