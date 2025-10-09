pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'eu-north-1'
    }
    parameters {
        
        
        choice choices: ['apply', 'destroy'], description: '''Choose your terraform action
        ''', name: 'action'
    }
    stages{
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Timothyolubiyi/Jenkins-EKS-terraform.git']])
                }
            }
        }
        
        stage('Initializing teraform'){
            steps{
                script{
                    dir('terraform'){
                         sh 'terraform init'
                        
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('terraform'){
                         sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the infrastructure'){
            steps{

                script{

                    dir('terraform'){

                        sh 'terraform plan'
                    }
                    input(message: "Approve?", ok: "proceed")
                }
            }
        }

        stage('Terraform Apply') {
            steps {
               /// withAWS(credentials: 'aws-key', region: 'eu-north-1') { 
                script {
                    if (params.'action' == 'apply') {

                        echo "You have chosen to ${params.'action'} the resources"
                        dir('terraform'){
                            sh 'terraform $action --auto-approve'
                            sh 'aws eks describe-cluster --name my-eks-cluster2 --region eu-north-1'
                            sh ('aws eks update-kubeconfig --name my-eks-cluster2 --region eu-north-1')
                            //sh "kubectl get ns"
                            sh "kubectl apply -f deployment.yaml"
                            sh "kubectl apply -f service.yaml"
                                
                    
                        }
                    }
                }
        

            }
        }
       
        stage('Terraform Destroy') {
            steps {
               /// withAWS(credentials: 'aws-key', region: 'us-east-1') { 
                script {
                    if (params.'action' == 'destroy') {

                        echo "You have chosen to ${params.'action'} the resources"
                        dir('terraform'){
                            sh 'terraform $action --auto-approve'
                        
                        }
                    }
                }
        

            }
        }
    }
}