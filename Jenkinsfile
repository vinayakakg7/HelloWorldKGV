pipeline{
    agent any

    tools {
        maven 'maven'
        jdk 'Java'
    }
    environment {

        GIT_REPO = 'https://github.com/vinayakakg7/HelloWorldKGV.git'
        GIT_BRANCH = 'main'
        NEXUS_SNAPSHOT_REPO = 'demo_snapshot'
      NEXUS_RELEASE_REPO = 'demo_release'
    }
    stages {
        stage('Clone Git repository') {
            steps {
                git branch: GIT_BRANCH, url: GIT_REPO
            }
        }
        
        stage('Build and test using Maven') {
            steps {
                bat 'mvn clean install -DskipTests=true'
            }
        }
        
        stage('Run SonarQube analysis') {
          steps {

             script{
                withSonarQubeEnv(credentialsId: 'sonarapi') {
                    bat 'mvn clean package sonar:sonar'
               }
           }
           }
       }
        
       stage('Check quality gate status') {
            steps {
              script {
                 def qg = waitForQualityGate()
                  if (qg.status != 'OK') {
                      error "Pipeline aborted due to quality gate failure: ${qg.status}"
                  }
              }
          }
       }
       
      stage('Upload JAR to Nexus repository') {

        steps {

           script {
            def pom = readMavenPom file: 'pom.xml'
              def version = pom.version
                env.version = version
                  def snapshot = version.endsWith('-SNAPSHOT')
                    
                    def repo = snapshot ? NEXUS_SNAPSHOT_REPO : NEXUS_RELEASE_REPO
                    env.repo = repo
                  
                    def groupId = pom.groupId
                    env.groupId = groupId

        
                    nexusArtifactUploader artifacts: [
                          [artifactId: 'springboot', classifier: '', file: 'target/*.jar', type: 'jar']
                          ], 
                           credentialsId: 'nexus_cred', 
                           groupId: "${env.groupId}", 
                            nexusUrl: '13.234.33.222:8081',
                            nexusVersion: 'nexus3', 
                            protocol: 'http',
                            repository: "${env.repo}", 
                           version: "${env.version}"

            }
}
}