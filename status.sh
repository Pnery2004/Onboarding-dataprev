#!/bin/bash

# Script de Verificação de Status dos Serviços
# Sistema de Gestão de Beneficiários - Dataprev

echo "=============================================="
echo "🔍 Status do Sistema de Gestão de Beneficiários"
echo "=============================================="
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar PostgreSQL
echo -e "${BLUE}1. PostgreSQL Database${NC}"
if pgrep -x postgres >/dev/null ; then
    echo -e "   ${GREEN}✅ Status: RODANDO${NC}"
    if ss -tuln | grep -q ":5432.*LISTEN" ; then
        echo -e "   ${GREEN}✅ Porta: 5432 (LISTEN)${NC}"
    fi
else
    echo -e "   ${RED}❌ Status: PARADO${NC}"
fi
echo ""

# Verificar Backend
echo -e "${BLUE}2. Backend API (Spring Boot)${NC}"
if pgrep -f "GestaoBeneficiariosApplication" >/dev/null ; then
    echo -e "   ${GREEN}✅ Status: RODANDO${NC}"
    if ss -tuln | grep -q ":8080.*LISTEN" ; then
        echo -e "   ${GREEN}✅ Porta: 8080 (LISTEN)${NC}"
    fi

    # Testar API
    if curl -s http://localhost:8080/api/v1/beneficiarios > /dev/null 2>&1; then
        BENEFICIARIOS=$(curl -s http://localhost:8080/api/v1/beneficiarios | grep -o '"id"' | wc -l)
        echo -e "   ${GREEN}✅ API: Respondendo${NC}"
        echo -e "   ${GREEN}ℹ️  Beneficiários cadastrados: $BENEFICIARIOS${NC}"
    else
        echo -e "   ${RED}⚠️  API: Não está respondendo${NC}"
    fi

    # Verificar CORS
    CORS_HEADER=$(curl -s -D - http://localhost:8080/api/v1/beneficiarios -H "Origin: http://localhost:3000" -o /dev/null 2>&1 | grep -i "access-control-allow-origin")
    if [ -n "$CORS_HEADER" ]; then
        echo -e "   ${GREEN}✅ CORS: Configurado (allow origin: http://localhost:3000)${NC}"
    else
        echo -e "   ${RED}⚠️  CORS: Não configurado${NC}"
    fi
else
    echo -e "   ${RED}❌ Status: PARADO${NC}"
fi
echo ""

# Verificar Frontend
echo -e "${BLUE}3. Frontend (React)${NC}"
if pgrep -f "react-scripts" >/dev/null ; then
    echo -e "   ${GREEN}✅ Status: RODANDO${NC}"
    if ss -tuln | grep -q ":3000.*LISTEN" ; then
        echo -e "   ${GREEN}✅ Porta: 3000 (LISTEN)${NC}"
    fi

    # Testar Frontend
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo -e "   ${GREEN}✅ Servidor: Respondendo${NC}"
    else
        echo -e "   ${RED}⚠️  Servidor: Não está respondendo${NC}"
    fi
else
    echo -e "   ${RED}❌ Status: PARADO${NC}"
fi
echo ""

# URLs
echo -e "${BLUE}📊 URLs Disponíveis:${NC}"
echo -e "   ${GREEN}• Frontend:${NC}     http://localhost:3000"
echo -e "   ${GREEN}• Backend API:${NC}  http://localhost:8080/api/v1/beneficiarios"
echo -e "   ${GREEN}• Swagger UI:${NC}   http://localhost:8080/swagger-ui.html"
echo -e "   ${GREEN}• Teste CORS:${NC}   http://localhost:3000/teste-conexao.html"
echo ""

# Logs
echo -e "${BLUE}📝 Localização dos Logs:${NC}"
if [ -f /tmp/backend.log ]; then
    BACKEND_LOG_SIZE=$(du -h /tmp/backend.log | cut -f1)
    echo -e "   ${GREEN}• Backend:${NC}  /tmp/backend.log (${BACKEND_LOG_SIZE})"
else
    echo -e "   ${YELLOW}• Backend:${NC}  /tmp/backend.log (não encontrado)"
fi

if [ -f /tmp/frontend.log ]; then
    FRONTEND_LOG_SIZE=$(du -h /tmp/frontend.log | cut -f1)
    echo -e "   ${GREEN}• Frontend:${NC} /tmp/frontend.log (${FRONTEND_LOG_SIZE})"
else
    echo -e "   ${YELLOW}• Frontend:${NC} /tmp/frontend.log (não encontrado)"
fi
echo ""

# Comandos úteis
echo -e "${BLUE}🔧 Comandos Úteis:${NC}"
echo -e "   ${GREEN}• Iniciar sistema:${NC}     ./start.sh"
echo -e "   ${GREEN}• Parar sistema:${NC}       ./stop.sh"
echo -e "   ${GREEN}• Ver log backend:${NC}     tail -f /tmp/backend.log"
echo -e "   ${GREEN}• Ver log frontend:${NC}    tail -f /tmp/frontend.log"
echo -e "   ${GREEN}• Testar API:${NC}          curl http://localhost:8080/api/v1/beneficiarios"
echo ""

echo "=============================================="


