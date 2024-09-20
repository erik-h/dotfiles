function sso -a 'profile' -d 'Log in to an AWS cli profile using SSO (dev by default)'
	if test -z "$profile"
		aws sso login --profile dev
	else
		aws sso login --profile $profile
	end
end
