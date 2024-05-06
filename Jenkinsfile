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
                ),
                string(
                    name: 'STEAM_GAMESERVERID',
                    defaultValue: '2915550'
                ),
                string(
                    name: 'GAMESERVER_CMD',
                    defaultValue: 'FoundryDedicatedServer.exe -log'
                ),
                string(
                    name: 'STEAM_ADDITIONAL_UPDATE_ARGS',
                    defaultValue: ''
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
                    url: 'https://www.syncovery.com/linver_x86_64-Web.tar.gz.txt',
                    contentTypes: [
                        MD5Sum()
                    ]
                ),
                URLTriggerEntry(
                    url: 'https://www.syncovery.com/linver_aarch64.tar.gz.txt',
                    contentTypes: [
                        MD5Sum()
                    ]
                ),
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
}
