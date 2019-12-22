# gradle-demo-with-docker

The following is how to use jenkins CI/CD pipeline to build and release a gradle application via docker.

The repo contains Jenkinsfile, ansible playbook, Java application, gradle configurations, shell scripts and etc.

## Procedure

```txt
Checkout source code  ==> Build and release image  ==> Check prerequsite ==> Ansible deployment ==> Health check

```

Remember to proactive the prerequisite before rollout the pipeline.

## Prerequisite

```txt
Github ===> Git repo

Jenkins ===> CI/CD system

Java ===> Java programming language

Gradle ===> Java Build tool

Nexus ===> Binary Package Repo

Python ===> Ansible dependency

Ansible ===> Deployment tool

```

## Runbook

1. Build all prerequisites in a box or more boxes

2. Create a jenkins pipeline style job

3. Import the repo into pipeline job

4. Rock and roll
