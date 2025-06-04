extends Control

@onready var deck := $Deck
@onready var cartas_viradas := $"Cartas Viradas"
var cartas_guardadas : Array[Carta]

func _on_deck_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			virar_carta_do_deck()

func virar_carta_do_deck() -> void:
	var ncartas_deck:int = deck.get_child_count()
	
	if ncartas_deck > 0:
		var cartas_deck:Array[Node] = deck.get_children()
		var carta:Carta = cartas_deck[ncartas_deck-1]
		adicionar_carta_virada(carta)
	else: 
		remover_cartas_viradas()
		var ncartas_guardadas:int = cartas_guardadas.size()
		for i in range(ncartas_guardadas):
			deck.add_child(cartas_guardadas[ncartas_guardadas-(i+1)])
		cartas_guardadas.clear()

func adicionar_carta_virada(carta:Carta) -> void:
	var ncartas:int = cartas_viradas.get_child_count()
	if ncartas >= 3:
		var primeira_carta:Carta= cartas_viradas.get_child(0)
		primeira_carta.virar_carta()
		cartas_guardadas.append(primeira_carta)
		cartas_viradas.remove_child(primeira_carta)
	
	carta.virar_carta()
	deck.remove_child(carta)
	cartas_viradas.add_child(carta)

func remover_cartas_viradas() -> void:
	for carta in cartas_viradas.get_children():
		carta.virar_carta()
		cartas_guardadas.append(carta)
		cartas_viradas.remove_child(carta)
