// This is a declarative Jenkins pipeline!

pipeline {
    agent {
        kubernetes {
            defaultContainer 'npm'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: npm
    image: node:10.15.1
    command:
    - cat
    tty: true
    resources:
      requests:
        cpu: "1000m"
        memory: "512Mi"
"""
        }
    }
    environment {
        npm_config_registry = "http://my-awesome-repo.example.com/"
    }
    stages {
        stage('Prepare environment') {
            steps {
                sh 'npm init -y'
            }
        }
    }
}
