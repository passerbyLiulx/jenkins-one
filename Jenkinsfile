def id = "6c8c156b-55a8-4564-bc61-4776377d9104"
def gitUrl = "https://github.com/passerbyLiulx/jenkins-one.git"
def branch = "${branch}"

def dockerUrl = "182.92.173.125"
def dockerUserName = "admin"
def dockerPassword = "admin@123"
def dockerNameSpace = "testOne"
def imageName = "jenkins-one"
def serviceName = "jenkins-one:${branch}"

pipeline {
    agent any

    stages {
        stage('拉取git代码') {
            steps {
                echo "部署模块：jenkins-one, git分支：${branch}, 正在拉取代码..."
                checkout([$class: 'GitSCM', branches: [[name: branch]], extensions: [],
                          userRemoteConfigs: [[credentialsId: id,
                                               url: gitUrl]]])
                echo "拉取代码完成..."
            }
        }

        stage('编译代码') {
            steps {
                echo "开始进行编译..."
                sh '''
                npm install --unsafe-perm --registry https://registry.npm.taobao.org
                npm run build
                '''
                echo "编译操作结束..."
            }
        }

        stage('打包docker') {
            steps {
                echo "开始docker 操作..."
                // 构建
                sh " docker build -t ${dockerUrl}/${dockerNameSpace}/${imageName}:${branch} . "
                // 登录
                sh " docker login -u ${dockerUserName} -p ${dockerPassword} ${dockerUrl}"
                // push
                sh " docker push  ${dockerUrl}/${dockerNameSpace}/${imageName}:${branch}"
                // 删除
                sh " docker rmi   ${dockerUrl}/${dockerNameSpace}/${imageName}:${branch}"
                echo "开始docker 操作完成..."
            }
        }

        stage('连接ssh, 执行 docker compose') {
            steps {
                echo "开始执行 ssh..."
                sshPublisher(publishers: [sshPublisherDesc(configName: "${branch}", transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand:
                        "cd /usr/local/dockerCompose/${dockerNameSpace}/;" +
                                "docker-compose stop ${imageName};" +
                                "docker-compose rm -f ${imageName};" +
                                "docker rmi ${dockerUrl}/${dockerNameSpace}/${imageName}:${branch};" +
                                "docker pull ${dockerUrl}/${dockerNameSpace}/${imageName}:${branch};" +
                                "docker-compose up -d ${imageName}",
                        execTimeout: 720000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false,
                        patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '',
                        sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                echo "ssh 执行结束..."
            }
        }
    }
}
