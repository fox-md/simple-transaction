pipeline {

  agent {
	label 'docker'
  }
  
  stages {
    stage('Cloning Git') {
        steps {
            cleanWs()
            git 'https://github.com/fox-md/simple-transaction.git'
        }
    }
	
    stage('Build GatewayApi image') {
        steps{
            sh "docker build -t local/gateway_api:$BUILD_NUMBER -t local/gateway_api:latest -f deploy/Gateway.dockerfile ."
        }
    }

    stage('Build IdentityApi image') {
        steps{
            sh "docker build -t local/identity_api:$BUILD_NUMBER -t local/identity_api:latest -f deploy/Identity.dockerfile ."
        }
    }
    
    stage('Build TransactionApi image') {
        steps{
            sh "docker build -t local/transaction_api:$BUILD_NUMBER -t local/transaction_api:latest -f deploy/Transaction.dockerfile ."
        }
    }

  }

  post {
    always {
      sh script: 'docker image prune -f'
    }
  }
}