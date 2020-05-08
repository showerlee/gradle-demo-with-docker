# Ansible docker

Simple Ansible playbooks integrated with Jenkins, Github, Docker for CI/CD deployment, we can easily build an ansible docker image via specific ansible version, no more worrying about lengthy provisioning the ansible initial environment.

## How to use

- check [Dockerfile](./Dockerfile) for the build

- Build image with ansible:${VERSION-2.9}

```shell
export VERSION=2.9 && docker build --build-arg VERSION=${VERSION} -t nexus.example.com:8082/showerlee/ansible:${VERSION} .
```

- Run the container to test ansible version

```shell
docker run --rm nexus.example.com:8082/showerlee/ansible:2.9 ansible-playbook --version
```

- Run ansible playbook via docker

``` shell
auto/ansible-playbook -i inventory/[qa/prod] ./deploy.yml -e project=[wordpress] -e branch=[master/develop] -e env=[qa/prod]
```
