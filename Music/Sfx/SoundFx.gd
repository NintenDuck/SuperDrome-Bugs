extends Node
onready var SoundPlayers = get_children()

var sfx_path = "res://Music/Sfx/"

var sounds = {
	"Bullet": load(sfx_path + "bullet_sfx.wav"),
	"Jump": load(sfx_path + "jump.wav"),
	"Hurt": load(sfx_path + "hurt_sfx.wav"),
	"Step": load(sfx_path + "step_sfx.wav"),
	"SuperGunSFX": load(sfx_path + "supergun_sfx.wav"),
	"DeathSFX": load(sfx_path + "enemyDeath.wav"),
	"TransitionSteps": load(sfx_path + "steps.wav"),
	"SuperGunPickup": load(sfx_path + "supergun_pickup.wav"),
	"TacoSFX": load(sfx_path + "tacoPickup.wav"),
	"PlayerHurtSFX": load(sfx_path + "PlayerHurt.wav"),
	"BossFalling": load(sfx_path + "boss_falling.wav"),
	"BossHit": load(sfx_path + "boss_hit.wav"),
	"BossHitGround": load(sfx_path + "boss_hit_ground.wav"),
	"BossJump": load(sfx_path + "boss_jump.wav"),
	"Voice": load(sfx_path + "Voice.ogg"),
	"Ring": load(sfx_path + "TelephoneRing.wav"),
	"Trampoline": load(sfx_path + "trampoline.wav"),
	"Button": load(sfx_path + "button.wav")
}

func play(sound_string:String, volume_db = 1, pitch_scale = 1, random_pitch=false, pitch_range_min=0, pitch_range_max=0):
	for soundPlayer in SoundPlayers:
		if not soundPlayer.playing:
			if random_pitch:
				soundPlayer.pitch_scale = rand_range(pitch_range_min,pitch_range_max)
			else:
				soundPlayer.pitch_scale = pitch_scale
			soundPlayer.volume_db = volume_db
			soundPlayer.stream = sounds[sound_string]
			soundPlayer.play()
			return
