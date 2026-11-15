# Cloudflare Email Channel Implementation Plan

> Execute in the current session using the executing-plans workflow. The user has selected option A and requested a fork PR; console setup and merge remain with the user.

**Goal:** Enable the existing Cloudflare Email Service sender in production and verify user forwarding with real mail after deployment.

**Architecture:** Bind `send_email` as `email`, which the existing sender and forwarding channel selector already consume. Onboard sending domains in the Cloudflare account before merging. Keep the existing forwarding implementation unchanged and report any defects separately.

**Tech Stack:** Cloudflare Workers, Wrangler TOML, Hono, Drizzle/D1, Vue 3, Vitest.

**Spec:** `docs/superpowers/specs/2026-11-10-account-forward-design.md`, section 12, plus the user's seven real-environment checks.

## Constraints

- Only push a feature branch and open a PR in `disaster1-tesk/cloud-mail`, targeting `main`.
- The user merges the PR and performs Cloudflare console onboarding.
- Never commit credentials or edit existing production migrations.
- Preserve baseline hashes, command results, a reversible configuration change and a local verification report.
- Unit tests and a dry run are preparation evidence, not proof of real email delivery.

## Task 1: Prepare the configuration PR

- [x] Read production deployment instructions and section 12 of the forwarding spec.
- [x] Create an isolated worktree from fork `origin/main` and a `codex/` branch.
- [x] Preserve the original production TOML and SHA256 hashes of existing production migrations outside the repository.
- [x] Install locked dependencies and run `pnpm test:unit` before the change.
- [x] Add only the following production binding:

```toml
[[send_email]]
name = "email"
```

- [x] Document Workers Paid, domain onboarding, deployment and rollback in `docs/cloudflare-production.md`.
- [x] Build frontend assets and run `pnpm exec wrangler deploy --dry-run --config wrangler.production.toml`.
- [ ] Check the diff, migration hashes and unchanged runtime source; push the branch and open the fork PR.

## Task 2: User console setup and deployment

- [ ] User opens Compute → Email Service → Email Sending and enables Workers Paid.
- [ ] User onboards all eight sending domains; record the actual DNS entries shown by the console, never guessed DKIM values.
- [ ] Confirm all sending domains are ready and record account sending limits.
- [ ] User merges the PR; verify the Cloudflare build, deployment version and `email` binding.

## Task 3: Real-environment verification

- [ ] Add and verify the user's Gmail target; inspect the sender and mailbox receipt.
- [ ] Deliver an external message with an attachment and inline image; inspect sender, display name, Reply-To, attachment bytes and raw forwarding headers.
- [ ] Reply in Gmail and observe receipt at the original sender.
- [ ] Test a second-domain mailbox owned by the user, if one exists.
- [ ] Send from a second on-site account and observe forwarding.
- [ ] Inject `X-CloudMail-Forwarded: 1` on a controlled incoming test message and confirm no second hop.
- [ ] Agree a scoped Cloudflare failure injection before the production failure test: changing a Resend token cannot affect the selected Cloudflare binding. Verify ten consecutive failures, UI reason, re-enable and successful recovery without changing real-user-wide credentials or DNS.
- [ ] Write observations and blockers for every item in the local report; report defects with source lines without modifying runtime behavior.
