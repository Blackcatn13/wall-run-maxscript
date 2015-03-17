local data_path = getSavePath caption:"Exe path" initialDir:"C:\\" 
if data_path != undefined then (
	PathLabel.text = data_path
	realPath = data_path + "\\"
	local filtered = filterString data_path "\\"
	local idx = 1
	local auxstring = ""
	PathLabel.text = auxstring
	while idx <= filtered.count do (
		
		if (filtered[idx].count + auxstring.count) <  22 then (
			auxstring = auxstring + filtered[idx] + "\\"
			idx = idx + 1
		) else (
			if filtered[idx].count > 22 then (
				auxstring = auxstring + filtered[idx] + "\\"
				idx = idx + 1
			)
			auxstring = auxstring + "\n"
			PathLabel.text = PathLabel.text + auxstring
			auxstring = ""
		)
	) 
	if auxstring != "" then (
		PathLabel.text = PathLabel.text + auxstring
	)
	format "==============================\n"
	format "Path set correctly\n"
	format "==============================\n"
)	