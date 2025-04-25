extends Resource

class_name SerializedPassenger

@export var visual: Texture2D
@export var dest_room_id: int

func _init(_visual = null, _dest = -1) -> void:
  visual = _visual
  dest_room_id = _dest
