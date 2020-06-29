# Jenkins CI/CD Pipelines Workshop Quick Start Guide

**System Requirements:**
* 4GB available RAM.
* 20GB available disk storage.


**Getting started:**
1. Install prerequisites:
    * Mac users: 
        * [Hyperkit](https://minikube.sigs.k8s.io/docs/drivers/hyperkit/)
    * Linux users: 
        * [kvm2](https://minikube.sigs.k8s.io/docs/drivers/kvm2/)
    * Mac + Linux:
        * [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/).
        * [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
        * [helm](https://helm.sh/docs/intro/install/).
        * [sbt](https://www.scala-sbt.org/1.x/docs/Setup.html).
    
2. Checkout this repository and change directory to the root of the repository.

3. **[Optional]** Create a `.env` file and update your GitHub credentials and repository settings.
   See `.env.example` file for reference. 

4. Launch or reset workshop:
    ```bash
    $ ./reset-workshop.sh
   Resetting Jenkins workshop: 'cicd-jenkins-workshop-1'...
   ...
   Switched to context "cicd-jenkins-workshop-1".
   Installing Jenkins...
   Done!
   
   
   ====================================================================================
   Jenkins Admin user URL:               http://192.168.39.20:32000/login
   Jenkins Admin user name:              admin
   Jenkins Admin user password:          secret
   GitHub WebHook URL: (Ngrok tunnel)    https://123456abc.ngrok.io/github-webhook/
   ====================================================================================
    ```

5. **[Optional]** Update GitHub webhook URL in your GitHub repository settings.

6. Login to the Jenkins web UI and enter your credentials. If you see the 
`Welcome to ${WORKSHOP_NAME} Jenkins CI/CD!` screen, you are ready!


**Cleanup:**
```bash
$ ./reset-workshop.sh cleanup
```

**Troubleshooting**

* I'm getting a browser timeout error when trying to access the Jenkins UI `/login` page.
  Please try again to provision the lab by executing: 
  
    ```bash
    ./reset-workshop.sh
    ```
  
* I see the following error when executing `./reset-workshop.sh`: 
  
    ```bash
    zsh: command not found: minikube
    ```
  Please make sure you installed all the system requirements as per described
  in the Getting Started section.

* I see the following message when executing `./reset-workshop.sh`:

    ```bash
    The ‘hyperkit’ driver requires elevated permissions. The following commands will be executed:
    $ sudo chown root:wheel /Users/razalon/.minikube/bin/docker-machine-driver-hyperkit 
    $ sudo chmod u+s /Users/razalon/.minikube/bin/docker-machine-driver-hyperkit 
    ```
  Minikube is trying to update Hyperkit driver, this is normal. Please enter your operating system 
  username and password and hit Enter. 

**Scala Project:**
* Run unit tests:
    ```bash
    $ sbt 'testOnly -- -n UnitTest'
    ```
* Run "Slow" suite:
    ```bash
    $ sbt 'testOnly -- -n Slow'
    ```
* Run all tests:
    ```bash
    $ sbt test
    ```
