extends CharacterBody2D

var enemy_in_atttack_range = false
var enemy_attack_cooldown = true 
var health = 100
var player_alive = true
signal health_depleted


var attack_in_progress = false

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * 500 
	var collide = move_and_collide(velocity * delta)

	if velocity.length() > 0.0: 
		if direction.x < 0:  
			$Cat.play_walk_animation()
			$Cat.get_node("AnimatedSprite2D").flip_h = true
			$CollisionShape2D.scale.x = -1
		else:
			$Cat.play_walk_animation()
			$Cat.get_node("AnimatedSprite2D").flip_h = false
			$CollisionShape2D.scale.x = 1
	else:
		if !attack_in_progress:
			$Cat.play_idle_animation()
	
	
	enemy_attack(delta)
	attack(direction)
	
	if health <= 0:
		player_alive = false
		health = 0
		health_depleted.emit()
		print("Player has been killed")
		self.queue_free()


func player():
	pass 

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_atttack_range = true
		
		
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_atttack_range = false

func enemy_attack(delta):
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %PlayerHitbox.get_overlapping_bodies()
	var mob_count = 0
	for mob in overlapping_mobs:
		if mob.has_method("enemy"):
			mob_count += 1
	if mob_count > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		enemy_attack_cooldown = false
		$AttackCooldown.start()


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack(direction):
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true 
		attack_in_progress = true 
		$Cat.play_right_attack_animation()
		$DealAttackTimer.start()

func _on_deal_attack_timer_timeout():
	$DealAttackTimer.stop()
	Global.player_current_attack = false
	attack_in_progress = false
	
