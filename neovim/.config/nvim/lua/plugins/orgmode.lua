require("orgmode").setup_ts_grammar()

require("orgmode").setup{
	org_agenda_files = {"~/.org/*"},
	org_default_notes_file = "~/.org/inbox.org",
	mappings = {
		global = {
			org_agenda = "gA",
			org_capture = "gC",
		},
	},
}
