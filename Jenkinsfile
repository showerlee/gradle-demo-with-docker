#!groovy

pipeline {
    agent{node {label 'master'}}

    options {
        timestamps ()
        ansiColor('xterm')
    }
    
    environment {
        PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin"
        PROJECT_NAME="gradle-demo-with-docker"
        GITHUB_CREDENTIAL_ID="Github-credential"
        NEXUS_URL="nexus.example.com:8082"
        NEXUS_CREDENTIAL_ID="Nexus-credential"
        SSH_USER="root"
        SSH_PORT="22"
        APP_PORT="8083"
    }
    
    stages {
        stage("Functional test"){
            steps{
                sh """
                echo "[INFO] Run functional test"
                ./auto/run-functional-test
                """
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

        stage("Initialize test env"){
            environment {
                DEPLOY_ENV="test"
            }
            steps{
                echo "[INFO] Initialize test env"
                sh """
                echo "Clean up docker resources"
                ./auto/clean-resource
                echo "[INFO] Checking SSH connection:"
                ./auto/test-ssh-connection ${env.SSH_USER} ${env.DEPLOY_ENV} ${env.SSH_PORT}
                echo "[INFO] Checking Disk space:"
                ./auto/check-resource ${env.SSH_USER} ${env.DEPLOY_ENV} ${env.SSH_PORT}
                """
                echo "[INFO] Env is ready to go..."
            }
        }

        stage("Deploy test env via ansible"){
            environment {
                DEPLOY_ENV="test"
            }
            steps{
                echo "[INFO] Start deploying war to the destination server"
                withCredentials([usernamePassword(credentialsId: "${env.NEXUS_CREDENTIAL_ID}", usernameVariable: 'Nexus_USERNAME', passwordVariable: 'Nexus_PASSWORD')]) {
                    sh "auto/ansible-playbook ${env.PROJECT_NAME} ${env.DEPLOY_ENV} ${env.Nexus_USERNAME} ${env.Nexus_PASSWORD} ${env.NEXUS_URL}"
                }
                echo "[INFO] Deployment is complete in ${env.DEPLOY_ENV} :)"
            }
        }

        stage("Health Check in test env"){
            environment {
                DEPLOY_ENV="test"
            }
            steps{
                echo "[INFO] Health check for destination server"
                sh "./auto/health-check ${env.DEPLOY_ENV} ${env.APP_PORT} ${env.PROJECT_NAME}"
                echo "[INFO] Health check is complete, deployment is accomplished in ${env.DEPLOY_ENV} :)"
                input("Start to deploy in prod?")
            }
        }

        stage("Initialize prod env"){
            environment {
                DEPLOY_ENV="prod"
            }
            steps{
                echo "[INFO] Initialize prod env"
                sh """
                echo "Clean up docker resources in build agent"
                ./auto/clean-resource
                echo "[INFO] Checking SSH connection:"
                ./auto/test-ssh-connection ${env.SSH_USER} ${env.DEPLOY_ENV} ${env.SSH_PORT}
                echo "[INFO] Checking Disk space:"
                ./auto/check-resource ${env.SSH_USER} ${env.DEPLOY_ENV} ${env.SSH_PORT}
                """
                echo "[INFO] Env is ready to go..."
            }
        }

        stage("Deploy prod env via ansible"){
            environment {
                DEPLOY_ENV="prod"
            }
            steps{
                echo "[INFO] Start deploying war to the destination server"
                withCredentials([usernamePassword(credentialsId: "${env.NEXUS_CREDENTIAL_ID}", usernameVariable: 'Nexus_USERNAME', passwordVariable: 'Nexus_PASSWORD')]) {
                    sh "auto/ansible-playbook ${env.PROJECT_NAME} ${env.DEPLOY_ENV} ${env.Nexus_USERNAME} ${env.Nexus_PASSWORD} ${env.NEXUS_URL}"
                }
                echo "[INFO] Deployment is complete in ${env.DEPLOY_ENV} :)"
            }
        }

        stage("Health Check in prod env"){
            environment {
                DEPLOY_ENV="prod"
            }
            steps{
                echo "[INFO] Health check for destination server"
                sh "./auto/health-check ${env.DEPLOY_ENV} ${env.APP_PORT} ${env.PROJECT_NAME}"
                echo "[INFO] Health check is complete, deployment is accomplished in ${env.DEPLOY_ENV} :)"
            }
        }

    }

}
