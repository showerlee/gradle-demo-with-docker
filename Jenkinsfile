#!groovy

pipeline {
    agent{node {label 'master'}}

    options { timestamps () }
    
    environment {
        PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/data/apache-maven-3.6.0/bin"
        GITHUB_CREDENTIAL_ID="Github-credential"
    }
    
    parameters {
        choice(
            choices: 'dev\nprod',
            description: 'choose deploy environment',
            name: 'DEPLOY_ENV')
        string(
            defaultValue: "master", 
            description: 'Choose the branch of repository for gradle-demo-with-docker', 
            name: 'BRANCH')
    }
    
    stages {
        stage("Checkout code from github"){
            steps{
                echo "[INFO] Checkout code from github."
                dir ("${env.WORKSPACE}/gradle-demo-with-docker") {
                    git branch: "${env.BRANCH}", credentialsId: "${env.GITHUB_CREDENTIAL_ID}", url: "https://github.com/showerlee/gradle-demo-with-docker.git"
                }
            }
        }

        stage("Build and Release Image"){
            steps{
                environment {
                    NEXUS_URL="nexus.example.com:8082"
                    NEXUS_CREDENTIAL_ID="Nexus-credential"
                }
                withCredentials([usernamePassword(credentialsId: "${env.NEXUS_CREDENTIAL_ID}", usernameVariable: 'Nexus_USERNAME', passwordVariable: 'Nexus_PASSWORD')]) {
                    sh """
                    echo "[INFO] Login Nexus registry"
                    docker login -u ${env.Nexus_USERNAME} -p ${env.Nexus_PASSWORD} ${env.NEXUS_URL}

                    echo "[INFO] Build and Release Image"
                    ./auto/release-image
                    """
                }
            }
        }

        stage("Env prerequsite"){
            steps{
                echo "[INFO] Checking deployment env"
                environment {
                    SSH_USER="root"
                    SSH_PORT="22"
                }

                sh """
                set +x
                echo "[INFO] Checking SSH connection:"
                ./auto/test-ssh-connection ${env.SSH_USR} ${env.DEPLY_ENV} ${env.SSH_PORT}

                echo "[INFO] Checking Disk space:"
                ssh -p${SSH_PORT} ${SSH_USER}@$domain df -h
                echo ""
                echo "[INFO] Checking RAM space:"
                ssh -p$SSH_PORT ${SSH_USER}@$domain free -m
                set -x
                """
                echo "[INFO] Env is ready to go..."
                input("Start deploying to ${DEPLOY_ENV}?")
            }
        }

        stage("Ansible Deployment"){
            steps{
                echo "[INFO] Start deploying war to the destination server"
                sh """
                set +x
                source /home/deploy/.py3env/bin/activate
                echo "[INFO] Checking python version"
                python --version
                . /home/deploy/.py3env/ansible/hacking/env-setup -q
                echo "[INFO] Checking ansible version"
                ansible --version
                echo "[INFO] Start ansible deployment"
                cd ${env.WORKSPACE}/Java-war-dev/ansible/
                ansible-playbook -i inventory/$DEPLOY_ENV ./deploy.yml -e project="${env.PROJECT_NAME}"             
                set -x

                """
                echo "[INFO] Congratulation, Anisble Deployment has been finished successfully :)"
            }
        }

        stage("Health Check"){
            steps{
                environment {
                    PROJECT_NAME="gradle-demo-with-docker"
                    APP_PORT="8083"
                }

                echo "[INFO] Health check for destination server"
                sh """
                ./auto/health-check ${env.DEPLOY_ENV} ${env.APP_PORT} ${env.PROJECT_NAME}
                """
                echo "[INFO] Congratulation, Health check is accomplished, please enjoy yourself... :)"
            }
        }

    }

}
