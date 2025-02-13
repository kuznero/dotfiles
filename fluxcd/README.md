# FluxCD SPIKE

## Objective

Demonstrate built-in capabilities of FluxCD with an emphasiz in the following areas:

1. Variable substitution
1. Interdependencies
1. Secret management

## Bootstrap local cluster

### Generate and deploy SSH keys

> This step need to only be done once.

First, let's generate SSH key (do not set any passwords when generating new
keys, and save keys as `~/.ssh/flux[.pub]`):

```bash
ssh-keygen -t rsa-sha2-512
```

Then, registry public key in source control management system to ensure it has
access to the target repository.

### Managing secrets with SOPS/AGE

References:

- [Managing Kubernetes secrets with SOPS](https://fluxcd.io/flux/guides/mozilla-sops/)
  - [Encrypting secrets using age](https://fluxcd.io/flux/guides/mozilla-sops/#encrypting-secrets-using-age)

First, it is important to create `age.agekey` file that should never be
committed to source control but should be kept in a secure way. Though, for the
purpose of demonstration `age.agekey` generated with `age-keygen -o age.agekey`
command is committed to source control.

> It is specific to each cluster, and is saved as `/clusters/local/age.agekey`.

### Pre-pull all necessary images

> This step need to only be done once until you remove `playground-data` docker
> volume that caches all the container images.

```bash
task images:pull
```

### Start local cluster

After new key was properly imported to source control management system, run
the following command to start and bootstrap your local cluster:

```bash
task start
```
