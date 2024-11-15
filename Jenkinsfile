pipeline {
    agent any

    environment {
        // AWS Credentials - Ensure 'aws-access-key-id' and 'aws-secret-access-key' are Jenkins credentials
        AWS_ACCESS_KEY_ID      = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY  = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION     = 'us-east-1'  // Set AWS region
        //TF_WORKSPACE           = 'terraform'  // Define the Terraform working directory, adjust as needed
    }

    stages {
        stage('Checkout Application Code') {
            steps {
                script {
                    // Checkout application code from the specified Git repository
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']], 
                              doGenerateSubmoduleConfigurations: false, 
                              extensions: [], 
                              submoduleCfg: [], 
                              userRemoteConfigs: [[credentialsId: 'jenkins-git', url: 'https://github.com/tensanbaby/terraform.git']]])
                }
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
            cleanWs()  // Clean up workspace after the pipeline finishes
        }
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed. Please check the logs.'
        }
    }
}


