#!/usr/bin/env bash

set -euo pipefail

# Script de Parada do Sistema de Gestão de Beneficiários
# Dataprev - Março 2026

echo "=========================================="
echo "🛑 Parando Sistema de Gestão de Beneficiários"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

stop_service() {
    local service_name="$1"
    local pid_file="$2"
    local port="$3"

    echo "$service_name..."

    # Kill by saved PID (the Maven wrapper subshell)
    if [ -f "$pid_file" ]; then
        local pid
        pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            # Also kill all children of this PID (the actual JVM)
            pkill -P "$pid" 2>/dev/null || true
            kill "$pid" 2>/dev/null || true
            echo -e "${GREEN}✅ $service_name parado (PID: $pid)${NC}"
        else
            echo -e "${YELLOW}⚠️  $service_name já estava parado${NC}"
        fi
        rm -f "$pid_file"
    fi

    # Kill anything still holding the port (catches orphaned JVM processes)
    local port_pids
    port_pids=$(lsof -ti :"$port" 2>/dev/null || true)
    if [ -n "$port_pids" ]; then
        echo "$port_pids" | xargs kill 2>/dev/null || true
        sleep 1
        # Force kill if still alive
        port_pids=$(lsof -ti :"$port" 2>/dev/null || true)
        if [ -n "$port_pids" ]; then
            echo "$port_pids" | xargs kill -9 2>/dev/null || true
        fi
        echo -e "${GREEN}✅ $service_name: porta $port liberada${NC}"
    elif [ ! -f "$pid_file" ]; then
        echo -e "${YELLOW}⚠️  $service_name não estava rodando${NC}"
    fi

    echo ""
}

cleanup_log() {
    local label="$1"
    local log_file="$2"

    if [ -f "$log_file" ]; then
        rm -f "$log_file"
        echo -e "${GREEN}✅ Log de $label removido${NC}"
    fi
}

echo "1️⃣ Parando Frontend..."
stop_service "Frontend" "/tmp/frontend.pid" 3000

echo "2️⃣ Parando backend em microserviços..."
stop_service "API Gateway" "/tmp/api-gateway.pid" 8080
stop_service "Consulta Service" "/tmp/consulta-service.pid" 8082
stop_service "Beneficiarios Service" "/tmp/beneficiarios-service.pid" 8081
stop_service "Discovery Server" "/tmp/discovery-server.pid" 8761

echo "3️⃣ Verificando portas monitoradas..."
if lsof -ti :8761,:8081,:8082,:8080,:3000 >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Ainda existem processos ocupando portas do projeto. A verificação final indicará quais são.${NC}"
else
    echo -e "${GREEN}✅ Nenhum processo do projeto ficou ocupando as portas monitoradas${NC}"
fi
echo ""

# Limpar logs
echo "4️⃣ Limpando logs temporários..."
cleanup_log "Discovery Server" "/tmp/discovery-server.log"
cleanup_log "Beneficiarios Service" "/tmp/beneficiarios-service.log"
cleanup_log "Consulta Service" "/tmp/consulta-service.log"
cleanup_log "API Gateway" "/tmp/api-gateway.log"
cleanup_log "Frontend" "/tmp/frontend.log"
echo ""

# Verificação final
echo "=========================================="
echo "🔍 Verificação Final"
echo "=========================================="
echo ""

for port in 8761 8081 8082 8080 3000; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
        echo -e "${RED}❌ Porta $port ainda está em uso${NC}"
    else
        echo -e "${GREEN}✅ Porta $port liberada${NC}"
    fi
done

echo ""
echo "=========================================="
echo "✅ Sistema parado com sucesso!"
echo "=========================================="
echo ""
echo "ℹ️  PostgreSQL continua rodando em segundo plano"
echo ""
echo "🚀 Para iniciar novamente, execute:"
echo "  ./start.sh"
echo "=========================================="

