class_name Movimento_Jogo
extends Control

const MOVIMENTO_SCENE : PackedScene = preload("res://cenas/movimento_jogo.tscn")
var save = load("res://scripts/save.gd") #para poder carregar a clase "abstrata"

const soma_zindex : int = 90
var camada_drag : Control

# Variáveis para destacar cartas
var carta_destacada : Carta = null
var cartas_hovering : Array[Carta]

# Variaveis para lógica de carregar e soltar cartas
var cartas_carregadas : Array[Carta]
var pos_alvo_cartas_carregadas : Array[Vector2]
var tweens_carregadas : Array[Tween]
var carregada : bool = false

# Variáveis para verificação de soltar cartas em colunas
var coluna_og : Control

# Sinais de cartas
signal soltandoCartas

signal soltouCartasColuna
signal soltouCartaDeck
signal soltouCartaCasa

signal moveuCartasColuna(carta_movida:Carta, container_og:Control, container_novo:Control)
signal moveuCartaDeck1
signal moveuCartaDeck2(carta_movida:Carta, container_og:Control, container_novo:Control, desvirou:bool)
signal moveuCartaCasa1
signal moveuCartaCasa2(carta_movida:Carta, container_og:Control, container_novo:Control, desvirou:bool)

static func novo_movimento_jogo(camada_drag_def:Control)-> Movimento_Jogo:
	var novo_movimento = MOVIMENTO_SCENE.instantiate()
	novo_movimento.camada_drag = camada_drag_def
	return novo_movimento

func processamento_movimento(_delta):
	if !carregada:
		return
	
	for i in range(cartas_carregadas.size()):
		var carta = cartas_carregadas[i]
		var pos = carta.get_parent().get_local_mouse_position() + Vector2(-50,-50+(i*25))
		
		var tween = carta.create_tween()
		tween.tween_property(carta, "position", pos, 0.05).set_delay((i+1) * 0.03)
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tweens_carregadas[i] = tween

func mouse_esq_press():
	if carta_destacada != null:
		var carta = carta_destacada
		carregando_cartas(carta)

func mouse_esq_solta():
	if carregada:
		soltandoCartas.emit(cartas_carregadas[0], coluna_og)


# Fuções para destacar cartas ao passar o mouse em cima delas
func mouse_entrou_carta(carta:Carta):
	if carregada:
		return
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
	if carta.virada:
		return
	carta_destacada = carta
	var tween_destaque = create_tween()
	tween_destaque.tween_property(carta_destacada, "scale", Vector2(1.25,1.25), 0.2)

func normalizar_carta(carta):
	var tween = create_tween()
	tween.tween_property(carta, "scale", Vector2(1,1), 0.2)
	carta_destacada = null

func get_primeira_carta(card_list):
	card_list.sort_custom(func(a, b): return a.z_index > b.z_index)
	return card_list[0]


# Funções para carregar/soltar cartas ao clicar/soltar o botão esq do mouse

func carregando_cartas(carta_carregada:Carta):

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

func soltando_cartas(container_alvo:Control, container_og:Control, pos_final_carta:Vector2, movida:bool, desfez:bool):
	var posicao_modificada:String = "position"
	if(!save.get_mudo()):
		$"../som_carta".play()
	if movida:
		posicao_modificada = "global_position"
		pos_alvo_cartas_carregadas[0] = pos_final_carta
	
	for i in range(cartas_carregadas.size()):
		var carta = cartas_carregadas[i]
		var tween = carta.create_tween()
		
		if i > 0:
			pos_alvo_cartas_carregadas[i].x = pos_alvo_cartas_carregadas[i-1].x
			pos_alvo_cartas_carregadas[i].y = pos_alvo_cartas_carregadas[i-1].y + 25
		
		# Anima as cartas para a posição correta
		tween.tween_property(carta, posicao_modificada, pos_alvo_cartas_carregadas[i], 0.25).set_delay(i * 0.03)
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		tween.finished.connect(func():
			if carta.get_parent() == camada_drag:
				camada_drag.remove_child(carta)
			container_alvo.add_child(carta)
			carta.position = Vector2.ZERO # Resetta a pos das cartas pro container alterar
			emitir_sinais_soltou_carta(container_alvo)
		)
		
		tweens_carregadas[i] = tween
	
	if movida and !desfez:
		emitir_sinais_moveu_carta(cartas_carregadas[0], container_og, container_alvo)
	
	cartas_carregadas.clear()
	pos_alvo_cartas_carregadas.clear()
	tweens_carregadas.clear()
	carregada = false
	coluna_og = null


# Funções de sinais

func emitir_sinais_soltou_carta(container_novo:Control):
	var container_novo_coluna:bool = container_novo.is_in_group("Colunas Jogo")
	var container_novo_casa:bool = container_novo.is_in_group("Casas Jogo")
	var container_novo_deck:bool = !container_novo.is_in_group("Casas Jogo") and !container_novo.is_in_group("Colunas Jogo")
	
	if container_novo_casa: soltouCartaCasa.emit()
	if container_novo_deck: soltouCartaDeck.emit()
	if container_novo_coluna: soltouCartasColuna.emit()

func emitir_sinais_moveu_carta(carta_movida:Carta, container_velho:Control, container_novo:Control):
	var container_velho_coluna:bool = container_velho.is_in_group("Colunas Jogo")
	var container_velho_casa:bool = container_velho.is_in_group("Casas Jogo")
	var container_velho_deck:bool = !container_velho.is_in_group("Casas Jogo") and !container_velho.is_in_group("Colunas Jogo")
	
	if container_velho_casa: 
		moveuCartaCasa2.emit(carta_movida, container_velho, container_novo, false)
		moveuCartaCasa1.emit()
	if container_velho_deck: 
		moveuCartaDeck2.emit(carta_movida, container_velho, container_novo, false)
		moveuCartaDeck1.emit()
	if container_velho_coluna: moveuCartasColuna.emit(carta_movida, container_velho, container_novo)
