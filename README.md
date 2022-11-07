# gitlab-mirror-helper
NOT USEFUL! This is a works for me type of script. Look elesewhere for reusable things.

## my setup

### Layout

I Have a ``mirror/`` folder containing this repo and all mirrors.
It looks like this.

```
|-- MyOrg
|   |-- repo_a
|   |-- repo_b
|   `-- repo_c
`-- gitlab-mirror-helper
    |-- add.sh
    |-- README.md
    `-- tags
```

### Add repos

To add a new mirror I goto the root of the ``mirror/`` folder and run this command:

```bash
./gitlab-mirror-helper/add.sh git@github.com:MyOrg/repo_d.git
```

It assumes that I went to gitlab already and created this group https://gitlab.com/MyOrg
It also depends on my ssh config having a host ``gitlab-MIRROR`` that is authorized to push to the group.
The repository will be created by doing a ``git push``

### Keep them updated

```bash
cd ~/Desktop/mirror
screen -AmdS mirror ./gitlab-mirror-helper/mirror.sh
```
