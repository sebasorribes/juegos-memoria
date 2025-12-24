class_name Landscape_Card
extends Node2D

var sprite : Sprite2D;

func _ready() -> void:
	sprite = get_node("Sprite2D");


func SetUp(texture : Texture2D) -> void:
	sprite.texture = texture;
