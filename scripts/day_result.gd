extends Object
class_name DayResult

# Les items restants sur le bureau à la fin de la journée
var remaining_items: Array[Item]

# Les items mis dans la boite à garder aujourd'hui
var today_stored_items: Array[Item]

# Les items mis au rebut aujourd'hui
var today_discarded_items: Array[Item]

# Les items mis dans la boite à garder depuis le début du jeu
var total_stored_items: Array[Item]

# Les items mis au rebut depuis le début du jeu
var total_discarded_items: Array[Item]

# Le nombre de règles suivies aujourd'hui
var today_followed_rules: int

# Le nombre de règles brisées aujourd'hui (briser 20 fois la même règle vaut pour 1)
var today_broken_rules: int
