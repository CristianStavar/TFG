extends Node

signal player_level_up(current_level)
#Emited by: Player
#Received by: UpgradesManager, GameManager

signal card_chosen(skill)
#Emited by: CardUI
#Received by: Player, UpgradesManager, GameManager

signal enemy_killed(monster)
#Emited by: Enemy
#Receivd by: StatisticsManager

signal damage_dealt(quantity,weapon)
#Emited by: Attacks
#Received by: StatisticsManager

signal damage_blocked(quantity)
#Emited by: EnemyBullet
#Received by: StatisticsManager

signal item_picked(item)
#Emited by: pickable_item
#Received by: StatisticsManager

signal time_passed(time)	#In seconds
#Emited by: GameManager
#Received by: StatisticsManager

signal ask_for_statistics_dictionary()
#Emited by: CollectionsManager
#Received by: StatisticsManager

signal give_statistics_dictionary(dictionary)
#Emited by:  StatisticsManager
#Received by: CollectionsManager



		#MENUS

signal back_to_menu()
#Emited by: CollectionsManager
#Received by: MainMenu
