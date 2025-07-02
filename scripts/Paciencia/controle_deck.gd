extends Control

var movimento : Movimento_Jogo

@onready var deck := $Deck
@onready var cartas_viradas := $"Cartas Viradas"
@onready var controle_jogo := $"../Controle Jogo"

var cartas_guardadas : Array[Carta]

signal virouCartaDeck(carta_movida:Carta, container_og:Control, container_novo:Control, desvirou:bool)


func inicia_deck() -> void:
	movimento.soltouCartaDeck.connect(_normalizar_zindex)
	movimento.moveuCartaDeck1.connect(carta_removida_deck)

func _on_deck_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			virar_carta_do_deck()

func virar_carta_do_deck() -> void:
	var ncartas_deck:int = deck.get_child_count()
	
	if ncartas_deck > 0:
		var cartas_deck:Array[Node] = deck.get_children()
		var carta:Carta = cartas_deck[ncartas_deck-1]
		adicionar_carta_virada(carta, false)
		virouCartaDeck.emit(carta, $Deck, $"Cartas Viradas", false)
	else: 
		remover_cartas_viradas()
		var ncartas_guardadas:int = cartas_guardadas.size()
		for i in range(ncartas_guardadas):
			deck.add_child(cartas_guardadas.back())
			cartas_guardadas.pop_back()

func adicionar_carta_virada(carta:Carta, desfazer:bool) -> void:
	var ncartas:int = cartas_viradas.get_child_count()
	
	carta.z_index =+ 30
	
	if ncartas >= 3:
		var primeira_carta:Carta= cartas_viradas.get_child(0)
		if !primeira_carta.virada:
			primeira_carta.virar_carta()
		cartas_guardadas.append(primeira_carta)
		cartas_viradas.remove_child(primeira_carta)
	if !desfazer:
		var tween = carta.create_tween()
		tween.tween_property(carta, "global_position", calcula_pos_deck_viradas(), 0.2)
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		tween.finished.connect(func():
			carta.position = Vector2.ZERO
			if carta.virada:
				carta.virar_carta()
			var pai = carta.get_parent()
			pai.remove_child(carta)
			cartas_viradas.add_child(carta)
			atualizar_conexoes(carta)
			_normalizar_zindex()
		)
	else:
		if carta.virada:
			carta.virar_carta()
		atualizar_conexoes(carta)
		_normalizar_zindex()

func remover_cartas_viradas() -> void:
	for carta in cartas_viradas.get_children():
		carta.virar_carta()
		cartas_guardadas.append(carta)
		cartas_viradas.remove_child(carta)

func atualizar_conexoes(carta:Carta) -> void:
	for i in range(cartas_viradas.get_child_count()):
		var carta_atual = cartas_viradas.get_child(i)
		controle_jogo.desconectar_carta(carta_atual)
	
	controle_jogo.conectar_carta(carta)

func _normalizar_zindex() -> void:
	for carta in cartas_viradas.get_children():
		carta.z_index = 0

func carta_removida_deck() -> void:
	var ncartas:int = cartas_viradas.get_child_count()
	if cartas_guardadas.size() > 0 and ncartas <= 2:
		var temp_cartas:Array[Carta]
		temp_cartas.append(cartas_guardadas.back())
		cartas_guardadas.pop_back()
		temp_cartas[0].virar_carta()
		
		for carta in cartas_viradas.get_children():
			temp_cartas.append(carta)
			cartas_viradas.remove_child(carta)
		
		for carta in temp_cartas:
			cartas_viradas.add_child(carta)
	
	ncartas = cartas_viradas.get_child_count()
	
	if ncartas > 0:
		var nova_ultima_carta = cartas_viradas.get_child(ncartas-1)
		atualizar_conexoes(nova_ultima_carta)

func calcula_pos_deck_viradas() -> Vector2:
	var ncartas:int = cartas_viradas.get_child_count()
	var pos_alvo_x = 181 + (ncartas * 33)
	var pos_alvo_y = deck.global_position.y
	if ncartas >= 3:
		pos_alvo_x = 181 + (2*33)
	
	return Vector2(pos_alvo_x, pos_alvo_y)
