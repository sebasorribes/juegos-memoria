class_name Card
extends Node2D

var sprite : Sprite2D;
var turnAnims : AnimationPlayer;
var area : Area2D;

var isFlipped := false;
var isInComparationFase := false;

signal OnCardSelected(card : Card)

func _ready() -> void:
	sprite = get_node("Obverse");
	turnAnims = get_node("TurnAnim");
	area = get_node("Area2D");

func SetUp(texture : Texture2D) -> void:
	sprite.texture = texture;

func TurnBackCard() -> void:
	turnAnims.play("turn_back");
	isFlipped = false;

func TouchCard() -> void:
	if (!isFlipped && !isInComparationFase):
		turnAnims.play("turn_over");
		isFlipped = true;
		emit_signal("OnCardSelected",self);

func GetTexture() -> Texture2D:
	return sprite.texture;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event is InputEventMouseButton || event is InputEventScreenTouch):
		TouchCard();
