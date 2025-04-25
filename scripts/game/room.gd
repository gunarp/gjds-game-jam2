extends Node2D

class_name Room

signal passenger_arrived_at_destination

var room_number: int
var queue_ref: CoolQueue
var dims: Vector2

# may want a flag for when a room is being adjusted,
# so we don't have two processes writing to the same queue at once?
enum STATE {IDLE, ADJUSTING}

func _to_string() -> String:
  return "room number: " + str(room_number) + ", " + str(get_child_count())


func _init(room_num: int, max_size: int, _dims: Vector2):
  room_number = room_num
  dims = _dims

  queue_ref = CoolQueue.new(max_size)
  add_child(queue_ref)


func _ready():
  pass


# not sure if this is relevant to maintaining room queue
func _process(_delta: float) -> void:
  pass


func pop_passenger(direction: Elevator.COMMAND) -> Passenger:
  var popped = queue_ref.pop_passenger(direction)
  _assign_passenger_positions()
  return popped


func push_passenger(direction: Elevator.COMMAND, passenger: Passenger) -> void:
  if passenger.dest_id == room_number:
    passenger.arrived = true
    passenger_arrived_at_destination.emit()

  queue_ref.push_passenger(direction, passenger)
  _assign_passenger_positions()


func _assign_passenger_positions() -> void:
  var passengers = queue_ref.get_passengers()
  # now place passengers in room based on their queue position
  pass


func is_full() -> bool:
  return queue_ref.is_full()
