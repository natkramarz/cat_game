extends Node2D


func play_idle_animation():
	%AnimatedSprite2D.play("Idle_1")


func play_walk_animation():
	%AnimatedSprite2D.play("W_3")

func play_right_attack_animation():
	%AnimatedSprite2D.play("Attack_1")

func play_left_attack_animation():
	%AnimatedSprite2D.play("Attack_3")
