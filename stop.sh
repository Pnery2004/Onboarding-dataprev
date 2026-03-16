#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}ℹ️  $*${NC}"; }
success() { echo -e "${GREEN}✅ $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $*${NC}"; }
die()     { echo -e "${RED}❌ $*${NC}"; exit 1; }

echo "=========================================="
echo "🛑 Parando Sistema de Gestão de Beneficiários"
echo "=========================================="
echo ""

run_docker_compose() {
    if docker compose "$@" 2>/dev/null; then
        return 0
    fi

    if command -v sg >/dev/null 2>&1; then
        sg docker -c "docker compose $*"
    else
        return 1
    fi
}

is_port_listening() {
    local port="$1"
    lsof -Pi :"$port" -sTCP:LISTEN -t >/dev/null 2>&1
}

stop_legacy_service() {
    local service_name="$1"
    local pid_file="$2"
    local port="$3"

    if [ -f "$pid_file" ]; then
        local pid
        pid="$(cat "$pid_file")"
        if kill -0 "$pid" 2>/dev/null; then
            pkill -P "$pid" 2>/dev/null || true
            kill "$pid" 2>/dev/null || true
            success "$service_name parado (PID: $pid)"
        fi
        rm -f "$pid_file"
    fi

    local pids
    pids="$(lsof -ti :"$port" 2>/dev/null || true)"
    if [ -n "$pids" ]; then
        echo "$pids" | xargs kill 2>/dev/null || true
        sleep 1
        pids="$(lsof -ti :"$port" 2>/dev/null || true)"
        if [ -n "$pids" ]; then
            echo "$pids" | xargs kill -9 2>/dev/null || true
        fi
        success "$service_name: porta $port liberada"
    fi
}

cleanup_log() {
    local log_file="$1"
    [ -f "$log_file" ] && rm -f "$log_file"
}

cd "$ROOT_DIR"

echo "1️⃣ Parando containers Docker Compose..."
if docker info >/dev/null 2>&1 || sg docker -c "docker info" >/dev/null 2>&1; then
    run_docker_compose down --remove-orphans || die "Falha ao executar docker compose down"
    success "Ambiente Docker parado"
else
    warn "Docker daemon indisponível nesta sessão. Pulando docker compose down."
fi

echo ""
echo "2️⃣ Limpando processos legados (modo local Maven/React), se existirem..."
stop_legacy_service "Frontend" "/tmp/frontend.pid" 3000
stop_legacy_service "API Gateway" "/tmp/api-gateway.pid" 8080
stop_legacy_service "Consulta Service" "/tmp/consulta-service.pid" 8082
stop_legacy_service "Beneficiarios Service" "/tmp/beneficiarios-service.pid" 8081
stop_legacy_service "Discovery Server" "/tmp/discovery-server.pid" 8761

echo ""
echo "3️⃣ Limpando logs temporários..."
cleanup_log "/tmp/discovery-server.log"
cleanup_log "/tmp/beneficiarios-service.log"
cleanup_log "/tmp/consulta-service.log"
cleanup_log "/tmp/api-gateway.log"
cleanup_log "/tmp/frontend.log"
success "Logs temporários removidos"

echo ""
echo "4️⃣ Verificação final de portas..."
for port in 8761 8081 8082 8080 3000; do
    if is_port_listening "$port"; then
        warn "Porta $port ainda está em uso"
    else
        success "Porta $port liberada"
    fi
done

echo ""
echo "=========================================="
echo "✅ Sistema parado com sucesso!"
echo "=========================================="
echo ""
echo "ℹ️  Banco no container também foi parado (dados persistem no volume Docker)."
echo "🚀 Para iniciar novamente, execute: ./start.sh"
echo ""

