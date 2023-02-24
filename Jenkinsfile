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
        DOCKER_REGISTRY = "hub.docker.com"
        DOCKER_NAMESPACE = "vinayakakg7"
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
       
   
   stage('Build Docker Image') {
 
   steps {
        script {
          def imageTag = "${DOCKER_NAMESPACE}/${env.JOB_NAME}:${env.BUILD_ID}" 
          bat "docker build -t ${imageTag} -f Dockerfile ."
         // withDockerRegistry([credentialsId: "Docker_Credential", url: DOCKER_REGISTRY]) {
         //   bat "docker push ${imageTag}"
      // }
       }
   }
   }

  

   // stage('Push image to DockerHub'){
    //  steps{
    //    script{
     //     withCredentials([string(credentialsId: 'Docker_Credentials', variable: 'Docker_Cred')]) {
      //      bat 'docker login -u vinayakakg7 -p ${Docker_Cred}'
       //      bat 'docker image push ${imageTag}-v1.${env.BUILD_ID}'
       //       bat 'docker image push ${imageTag}-v1.latest'

    
          //      }

         //    }
        
     //   }
    }
    }

