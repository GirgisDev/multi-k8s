docker build -t gergis/multi-container-client:latest -t gergis/multi-container-client:$SHA -f ./client/Dockerfile ./client
docker build -t gergis/multi-container-server:latest -t gergis/multi-container-server:$SHA -f ./server/Dockerfile ./server
docker build -t gergis/multi-container-worker:latest -t gergis/multi-container-worker:$SHA -f ./worker/Dockerfile ./worker

docker push gergis/multi-container-client:latest
docker push gergis/multi-container-server:latest
docker push gergis/multi-container-worker:latest

docker push gergis/multi-container-client:$SHA
docker push gergis/multi-container-server:$SHA
docker push gergis/multi-container-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=gergis/multi-container-server:$SHA
kubectl set image deployments/client-deployment client=gergis/multi-container-client:$SHA
kubectl set image deployments/worker-deployment worker=gergis/multi-container-worker:$SHA