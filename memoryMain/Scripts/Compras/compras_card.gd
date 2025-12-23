class_name  Compras_Card
extends Node2D

var cardImage : Sprite2D;
var amount : int;
var amountText : Label;

signal OnCardSelected(card : Compras_Card);

func _ready() -> void:
	cardImage = get_node("Image");
	amountText = get_node("ColorRect/Number");

func SetAmount(imageAmount = null) -> void:
	if(imageAmount == null):
		amount = randi_range(1, 9);
		amountText.text = str(amount);
	else:
		amount = imageAmount;
		amountText.text = str(amount);

func BuildCard(image : Texture2D, imageAmount = null) -> void:
	cardImage.texture = image;
	SetAmount(imageAmount);

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event is InputEventMouseButton || event is InputEventScreenTouch):
		TouchCard();

func TouchCard() -> void:
	emit_signal("OnCardSelected",self);
