//cael - two events here

/datum/event/meteor_wave
	startWhen		= 5
	endWhen 		= 7
	var/next_meteor = 6
	var/waves = 1

/datum/event/meteor_wave/setup()
	waves = severity * rand(1,3)

/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Meteorlogical reports predict a meteor storm is on collision course with the station. Recommended that crew take refuge at the center of the station until the storm has passed.", "AUTOMATED ALERT: Meteor Storm", new_sound = 'sound/AI/meteors.ogg')
		else
			command_announcement.Announce("Meteorlogical reports predict a meteor shower is on collision course with the station. Recommended that crew take refuge at the center of the station until the shower has passed.", "AUTOMATED ALERT: Meteor Shower")

//meteor showers are lighter and more common,
/datum/event/meteor_wave/tick()
	if(waves && activeFor >= next_meteor)
		spawn() spawn_meteors(severity * rand(1,2), get_meteors())
		next_meteor += rand(15, 30) / severity
		waves--
		endWhen = (waves ? next_meteor + 1 : activeFor + 15)

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("The station has cleared the meteor storm. Engineering personnel must repair any resultant breaches.", "AUTOMATED ALERT: Meteor Storm")
		else
			command_announcement.Announce("The station has cleared the meteor shower. Engineering personnel must repair any resultant breaches.", "AUTOMATED ALERT: Meteor Shower")

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return meteors_catastrophic
		if(EVENT_LEVEL_MODERATE)
			return meteors_threatening
		else
			return meteors_normal
