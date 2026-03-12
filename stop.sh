#!/bin/bash

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

# Parar Frontend
echo "1️⃣ Parando Frontend..."
if [ -f /tmp/frontend.pid ]; then
    FRONTEND_PID=$(cat /tmp/frontend.pid)
    if kill -0 $FRONTEND_PID 2>/dev/null; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✅ Frontend parado (PID: $FRONTEND_PID)${NC}"
        rm /tmp/frontend.pid
    else
        echo -e "${YELLOW}⚠️  Frontend já estava parado${NC}"
        rm /tmp/frontend.pid
    fi
else
    # Tentar parar pelo processo
    FRONTEND_PID=$(lsof -ti :3000)
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✅ Frontend parado (PID: $FRONTEND_PID)${NC}"
    else
        echo -e "${YELLOW}⚠️  Frontend não está rodando${NC}"
    fi
fi
echo ""

# Parar Backend
echo "2️⃣ Parando Backend..."
if [ -f /tmp/backend.pid ]; then
    BACKEND_PID=$(cat /tmp/backend.pid)
    if kill -0 $BACKEND_PID 2>/dev/null; then
        kill $BACKEND_PID
        echo -e "${GREEN}✅ Backend parado (PID: $BACKEND_PID)${NC}"
        rm /tmp/backend.pid
    else
        echo -e "${YELLOW}⚠️  Backend já estava parado${NC}"
        rm /tmp/backend.pid
    fi
else
    # Tentar parar pelo processo
    BACKEND_PID=$(lsof -ti :8080)
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID
        echo -e "${GREEN}✅ Backend parado (PID: $BACKEND_PID)${NC}"
    else
        echo -e "${YELLOW}⚠️  Backend não está rodando${NC}"
    fi
fi
echo ""

# Parar processos do Spring Boot
echo "3️⃣ Verificando processos remanescentes..."
SPRING_PIDS=$(pgrep -f "spring-boot:run")
if [ ! -z "$SPRING_PIDS" ]; then
    echo -e "${YELLOW}🔧 Parando processos Spring Boot...${NC}"
    pkill -f "spring-boot:run"
    echo -e "${GREEN}✅ Processos Spring Boot parados${NC}"
else
    echo -e "${GREEN}✅ Nenhum processo Spring Boot rodando${NC}"
fi
echo ""

# Parar processos do React
echo "4️⃣ Verificando processos React..."
REACT_PIDS=$(pgrep -f "react-scripts")
if [ ! -z "$REACT_PIDS" ]; then
    echo -e "${YELLOW}🔧 Parando processos React...${NC}"
    pkill -f "react-scripts"
    echo -e "${GREEN}✅ Processos React parados${NC}"
else
    echo -e "${GREEN}✅ Nenhum processo React rodando${NC}"
fi
echo ""

# Limpar logs
echo "5️⃣ Limpando logs temporários..."
if [ -f /tmp/backend.log ]; then
    rm /tmp/backend.log
    echo -e "${GREEN}✅ Log do backend removido${NC}"
fi
if [ -f /tmp/frontend.log ]; then
    rm /tmp/frontend.log
    echo -e "${GREEN}✅ Log do frontend removido${NC}"
fi
echo ""

# Verificação final
echo "=========================================="
echo "🔍 Verificação Final"
echo "=========================================="
echo ""

# Verificar porta 8080
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null ; then
    echo -e "${RED}❌ Porta 8080 ainda está em uso${NC}"
else
    echo -e "${GREEN}✅ Porta 8080 liberada${NC}"
fi

# Verificar porta 3000
if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null ; then
    echo -e "${RED}❌ Porta 3000 ainda está em uso${NC}"
else
    echo -e "${GREEN}✅ Porta 3000 liberada${NC}"
fi

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

