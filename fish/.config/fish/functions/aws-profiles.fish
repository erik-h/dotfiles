function aws-profiles -d 'Print out the AWS profiles configured in ~/.aws'
	grep -Po '(?<=\[)[^]]*' < ~/.aws/credentials
end
