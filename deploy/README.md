# deploy

OpenTofu root that puts Gitea and its runner under SubZeroDev.Infra's `modules/app`: a Cloudflare tunnel with `git.subzerodev.com`, and a Portainer Git stack (`docker-compose.yml` + `compose.tunnel.yaml`). State: R2 bucket `subzerodev-tofu-state`, key `apps/gitea.tfstate`, encrypted. Run everything through `deploy/tofu.ps1`; it loads credentials from your User-scope environment and the stack's values from a private var-file outside the repository (`~/.subzerodev/gitea.tfvars.json`, written with `scripts/export-stack-env.ps1` of SubZeroDev.Infra).

Images are pinned by digest in `docker-compose.yml`: change the pin in a PR and Portainer redeploys. Data lives in the named volumes `gitea_data`, `postgres_data`, `runner_data` and `runner_docker`; none is touched by an apply.

SSH is disabled in this Gitea, and the tunnel carries HTTPS only. Cloudflare limits a request body to 100 MB on the free plan, so a larger `git push` over HTTPS is refused.

## First adoption

1. Back up `gitea_data` and the database.
2. Merge the PR that adds these files to `main`.
3. `./deploy/tofu.ps1 plan`. Expect: stack 17 imported and replaced, a tunnel, and the `git` record repointed.
4. Apply, check `https://git.subzerodev.com`, then a second `plan` shows no changes.
