extends CharacterBody2D

#Signal para indicar cuando el jugador ha recibido damage
signal damage_taken
#Variable damage cambiable desde el editor
#valor minimo de 5 y maximo de 25, el valor va a ir de 5 en 5
@export_range(5, 25, 5) var damage: int
#Variable dead con set & get
var dead : bool = false: 
	set = set_dead, 
	get = get_dead


func _ready():
	print(damage)

##Setter -> dead
func set_dead(newDead : bool) -> bool:
	dead = newDead
	return get_dead()

##Getter -> dead
func get_dead() -> bool:
	return dead

##Funcion que indica si hemos recibido daño
func produce_damage(amount_damage: int):
	damage_taken.emit(damage)
	print('Damage ' + str(amount_damage))

##Signal del boton invocada cada vez que se presiona
func _on_button_pressed():
	if get_dead():
		return
	produce_damage(damage)

##Signal propia del Nodo Control que nos indica que no tenemos vida
func _on_control_no_health():
	set_dead(true)

