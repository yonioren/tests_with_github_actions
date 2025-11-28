replicaCount: 2

image:
  repository: ${DOCKERHUB_REPO}/${DOCKER_IMAGE_NAME}
  tag: "${VERSION}"
  pullPolicy: IfNotPresent

service:
  type: NodePort
  port: 8666
  nodePort: 8666

nfs:
  server: ${NFS_SERVER}
  path: /data/nfs
  mountPath: /data/db

storage:
  size: 1Gi
