class_name No_Pilha
extends RefCounted # Usar RefCounted é uma boa prática para gerenciamento de memória

var carta:Carta
var onde_veio:Control
var onde_esta_agora:Control
var desvirou_carta:bool

# Construtor para criar o nó com valores iniciais
func _init(p_codigo_carta, p_onde_veio, p_onde_esta_agora, desv_carta):
	self.carta = p_codigo_carta
	self.onde_veio = p_onde_veio
	self.onde_esta_agora = p_onde_esta_agora
	self.desvirou_carta = desv_carta

# --- Getters ---

func get_carta():
	return carta

func get_onde_veio():
	return onde_veio

func get_onde_esta_agora():
	return onde_esta_agora

func get_desvirou_carta():
	return desvirou_carta

# --- Setters ---

func set_carta(nova_carta):
	carta = nova_carta

func set_onde_veio(nova_origem):
	onde_veio = nova_origem

func set_onde_esta_agora(novo_local):
	onde_esta_agora = novo_local

func set_desvirou_carta(novo_desv_carta):
	desvirou_carta = novo_desv_carta
