# Agent Instructions

## Commit Messages
Never add your agent name as a co-author in commit messages.

## File Editing
Never manually modify CHANGELOG.md files or any files marked as auto-generated.

When writing or substantially editing long Markdown files, put each full sentence on its own line.
Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.

## Technical Decisions
When making technical decisions, do not give much weight to development cost.
Prefer quality, simplicity, robustness, scalability, and long-term maintainability.

## Bug Fixes
When doing bug fixes, always start by reproducing the bug in an E2E setting as closely aligned as possible with how an end user would experience it.
This ensures you find the real problem so your fix will actually solve it.

## Quality Standards
When end-to-end testing a product, be picky about the UI and obsessed with pixel perfection.
If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.

Apply that same standard to engineering excellence: lint, test failures, and test flakiness.
If you see one, even if it is not caused by what you are currently working on, still get it fixed.

## Environment
- Dotfiles live in `~/Developer/configs/config-files/` and are symlinked to `~`
- tmux uses oh-my-tmux with `~/.tmux.conf.local` as the override file
- Shell is zsh with zinit, powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting
