node{
    
    def tag, dockerHubUser, containerName, httpPort = ""
    
    stage('Prepare Environment'){
        echo 'Initialize Environment'
        tag="3.0"
	withCredentials([usernamePassword(credentialsId: 'dockerHubAccount', usernameVariable: 'dockerUser', passwordVariable: 'dockerPassword')]) {
		dockerHubUser="$dockerUser"
        }
	containerName="bankingapp"
	httpPort="8989"
    }
    
    stage('Code Checkout'){
        try{
            checkout scm
        }
        catch(Exception e){
            echo 'Exception occured in Git Code Checkout Stage'
            currentBuild.result = "FAILURE"
        }
    }
    
    stage('Maven Build'){
        sh "mvn clean package"        
    }
    
    stage('Docker Image Build'){
        echo 'Creating Docker image'
        sh "docker build -t sravani81299/bankingapp:3.0 --pull --no-cache ."
    }  
	
    stage('Publishing Image to DockerHub'){
        echo 'Pushing the docker image to DockerHub'
        withCredentials([usernamePassword(credentialsId: 'dockerHubAccount', usernameVariable: 'dockerUser', passwordVariable: 'dockerPassword')]) {
		sh "docker login -u sravani81299 -p $dockerPassword"
		sh "docker push sravani81299/bankingapp:3.0"
		echo "Image push complete"
        } 
    }    
	stage('Ansible Playbook Execution'){
			sh "export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -i inventory.yaml containerDeploy.yaml -e httpPort=$httpPort -e containerName=$containerName -e dockerImageTag=sravani81299/$containerName:$tag -e key_pair_path=/var/lib/jenkins/server.pem --become" 
	}
}


