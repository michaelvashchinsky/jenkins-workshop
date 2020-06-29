#!/usr/bin/env bash
set -e

DOTENV=./.env
DOTENV_EXAMPLE=./.env.example

if test -f "$DOTENV"; then
    export $(cat "$DOTENV" | xargs)
else
    echo "INFO: Missing .env file, using defaults from ${DOTENV_EXAMPLE}"
    export $(cat "$DOTENV_EXAMPLE" | xargs)
fi

if [ "$1" == "cleanup" ]; then
    echo "Cleaning Jenkins workshop: '${WORKSHOP_NAME}'..."
    minikube delete --profile ${WORKSHOP_NAME}
    exit 0
fi

OS="$(uname -s)"
if [ "${OS}" == "Darwin" ]; then
    DRIVER="hyperkit"
elif [ "${OS}" == "Linux" ]; then
    DRIVER="kvm2"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    echo "Unknown OS type, exiting."
    exit 1
fi


echo "Resetting Jenkins workshop: '${WORKSHOP_NAME}'..."
minikube delete --profile ${WORKSHOP_NAME} 2> /dev/null
minikube start \
            --driver=${DRIVER} \
            --interactive=true \
            --cpus=${CPUS} \
            --memory=${MEMORY} \
            --profile=${WORKSHOP_NAME}

kubectl config use-context ${WORKSHOP_NAME}

NODE_PORT=32000
NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
JENKINS_URL="http://${NODE_IP}:${NODE_PORT}"

echo "Installing Jenkins..."
helm repo add stable https://kubernetes-charts.storage.googleapis.com > /dev/null
helm uninstall ${WORKSHOP_NAME} &> /dev/null || true
helm install --atomic \
             --timeout 10m0s \
             --version 2.1.0 \
             --values values.yaml \
             --set "master.nodePort=${NODE_PORT}" \
             --set-string "master.containerEnv[0].value=${WORKSHOP_NAME}" \
             --set-string "master.containerEnv[1].value=${GITHUB_REPO_NAME}" \
             --set-string "master.containerEnv[2].value=${GITHUB_USER_NAME}" \
             --set-string "master.containerEnv[3].value=${GITHUB_API_TOKEN}" \
             --set-string "master.jenkinsUrl=${JENKINS_URL}" \
             ${WORKSHOP_NAME} 'stable/jenkins' > /dev/null

ADMIN_PASSWORD="$(kubectl get secret --namespace default ${WORKSHOP_NAME} -o jsonpath='{.data.jenkins-admin-password}' | base64 --decode)"
POD_NAME=$(kubectl get pods --selector=app.kubernetes.io/instance=${WORKSHOP_NAME} -o name)
NGROK_URL="$(kubectl logs ${POD_NAME} -c ngrok | grep 'started tunnel' | tail -1 | sed 's/^.*url=//')"

echo "Done!"
printf "\n\n"
echo "===================================================================================="
echo "Jenkins Admin user URL:               ${JENKINS_URL}/login"
echo "Jenkins Admin user name:              admin"
echo "Jenkins Admin user password:          ${ADMIN_PASSWORD}"
echo "GitHub WebHook URL: (NGROK Channel)   ${NGROK_URL}/github-webhook/"
echo "===================================================================================="
