extends Control

#Signal para indicar que no tenemos vida
signal no_health

@export var max_health: int = 100:
	set = set_max_health,
	get = get_max_health
@onready var health_bar: ProgressBar = %Health_Bar
@onready var health_label: Label = %Health_Label
var health: int = get_max_health()
##Funcion lambda para asignar texto al Label
var label_text = func(life : int): 
	return 'Health: ' + str(life)


func _ready():
	#Las funciones en Godot son tratadas como variables (first class citizens)
	set_label_text(get_health())

##Setter -> max_health
func set_max_health(new_max_health: int) -> int:
	max_health = new_max_health
	return get_max_health()

##Getter -> max_health
func get_max_health() -> int:
	return max_health

##Setter -> health
func set_health(new_health: int) -> int:
	health = new_health
	#si la nueva vida es menor o igual a cero hemos la signal de muerte
	if new_health <= 0:
		health = 0
		no_health.emit()
	#Asignamos el nuevo valor a la barra de vida y el label
	set_bar_value(health)
	set_label_text(get_health())
	return get_health()

##Getter -> health
func get_health() -> int:
	return health

##Funcion para agregar vida
func add_health(amount: int) -> void:
	var actual_health = get_health()
	actual_health += amount
	set_health(actual_health)

##Funcion para quitar vida
func substract_health(amount: int) -> void:
	var actual_health = get_health()
	actual_health -= amount
	set_health(actual_health)

##Asignamos valor a la barra
func set_bar_value(newValue: int):
	const property_value = 'value'
	#El valor se asigna mediante el tween
	tween_element(health_bar, property_value, newValue, 0.25)


func set_label_text(content : int):
	tween_label(content)
	
	
##Funcion creacion tween
##element -> Elemento crear transicion
##property -> Propiedad transicionar entre valor actual y el que asignemos
##value -> nuevo valor asignado a la propiedad
##velocity -> velocidad de ejecucion transicion
func tween_element(element : Node, property, value, velocity):
	var tween := create_tween()
	tween.tween_property(element, property, value, velocity)
	

func tween_label(newValue : int):
	var tween := create_tween()
	tween.tween_method(
		func(value): 
			health_label.text = label_text.call(round(value)),
		health_bar.value, 
		newValue, 
		.6
	)

##Signal del jugador que indica cuando se ha recibido daño
##Pasamos como parametro el daño recibido
func _on_player_damage_taken(damage):
	substract_health(damage)

