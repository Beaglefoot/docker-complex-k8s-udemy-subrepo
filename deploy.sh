# :latest tag is used for executing
# kubectl apply -f k8s
# with no hassle

# :$SHA tag is used to uniquely identify build for redeployment

docker build \
  -t beaglefoot/multi-client:latest \
  -t beaglefoot/multi-client:$SHA \
  -f ./client/Dockerfile ./client

docker build \
  -t beaglefoot/multi-server:latest \
  -t beaglefoot/multi-server:$SHA \
  -f ./server/Dockerfile ./server

docker build \
  -t beaglefoot/multi-worker:latest \
  -t beaglefoot/multi-worker:$SHA \
  -f ./worker/Dockerfile ./worker

# Already logged in via .travis.yml
docker push beaglefoot/multi-client:latest
docker push beaglefoot/multi-server:latest
docker push beaglefoot/multi-worker:latest

docker push beaglefoot/multi-client:$SHA
docker push beaglefoot/multi-server:$SHA
docker push beaglefoot/multi-worker:$SHA

kubectl apply -f k8s

# Name inside server-deployment.yaml
kubectl set image deployment/server-deployment server=beaglefoot/multi-server:$SHA
kubectl set image deployment/client-deployment client=beaglefoot/multi-client:$SHA
kubectl set image deployment/worker-deployment worker=beaglefoot/multi-worker:$SHA
