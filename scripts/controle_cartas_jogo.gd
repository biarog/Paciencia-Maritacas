extends Control

const soma_zindex : int = 90
@onready var camada_drag = $"../Camada Drag"

# Variáveis para destacar cartas
var carta_destacada : Node = null
var cartas_hovering : Array[Node]

# Variaveis para lógica de carregar e soltar cartas
var cartas_carregadas : Array[Node]
var pos_alvo_cartas_carregadas : Array[Vector2]
var tweens_carregadas : Array[Tween]
var carregada : bool = false

# Variáveis para verificação de soltar cartas em colunas
var em_coluna : bool = false
var coluna_og : Node
var coluna_nova : Node

func _ready():
	update_pos_containers()
	for carta in get_tree().get_nodes_in_group("Cartas Jogo"):
		carta.connect("mouse_entered", mouse_entrou_carta)
		carta.connect("mouse_exited", mouse_saiu_carta)
	
	for coluna in get_tree().get_nodes_in_group("Colunas Jogo"):
		coluna.mouse_entered.connect(Callable(self, "_on_area_coluna_mouse_entered").bind(coluna))
		coluna.mouse_exited.connect(_on_area_coluna_mouse_exited)

func _process(_delta):
	if carregada:
		for i in range(cartas_carregadas.size()):
			var carta = cartas_carregadas[i]
			var pos = carta.get_parent().get_local_mouse_position() + Vector2(-50,-50+(i*25))
			
			var tween = carta.create_tween()
			tween.tween_property(carta, "position", pos, 0.05).set_delay((i+1) * 0.03)
			tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tweens_carregadas[i] = tween

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and carta_destacada != null:
			var carta = carta_destacada
			normalizar_carta(carta)
			carregando_cartas(carta)
		elif event.is_released() and carregada:
			soltando_cartas()

# Fuções para destacar cartas ao passar o mouse em cima delas

func mouse_entrou_carta(carta):
	# Adiciona a carta a lista de hovering se ela nao esta nela
	if not cartas_hovering.has(carta):
		cartas_hovering.append(carta)
	
	if cartas_carregadas.size() > 0:
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
		if cartas_hovering.size() > 0 and cartas_carregadas.size() == 0:
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
	carta_destacada = null

func get_primeira_carta(card_list):
	card_list.sort_custom(func(a, b): return a.z_index > b.z_index)
	return card_list[0]


# Funções para carregar/soltar cartas ao clicar/soltar o click

func carregando_cartas(carta_carregada:Node):
	pos_alvo_cartas_carregadas.append(Vector2(carta_carregada.global_position.x + 12.5, carta_carregada.global_position.y + 18.75))
	cartas_carregadas.append(carta_carregada)
	coluna_og = carta_carregada.get_parent()
	
	var cartas_irmas : Array = cartas_carregadas[0].get_parent().get_children()
	for i in range(cartas_carregadas[0].get_index()+1,cartas_irmas.size()):
		cartas_carregadas.append(cartas_irmas[i])
		pos_alvo_cartas_carregadas.append(cartas_irmas[i].global_position)
	
	for i in range(cartas_carregadas.size()):
		var carta = cartas_carregadas[i]
		coluna_og.remove_child(carta)
		camada_drag.add_child(carta)
		
		carta.global_position = pos_alvo_cartas_carregadas[i]
		
		carta.z_index += soma_zindex
		tweens_carregadas.append(null)
	
	carregada = true

func soltando_cartas():
	var container_alvo = coluna_og
	
	if em_coluna and coluna_nova != null and coluna_nova != coluna_og:
		container_alvo = coluna_nova
	pos_alvo_cartas_carregadas[0] = calcula_posicao_alvo_de_carta(container_alvo)
	
	for i in range(cartas_carregadas.size()):
		var carta = cartas_carregadas[i]
		var tween = carta.create_tween()
		
		if i > 0:
			pos_alvo_cartas_carregadas[i].x = pos_alvo_cartas_carregadas[i-1].x
			pos_alvo_cartas_carregadas[i].y = pos_alvo_cartas_carregadas[i-1].y + 25
		
		# Anima as cartas para a posição correta
		tween.tween_property(carta, "global_position", pos_alvo_cartas_carregadas[i], 0.25).set_delay(i * 0.03)
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		tween.finished.connect(func():
			if carta.get_parent() == camada_drag:
				camada_drag.remove_child(carta)
			container_alvo.add_child(carta)
			carta.position = Vector2.ZERO # Resetta a pos das cartas pro container alterar
			update_pos_containers()
		)
		
		tweens_carregadas[i] = tween
	
	cartas_carregadas.clear()
	pos_alvo_cartas_carregadas.clear()
	tweens_carregadas.clear()
	carregada = false
	coluna_og = null


# Funções para atualizar containers das colunas

func update_pos_containers():
	var colunas := [$Jogo/Coluna1, $Jogo/Coluna2, $Jogo/Coluna3, $Jogo/Coluna4, $Jogo/Coluna5, $Jogo/Coluna6, $Jogo/Coluna7]
	for coluna in colunas:
		var filhos = coluna.get_child_count()
		# Filhos - 2, pois um é para a carta (já que a posicção default do y é de 75
		# e o outro é para a própria AreaColuna que toda coluna possui
		if (filhos-2 < 0) :
			filhos += 1;
		
		coluna.get_child(0).position.y = 75 + ((filhos-2) * 25)
		
		for i in range(coluna.get_child_count()) :
			var child = coluna.get_child(i)
			child.z_index = i


# Funções para soltar cartas dentro da área de uma coluna

func _on_area_coluna_mouse_entered(coluna):
	coluna_nova = coluna.get_parent()
	em_coluna = true

func _on_area_coluna_mouse_exited():
	em_coluna = false
	coluna_nova = null


# Calcula a posição-alvo para uma carta

func calcula_posicao_alvo_de_carta(coluna_alvo: Node) -> Vector2:
	var pos_x_coluna = 76 + (150 * coluna_alvo.get_parent().get_children().find(coluna_alvo))
	var pos_y_alvo = 216 + ((coluna_alvo.get_child_count() - 1) * 25)
	
	return Vector2(pos_x_coluna, pos_y_alvo)
