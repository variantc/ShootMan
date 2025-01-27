extends RichTextLabel
class_name ScoreText


var score = 0:
	set(value):
		score = value
		update_points()


func update_points():
	text = "Points: " + str(score)
