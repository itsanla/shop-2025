pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-token')
        GHCR_CREDENTIALS = credentials('github-token')
        DOCKER_IMAGE = 'itsanla/mobile-api'
        GHCR_IMAGE = 'ghcr.io/itsanla/mobile-api'
        SERVICE_NAME = 'mobile-api'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Get Version') {
            steps {
                script {
                    def commitMsg = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    echo "Commit message: ${commitMsg}"
                    
                    def tags = sh(
                        script: """curl -s 'https://registry.hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags?page_size=100' | \
                                   grep -o '"name":"[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+"' | \
                                   grep -o '[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+' | \
                                   sort -V | tail -1""",
                        returnStdout: true
                    ).trim()
                    
                    if (tags == '') {
                        env.NEW_VERSION = '1.0.0'
                    } else {
                        def version = tags.tokenize('.')
                        def major = version[0].toInteger()
                        def minor = version[1].toInteger()
                        def patch = version[2].toInteger()
                        
                        if (commitMsg.contains('[major]')) {
                            major += 1
                            minor = 0
                            patch = 0
                            echo "Major version bump detected"
                        } else if (commitMsg.contains('[minor]')) {
                            minor += 1
                            patch = 0
                            echo "Minor version bump detected"
                        } else {
                            patch += 1
                            echo "Patch version bump (default)"
                        }
                        
                        env.NEW_VERSION = "${major}.${minor}.${patch}"
                    }
                    
                    echo "Current version: ${tags ?: 'none'}"
                    echo "New version: ${env.NEW_VERSION}"
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                dir('apps/api') {
                    sh "docker build --no-cache -t ${DOCKER_IMAGE}:${env.NEW_VERSION} ."
                    sh "docker tag ${DOCKER_IMAGE}:${env.NEW_VERSION} ${DOCKER_IMAGE}:latest"
                    sh "docker tag ${DOCKER_IMAGE}:${env.NEW_VERSION} ${GHCR_IMAGE}:${env.NEW_VERSION}"
                    sh "docker tag ${DOCKER_IMAGE}:${env.NEW_VERSION} ${GHCR_IMAGE}:latest"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                sh "docker push ${DOCKER_IMAGE}:${env.NEW_VERSION}"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }
        
        stage('Push to GHCR') {
            steps {
                sh 'echo $GHCR_CREDENTIALS_PSW | docker login ghcr.io -u $GHCR_CREDENTIALS_USR --password-stdin'
                sh "docker push ${GHCR_IMAGE}:${env.NEW_VERSION}"
                sh "docker push ${GHCR_IMAGE}:latest"
            }
        }
        
        stage('Cleanup') {
            steps {
                sh "docker rmi ${DOCKER_IMAGE}:${env.NEW_VERSION} ${DOCKER_IMAGE}:latest || true"
                sh "docker rmi ${GHCR_IMAGE}:${env.NEW_VERSION} ${GHCR_IMAGE}:latest || true"
            }
        }
    }
    
    post {
        success {
            echo "Build ${SERVICE_NAME} service v${env.NEW_VERSION} berhasil buk!"
        }
        failure {
            echo "Build ${SERVICE_NAME} service gagal buk!"
        }
    }
}
