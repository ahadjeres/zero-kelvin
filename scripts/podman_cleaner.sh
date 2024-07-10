# List all pods
podman pod ls

# List all containers
podman ps -a

# Force remove all pods
for pod in $(podman pod ls -q); do
    podman pod rm -f $pod
done

# Force remove all containers
for container in $(podman ps -a -q); do
    podman rm -f $container
done

# Prune system to remove unused volumes and images
podman system prune -a --volumes

# Verify cleanup
podman pod ls
podman ps -a
podman volume ls
