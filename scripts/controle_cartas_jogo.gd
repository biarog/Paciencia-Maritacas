extends Control

var carta_destacada : Node = null
var carta_carregada: Node = null
var cartas_hovering := []

func _ready():
	update_pos_containes()
	for carta in get_tree().get_nodes_in_group("Cartas Jogo"):
		carta.connect("mouse_entered", mouse_entrou_carta)
		carta.connect("mouse_exited", mouse_saiu_carta)

func _process(delta):
	if carta_carregada:
		carta_carregada.position = carta_carregada.get_parent().get_local_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if carta_destacada:
				carta_carregada = carta_destacada
		else:
			carta_carregada = null

# Fuções para destacar cartas ao passar o mouse em cima delas
func mouse_entrou_carta(carta):
	# Adiciona a carta a lista de hovering se ela nao esta nela
	if not cartas_hovering.has(carta):
		cartas_hovering.append(carta)
	
	if carta_carregada != null:
		return

	# Se nenhuma carta esta destacada, destacar a nova
	if carta_destacada == null:
		destacar_carta(carta)
	else:
		# Checa se a carta atual tem um z.index maior
		if carta.z_index > carta_destacada.z_index:
			# Normalizar a carta atual e destacar a carta nova
			normalizar_carta(carta_destacada)
			destacar_carta(carta)

func mouse_saiu_carta(carta):
	cartas_hovering.erase(carta)
	
	if carta_destacada == carta:
		normalizar_carta(carta)
		carta_destacada = null
		
		# Checa se mais alguma carta eh hovered
		if cartas_hovering.size() > 0 and carta_carregada == null:
			# Encontra a primeira carta abaixo do mouse e destaca ela
			var top_card = get_primeira_carta(cartas_hovering)
			destacar_carta(top_card)

func destacar_carta(carta):
	carta_destacada = carta
	var tween = create_tween()
	tween.tween_property(carta_destacada, "scale", Vector2(1.25,1.25), 0.1)

func normalizar_carta(carta):
	var tween = create_tween()
	tween.tween_property(carta, "scale", Vector2(1,1), 0.1)

func get_primeira_carta(card_list):
	card_list.sort_custom(func(a, b): return a.z_index > b.z_index)
	return card_list[0]

# Funções para atualizar containers
func update_pos_containes():
	var colunas = [$Jogo/Coluna1, $Jogo/Coluna2, $Jogo/Coluna3, $Jogo/Coluna4, $Jogo/Coluna5, $Jogo/Coluna6, $Jogo/Coluna7]
	for coluna in colunas:
		var filhos = coluna.get_child_count()
		coluna.get_child(0).position.y = 75 + ((filhos-1) * 25)
