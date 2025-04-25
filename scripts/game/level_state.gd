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
  # json parse code from https://forum.godotengine.org/t/how-i-read-and-show-a-content-of-a-json-file-in-godot-4/2986
  var file = "res://resource/levels/level_1.json" #this can be a passed in variable 
  var json_as_text = FileAccess.get_file_as_string(file)
  var json_as_dict = JSON.parse_string(json_as_text)
  if json_as_dict:
      # print(json_as_dict)
      pass
  
  for building in json_as_dict:
    # print(json_as_dict[building])
    for floor in json_as_dict[building]:
      print(json_as_dict[building][floor])
      
      # create room with int(json_as_dict[building][floor]["room_id"]), json_as_dict[building][floor]["initial_passengers"]
      print(int(json_as_dict[building][floor]["room_id"]))
      print(json_as_dict[building][floor]["initial_passengers"])
      var room_gen = Room.new(int(json_as_dict[building][floor]["room_id"]), json_as_dict[building][floor]["initial_passengers"])
      add_child(room_gen)
      print("\n\n")
      
  # populate rooms based on serialized data
  #   - need a way to figure out where the rooms are in the map
  # print(level_state.buildings[0].rooms[0])

  # should also register callbacks with elevator
  print(get_children())
  pass


func elevator_opened(Elevator) -> Passenger:
  # provide floor they're on, and if they're holding any passengers, what direction they're opening the door
  # also which elevator it is (Left or right)
  # level state will take care of knowing which building they're next to

  # when elevator open, level state figures out room is to left or right of elevator
  # does level state keep track of buildings

  # elevator open called
  # somehow, need this information from elevator
  # which elevator [left right]
  # what floor [elevator provides]
  # what passenger [if any in elevator]
  # what direction [left right]
  # then, get this from internal
  # based on which elevator is calling, and which direction it is opening,
  # identify which building that corresponds to (left elevator, open left goes to building 0)
  # for that building, get room that is on that floor [could be none]
  # if someone in elevator, then unload procedure
  #   pass them into the room, move the passenger sfrom the elevator to room ownership
  #     under the hood, room puts passenger into internal CoolQueue [direction required]
  # if no one in elevator, begin load procedure
  #   pop from the room, move passenger from the room into the elevator [direction required]
  #   takes passenger and makes child of elevator
  # add_child
  # remove_child

  #
  return null
