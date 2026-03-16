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
error()   { echo -e "${RED}❌ $*${NC}"; }

echo "=============================================="
echo "🔍 Status do Sistema de Gestão de Beneficiários"
echo "=============================================="
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

check_url() {
    local label="$1"
    local url="$2"
    if curl -fsS "$url" >/dev/null 2>&1; then
        success "$label respondendo"
    else
        warn "$label sem resposta no momento"
    fi
}

is_port_listening() {
    local port="$1"

    if ss -tuln 2>/dev/null | grep -Eq "[.:]$port([[:space:]]|$)"; then
        return 0
    fi

    if command -v lsof >/dev/null 2>&1; then
        lsof -Pi :"$port" -sTCP:LISTEN -t >/dev/null 2>&1
        return $?
    fi

    return 1
}

print_log_status() {
    local label="$1"
    local file="$2"

    if [ -f "$file" ]; then
        local size
        size="$(du -h "$file" | cut -f1)"
        echo -e "   ${GREEN}- $label:${NC} $file ($size)"
    else
        echo -e "   ${YELLOW}- $label:${NC} $file (nao encontrado)"
    fi
}

cd "$ROOT_DIR"

echo "1) Docker Compose"
if docker info >/dev/null 2>&1 || sg docker -c "docker info" >/dev/null 2>&1; then
    if run_docker_compose ps; then
        success "Status listado via Docker Compose"
    else
        warn "Nao foi possivel consultar Docker Compose"
    fi
else
    warn "Docker daemon indisponivel nesta sessao"
fi

echo ""
echo "2) Healthcheck rapido de endpoints"
check_url "Frontend" "http://localhost:3000"
check_url "API Gateway" "http://localhost:8080/api/v1/beneficiarios"
check_url "Eureka" "http://localhost:8761"
check_url "Beneficiarios Service" "http://localhost:8081/actuator/health"
check_url "Consulta Service" "http://localhost:8082/actuator/health"

if curl -fsS http://localhost:8080/api/v1/beneficiarios >/dev/null 2>&1; then
    beneficiarios_count="$(curl -fsS http://localhost:8080/api/v1/beneficiarios | grep -o '"id"' | wc -l || true)"
    info "Beneficiarios retornados pelo gateway: ${beneficiarios_count}"
fi

echo ""
echo "3) Fallback legado por portas"
for entry in "Discovery Server:8761" "Beneficiarios Service:8081" "Consulta Service:8082" "API Gateway:8080" "Frontend:3000"; do
    name="${entry%%:*}"
    port="${entry##*:}"
    if is_port_listening "$port"; then
        success "$name ouvindo na porta $port"
    else
        error "$name sem listener na porta $port"
    fi
done

echo ""
echo "4) URLs"
echo "   - Frontend:        http://localhost:3000"
echo "   - API Gateway:     http://localhost:8080"
echo "   - Swagger Gateway: http://localhost:8080/swagger-ui.html"
echo "   - Eureka:          http://localhost:8761"
echo "   - PostgreSQL host: localhost:5433"

echo ""
echo "5) Logs"
print_log_status "Discovery Server" "/tmp/discovery-server.log"
print_log_status "Beneficiarios Service" "/tmp/beneficiarios-service.log"
print_log_status "Consulta Service" "/tmp/consulta-service.log"
print_log_status "API Gateway" "/tmp/api-gateway.log"
print_log_status "Frontend" "/tmp/frontend.log"

echo ""
echo "6) Comandos uteis"
echo "   - Iniciar:           ./start.sh"
echo "   - Parar:             ./stop.sh"
echo "   - Status containers: docker compose ps"
echo "   - Logs gerais:       docker compose logs -f"
echo "   - Logs frontend:     docker compose logs -f frontend"

echo ""

echo "=============================================="


