extends Node2D


func play_walk():
	%AnimationPlayer.play("Walk")

func play_hurt():
	%AnimationPlayer.play("Hurt")

func play_idle():
	%AnimationPlayer.play("Idle")
	
func play_death():
	%AnimationPlayer.play("Death")
	
func play_attack():
	%AnimationPlayer.play("Attack")
