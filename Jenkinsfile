pipeline {
    agent any

environment {
    AWS_REGION    = "us-east-2"
    ACCOUNT_ID    = "899631475351"

    BACKEND_REPO  = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/devops-backend"
    FRONTEND_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/devops-frontend"
}

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to ECR') {
            steps {
                withAWS(credentials: 'aws-devops-creds', region: "${AWS_REGION}") {
                    sh '''
                        aws ecr get-login-password --region $AWS_REGION | docker login \
                            --username AWS \
                            --password-stdin ${ACCOUNT_ID}.dkr.ecr.$AWS_REGION.amazonaws.com
                    '''
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                sh '''
                    cd backend
                    docker build -t devops-backend:latest .
                    docker tag devops-backend:latest $BACKEND_REPO:latest
                '''
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh '''
                    cd frontend
                    docker build -t devops-frontend:latest .
                    docker tag devops-frontend:latest $FRONTEND_REPO:latest
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    docker push $BACKEND_REPO:latest
                    docker push $FRONTEND_REPO:latest
                '''
            }
        }

        stage('Deploy to ECS via Terraform') {
            steps {
                withAWS(credentials: 'aws-devops-creds', region: "${AWS_REGION}") {
                    dir('infra') {
                        sh '''
                            terraform init 
                            terraform apply -auto-approve \
                               -var="backend_image=$BACKEND_REPO:latest" \
                               -var="frontend_image=$FRONTEND_REPO:latest"
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment FAILED — check logs."
        }
    }
}
