#!/usr/bin/env bash
set -u

echo "--- kubectl node ---"
kubectl get nodes -o wide 2>&1 || true
kubectl describe node grpc-stream-single-control-plane 2>/dev/null \
  | grep -E 'Ready|InternalIP|Lease|KubeletReady|LastHeartbeatTime|LastTransitionTime' \
  | tail -n 50 || true

echo "--- kind container ---"
docker inspect grpc-stream-single-control-plane --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 2>&1 || true

echo "--- kubelet config inside kind ---"
docker exec grpc-stream-single-control-plane sh -lc '
  echo "container_ip=$(hostname -I)"
  grep -n "server:" /etc/kubernetes/kubelet.conf || true
  grep -n "server:" /etc/kubernetes/admin.conf || true
  crictl ps --name kube-apiserver || true
' 2>&1 || true
