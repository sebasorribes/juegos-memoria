class_name Compra_Game
extends Node2D


var itemImages = [
	preload("res://Sprites/Compras/alimentos/bananas.jpg"),
	preload("res://Sprites/Compras/alimentos/frutillas.jpg"),
	preload("res://Sprites/Compras/alimentos/huevos.jpg"),
	preload("res://Sprites/Compras/alimentos/kiwi.jpg"),
	preload("res://Sprites/Compras/alimentos/manzanas.jpg"),
	preload("res://Sprites/Compras/alimentos/naranjas.jpg"),
	preload("res://Sprites/Compras/alimentos/paltas.jpg"),
	preload("res://Sprites/Compras/alimentos/peras.jpg")]
var itemList = {};

var instructionPanel : Control;
var textToList = [];
var listText;

var inGamePanel : Control;

var endGamePanel : Control;
var pointsText : Label;

@onready var card := preload("res://Scenes/Compras/compras_card.tscn");
var cards = [];
var imagesCardsShowedInTurn =[];

var points := 0;
var turn := 0;
var maxTurns := 10;
var isPlaying : bool;

func _ready() -> void:
	listText = get_node("Transform/Control/ColorRect/Instruction/Lista");
	
	instructionPanel = get_node("Transform/Control/ColorRect/Instruction");
	inGamePanel = get_node("Transform/Control/ColorRect/InGame");
	
	endGamePanel = get_node("Transform/Control/ColorRect/EndGame");
	pointsText = get_node("Transform/Control/ColorRect/EndGame/Label");
	
	inGamePanel.hide();
	endGamePanel.hide();
	instructionPanel.show();
	
	points = 0;
	turn = 0;
	isPlaying = true;
	
	CreateItemsList();

func CreateItemsList() -> void:
	var counter = 0;
	while (counter < 4):
		var auxItem = itemImages.pick_random();
		if (itemList.has(auxItem)):
			continue ;
		else:
			var randomAmount = randi_range(1, 9);
			itemList[auxItem] = randomAmount;
			counter += 1;
	ItemListText();


func ItemListText() -> void:
	for key in itemList.keys():
		var auxName = str(key.resource_path.get_file());
		auxName = auxName.left(-4);
		listText.text += "* " + str(itemList[key]) + " " + auxName + "[br]";
	

func ShowCards() -> void:
	if !isPlaying : return;
	
	var specialCard = card.instantiate();
	get_node("Transform").add_child(specialCard);
	
	var imageSpecialCard = itemList.keys().pick_random();
	
	cards.append(specialCard);
	imagesCardsShowedInTurn.append(imageSpecialCard);
	
	(specialCard as Compras_Card).BuildCard(imageSpecialCard,itemList[imageSpecialCard]);
	(specialCard as Compras_Card).connect("OnCardSelected", Callable(self, "CardSeleccted"));
	
	for i in range(3):
		var auxCard = card.instantiate();
		get_node("Transform").add_child(auxCard);
		
		var imageAuxCard = itemImages.pick_random();
		while(imagesCardsShowedInTurn.has(imageAuxCard)):
			imageAuxCard = itemImages.pick_random();
		
		if(itemList.has(imageAuxCard)):
			var listValue = itemList[imageAuxCard]
			var randomValue = randi_range(1, 9);
			while (randomValue == listValue):
				randomValue = randi_range(1, 9);
			(auxCard as Compras_Card).BuildCard(imageAuxCard, randomValue);
		else:
			(auxCard as Compras_Card).BuildCard(imageAuxCard);
		
		cards.append(auxCard);
		imagesCardsShowedInTurn.append(imageAuxCard);
		
		(auxCard as Compras_Card).connect("OnCardSelected", Callable(self, "CardSeleccted"));
	
	RandomPositions();

func RandomPositions() -> void:
	cards.shuffle();
	
	for i in range(2):
		for j in range(2):
			var auxCard = cards[j + i * 2];
			auxCard.position = Vector2(200 + 350 * j, 400 +  300 * i);

func _on_intructions_button_pressed() -> void:
	instructionPanel.hide();
	inGamePanel.show();
	ShowCards();

func CardSeleccted(cardSelected : Compras_Card) -> void:
	var texturecardSelected = cardSelected.cardImage.texture;
	print("cambio");
	if(itemList.has(texturecardSelected)):
		if(itemList[texturecardSelected] == cardSelected.amount):
			points += 1;
	DestroyCardShowed();
	turn += 1;
	CheckTurn();
	await get_tree().create_timer(0.5).timeout;
	ShowCards();

func DestroyCardShowed() -> void:
	for auxCard in cards:
		auxCard.queue_free();
	cards.clear();
	imagesCardsShowedInTurn.clear();

func CheckTurn() -> void:
	if(turn >= maxTurns):
		isPlaying = false;
		EndGame();

func EndGame() -> void:
	inGamePanel.hide();
	instructionPanel.hide();
	
	pointsText.text = "Aciertos: " + str(points);
	endGamePanel.show();
	

func _on_end_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn");
