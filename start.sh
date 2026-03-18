#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORCE_FRONTEND_REBUILD="${FORCE_FRONTEND_REBUILD:-0}"

# ── Cores ──────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info()    { echo -e "${BLUE}ℹ️  $*${NC}"; }
success() { echo -e "${GREEN}✅ $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $*${NC}"; }
die()     { echo -e "${RED}❌ $*${NC}"; exit 1; }

echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   🚀 Gestão de Beneficiários             ║"
echo "  ║      Iniciando ambiente Docker...        ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"

# ── 1. Garantir que o Docker está rodando ─────────────────────────────────────
echo "1️⃣  Verificando Docker..."

if ! docker info >/dev/null 2>&1; then
    warn "Daemon do Docker não está ativo. Tentando iniciar..."

    # WSL2 com Docker nativo usa 'service'; systemd pode não estar disponível
    if command -v systemctl >/dev/null 2>&1 \
        && systemctl list-units --type=service 2>/dev/null | grep -q 'docker\.service'; then
        sudo systemctl start docker
    else
        sudo service docker start
    fi

    echo -n "   Aguardando Docker iniciar"
    for i in {1..15}; do
        sleep 1; echo -n "."
        docker info >/dev/null 2>&1 && break
    done
    echo ""
fi

docker info >/dev/null 2>&1 || die "Não foi possível iniciar o Docker. Verifique a instalação."
success "Docker está rodando ($(docker --version | cut -d' ' -f3 | tr -d ','))"

# ── 2. Subir os containers ────────────────────────────────────────────────────
echo ""
echo "2️⃣  Subindo todos os containers..."
cd "$ROOT_DIR"

# Usa 'sg docker' como fallback caso o grupo ainda não esteja ativo na sessão
run_docker_compose() {
    if docker compose "$@" 2>/dev/null; then
        return 0
    elif command -v sg >/dev/null 2>&1; then
        sg docker -c "docker compose $*"
    else
        return 1
    fi
}

compose_logs_tail() {
    local service="$1"
    local lines="${2:-5}"
    run_docker_compose logs --tail="$lines" "$service" || true
}

if [ "$FORCE_FRONTEND_REBUILD" = "1" ]; then
    info "FORCE_FRONTEND_REBUILD=1 → rebuild do frontend sem cache"
    run_docker_compose build --no-cache frontend || die "Falha no build sem cache do frontend"
fi

run_docker_compose up -d --build || die "Falha ao subir containers com Docker Compose"
success "Containers iniciados com Docker Compose"

# ── 3. Mostrar status dos containers ─────────────────────────────────────────
echo ""
echo "3️⃣  Status dos containers:"
run_docker_compose ps || die "Não foi possível listar o status dos containers"

# ── 4. Aguardar frontend estar acessível ─────────────────────────────────────
echo ""
echo "4️⃣  Aguardando o frontend ficar acessível em http://localhost:3000..."

TIMEOUT=120
READY=false
for ((i = 1; i <= TIMEOUT; i++)); do
    if curl -fsS http://localhost:3000 >/dev/null 2>&1; then
        READY=true
        break
    fi
    if (( i % 15 == 0 )); then
        info "Ainda aguardando frontend... (${i}s / ${TIMEOUT}s)"
        compose_logs_tail frontend 5
    fi
    sleep 1
done

if $READY; then
    success "Frontend disponível em http://localhost:3000"
else
    warn "Frontend ainda não respondeu após ${TIMEOUT}s."
    warn "Verifique com: docker compose logs -f frontend"
fi

# ── 4b. Aguardar API Gateway estar pronta ────────────────────────────────────
echo ""
echo "4️⃣b Aguardando API Gateway e microserviços estarem prontos..."
echo "   (Serviços Spring Boot levam ~30–90 s para inicializar)"

