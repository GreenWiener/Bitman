extends Node



### MUUTUJAD

#var muutuja1 : String
#var muutuja2 : int
#var muutuja3 : float
#var muutuja4 : bool
#var muutuja5 : Array
#var muutuja6 : Dictionary
#var muutuja7 : Vector2
#var muutuja8

var muutuja1 = "tekst 123"
var muutuja2 = 7
var muutuja3 = 0.3
var muutuja4 = true
var muutuja5 = ["element1", "element2", "element3"]
var muutuja6 = {"võti1" : 13, "võti2": 27, "võti3": 9}
var muutuja7 = Vector2(3,4)
var muutuja8 = "tekst abc"


func _ready():
	var funktsiooni_tulemus = taisarvude_liitmine(3, 7) # funktsiooni väljakutsumine
	
	print("täisarvude liitmise vastus: ", taisarvude_liitmine(3, 7))
	
	### IF LAUSE
	
	# muutujate loomine
	var arv : int
	var vastus
	
	# muutujale väärtuse omistamine  
	arv = -3
	
	if arv < 0: # if-lause päis
		vastus = arv * -1   
	else:
		vastus = arv
	
	print("vastus: ", vastus) # väljasta vastus konsooli
	
	### WHILE TSÜKKEL

	var teisendatav_arv = 6 # teisendatav kümnendarv
	var jaak # jääk (täpitähed pole koodis head)
	var kahendarv = [] # järjend kahendarvu numbrite kogumiseks
	
	while teisendatav_arv > 0: # while-lause päis
		jaak = teisendatav_arv % 2 # arvust jäägi võtmine
		teisendatav_arv = teisendatav_arv / 2 # arvu jagamine 2-ga
		kahendarv.append(jaak) # jäägi lisamine järjendisse
	print("kahendarvu numbrid järjendina: ", kahendarv)
	kahendarv = "".join(kahendarv) # järjendi elementide ühendamine kokku üheks sõneks
	print("kahendarv ühe sõnena, aga tagurpidi: ", kahendarv)
	kahendarv = kahendarv.reverse() # kahendarvu sõne ümberkeeramine
	print("kahendarv õigetpidi (LÕPLIK VASTUS): ", kahendarv)
	
	
	### FOR TSÜKKEL
	var nimede_list = ["Peeter", "Timmu", "Jeesus", "Paul", "Tobias"]
	# for-tsükkel
	for el in nimede_list:
		print("Tere, ", el, "!")

func taisarvude_liitmine(argument1 : int, argument2 : int): # funktsiooni loomine
	var summa = argument1 + argument2
	return summa # funktsiooni tulemuse tagastamine

#func _ready():
	var player
	
	# Loome player objekti
	player = load("res://player/player.tscn").instantiate()
	
	# Kutsume välja 'arvuta_summa' meetodi
	var tulemus = player.arvuta_summa(3, 4)
	print("Summa on: ", tulemus)  # Väljund: Summa on: 7
	
	# Kutsume välja 'tervita' meetodi
	player.tervita("Maailm")  # Väljund: Tere, Maailm!



# Meetod, mis liidab kaks arvu
func arvuta_summa(a, b):
	return a + b

# Meetod, mis prindib tervituse
func tervita(nimi):
	print("Tere, " + nimi + "!")




# Muutujad, mis hoiavad viiteid teisele objektile











