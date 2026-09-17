# Dotfiles

A personal dotfiles repository managed with GNU stow. Each top-level directory is a package that stows into the home directory; the Neovim config is the most actively edited one.

## Language

### Repository

**Package**:
A top-level directory that `stow <name>` installs into `$HOME` as symlinks.
_Avoid_: Module, bundle, dotfile dir

**Stow**:
To install a package's files into `$HOME` (e.g. `stow nvim`).
_Avoid_: Install, deploy, sync

**Repo root**:
The top of this repository, where the packages, `AGENTS.md`, and this file live.

**Machine**:
A host that runs this dotfiles repo (`setup_mac.sh`, `setup_arch.sh`).
_Avoid_: Host, box, environment

**Scratch**:
`.scratch/` at the repo root — the only place skill output lives; gitignored. This repo has no `docs/` directory by design.
_Avoid_: Docs, notes, temp

**Feature**:
One work effort with its own `.scratch/<feature>/` directory containing a spec and tickets.
_Avoid_: Epic, project

**Ticket**:
One tracked piece of work, one file under `.scratch/<feature>/issues/`.
_Avoid_: Issue, task, todo

**ADR**:
A recorded decision under `.scratch/docs/adr/`, numbered sequentially.
_Avoid_: Decision log, design note
