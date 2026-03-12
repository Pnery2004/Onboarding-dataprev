#!/bin/bash

# Script de Inicialização do Sistema de Gestão de Beneficiários
# Dataprev - Março 2026

echo "=========================================="
echo "🚀 Sistema de Gestão de Beneficiários"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para verificar se um serviço está rodando
check_service() {
    local port=$1
    local service=$2

    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
        echo -e "${GREEN}✅ $service está rodando na porta $port${NC}"
        return 0
    else
        echo -e "${RED}❌ $service NÃO está rodando na porta $port${NC}"
        return 1
    fi
}

# Verificar PostgreSQL
echo "1️⃣ Verificando PostgreSQL..."
if pgrep -x postgres >/dev/null ; then
    echo -e "${GREEN}✅ PostgreSQL está rodando${NC}"
else
    echo -e "${YELLOW}⚠️  PostgreSQL não está rodando. Tentando iniciar...${NC}"
    sudo systemctl start postgresql
    sleep 2
    if pgrep -x postgres >/dev/null ; then
        echo -e "${GREEN}✅ PostgreSQL iniciado com sucesso${NC}"
    else
        echo -e "${RED}❌ Erro ao iniciar PostgreSQL${NC}"
        exit 1
    fi
fi
echo ""

# Verificar Backend
echo "2️⃣ Verificando Backend (API REST)..."
if check_service 8080 "Backend"; then
    echo -e "${YELLOW}ℹ️  Backend já está rodando. Pulando inicialização.${NC}"
else
    echo -e "${YELLOW}🔧 Iniciando Backend...${NC}"
    cd backend
    ./mvnw spring-boot:run > /tmp/backend.log 2>&1 &
    BACKEND_PID=$!

    echo "⏳ Aguardando backend iniciar (pode levar até 60 segundos)..."

    # Aguardar até 60 segundos
    for i in {1..60}; do
        sleep 1
        if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null ; then
            echo -e "${GREEN}✅ Backend iniciado com sucesso! (PID: $BACKEND_PID)${NC}"
            echo $BACKEND_PID > /tmp/backend.pid
            break
        fi
        if [ $i -eq 60 ]; then
            echo -e "${RED}❌ Timeout ao iniciar backend. Verifique os logs em /tmp/backend.log${NC}"
            exit 1
        fi
        echo -n "."
    done
    cd ..
fi
echo ""

# Testar API
echo "3️⃣ Testando API..."
if curl -s http://localhost:8080/api/v1/beneficiarios > /dev/null; then
    echo -e "${GREEN}✅ API respondendo corretamente${NC}"
    BENEFICIARIOS_COUNT=$(curl -s http://localhost:8080/api/v1/beneficiarios | grep -o '"id"' | wc -l)
    echo -e "${GREEN}ℹ️  $BENEFICIARIOS_COUNT beneficiário(s) cadastrado(s)${NC}"
else
    echo -e "${RED}❌ API não está respondendo${NC}"
    exit 1
fi
echo ""

# Verificar Frontend
echo "4️⃣ Verificando Frontend (React)..."
if check_service 3000 "Frontend"; then
    echo -e "${YELLOW}ℹ️  Frontend já está rodando. Pulando inicialização.${NC}"
else
    echo -e "${YELLOW}🎨 Iniciando Frontend...${NC}"
    cd frontend/gestao-beneficiarios-frontend

    # Verificar se node_modules existe
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}📦 Instalando dependências do npm (primeira vez)...${NC}"
        npm install
    fi

    npm start > /tmp/frontend.log 2>&1 &
    FRONTEND_PID=$!

    echo "⏳ Aguardando frontend iniciar (pode levar até 60 segundos)..."

    # Aguardar até 30 segundos
    for i in {1..60}; do
        sleep 1
        if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null ; then
            echo -e "${GREEN}✅ Frontend iniciado com sucesso! (PID: $FRONTEND_PID)${NC}"
            echo $FRONTEND_PID > /tmp/frontend.pid
            break
        fi
        if [ $i -eq 60 ]; then
            echo -e "${RED}❌ Timeout ao iniciar frontend. Verifique os logs em /tmp/frontend.log${NC}"
            exit 1
        fi
        echo -n "."
    done
    cd ../..
fi
echo ""

# Resumo
echo "=========================================="
echo "✅ Sistema iniciado com sucesso!"
echo "=========================================="
echo ""
echo "📊 URLs Disponíveis:"
echo "  • Frontend:  http://localhost:3000"
echo "  • Backend:   http://localhost:8080"
echo "  • Swagger:   http://localhost:8080/swagger-ui.html"
echo ""
echo "📝 Logs:"
echo "  • Backend:   /tmp/backend.log"
echo "  • Frontend:  /tmp/frontend.log"
echo ""
echo "🛑 Para parar os serviços, execute:"
echo "  ./stop.sh"
echo ""
echo "🎉 Acesse agora: http://localhost:3000"
echo "=========================================="

# Tentar abrir o navegador automaticamente
if command -v xdg-open > /dev/null; then
    echo ""
    echo "🌐 Abrindo navegador automaticamente..."
    xdg-open http://localhost:3000 2>/dev/null &
elif command -v open > /dev/null; then
    echo ""
    echo "🌐 Abrindo navegador automaticamente..."
    open http://localhost:3000 2>/dev/null &
fi

