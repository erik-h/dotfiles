function kubectl --description 'Run kubectl using minikube'
	# Use kubernetes-api from brew's kubectl instead of minikube.
	# The minikube version doesn't respect ~/.kube/config apparently... it was
	# ignoring my config setup for EKS.
	command kubectl $argv
	# minikube kubectl -- $argv
	# minikube -p oauth2-proxy kubectl -- $argv
end
