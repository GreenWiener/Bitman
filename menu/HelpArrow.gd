extends Node2D

var tween1
var tween2

func _ready():
	$AnimationPlayer.play("trans_in")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("wobble")
