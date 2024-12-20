pipeline {
    agent any

    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['apply', 'destroy', 'plan'], description: 'Select Terraform action to perform')
        string(name: 'USER_NAME', defaultValue: 'Admin', description: 'Specify who is running the code')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
        TF_VAR_aws_region     = 'us-east-1'
    }

    stages {
        stage('Checkout Version Control') {
            steps {
                dir('terraform') {
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[credentialsId: 'Github-Integration', url: 'https://github.com/tensanbaby/terraform.git']]])
                }
            }
        }

        stage('Terraform Validation') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Initialization') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Action Selector') {
            steps {
                dir('terraform') {
                    script {
                        if (params.TERRAFORM_ACTION == 'apply') {
                            sh 'terraform apply -auto-approve'
                        } else if (params.TERRAFORM_ACTION == 'destroy') {
                            sh 'terraform destroy -auto-approve'
                        } else if (params.TERRAFORM_ACTION == 'plan') {
                            sh 'terraform plan'
                        } else {
                            echo "Invalid Terraform action selected: ${params.TERRAFORM_ACTION}"
                            error "Invalid Terraform action selected: ${params.TERRAFORM_ACTION}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
}

