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
