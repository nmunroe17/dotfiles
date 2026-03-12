# Todo Management

Todo file: `~/todo/todo.md`

## Format
- Markdown with `## Section` headers for categories
- Tasks are `- [ ] Description (time estimate)` or `- [x] Done`
- Categories: Time-sensitive, Money, Olivia, House, Shopping, Work, Learning - Career, Learning - Personal, Inbox

## Commands
Parse the user's arguments to determine what they want:

- **add**: `add "task description" to Section` — append task under the matching `## Section`. If no section specified, add to `## Inbox`. Include a time estimate in parentheses if the user provides one.
- **check/done**: `check "partial match"` — find the matching task and change `- [ ]` to `- [x]`
- **remove/delete**: `remove "partial match"` — delete the matching line entirely
- **move**: `move "partial match" to Section` — move a task from its current section to another
- **show**: show the full todo list (default if no arguments given)
- **show Section**: show only that section

## Rules
- Always read the file first before making changes
- After any change, show what was changed (not the entire list)
- Match tasks by substring — user can say "Schwab" instead of the full task text
- If a match is ambiguous (multiple hits), show the options and ask which one
- Never reorder existing tasks
- Preserve time estimates when moving tasks
