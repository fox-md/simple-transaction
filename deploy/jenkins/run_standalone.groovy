pipeline {

  agent {
	label 'docker'
  }
  
  stages {
	stage('Deploy image'){
		steps{
	      sh 'docker network create --attachable --internal ws-internal'
	      
	      sh '''docker run -d --name gw \
				-e ID_ENDPOINT_HOST=id.ws-internal \
				-e ID_ENDPOINT_PORT=80 \
				-e TX_ENDPOINT_HOST=tx.ws-internal \
				-e TX_ENDPOINT_PORT=80 \
				-p 80:80 \
				local/gateway_api'''
	      
		  sh 'docker network connect ws-internal gw'
		  
	      sh '''docker run -d --name id \
				local/identity_api'''
	      
		  sh 'docker network connect ws-internal id'
		  
		  withCredentials([usernamePassword(credentialsId: 'SQL_CREDENTIALS', passwordVariable: 'SQL_PASS', usernameVariable: 'SQL_USER')]) {
			  sh '''docker run -d --name tx \
					-e SQL_SERVER_HOST=${SQL_HOST} \
					-e SQL_SERVER_USER=${SQL_USER} \
					-e SQL_SERVER_PASS=${SQL_PASS} \
					local/transaction_api'''
			  
			  sh 'docker network connect ws-internal tx'
		  }
		}
	}

  }
}