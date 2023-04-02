extends TouchScreenButton


var touchStart = Vector2.ZERO
var touchEnd = Vector2.ZERO
var direction

#This wont be called if a GUI or something else is handling the event
func _input(event):
	
	if event is InputEventScreenTouch:
		if event.is_pressed():
			touchStart = event.position
		elif not event.is_pressed():
			touchEnd = event.position	
			direction = (touchStart - touchEnd).normalized()		
	else: 
		direction = Vector2.ZERO
	

func swiped():
	return direction
