pipeline {
    agent any
    environment {
        CHKP_CLOUDGUARD_ID = credentials("CHKP_CLOUDGUARD_ID")
        CHKP_CLOUDGUARD_SECRET = credentials("CHKP_CLOUDGUARD_SECRET")
        SHIFTLEFT_REGION = 'us1'
        SPECTRAL_DSN = credentials("SPECTRAL_DSN")
    }
    
    stages {
        
        stage('Clone Github repository') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Spectral') {
            steps {
                sh "curl -L 'https://spectral-us.checkpoint.com/latest/x/sh?dsn=$SPECTRAL_DSN' | sh"
            }
        }
        
        stage('Scan for Issues') {
            steps {
                sh "$HOME/.spectral/spectral scan --ok --engines secrets,iac,oss --include-tags base,audit3,iac"
            }
        }
        
        
        stage('Webapp Docker Image Build and Scan Prep') {
            steps {
                sh 'docker build -t myweb:latest .'
                sh 'docker save myweb:latest -o webapp.tar'
            }
        }
        
        stage('ShiftLeft Container Image Scan') {    
            steps {
                script {      
                    try {
                        sh 'chmod +x shiftleft'
                        sh './shiftleft image-scan -e 94fddd65-708a-4dc1-bac8-002fd35e34bf -i webapp.tar'
                    } catch (Exception e) {
                        echo "Request for Approval"
                    }
                }  
            }
        }
        
        stage('Container Image Approval Request') {
            steps {
                script {
                    def userInput = input(
                        id: 'confirm', 
                        message: 'Do you Approve to use this container image?', 
                        parameters: [ 
                            [$class: 'BooleanParameterDefinition', 
                             defaultValue: false, 
                             description: 'Approve docker image to Proceed', 
                             name: 'approve']
                        ]
                    )
                }
            }
        }
    }
}
