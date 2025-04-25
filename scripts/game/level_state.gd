extends Node

# point to a json file for the initial level state
# @export var level_state: LevelData

# collection of buildings
# in each building
# collection of rooms
# in each room
# CoolQueue (filled with passengers)
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


# on load, read in the intial_level_state (export initlization will happen before)
func _ready() -> void:
  # populate rooms based on serialized data
  #   - need a way to figure out where the rooms are in the map
  # print(level_state.buildings[0].rooms[0])
  pass


func elevator_opened(Elevator) -> Passenger:
  # provide floor they're on, and if they're holding any passengers, what direction they're opening the door
  # also which elevator it is (Left or right)
  # level state will take care of knowing which building they're next to
  return null
