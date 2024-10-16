pipeline {
  environment {
    dockerimagename = "ktei8htop15122004/react-todo"
    dockerImage = ""
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
  }

  agent {
    kubernetes {
      yaml '''
      apiVersion: v1
      kind: Pod
      spec:
        serviceAccountName: jenkins-admin
        dnsConfig:
          nameservers:
            - 8.8.8.8
        containers:
        - name: docker
          image: docker:latest
          imagePullSecrets:
            - name: regcred
          command:
            - sh
            - -c
            - "while true; do sleep 10; done"
          tty: true
          securityContext:
            privileged: true
          volumeMounts:
            - mountPath: /var/run/docker.sock
              name: docker-sock
        - name: kubectl
          image: bitnami/kubectl:latest
          imagePullSecrets:
            - name: regcred
          command:
            - sh
            - -c
            - "while true; do sleep 10; done"
          tty: true
        volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock
      '''
    }
  }

  stages {
    stage('Unit Test') {
      when {
        expression {
          return env.BRANCH_NAME != 'master';
        }
      }
      steps {
        sh 'echo Unit Test'
      }
    }

    stage('Build image') {
      steps {
        container('docker') {
          script {
            sh 'docker build --network=host -t ktei8htop15122004/react-todo .'
          }
        }
      }
    }

    stage('Pushing Image') {
      steps {
        container('docker') {
          script {
            sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            sh 'docker tag ktei8htop15122004/react-todo ktei8htop15122004/react-todo'
            sh 'docker push ktei8htop15122004/react-todo:latest'
          }
        }
      }
    }

    stage('Deploying App to Kubernetes') {
      steps {
        container('kubectl') {
          withCredentials([file(credentialsId: 'kube-config-admin', variable: 'TMPKUBECONFIG')]) {
            sh "kubectl --kubeconfig=\$TMPKUBECONFIG apply -f deployment-react.yaml"
          }
        }
      }
    }
  }
}
