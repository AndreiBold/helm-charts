#!/bin/bash
set -e

echo Namespace = "$1"
NAMESPACE=$1
RELEASE_NAME="$2"

kubectl config get-contexts
kubectl create ns "alstom"
kubectl config set-context --current --namespace "alstom"
helm lint pages
helm template pages


echo "------------------------Start time is--------  $(date +%Y-%m-%dT%H%M%S%z)"

helm upgrade --install "beary" pages --debug

echo "------------------------End time is--------  $(date +%Y-%m-%dT%H%M%S%z)"

echo '---------------------Started testing--------------'
sleep 60s
kubectl get po -n "alstom" --show-labels
kubectl get svc -n "alstom" -o wide
helm test "beary" --logs
echo '---------------------Completed testing------------'

helm uninstall "beary"
kubectl delete ns "alstom"