API_TIMEOUT=180
API_READY=false
for ((i = 1; i <= API_TIMEOUT; i++)); do
    STATUS=$(curl -fsS http://localhost:8080/actuator/health 2>/dev/null || true)
    if echo "$STATUS" | grep -q '"status":"UP"'; then
        API_READY=true
        break
    fi
    if (( i % 20 == 0 )); then
        info "Aguardando API Gateway... (${i}s / ${API_TIMEOUT}s)"
        compose_logs_tail api-gateway 5
    fi
    sleep 1
done

# ── 4c. Verificar rota de beneficiários para evitar abrir frontend cedo demais ─
echo ""
echo "4️⃣c Validando endpoint de beneficiários..."

BEN_TIMEOUT=120
BEN_READY=false
for ((i = 1; i <= BEN_TIMEOUT; i++)); do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/beneficiarios || true)
    if [ "$HTTP_CODE" = "200" ]; then
        BEN_READY=true
        break
    fi
    if (( i % 20 == 0 )); then
        info "Aguardando endpoint /api/beneficiarios... (${i}s / ${BEN_TIMEOUT}s, HTTP ${HTTP_CODE:-000})"
        compose_logs_tail beneficiarios-service 5
    fi
    sleep 1
done

if $BEN_READY; then
    success "Endpoint de beneficiários respondeu 200"
else
    warn "Endpoint /api/beneficiarios não respondeu 200 após ${BEN_TIMEOUT}s."
    warn "O frontend será aberto, mas pode exibir erro temporário até os serviços subirem."
fi

if $API_READY; then
    success "API Gateway pronta em http://localhost:8080"
else
    warn "API Gateway ainda não respondeu após ${API_TIMEOUT}s."
    warn "Verifique com: docker compose logs -f api-gateway"
    warn "O browser será aberto mesmo assim – a API pode ainda estar subindo."
fi

# ── 5. Abrir o navegador ──────────────────────────────────────────────────────
echo ""
echo "5️⃣  Abrindo o navegador..."

FRONTEND_URL="http://localhost:3000"

# Detecta WSL2 → abre browser do Windows
if grep -qi microsoft /proc/version 2>/dev/null || grep -qi wsl /proc/version 2>/dev/null; then
    info "Ambiente WSL2 detectado → abrindo no browser do Windows"
    if command -v wslview >/dev/null 2>&1; then
        wslview "$FRONTEND_URL" &
    elif [ -x "/mnt/c/Windows/System32/cmd.exe" ]; then
        /mnt/c/Windows/System32/cmd.exe /c "start $FRONTEND_URL" >/dev/null 2>&1 &
    elif [ -x "/mnt/c/Windows/explorer.exe" ]; then
        /mnt/c/Windows/explorer.exe "$FRONTEND_URL" >/dev/null 2>&1 &
    else
        warn "Não foi possível abrir o navegador automaticamente."
        info "Abra manualmente: $FRONTEND_URL"
    fi
# Linux desktop
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$FRONTEND_URL" >/dev/null 2>&1 &
# macOS
elif command -v open >/dev/null 2>&1; then
    open "$FRONTEND_URL" &
else
    warn "Navegador não detectado. Acesse manualmente: $FRONTEND_URL"
fi

# ── 6. Resumo final ───────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   ✅ Sistema iniciado com sucesso!       ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo "  📊 URLs Disponíveis:"
echo "  ┌─────────────────────────────────────────────"
echo "  │  🌐 Frontend:         http://localhost:3000"
echo "  │  🔀 API Gateway:      http://localhost:8080"
echo "  │  📡 Eureka Dashboard: http://localhost:8761"
echo "  │  👤 Beneficiários:    http://localhost:8081"
echo "  │  🔍 Consulta:         http://localhost:8082"
echo "  │  🗄️  PostgreSQL:       localhost:5433"
echo "  └─────────────────────────────────────────────"
echo ""
echo "  📋 Comandos úteis:"
echo "    docker compose ps              → status"
echo "    docker compose logs -f         → todos os logs"
echo "    docker compose logs -f <nome>  → log de um serviço"
echo ""
echo "  🛑 Para parar tudo:  ./stop.sh"
echo "  📊 Para ver status:  ./status.sh"
echo ""

