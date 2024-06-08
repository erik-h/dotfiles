function kubesecret --description 'Decode and display a k8s secret base64 string values'
	kubectl get secret $argv[1] -o json | jq '.data | map_values(@base64d)'
end
