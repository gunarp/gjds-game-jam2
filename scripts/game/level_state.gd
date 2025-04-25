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

func _init() -> void:
  # ! Temporary room creation - remove later
  for i in range(0, 10):
    var room = Room.new(i, [])
    room.name = "room_" + str(i)
    add_child(room)


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

  # TODO: Initialize rooms with scheme room_x (x = room_id)

  # should also register callbacks with elevator
  $ElevatorLeft.register_opened_handler(elevator_opened)
  $ElevatorRight.register_opened_handler(elevator_opened)
  print(get_children())

  pass


#region temp variables
# maps building id to the room ids held in them
# (for a more complicated map, can still use something like this,
# but replace a room id with -1 to signify there's no room there)
var buildings = {
  0: [0, 1, 2],
  1: [3, 4, 5],
  2: [6, 7, 8],
}
#endregion

func _lookup_room_id(building_id: int, floor_id: int) -> int:
  return buildings[building_id][floor_id]


# ! function operates on assumption that rooms are named
# ! room_x, where x is the room id
func _get_room_by_id(room_id: int) -> Room:
  # * children created dynamically are not "owned" by this node
  return self.find_child("room_" + str(room_id), false, false)


# TODO: flesh this out later if implementing a more complicated map
func _can_room_be_opened_from_side(_room_id: int, _direction: Elevator.COMMAND) -> bool:
  return true


func elevator_opened(elevator_kind: Elevator.KIND,  direction: Elevator.COMMAND, floor_number: int, passenger: Passenger) -> Passenger:
  print("Elevator ", elevator_kind,
        " opening ", "left" if direction == Elevator.COMMAND.LEFT else "right",
        " on floor ", floor_number,
        " passenger ", passenger)

  # provide floor they're on, and if they're holding any passengers, what direction they're opening the door
  # also which elevator it is (Left or right)
  # level state will take care of knowing which building they're next to

  # when elevator open, level state figures out room is to left or right of elevator
  # does level state keep track of buildings - yes

  # elevator open called
  # somehow, need this information from elevator
  # which elevator [left right]
  # what floor [elevator provides]
  # what passenger [if any in elevator]
  # what direction [left right]

  # then, get this from internal
  # based on wshich elevator is calling, and which direction it is opening,
  # identify which building that corresponds to (left elevator, open left goes to building 0)
  # for that building, get room that is on that floor [could be none]
  var room_ref : Room = null
  if elevator_kind == Elevator.KIND.LEFT:
    if direction == Elevator.COMMAND.LEFT:
      room_ref = _get_room_by_id(_lookup_room_id(0, floor_number))
      pass
    else:
      room_ref = _get_room_by_id(_lookup_room_id(1, floor_number))
      pass
  else:
    if direction == Elevator.COMMAND.LEFT:
      room_ref = _get_room_by_id(_lookup_room_id(1, floor_number))
      pass
    else:
      room_ref = _get_room_by_id(_lookup_room_id(2, floor_number))
      pass

  # if there's nothing to do, return the same passenger
  # the elevator tried to offload (this should always result in a no-op, effectively)
  if room_ref == null:
    return passenger

  # if someone in elevator, then unload procedure
  #   pass them into the room, move the passenger sfrom the elevator to room ownership
  #     under the hood, room puts passenger into internal CoolQueue [direction required]
  # if no one in elevator, begin load procedure
  #   pop from the room, move passenger from the room into the elevator [direction required]
  #   takes passenger and makes child of elevator

  var ret: Passenger = null
  if passenger == null:
    # loading passenger from elevator
    ret = room_ref.pop_passenger(direction)
  else:
    # unloading passenger from elevator
    if room_ref.is_full():
      # If the room is full, then we would swap passenger out with person in the room
      ret = room_ref.pop_passenger(direction)
      # If we're unable to pop from the room, then this is a no-op
      if ret == null:
        return passenger

    room_ref.push_passenger(direction, passenger)

  return ret
