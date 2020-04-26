pipeline {
 
  agent {
	label 'docker'
  }
  
  stages {
    
    stage('Cloning Git') {
      steps {
        cleanWs()
        git 'https://github.com/fox-md/simple-transaction.git'
        //sh "sed -i 's/localhost/gw.ws-interconnect/g' test/Postman/SimpleTxApp.postman_environment.json"
        sh "sed -i 's/localhost/gw-service/g' test/Postman/SimpleTxApp.postman_environment.json"
      }
    }
	
    stage('Test API') {
      steps{
        ansiColor('xterm') {
            //ws-interconnect
            sh script: """docker run --rm --network mynet \
            -v ${WORKSPACE}/test/Postman:/etc/newman -t postman/newman_ubuntu1404 \
            run SimpleTxApp.postman_tests.json -e SimpleTxApp.postman_environment.json --color off"""
        }
      }
    }

  }
}