#!/bin/bash

# defining colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# defining variables
AWS_REGION='eu-west-3'
AWS_ACCOUNT_ID='230410870031'

#! if you are using minikube and kubectl not work for you try change it with < minikube kubectl >

printf "⏳ ${RED}Cleaning up environment for project deployment ...${NC}\n"
printf "${PURPLE}"
kubectl delete secret crawlee-app-secret
kubectl delete secret ecr-registry-secret
kubectl delete configmap crawlee-app-config
kubectl delete service crawlee-app-service
kubectl scale deployment crawlee-app-deployment --replicas=0
kubectl delete pods -l app=crawlee-app-deployment
printf "${NC}"

printf "\n⏳ ${GREEN}Setting up environment for project deployment ...${NC}\n"
printf "${PURPLE}"
kubectl create secret docker-registry ecr-registry-secret \
  --docker-server=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region ${AWS_REGION})
printf "${NC}"

printf "\n⏳ ${GREEN}Start Deployment...${NC}\n"

printf "${PURPLE}"
kubectl apply -f crawlee-app-config.yaml
kubectl apply -f crawlee-app-secret.yaml
kubectl apply -f crawlee-app.yaml
printf "${NC}"

printf "\n🎉 ${GREEN}Deployment Done!${NC}\n\n"
printf "\t- ${PURPLE}you can view your deployment by running ${BLUE}kubectl get pods${NC}\n"
printf "\t- ${PURPLE}you can view your services by running ${BLUE}kubectl get services${NC}\n"
printf "\t- ${PURPLE}you can view your deployment logs ${BLUE}kubectl logs <pod name>${NC}\n"
printf "\t\t\t* ${PURPLE}you can stream the logs by adding ${BLUE}-f ${PURPLE} to the previous command${NC}\n\n"
