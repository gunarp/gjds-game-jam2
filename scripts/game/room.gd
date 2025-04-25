extends Node2D

class_name Room

signal passenger_arrived_at_destination

var room_number: int
var queue_ref: CoolQueue
var dims: Vector2

# local positions of where to place passengers, spaced evenly over the room width
# poulated based on the size of the queue and dims
# ! Could consider doing dynamic spacing of the passengers instead of fixed too
var render_anchors_x: Array[float]

# may want a flag for when a room is being adjusted,
# so we don't have two processes writing to the same queue at once?
enum STATE {IDLE, ADJUSTING}

func _to_string() -> String:
  return "room number: " + str(room_number) + ", " + str(get_child_count())


func _create_anchor_points(max_size: int) -> void:
  var anchor_sides: Array = range(1, dims.x - 1, ((dims.x - 2) / max_size))

  for i in range(0, anchor_sides.size() - 1):
    var x_mean: float = (anchor_sides[i] + anchor_sides[i + 1]) / 2
    render_anchors_x.push_back(x_mean)


func _init(room_num: int, max_size: int, _dims: Vector2):
  room_number = room_num
  dims = _dims
  name = "room_" + str(room_num)
  _create_anchor_points(max_size)

  queue_ref = CoolQueue.new(max_size)
  add_child(queue_ref)


func _ready():
  pass


func pop_passenger(direction: Elevator.COMMAND) -> Passenger:
  var popped = queue_ref.pop_passenger(direction)
  _assign_passenger_positions()
  return popped


func push_passenger(direction: Elevator.COMMAND, passenger: Passenger) -> void:
  if passenger.dest_id == room_number:
    passenger.display_happy_bubble()
    passenger.arrived = true
    passenger_arrived_at_destination.emit()

  queue_ref.push_passenger(direction, passenger)
  _assign_passenger_positions()


func _assign_passenger_positions() -> void:
  var passenger_dict = queue_ref.get_passengers()

  for pos in passenger_dict:
    var p = passenger_dict[pos]
    if p != null:
      p.position.x = render_anchors_x[pos]
      p.position.y = dims.y - p.get_y_offset()


func is_full() -> bool:
  return queue_ref.is_full()
