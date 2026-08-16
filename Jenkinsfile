pipeline {
    agent any

    options {
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = "ranjeet301095/multibranch-flask-app"
        GIT_EMAIL  = "chavanranjeet451@gmail.com"
    }

    stages {

        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Build and Push Image") {
            when {
                branch "main"
            }

            steps {
                script {

                    env.IMAGE_TAG = "build-${BUILD_NUMBER}"

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'dockerhub-creds',
                            usernameVariable: 'DOCKER_USER',
                            passwordVariable: 'DOCKER_PASS'
                        )
                    ]) {

                        sh '''
                            set -e

                            docker build \
                                -t ${IMAGE_NAME}:${IMAGE_TAG} .

                            echo "$DOCKER_PASS" | docker login \
                                -u "$DOCKER_USER" \
                                --password-stdin

                            docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        '''
                    }
                }
            }
        }

        stage("Update K8s Manifest") {
            when {
                branch "main"
            }

            steps {
                script {

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'github-creds',
                            usernameVariable: 'GIT_USER',
                            passwordVariable: 'GIT_TOKEN'
                        )
                    ]) {

                        sh '''
                            set -e

                            git config user.name "$GIT_USER"
                            git config user.email "$GIT_EMAIL"

                            git fetch origin main
                            git checkout main
                            git reset --hard origin/main

                            sed -i "s|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|" k8s/deployment.yml

                            git add k8s/deployment.yml

                            if ! git diff --cached --quiet; then
                                git commit -m "Updated image tag to ${IMAGE_TAG}"

                                git push \
                                    https://${GIT_USER}:${GIT_TOKEN}@github.com/ranjeetchavan7/Multi-Branch-Production.git \
                                    main
                            else
                                echo "No changes to commit"
                            fi
                        '''
                    }
                }
            }
        }
    }
}