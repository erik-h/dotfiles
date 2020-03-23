function jira --description "Open the given Jira issue(s) in \$BROWSER. \$BROWSER is executed once for each issue."
	if test -z "$JIRA_BASE_URL"
		echo "[ERROR] JIRA_BASE_URL must be set." >&2
		return 1
	end
	for issue in $argv
		set -l browser "$JIRA_BROWSER"
		test -z "$browser"; and set -l browser "$BROWSER"
		eval $browser "https://"$JIRA_BASE_URL"/browse/"$issue
	end
end
