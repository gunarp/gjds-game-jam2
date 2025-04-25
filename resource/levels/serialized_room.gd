extends Resource

class_name SerializedRoom

@export var room_id: int
@export var passengers: Array[SerializedPassenger]

func _init(_id = -1, _passengers = [] as Array[SerializedPassenger]) -> void:
  room_id = _id
  passengers = _passengers
