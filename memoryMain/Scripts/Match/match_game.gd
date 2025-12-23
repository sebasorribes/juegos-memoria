class_name Match_Game
extends Node2D


var obverseImages := [
	preload("res://Sprites/Match/1.png"),
	preload("res://Sprites/Match/2.png"),
	preload("res://Sprites/Match/3.png"),
	preload("res://Sprites/Match/4.png"),
	preload("res://Sprites/Match/5.png"),
	preload("res://Sprites/Match/6.png")]

var card := preload("res://Scenes/Match/card.tscn");

var cards := [];

var flippedCard : Card;

var cardsFlippeds : int;

#la multiplicacion entre ambas tiene que ser la cantidad de cartas totales.
var boardCols := 2;
var boardRows := 6;

var numberRound : int;

var turns : Label;


func _ready() -> void:
	numberRound = 1;
	turns = get_node("Transform/Turns");
	turns.text = "Turns: " + str(numberRound);
	BuildBoard();

func BuildBoard() -> void:
	cards.clear();
	for obverseImage in obverseImages:
		var auxCard = card.instantiate();
		get_node("Transform").add_child(auxCard);
		cards.append(auxCard);
		(auxCard as Card).SetUp(obverseImage);
		(auxCard as Card).connect("OnCardSelected", Callable(self, "CheckFlipped"));

		var matchCard = card.instantiate();
		get_node("Transform").add_child(matchCard);
		cards.append(matchCard);
		(matchCard as Card).SetUp(obverseImage);
		(matchCard as Card).connect("OnCardSelected", Callable(self, "CheckFlipped"));
	RandomPositions();

func RandomPositions() -> void:
	cards.shuffle();

	for i in range(boardRows):
		for j in range(boardCols):
			var auxCard = cards[j + i * boardCols];
			auxCard.position = Vector2(250 + 250 * j, 200 +  200 * i);

func CheckFlipped(cardClicked : Card) -> void:
	if(flippedCard == null):
		flippedCard = cardClicked;
	else:
		SetComparationFase(true);
		WaitTime(cardClicked);

func WaitTime(cardClicked : Card) -> void:
	numberRound += 1;
	turns.text = "Turns: " + str(numberRound);
	await get_tree().create_timer(1.0).timeout;

	if(cardClicked.GetTexture() == flippedCard.GetTexture()):
		cardsFlippeds += 1;
	else:
		cardClicked.TurnBackCard();
		flippedCard.TurnBackCard();
	
	flippedCard = null;
	SetComparationFase(false);
	CheckGameStatus();

func SetComparationFase(faseStatus : bool) -> void:
	for auxCard in cards:
		auxCard.isInComparationFase = faseStatus;

func CheckGameStatus() -> void:
	if(cardsFlippeds == (boardCols * boardRows) / 2):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn");
