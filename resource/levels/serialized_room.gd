extends Resource

class_name SerializedRoom

@export var room_id: int
@export var initial_state: Array[SerializedPassenger]

func _init(_id = -1, _passengers = []) -> void:
  room_id = _id
  initial_state = _passengers
