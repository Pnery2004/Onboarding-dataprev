#!/usr/bin/env bash
# ============================================================
#  install.sh — Baixa todas as dependências do projeto
#  Gestão de Beneficiários (Backend + Frontend)
# ============================================================

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend/gestao-beneficiarios-frontend"

# ---------- cores ----------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✅ $*${NC}"; }
info() { echo -e "${CYAN}ℹ️  $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
fail() { echo -e "${RED}❌ $*${NC}"; exit 1; }

echo ""
echo -e "${CYAN}============================================================${NC}"
echo -e "${CYAN}   Instalação de Dependências — Gestão de Beneficiários${NC}"
echo -e "${CYAN}============================================================${NC}"
echo ""

# ============================================================
# 1. Verificar pré-requisitos
# ============================================================
info "Verificando pré-requisitos..."

# Java
if ! command -v java &>/dev/null; then
    fail "Java não encontrado. Instale o Java 17: https://adoptium.net/"
fi
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VER" -lt 17 ] 2>/dev/null; then
    warn "Java $JAVA_VER detectado. Recomenda-se Java 17 ou superior."
else
    ok "Java $JAVA_VER detectado"
fi

# Maven wrapper (não precisa de Maven instalado globalmente)
if [ ! -f "$BACKEND_DIR/mvnw" ]; then
    fail "Maven Wrapper (mvnw) não encontrado em $BACKEND_DIR"
fi
chmod +x "$BACKEND_DIR/mvnw"
ok "Maven Wrapper disponível"

# Node.js
if ! command -v node &>/dev/null; then
    fail "Node.js não encontrado. Instale Node.js 18+: https://nodejs.org/"
fi
NODE_VER=$(node --version | sed 's/v//' | cut -d'.' -f1)
if [ "$NODE_VER" -lt 18 ] 2>/dev/null; then
    warn "Node.js v$NODE_VER detectado. Recomenda-se Node.js 18 ou superior."
else
    ok "Node.js v$NODE_VER detectado"
fi

# npm
if ! command -v npm &>/dev/null; then
    fail "npm não encontrado. Reinstale o Node.js: https://nodejs.org/"
fi
ok "npm $(npm --version) detectado"

echo ""

# ============================================================
# 2. Dependências do Backend (Maven)
# ============================================================
echo -e "${CYAN}------------------------------------------------------------${NC}"
echo -e "${CYAN}  📦 Backend — baixando dependências Maven...${NC}"
echo -e "${CYAN}------------------------------------------------------------${NC}"

cd "$BACKEND_DIR"

# Baixa todas as dependências sem compilar o código de produção
# -T 4  → usa 4 threads para acelerar o download
./mvnw dependency:go-offline -T 4 --no-transfer-progress \
    || ./mvnw dependency:go-offline --no-transfer-progress

ok "Dependências Maven baixadas com sucesso"
echo ""

# ============================================================
# 3. Dependências do Frontend (npm)
# ============================================================
echo -e "${CYAN}------------------------------------------------------------${NC}"
echo -e "${CYAN}  📦 Frontend — instalando pacotes npm...${NC}"
echo -e "${CYAN}------------------------------------------------------------${NC}"

cd "$FRONTEND_DIR"

# Instala exatamente o que está no package-lock.json (se existir),
# ou resolve e instala a partir do package.json
if [ -f "package-lock.json" ]; then
    npm ci --prefer-offline 2>/dev/null || npm install
else
    npm install
fi

ok "Pacotes npm instalados com sucesso"
echo ""

# ============================================================
# 4. Resumo final
# ============================================================
echo -e "${CYAN}============================================================${NC}"
echo -e "${GREEN}  ✅ Todas as dependências foram instaladas!${NC}"
echo -e "${CYAN}============================================================${NC}"
echo ""
echo "  Próximos passos:"
echo ""
echo "  1️⃣  Configure o banco de dados PostgreSQL:"
echo "       sudo -u postgres psql -c \"CREATE USER myuser WITH PASSWORD 'secret';\""
echo "       sudo -u postgres psql -c \"CREATE DATABASE beneficiarios OWNER myuser;\""
echo ""
echo "  2️⃣  Inicie o sistema completo:"
echo "       ./start.sh"
echo ""
echo "  3️⃣  Acesse:"
echo "       • Frontend : http://localhost:3000"
echo "       • API      : http://localhost:8080"
echo "       • Swagger  : http://localhost:8080/swagger-ui.html"
echo ""

