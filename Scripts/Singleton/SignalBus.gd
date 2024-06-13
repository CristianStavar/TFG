extends Node

signal player_level_up(current_level)
#Emited by: Player
#Received by: UpgradesManager, GameManager

signal player_died()
#Emited by: Player
#Received by: GameManager StatisticsManager


signal player_take_damage(quantity)
#Emited by: Player
#Received by: StatisticsManager

signal game_ended()
#Emited by: GameManager
#Received by: StatisticsManager

signal card_chosen(skill)
#Emited by: CardUI
#Received by: Player, UpgradesManager, GameManager

signal enemy_killed(monster)
#Emited by: Enemy
#Receivd by: StatisticsManager

signal damage_dealt(quantity,weapon)
#Emited by: Attacks
#Received by: StatisticsManager

signal projectile_blocked()
#Emited by: attack_shield
#Received by: StatisticsManager

signal barrel_destroyed()
#Emited by: barrel
#Received by: StatisticsManager

signal potion_taken()
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



signal lock_maxed_card(skill_card)
#Emited by:  player
#Received by: upgradesManager

signal card_unlocked(skill_card)
#Emited by:  player
#Received by: upgradesManager


signal secret_discovered()
#Emited by:  secret
#Received by: StatisticsManager


signal boss_spawned()
#Emited by:  Spawner
#Received by: GameManager

signal boss_killed()
#Emited by:  StatisticsManager
#Received by: GameManager

signal ask_for_only_dagger()
#Emited by:  statisticsManageer
#Received by: player


signal send_only_dagger()
#Emited by:  player
#Received by: statisticsManageer










		#MENUS

signal back_to_menu()
#Emited by: CollectionsManager
#Received by: MainMenu, gameManager


signal colection_item_pressed(item)
#Emited by:  colection_item_button
#Received by: CollectionsManager

signal colection_achievement_pressed(achievement)
#Emited by:  colection_achievement_button
#Received by: CollectionsManager


signal delete_save_file()
#Emited by: OptionsMenuUI
#Received by: StatisticsManager
