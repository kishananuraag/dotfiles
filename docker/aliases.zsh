# Docker aliases and functions
# Source this file in .zshrc

# Docker container management
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias drmi='docker rmi'
alias drm='docker rm'

# Docker container interaction
alias dex='docker exec -it'
alias dlogs='docker logs'
alias dinspect='docker inspect'

# Docker Compose
alias dc='docker-compose'
alias dcup='docker-compose up'
alias dcupd='docker-compose up -d'
alias dcdown='docker-compose down'
alias dcbuild='docker-compose build'
alias dclogs='docker-compose logs'
alias dcps='docker-compose ps'

# Quick container actions
alias dstart='docker start'
alias dstop='docker stop'
alias drestart='docker restart'

# Docker cleanup functions
dcleanup() {
    echo "🧹 Cleaning up Docker..."
    
    # Remove stopped containers
    echo "Removing stopped containers..."
    docker container prune -f
    
    # Remove unused images
    echo "Removing unused images..."
    docker image prune -f
    
    # Remove unused volumes
    echo "Removing unused volumes..."
    docker volume prune -f
    
    # Remove unused networks
    echo "Removing unused networks..."
    docker network prune -f
    
    echo "✅ Docker cleanup complete!"
}

# Nuclear cleanup (removes everything)
dnuke() {
    echo "💥 WARNING: This will remove ALL containers, images, volumes, and networks!"
    echo -n "Are you sure? (y/N) "
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        docker system prune -a --volumes -f
        echo "💥 Docker nuked successfully!"
    else
        echo "❌ Operation cancelled"
    fi
}

# Quick container shell access
dsh() {
    if [ $# -eq 0 ]; then
        echo "Usage: dsh <container_name_or_id> [shell]"
        echo "Example: dsh nginx bash"
        echo "         dsh redis sh"
        return 1
    fi
    
    local container=$1
    local shell=${2:-bash}
    
    echo "🐳 Accessing $container with $shell..."
    docker exec -it "$container" "$shell"
}

# Build and run a Dockerfile in current directory
dbuild() {
    local tag=${1:-$(basename $(pwd))}
    echo "🔨 Building Docker image: $tag"
    docker build -t "$tag" .
}

# Quick container stats
dstats() {
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# Show running containers with better formatting
dps-pretty() {
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

# Docker system information
dinfo() {
    echo "🐳 Docker System Information"
    echo "=========================="
    docker version --format 'Client Version: {{.Client.Version}}'
    docker version --format 'Server Version: {{.Server.Version}}'
    echo ""
    echo "💾 Disk Usage:"
    docker system df
    echo ""
    echo "📊 Container Stats:"
    dps-pretty
}