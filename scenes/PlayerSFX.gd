extends Node
@onready var attack_sound: AudioStreamPlayer = $AttackSound
@onready var parry_sound: AudioStreamPlayer = $ParrySound
@onready var hit_sound: AudioStreamPlayer = $HitSound


func playAttack():
	attack_sound.randomPitchPlay()
func playParry():
	parry_sound.randomPitchPlay()
func playHit():
	hit_sound.randomPitchPlay()
	
	
