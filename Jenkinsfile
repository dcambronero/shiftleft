pipeline {
      agent any
      environment {
           CHKP_CLOUDGUARD_ID = credentials("CHKP_CLOUDGUARD_ID")
           CHKP_CLOUDGUARD_SECRET = credentials("CHKP_CLOUDGUARD_SECRET")
	   SPECTRAL_DSN = credentials("SPECTRAL_DSN")
        }
        
  stages {
          
         stage('Clone Github repository') {
            
    
           steps {
              
             checkout scm
           
             }
  
          }
          
    stage('ShiftLeft Code Scan') {   
       steps {   
                   
         script {      
              try {

             
                
            
                sh 'chmod +x shiftleft' 

                sh './shiftleft code-scan -r -2003 -e b579409a-5b47-4fc9-9d6c-aacbe5313664 -s .'
           
               } catch (Exception e) {
    
                 echo "Request for Approval"  
                  }
              }
            }
         }
         
     stage('Code approval request') {
     
           steps {
             script {
               def userInput = input(id: 'confirm', message: 'Do you Approve to use this code?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Approve Code to Proceed', name: 'approve'] ])
              }
            }
          }
           
           
          stage('webapp Docker image Build and scan prep') {
             
            steps {

              sh 'docker build -t myweb:latest .'
              sh 'docker save myweb:latest -o webapp.tar'
              
             } 
           }
        
           
       stage('ShiftLeft Container Image Scan') {    
           
            steps {
                script {      
              try {
         
                    sh './shiftleft image-scan -r -2002 -e b579409a-5b47-4fc9-9d6c-aacbe5313664 -i webapp.tar'
                   } catch (Exception e) {
    
                 echo "Request for Approval"  
                  }
                }  
             }
          }
          
       stage('Container image approval request') {
     
           steps {
             script {
               def userInput = input(id: 'confirm', message: 'Do you Approve to use this container image?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Approve docker image to Proceed', name: 'approve'] ])
              }
            }
          }
        stage('install Spectral') {
      steps {
        sh "curl -L 'https://get.spectralops.io/latest/x/sh?dsn=$SPECTRAL_DSN' | sh"
      }
    }
    stage('scan for issues') {
      steps {
        sh "$HOME/.spectral/spectral scan --ok --include-tags base,audit,iac"
      }
    }

      stage('Terraform config policy Scan') {    
           
            steps {
         
                    sh './shiftleft iac-assessment -i terraform -p ./terraform/ -r -64 -e b579409a-5b47-4fc9-9d6c-aacbe5313664'
                    
              }
            }
  } 
}


