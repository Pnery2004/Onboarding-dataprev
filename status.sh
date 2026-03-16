#!/usr/bin/env bash

set -euo pipefail

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

print_service_status() {
    local label="$1"
    local port="$2"
    local url="${3:-}"

    echo -e "${BLUE}$label${NC}"
    if ss -tuln | grep -q ":$port .*LISTEN\|:$port\\b"; then
        echo -e "   ${GREEN}✅ Status: RODANDO${NC}"
        echo -e "   ${GREEN}✅ Porta: $port (LISTEN)${NC}"

        if [ -n "$url" ]; then
            if curl -fsS "$url" >/dev/null 2>&1; then
                echo -e "   ${GREEN}✅ Endpoint: Respondendo${NC}"
            else
                echo -e "   ${YELLOW}⚠️  Endpoint: Porta aberta, mas URL não respondeu${NC}"
            fi
        fi
    else
        echo -e "   ${RED}❌ Status: PARADO${NC}"
    fi
    echo ""
}

print_log_status() {
    local label="$1"
    local file="$2"

    if [ -f "$file" ]; then
        local size
        size=$(du -h "$file" | cut -f1)
        echo -e "   ${GREEN}• $label:${NC} $file ($size)"
    else
        echo -e "   ${YELLOW}• $label:${NC} $file (não encontrado)"
    fi
}

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

print_service_status "2. Discovery Server (Eureka)" 8761 "http://localhost:8761"
print_service_status "3. Beneficiarios Service" 8081 "http://localhost:8081/swagger-ui.html"
print_service_status "4. Consulta Service" 8082 "http://localhost:8082/swagger-ui.html"
print_service_status "5. API Gateway" 8080 "http://localhost:8080/api/v1/beneficiarios"

if curl -fsS http://localhost:8080/api/v1/beneficiarios >/dev/null 2>&1; then
    BENEFICIARIOS=$(curl -fsS http://localhost:8080/api/v1/beneficiarios | grep -o '"id"' | wc -l || true)
    echo -e "   ${GREEN}ℹ️  Beneficiários retornados pelo gateway: $BENEFICIARIOS${NC}"
    CORS_HEADER=$(curl -s -D - http://localhost:8080/api/v1/beneficiarios -H "Origin: http://localhost:3000" -o /dev/null 2>&1 | grep -i "access-control-allow-origin" || true)
    if [ -n "$CORS_HEADER" ]; then
        echo -e "   ${GREEN}✅ CORS: Configurado para o frontend${NC}"
    else
        echo -e "   ${YELLOW}⚠️  CORS: Cabeçalho não retornado no teste${NC}"
    fi
    echo ""
fi

# Verificar Frontend
echo -e "${BLUE}6. Frontend (React)${NC}"
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
echo -e "   ${GREEN}• API Gateway:${NC}  http://localhost:8080/api/v1/beneficiarios"
echo -e "   ${GREEN}• Swagger:${NC}      http://localhost:8080/swagger-ui.html"
echo -e "   ${GREEN}• Eureka:${NC}       http://localhost:8761"
echo -e "   ${GREEN}• Teste CORS:${NC}   http://localhost:3000/teste-conexao.html"
echo ""

# Logs
echo -e "${BLUE}📝 Localização dos Logs:${NC}"
print_log_status "Discovery Server" "/tmp/discovery-server.log"
print_log_status "Beneficiarios Service" "/tmp/beneficiarios-service.log"
print_log_status "Consulta Service" "/tmp/consulta-service.log"
print_log_status "API Gateway" "/tmp/api-gateway.log"
print_log_status "Frontend" "/tmp/frontend.log"
echo ""

# Comandos úteis
echo -e "${BLUE}🔧 Comandos Úteis:${NC}"
echo -e "   ${GREEN}• Iniciar sistema:${NC}     ./start.sh"
echo -e "   ${GREEN}• Parar sistema:${NC}       ./stop.sh"
echo -e "   ${GREEN}• Ver log gateway:${NC}     tail -f /tmp/api-gateway.log"
echo -e "   ${GREEN}• Ver log frontend:${NC}    tail -f /tmp/frontend.log"
echo -e "   ${GREEN}• Testar API:${NC}          curl http://localhost:8080/api/v1/beneficiarios"
echo ""

echo "=============================================="


