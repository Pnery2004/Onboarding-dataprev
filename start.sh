#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
    else
        sg docker -c "docker compose $*"
    fi
}

run_docker_compose up -d --build
success "Containers iniciados com Docker Compose"

# ── 3. Mostrar status dos containers ─────────────────────────────────────────
echo ""
echo "3️⃣  Status dos containers:"
docker compose ps 2>/dev/null || sg docker -c "docker compose ps"

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
        info "Ainda aguardando... (${i}s / ${TIMEOUT}s)"
        # Mostra logs do frontend para diagnóstico
        docker compose logs --tail=5 frontend 2>/dev/null || true
    fi
    sleep 1
done

if $READY; then
    success "Frontend disponível em http://localhost:3000"
else
    warn "Frontend ainda não respondeu após ${TIMEOUT}s. Pode estar inicializando..."
    warn "Verifique com: docker compose logs -f frontend"
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

