---
name: grok-code
description: "Delegate coding to Grok Build CLI (features, PRs, multi-workspace)."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, wsl]
metadata:
  hermes:
    tags: [Coding-Agent, Grok, xAI, Worktree, Tmux, Parallel, Automation]
    related_skills: [claude-code, codex, opencode, hermes-agent]
---

# Grok Build CLI — Hermes Orchestration Guide

Delegate coding tasks to **Grok Build** (`grok` CLI) — xAI's powerful autonomous coding TUI — via Hermes. Grok Build excels at worktree-based parallel development, subagent orchestration, and long-running coding sessions.

## Core Philosophy (Hermes + Grok)

- **Hermes** = high-level companion, planner, reviewer, memory, and coordinator
- **Grok Build** = the coding execution engine (fast TUI with excellent worktree + session support)
- **tmux** = persistent, monitorable, parallel execution layer

## Prerequisites

- `grok` is already installed at `~/.local/bin/grok`
- Run `grok login` or `grok --oauth` once for authentication
- Recommended: `grok update` to stay current
- tmux is available (standard on WSL/Linux)

## Two Main Execution Modes

### 1. Print / One-shot Mode (`-p`)

Best for scoped tasks. Non-interactive, returns when done.

```bash
grok -p "Implement JWT auth with refresh tokens and rate limiting" \
     --worktree auth-v2 \
     --effort high \
     --max-turns 20
```

### 2. Interactive TUI via tmux (Multi-turn / Complex Work)

This is the primary mode for serious development.

**Basic tmux + Grok pattern:**
```bash
# Create session
tmux new-session -d -s grok-auth -x 160 -y 48 -c "$HOME/projects/myapp"

# Launch Grok
tmux send-keys -t grok-auth 'grok --worktree auth-v2 --effort high' Enter

# Send initial task (after ~3-5s startup)
sleep 4
tmux send-keys -t grok-auth 'Build complete auth system with tests' Enter
```

## Recommended Hermes Workflow

**Important: User Visibility First**

I will **always show you the tmux sessions** so you can watch Grok work in real time. I prefer giving you direct `tmux attach` commands rather than hiding the sessions.

### Starting a New Coding Task
1. Hermes writes a plan (`plan` skill or `.hermes/plans/`)
2. Hermes creates tmux session(s) + worktree(s)
3. Hermes immediately gives you the attach command so you can watch live
4. Hermes also monitors in the background and can send follow-ups
5. When ready, Hermes reviews changes and coordinates merge

### Parallel Multi-Workspace Development (Hermes Strength)

Example of running 3 concurrent agents:

```bash
# Backend
tmux new-session -d -s grok-backend -c ~/projects/myapp
tmux send-keys -t grok-backend 'grok --worktree feature/api --effort high' Enter

# Frontend
tmux new-session -d -s grok-frontend -c ~/projects/myapp
tmux send-keys -t grok-frontend 'grok --worktree feature/ui --effort high' Enter

# Tests / QA
tmux new-session -d -s grok-tests -c ~/projects/myapp
tmux send-keys -t grok-tests 'grok --worktree feature/tests --effort medium' Enter
```

Hermes will give you direct attach commands so you can watch live, plus background monitoring:

**Watch live (recommended):**
```bash
tmux attach -t grok-backend
tmux attach -t grok-frontend
tmux attach -t grok-tests
```

**Or read-only from chat:**
```bash
tmux capture-pane -t grok-backend -p -S -30
tmux capture-pane -t grok-frontend -p -S -30
```

## Useful Grok Flags (Adapted for Hermes Use)

| Flag                    | Purpose                                      | Recommended Use                  |
|-------------------------|----------------------------------------------|----------------------------------|
| `-p, --single`          | One-shot print mode                          | Scoped tasks                     |
| `--worktree [name]`     | Isolated git worktree                        | Almost always use                |
| `--effort high\|max`    | Reasoning depth                              | Complex features                 |
| `--max-turns N`         | Safety cap                                   | Print mode only                  |
| `-m, --model`           | Model selection                              | Use when needed                  |
| `--rules`               | Extra system rules                           | Project-specific coding standards|
| `--no-subagents`        | Disable subagent spawning                    | When you want single agent       |
| `--experimental-memory` | Cross-session memory                         | Long-running projects            |
| `-c, --continue`        | Resume last session in dir                   | Quick follow-ups                 |
| `-r, --resume <id>`     | Resume specific session                      | Recovery                         |

## Monitoring & Control Commands (Hermes)

```bash
# List active coding sessions
tmux list-sessions | grep grok-

# Watch a session live (read-only view)
tmux capture-pane -t grok-backend -p -S -100

# Send follow-up instruction
tmux send-keys -t grok-backend 'Now add comprehensive tests' Enter

# Kill when done
tmux kill-session -t grok-backend
```

## Best Practices

1. **Always use `--worktree`** for anything non-trivial — keeps main branch clean.
2. **One tmux session per logical task** — easier to manage and review.
3. **Hermes reviews before merging** — capture diff from the worktree.
4. **Use high effort** for architecture-heavy work, medium for implementation.
5. **Clean up tmux sessions** after completion to avoid clutter.
6. **Combine with Hermes memory** — store project conventions so future Grok sessions inherit context.

## Example End-to-End Flow (Hermes Perspective)

1. User: "Add real-time notifications using WebSockets"
2. Hermes: Creates plan + breaks into backend + frontend + tests
3. Hermes: Spawns 3 tmux + grok sessions in parallel worktrees
4. Hermes: Monitors progress every 30-60s
5. Hermes: When all done, shows summary + diffs
6. User approves → Hermes merges worktrees

This pattern scales extremely well for large features.

---

**Ready to use.** Just tell me a coding task and I'll spin up the appropriate Grok + tmux setup.
