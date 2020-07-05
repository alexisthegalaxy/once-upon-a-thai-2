extends Node2D

export(String) var content = "ชัยภูมิ"

func _ready():
	$Label.text = content
