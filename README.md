# docker-github-runner-linux

Repository for building a self hosted GitHub runner as a ubuntu linux container

For more details on using this repo, check out my blog post: [Self Hosted GitHub Runners on Azure - Linux Container](https://dev.to/pwd9000/create-a-docker-based-self-hosted-github-runner-linux-container-48dh).

Also see my GitHub repository: [docker-github-runner-windows](https://github.com/Pwd9000-ML/docker-github-runner-windows) for building a self hosted GitHub runner as a windows container.

## Notes

- Keep in mind that .dockerignore is a whitelist (this can cause files to not be found during COPY/ADD operations if they are not added to it)
- Run cacher proxy in advance with `docker compose up apt-cacher-ng` before running `docker compose up runner`
- `wget` `actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz` into `downloaded_files` before starting runner
