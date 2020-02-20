function ecrlogin
	eval (aws ecr get-login --no-include-email --region ca-central-1)
end
