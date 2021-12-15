extends Node
class_name SoundMusicSystem

onready var MusicPlayer = $Music

enum states{
	STOPPED,
	PLAYING,
	TRANSITION_TO_NEXT_SONG
}

var state = states.STOPPED
var music_path = "res://Music/Music/"
var fadeSPD = 0.05
var currentSong = ""
var currenDefaultVolume = 0

var music = {
	"Caves!!!": load(music_path + "Caves!!!.ogg"),
	"WeirdMansion": load(music_path + "Werid_Mansion.ogg"),
	"BossTheme": load(music_path + "BossTheme.ogg")
}

func play(songName = "", volume = 1):
		if MusicPlayer.playing:
			if songName == currentSong:
				return
			MusicPlayer.stop()
			MusicPlayer.stream = music[songName]
			MusicPlayer.volume_db = volume
			MusicPlayer.play(0)
			currentSong = songName
			currenDefaultVolume = volume
		else:
			MusicPlayer.stream = music[songName]
			MusicPlayer.volume_db = volume
			MusicPlayer.play(0)
			currentSong = songName
			currenDefaultVolume = volume
			
func change_volume(newVolume):
	MusicPlayer.volume_db = newVolume
	
#func fade_music():
#	MusicPlayer.volume_db = lerp( MusicPlayer.volume_db, 0, fadeSPD)
	
func stop():
	if MusicPlayer.playing:
		MusicPlayer.stop()
