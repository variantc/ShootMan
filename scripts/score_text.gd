extends RichTextLabel
class_name ScoreText


var score = 0:
	set(value):
		score = value
		update_points_by(0)


func update_points_by(inc : int):
	text = "Points: " + str(score)
