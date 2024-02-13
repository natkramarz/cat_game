extends CharacterBody2D

var speed = 250

@onready var player = get_node("/root/Game/Player")
var player_chase = false

var health = 100
var player_inattack_zone = false
var can_take_damage = true


func _physics_process(delta):
	deal_with_damage()
	if player_inattack_zone: 
		$Dog.play_attack()
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		if velocity.length() > 0.0: 
			if direction.x < 0:  
				$Dog.play_walk()
				$Dog.get_node("Sprite2D").flip_h = true
				$CollisionShape2D.scale.x = -1
			else:
				$Dog.play_walk()
				$Dog.get_node("Sprite2D").flip_h = false
				$CollisionShape2D.scale.x = 1


func _on_detection_area_body_entered(body):
	player_chase = true 


func _on_detection_area_body_exited(body):
	player_chase = false 
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	var a = $CollisionShape2D.scale.x
	var b = player.get_node("CollisionShape2D").scale.x
	if player_inattack_zone and Global.player_current_attack:
		if can_take_damage and a * b == -1:
			health -= 20 
			$TakeDamageCooldown.start()
			can_take_damage = false
			$Dog.play_hurt()
	if health <= 0:
		Global.score += 1
		player.get_node("CanvasLayer").get_node("ScoreLabel").text = "Score {str}".format({"str": Global.score})
		$Dog.play_death()
		var random_value = randf()
		if random_value < 0.5 and player.health > 0:
			print("player health", player.health)
			if player.health + 20 > 100:
				player.health = 100
			else: 
				player.health += 20
			player.get_node("ProgressBar").value = player.health
			print("health added")
		self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
