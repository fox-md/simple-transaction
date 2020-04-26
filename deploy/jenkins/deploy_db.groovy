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
            
    stage('Create database') {
      steps{
        withCredentials([usernamePassword(credentialsId: 'SQL_CREDENTIALS', passwordVariable: 'SQL_PASS', usernameVariable: 'SQL_USER')]) {
            sh script: """docker run --rm \\
            -v ${WORKSPACE}/src/Database/flyway/sql/create:/flyway/sql \\
            flyway/flyway -user=${SQL_USER} -password=${SQL_PASS} \\
            -url='jdbc:sqlserver://${SQL_HOST}:1433;databaseName=master' \\
            -driver=com.microsoft.sqlserver.jdbc.SQLServerDriver \\
            -placeholders.DatabaseName=SimpleTransaction -mixed=true migrate"""
        }
      }
    }
    
    stage('Migrate database') {
      steps{
        withCredentials([usernamePassword(credentialsId: 'SQL_CREDENTIALS', passwordVariable: 'SQL_PASS', usernameVariable: 'SQL_USER')]) {
            sh script: """docker run --rm \\
            -v ${WORKSPACE}/src/Database/flyway/sql/schema:/flyway/sql \\
            flyway/flyway -user=${SQL_USER} -password=${SQL_PASS} \\
            -url='jdbc:sqlserver://${SQL_HOST}:1433;databaseName=SimpleTransaction' \\
            -driver=com.microsoft.sqlserver.jdbc.SQLServerDriver \\
            -placeholders.DatabaseName=SimpleTransaction migrate"""
        }
      }  
    }
  }
}
