extends Node2D

class_name LevelState

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

@export_file("*.json") var initial_level_json

signal level_complete

# * Maps Building identifier to list of rooms in building
# * The index of the list is the floor the room is located on
# * If there is no room on that floor, the room id will be -1
var buildings: Array[Array]

var passenger_count: int = 0
var arrived_count: int = 0

# if null, default to static json
static func make_level(level_data: Dictionary, scene_path: String) -> LevelState:
  var scene: PackedScene = load(scene_path)
  var ret: LevelState = scene.instantiate()
  ret.load_state_from_dict(level_data)

  return ret


# json parse code from https://forum.godotengine.org/t/how-i-read-and-show-a-content-of-a-json-file-in-godot-4/2986
  # var json_as_text = FileAccess.get_file_as_string(initial_level_json)
  # var json_as_dict = JSON.parse_string(json_as_text)

func load_state_from_dict(start_state: Dictionary) -> void:
  var max_y = start_state["visual_data"]["max_y"] as int
  var side_margin = start_state["visual_data"]["side_margin"] as int
  var floor_margin = start_state["visual_data"]["floor_margin"] as int
  var elevator_width = start_state["visual_data"]["elevator_width"] as int
  var room_dims = Vector2(start_state["visual_data"]["room_width"] as int, start_state["visual_data"]["room_height"] as int)

  for building in start_state["buildings"]:
    var building_rooms = []

    for floor_id in building:
      var room_raw = building[floor_id]
      if room_raw["room_id"] as int < 0:
        building_rooms.push_back(-1)
      else:
        # ? Quite a bit of opportunity to clean this up later

        var room = Room.new(room_raw["room_id"] as int, room_raw["max_size"] as int, room_dims)
        # Position is set to top left corner of room
        room.position.x = side_margin + (buildings.size() * (room_dims.x + elevator_width))
        room.position.y = max_y - floor_margin - ((building_rooms.size() + 1) * room_dims.y) - 1
        add_child(room)

        var initial_passengers: Array[Passenger] = [] as Array[Passenger]
        for p_raw in room_raw["initial_passengers"]:
          var p = Passenger.new_passenger(p_raw["dest_room"] as int, p_raw["sprite_style"] as int)
          initial_passengers.push_back(p)
          passenger_count += 1

        for p in initial_passengers:
          room.push_passenger(Elevator.COMMAND.RIGHT, p)

        room.connect("passenger_arrived_at_destination", _on_passenger_arrived)
        building_rooms.push_back(room_raw["room_id"] as int)

    buildings.push_back(building_rooms)


func _ready() -> void:
  $ElevatorLeft.register_opened_handler(elevator_opened)
  $ElevatorRight.register_opened_handler(elevator_opened)


func _on_passenger_arrived() -> void:
  arrived_count += 1
  if arrived_count == passenger_count:
    level_complete.emit()


func _lookup_room_id(building_id: int, floor_id: int) -> int:
  return buildings[building_id][floor_id]


# * Assumes room names are formatted like "room_x" where x = room id
func _get_room_by_id(room_id: int) -> Room:
  # children created dynamically are not "owned" by this node
  return self.find_child("room_" + str(room_id), false, false)


# TODO: flesh this out later if implementing a more complicated map
func _can_room_be_opened_from_side(_room_id: int, _direction: Elevator.COMMAND) -> bool:
  return true


# * Elevator open callback handler, takes in a passenger (if any in the elevator)
# * And returns a passenger (if any) to be placed into the elevator.
# * If the passener cannot be unloaded, returns the same passsenger.
# * If no passenger can be loaded from the room, returns null.
# * If return is not null, returns a valid, unparented, potentially shown/unshown Passenger node
# @param passenger should be either null (no passenger), or valid, unparented, but still shown Passenger node.
func elevator_opened(elevator_kind: Elevator.KIND, direction: Elevator.COMMAND, floor_number: int, passenger: Passenger) -> Passenger:
  # print("Elevator ", elevator_kind,
  #       " opening ", "left" if direction == Elevator.COMMAND.LEFT else "right",
  #       " on floor ", floor_number,
  #       " passenger ", passenger)

  # ? Consider refactoring the lookup to a helper function
  var room_ref: Room = null
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

  var ret: Passenger = null
  if passenger == null:
    # loading passenger from elevator
    ret = room_ref.pop_passenger(direction)
  else:
    # unloading passenger from elevator
    if room_ref.is_full():
      ret = room_ref.pop_passenger(direction)
      if ret == null:
        # If we're unable to pop from the room, then this is a no-op
        return passenger

    room_ref.push_passenger(direction, passenger)

  return ret
