pipeline {

  agent {
	label 'docker'
  }
  
  stages {
	stage('Deploy image'){
		steps{
	      sh 'docker network create --attachable --driver overlay ws-internal'
	      
	      sh '''docker service create --name gw-service \
	      --hostname "{{.Node.Hostname}}-{{.Node.ID}}-{{.Service.Name}}" --replicas 1 \
	      --publish 80:80 --network ws-internal \
	      --env ID_ENDPOINT_HOST=id-service \
	      --env ID_ENDPOINT_PORT=80 \
	      --env TX_ENDPOINT_HOST=tx-service \
	      --env TX_ENDPOINT_PORT=80 \
	      local/gateway_api'''
	      
	      sh '''docker service create --name id-service \
	      --hostname "{{.Node.Hostname}}-{{.Node.ID}}-{{.Service.Name}}" --replicas 1 \
	      --network ws-internal \
	      local/identity_api'''
	      
		  withCredentials([usernamePassword(credentialsId: 'SQL_CREDENTIALS', passwordVariable: 'SQL_PASS', usernameVariable: 'SQL_USER')]) {
			  sh '''docker service create --name tx-service \
			  --hostname "{{.Node.Hostname}}-{{.Node.ID}}-{{.Service.Name}}" --replicas 1 \
			  --network ws-internal \
			  --env SQL_SERVER_HOST=${SQL_HOST} \
			  --env SQL_SERVER_USER=${SQL_USER} \
			  --env SQL_SERVER_PASS=${SQL_PASS} \
			  local/transaction_api'''
		  }
		}
	}

  }
}