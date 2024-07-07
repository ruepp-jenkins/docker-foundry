properties(
    [
        githubProjectProperty(
            displayName: 'docker-foundry',
            projectUrlStr: 'https://github.com/MyUncleSam/docker-foundry/'
        ),
        parameters(
            [
                string(
                    name: 'IMAGE_FULLNAME',
                    defaultValue: 'stefanruepp/foundry-gameserver'
                )
            ]
        )
    ]
)

pipeline {
    agent {
        label 'docker'
    }

    triggers {
        URLTrigger(
            cronTabSpec: 'H/30 * * * *',
            entries: [
                URLTriggerEntry(
                    url: 'https://hub.docker.com/v2/namespaces/library/repositories/ubuntu/tags/24.04',
                    contentTypes: [
                        JsonContent(
                            [
                                JsonContentEntry(jsonPath: '$.last_updated')
                            ]
                        )
                    ]
                )
            ]
        )
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/MyUncleSam/docker-foundry.git'
            }
        }
        stage('Build') {
            steps {
                sh 'chmod +x scripts/*.sh'
                sh './scripts/start.sh'
            }
        }
    }

    post {
        always {
            discordSend result: currentBuild.currentResult,
                description: env.GIT_URL,
                link: env.BUILD_URL,
                title: JOB_NAME,
                webhookURL: DISCORD_WEBHOOK
        }
    }
}
