global ww_open_file_tag 	= "<WWise>\n"
global ww_close_file_tag 	= "</WWise>\n"
global ww_bnk_tag 			= "\t<Bank"
global ww_go_2D				= "\t<GameObject2D"
global ww_go_3D				= "\t<GameObject3D"
global ww_init_tag			= "\t<InitEvent"

global ww_init_bnk			= "Init.bnk"

global snd_file

function exportSound =
(
	snd_file = createfile (PathToCopy + SoundFileName)

	format (XMLVersion) to:snd_file
	format (ww_open_file_tag) to:snd_file
	format (ww_bnk_tag + XMLName + XML1Value + XMLCloseTag) ww_init_bnk to:snd_file

	format (ww_close_file_tag) to:snd_file
	close snd_file

)