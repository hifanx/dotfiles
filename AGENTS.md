# AGENTS.md

Instructions for coding agents working in this repo.

## Repo layout rule

This repo is a GNU stow package tree. It has **no `docs/` directory by design**. Every skill-generated file goes under `.scratch/` (gitignored). Never create `docs/`, `docs/agents/`, or `docs/adr/` here. Never run `/setup-matt-pocock-skills` in this repo — its config already lives in `.scratch/docs/`. When a skill's instructions say `docs/agents/…` or `docs/adr/`, the path here is `.scratch/docs/…`.

## Agent skills

### Issue tracker

Local markdown files under `.scratch/`. See `.scratch/docs/issue-tracker.md`.

### Triage labels

Default canonical labels (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `.scratch/docs/triage-labels.md`.

### Domain docs

Single-context: root `CONTEXT.md` + ADRs at `.scratch/docs/adr/`. See `.scratch/docs/domain.md`.
