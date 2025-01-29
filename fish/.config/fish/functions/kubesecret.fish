function kubesecret --description 'Decode and display a k8s secret base64 string values'
	kubectl get secret $argv[1] -o json | jq '.data | map_values(@base64d)'
	# NOTE: I switched to the go-template version before at some point, but I don't rememberw why...
	# I think I had encountered some situation where it was better? Hmm.
	#kubectl get secret $argv[1] -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'
end
