#!groovy

pipeline {
    agent{node {label 'master'}}

    options { timestamps () }
    
    environment {
        PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/data/apache-maven-3.6.0/bin"
        PROJECT_NAME="gradle-demo-with-docker"
        GITHUB_CREDENTIAL_ID="Github-credential"
        NEXUS_URL="nexus.example.com:8082"
        NEXUS_CREDENTIAL_ID="Nexus-credential"
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
                withCredentials([usernamePassword(credentialsId: "${env.NEXUS_CREDENTIAL_ID}", usernameVariable: 'Nexus_USERNAME', passwordVariable: 'Nexus_PASSWORD')]) {
                    sh """
                    echo "[INFO] Login Nexus registry"
                    ./auto/login-nexus ${env.Nexus_USERNAME} ${env.Nexus_PASSWORD} ${env.NEXUS_URL}

                    echo "[INFO] Build and Release Image"
                    ./auto/release-image
                    """
                }
            }
        }

        stage("Env prerequsite"){
            environment {
                SSH_USER="root"
                SSH_PORT="22"
            }
            steps{
                echo "[INFO] Checking deployment env"
                sh """
                echo "[INFO] Checking SSH connection:"
                ./auto/test-ssh-connection ${env.SSH_USER} ${env.DEPLOY_ENV} ${env.SSH_PORT}
                echo "[INFO] Checking Disk space:"
                ./auto/check-resource ${env.SSH_USER} ${env.DEPLOY_ENV} ${env.SSH_PORT}
                """
                echo "[INFO] Env is ready to go..."
                input("Start deploying to ${DEPLOY_ENV}?")
            }
        }

        stage("Ansible Deployment"){
            steps{
                echo "[INFO] Start deploying war to the destination server"
                withCredentials([usernamePassword(credentialsId: "${env.NEXUS_CREDENTIAL_ID}", usernameVariable: 'Nexus_USERNAME', passwordVariable: 'Nexus_PASSWORD')]) {
                    sh "auto/ansible-playbook ${env.PROJECT_NAME} ${env.DEPLOY_ENV} ${env.Nexus_USERNAME} ${env.Nexus_PASSWORD} ${env.NEXUS_URL}"
                }
                echo "[INFO] Congratulation, Anisble Deployment has been finished successfully :)"
            }
        }

        stage("Health Check"){
            environment {
                APP_PORT="8083"
            }
            steps{
                echo "[INFO] Health check for destination server"
                sh "./auto/health-check ${env.DEPLOY_ENV} ${env.APP_PORT} ${env.PROJECT_NAME}"
                echo "[INFO] Congratulation, Health check is accomplished, please enjoy yourself... :)"
            }
        }

    }

}
