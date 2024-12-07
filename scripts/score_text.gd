extends RichTextLabel

var score = 0

func update_points_by(inc: int):
	score += inc
	text = "Points: " + str(score)
