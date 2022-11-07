# gitlab-mirror-helper
NOT USEFUL! This is a works for me type of script. Look elesewhere for reusable things.

## my setup

I Have a ``mirror/`` folder containing this repo and all mirrors.
It looks like this.

```
|-- ChillerDragon
|   |-- repo_a
|   |-- repo_b
|   `-- repo_c
`-- gitlab-mirror-helper
    |-- add.sh
    |-- README.md
    `-- tags
```

To add a new mirror I goto the root of the ``mirror/`` folder and run this command:

```
./gitlab-mirror-helper/add.sh git@github.com:ChillerDragon/repo_d.git
```

It assumes that I went to gitlab already and created this repo https://gitlab.com/ChillerDragon/repo_d
It also depends on my ssh config having a host ``gitlab-MIRROR`` that is authorized to push to the repo.
