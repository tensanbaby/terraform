pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/tensanbaby/terraform.git'  // Replace with your Git repository URL
        BRANCH = 'main'  // Replace with your branch name
        TF_WORKSPACE = 'main.tf'  // Directory containing your Terraform scripts
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Cloning the repository...'
                git branch: "${BRANCH}", url: "${REPO_URL}"
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir("${TF_WORKSPACE}") {  // Navigate to Terraform workspace
                    echo 'Initializing Terraform...'
                    sh 'terraform init'
                }
            }
        }

        stage('Validate Terraform Configuration') {
            steps {
                dir("${TF_WORKSPACE}") {
                    echo 'Validating Terraform files...'
                    sh 'terraform validate'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir("${TF_WORKSPACE}") {
                    echo 'Planning Terraform deployment...'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir("${TF_WORKSPACE}") {
                    echo 'Applying Terraform configuration...'
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()  // Clean up workspace
        }
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed. Please check the logs.'
        }
    }
}
