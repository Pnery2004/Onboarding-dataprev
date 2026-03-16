#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend/gestao-beneficiarios-frontend"

echo "=========================================="
echo "🚀 Sistema de Gestão de Beneficiários"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
    echo -e "${BLUE}ℹ️  $*${NC}"
}

success() {
    echo -e "${GREEN}✅ $*${NC}"
}

warn() {
    echo -e "${YELLOW}⚠️  $*${NC}"
}

error() {
    echo -e "${RED}❌ $*${NC}"
}

check_port() {
    local port="$1"
    lsof -Pi :"$port" -sTCP:LISTEN -t >/dev/null 2>&1
}

wait_for_port() {
    local port="$1"
    local service_name="$2"
    local timeout="${3:-90}"
    local log_file="${4:-}"

    for ((i = 1; i <= timeout; i++)); do
        if check_port "$port"; then
            success "$service_name está rodando na porta $port"
            return 0
        fi

        if (( i % 5 == 0 )); then
            echo -n "."
        fi

        sleep 1
    done

    echo ""
    error "Timeout ao iniciar $service_name"
    if [ -n "$log_file" ] && [ -f "$log_file" ]; then
        warn "Últimas linhas de $log_file:"
        tail -n 20 "$log_file" || true
    fi
    return 1
}

start_backend_module() {
    local module="$1"
    local service_name="$2"
    local port="$3"
    local pid_file="$4"
    local log_file="$5"

    echo ""
    echo "▶ $service_name"

    if check_port "$port"; then
        warn "$service_name já está rodando na porta $port. Pulando inicialização."
        return 0
    fi

    rm -f "$pid_file" "$log_file"
    info "Iniciando $service_name..."

    (
        cd "$BACKEND_DIR"
        ./mvnw -pl "$module" spring-boot:run --no-transfer-progress > "$log_file" 2>&1
    ) &

    local pid=$!
    echo "$pid" > "$pid_file"

    info "Aguardando $service_name iniciar..."
    wait_for_port "$port" "$service_name" 120 "$log_file"
}

start_frontend() {
    local pid_file="/tmp/frontend.pid"
    local log_file="/tmp/frontend.log"

    echo ""
    echo "▶ Frontend"

    if check_port 3000; then
        warn "Frontend já está rodando na porta 3000. Pulando inicialização."
        return 0
    fi

    rm -f "$pid_file" "$log_file"

    if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
        info "node_modules não encontrado. Instalando dependências do frontend..."
        (
            cd "$FRONTEND_DIR"
            npm install
        )
    fi

    info "Iniciando frontend React..."
    (
        cd "$FRONTEND_DIR"
        BROWSER=none npm start > "$log_file" 2>&1
    ) &

    local pid=$!
    echo "$pid" > "$pid_file"

    info "Aguardando frontend iniciar..."
    wait_for_port 3000 "Frontend" 120 "$log_file"
}

echo "1️⃣ Verificando PostgreSQL..."
if check_port 5432 || pgrep -x postgres >/dev/null 2>&1; then
    success "PostgreSQL está disponível"
else
    warn "PostgreSQL não está rodando. Tentando iniciar..."
    if command -v systemctl >/dev/null 2>&1; then
        sudo systemctl start postgresql || true
        sleep 3
    fi

    if check_port 5432 || pgrep -x postgres >/dev/null 2>&1; then
        success "PostgreSQL iniciado com sucesso"
    else
        error "PostgreSQL não está disponível. Configure o banco 'beneficiarios' antes de subir o sistema."
        exit 1
    fi
fi

echo ""
echo "2️⃣ Iniciando backend em microserviços..."
start_backend_module "discovery-server" "Discovery Server" 8761 "/tmp/discovery-server.pid" "/tmp/discovery-server.log"
start_backend_module "beneficiarios-service" "Beneficiarios Service" 8081 "/tmp/beneficiarios-service.pid" "/tmp/beneficiarios-service.log"
start_backend_module "consulta-service" "Consulta Service" 8082 "/tmp/consulta-service.pid" "/tmp/consulta-service.log"
start_backend_module "api-gateway" "API Gateway" 8080 "/tmp/api-gateway.pid" "/tmp/api-gateway.log"

echo ""
echo "3️⃣ Testando API via gateway (aguardando propagação do Eureka)..."
API_OK=false
for ((i = 1; i <= 60; i++)); do
    if curl -fsS http://localhost:8080/api/v1/beneficiarios >/dev/null 2>&1; then
        API_OK=true
        break
    fi
    sleep 1
    if (( i % 5 == 0 )); then
        echo -n "."
    fi
done
echo ""

if $API_OK; then
    BENEFICIARIOS_COUNT=$(curl -fsS http://localhost:8080/api/v1/beneficiarios | grep -o '"id"' | wc -l || true)
    success "API Gateway respondendo corretamente"
    info "$BENEFICIARIOS_COUNT beneficiário(s) retornado(s)"
else
    error "API Gateway não respondeu após 60 segundos de espera"
    warn "Consulte os logs em /tmp/api-gateway.log e /tmp/beneficiarios-service.log"
    exit 1
fi

echo ""
echo "4️⃣ Iniciando frontend..."
start_frontend

echo ""
echo "=========================================="
echo "✅ Sistema iniciado com sucesso!"
echo "=========================================="
echo ""
echo "📊 URLs Disponíveis:"
echo "  • Frontend:          http://localhost:3000"
echo "  • API Gateway:       http://localhost:8080"
echo "  • Swagger Gateway:   http://localhost:8080/swagger-ui.html"
echo "  • Eureka Dashboard:  http://localhost:8761"
echo ""
echo "📝 Logs:"
echo "  • Discovery Server:       /tmp/discovery-server.log"
echo "  • Beneficiarios Service:  /tmp/beneficiarios-service.log"
echo "  • Consulta Service:       /tmp/consulta-service.log"
echo "  • API Gateway:            /tmp/api-gateway.log"
echo "  • Frontend:               /tmp/frontend.log"
echo ""
echo "🛑 Para parar os serviços, execute:"
echo "  ./stop.sh"
echo ""
echo "🎉 Acesse agora: http://localhost:3000"
echo "=========================================="

if command -v xdg-open >/dev/null 2>&1; then
    echo ""
    info "Abrindo navegador automaticamente..."
    xdg-open http://localhost:3000 >/dev/null 2>&1 &
elif command -v open >/dev/null 2>&1; then
    echo ""
    info "Abrindo navegador automaticamente..."
    open http://localhost:3000 >/dev/null 2>&1 &
fi

