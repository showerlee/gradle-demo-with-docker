# gradle-demo-with-docker

The following is how to use jenkins CI/CD pipeline to build and release a gradle application via docker.

The repo contains Jenkinsfile, ansible playbook, Java application, gradle configurations, shell scripts and etc.

## Architecture

![Gradle-demo-with-docker architecture](https://github.com/showerlee/gradle-demo-with-docker/blob/master/docs/Gradle-demo-with-docker.png)

## Procedure

```txt
Checkout source code  ==> Build and release image  ==> Check prerequsite ==> Ansible deployment ==> Health check
```

Remember to proactive the prerequisite before rollout the pipeline.

## Prerequisite

```txt
Github ===> Git repo

Jenkins ===> CI/CD system

Docker ===> Docker container

Java ===> Java programming language

Gradle ===> Java Build tool

Nexus ===> Binary Package Repo

Python ===> Ansible dependency

Ansible ===> Deployment tool
```

## Runbook

1. Build all prerequisites in an instance or more instances depend on your budget

2. Create an [ansible docker](https://github.com/showerlee/gradle-demo-with-docker/tree/master/ansible) in Jenkins node.

2. Create a jenkins pipeline style job

3. Provision the repo and all related in pipeline job

4. Rock and roll
