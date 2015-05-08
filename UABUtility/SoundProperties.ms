DynamicUIRollout = newRolloutFloater "Dynamic UI" 300 300

rollout UIDialogTest "Dynamic UI"
(
	local UInum = 1
	button btnExecute "Execute Rollout"
	
	on btnExecute pressed do
	(
		UIcode = "rollout UIDialogTest" + UInum as string + " \"Bank Name #" + UInum as string + "\"\n"
		UIcode += "("
		UIcode += "label bnkName" + UInum as string + " \"Bank Name" + "\"" + " pos:[12,18] width:60 height:16" + "\n"
		UIcode += "editText bnkText" + UInum as string + " \"\"" + "pos:[72,16] width:200 height:16" + "\n"
		UIcode += ")"
		UIcode += "addRollout UIDialogTest" + UInum as string + " DynamicUIRollout"
		execute UIcode
		UInum += 1
	)
	
)

addRollout UIDialogTest DynamicUIRollout rolledUp:false