class_name No_Pilha
extends RefCounted # Usar RefCounted é uma boa prática para gerenciamento de memória

var carta:Carta
var onde_veio:Control
var onde_esta_agora:Control

# Construtor para criar o nó com valores iniciais
func _init(p_codigo_carta, p_onde_veio, p_onde_esta_agora):
	self.carta = p_codigo_carta
	self.onde_veio = p_onde_veio
	self.onde_esta_agora = p_onde_esta_agora

# --- Getters ---

func get_codigo_carta():
	return carta

func get_onde_veio():
	return onde_veio

func get_onde_esta_agora():
	return onde_esta_agora

# --- Setters ---

func set_codigo_carta(nova_carta):
	carta = nova_carta

func set_onde_veio(nova_origem):
	onde_veio = nova_origem

func set_onde_esta_agora(novo_local):
	onde_esta_agora = novo_local
