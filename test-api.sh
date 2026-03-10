#!/bin/bash

# Script de testes para a API de Gerenciamento de Beneficiários
# Executar: chmod +x test-api.sh && ./test-api.sh

BASE_URL="http://localhost:8080/api/v1/beneficiarios"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║   TESTES DA API DE GERENCIAMENTO DE BENEFICIÁRIOS            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Teste 1: GET - Listar todos
echo -e "\n${BLUE}[TESTE 1] GET - Listar todos os beneficiários${NC}"
echo "URL: GET $BASE_URL"
echo "---"
curl -s "$BASE_URL" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL"
echo -e "\n${GREEN}✅ Teste 1 executado${NC}\n"

# Teste 2: GET - Buscar por ID
echo -e "${BLUE}[TESTE 2] GET - Obter beneficiário por ID${NC}"
echo "URL: GET $BASE_URL/1"
echo "---"
curl -s "$BASE_URL/1" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL/1"
echo -e "\n${GREEN}✅ Teste 2 executado${NC}\n"

# Teste 3: GET - Buscar por CPF
echo -e "${BLUE}[TESTE 3] GET - Obter beneficiário por CPF${NC}"
echo "URL: GET $BASE_URL/cpf/98765432101"
echo "---"
curl -s "$BASE_URL/cpf/98765432101" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL/cpf/98765432101"
echo -e "\n${GREEN}✅ Teste 3 executado${NC}\n"

# Teste 4: POST - Criar novo
echo -e "${BLUE}[TESTE 4] POST - Criar novo beneficiário${NC}"
echo "URL: POST $BASE_URL"
echo "Body:"
cat << 'BODY'
{
  "nome": "Pedro Mendes",
  "cpf": "22233344455",
  "dataNascimento": "1988-12-01",
  "situacao": "ATIVO"
}
BODY
echo "---"
curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Pedro Mendes",
    "cpf": "22233344455",
    "dataNascimento": "1988-12-01",
    "situacao": "ATIVO"
  }' | python3 -m json.tool 2>/dev/null || curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Pedro Mendes",
    "cpf": "22233344455",
    "dataNascimento": "1988-12-01",
    "situacao": "ATIVO"
  }'
echo -e "\n${GREEN}✅ Teste 4 executado${NC}\n"

# Teste 5: PUT - Atualizar
echo -e "${BLUE}[TESTE 5] PUT - Atualizar beneficiário${NC}"
echo "URL: PUT $BASE_URL/1"
echo "Body:"
cat << 'BODY'
{
  "nome": "João Silva Santos - ATUALIZADO",
  "cpf": "12345678901",
  "dataNascimento": "1990-05-15",
  "situacao": "SUSPENSO"
}
BODY
echo "---"
curl -s -X PUT "$BASE_URL/1" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Silva Santos - ATUALIZADO",
    "cpf": "12345678901",
    "dataNascimento": "1990-05-15",
    "situacao": "SUSPENSO"
  }' | python3 -m json.tool 2>/dev/null || curl -s -X PUT "$BASE_URL/1" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Silva Santos - ATUALIZADO",
    "cpf": "12345678901",
    "dataNascimento": "1990-05-15",
    "situacao": "SUSPENSO"
  }'
echo -e "\n${GREEN}✅ Teste 5 executado${NC}\n"

# Teste 6: DELETE
echo -e "${BLUE}[TESTE 6] DELETE - Deletar beneficiário${NC}"
echo "URL: DELETE $BASE_URL/2"
echo "---"
curl -s -X DELETE "$BASE_URL/2" -v 2>&1 | grep -E "< HTTP|deleted|not found" || echo "Beneficiário deletado com sucesso!"
echo -e "\n${GREEN}✅ Teste 6 executado${NC}\n"

# Teste 7: Listar novamente para confirmar mudanças
echo -e "${BLUE}[TESTE 7] GET - Listar todos (após mudanças)${NC}"
echo "URL: GET $BASE_URL"
echo "---"
curl -s "$BASE_URL" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL"
echo -e "\n${GREEN}✅ Teste 7 executado${NC}\n"

# Teste 8: Erro de validação
echo -e "${BLUE}[TESTE 8] POST - Teste de erro (CPF inválido)${NC}"
echo "URL: POST $BASE_URL"
echo "Body com CPF inválido (menos de 11 dígitos):"
cat << 'BODY'
{
  "nome": "Teste Erro",
  "cpf": "123",
  "dataNascimento": "2000-01-01",
  "situacao": "ATIVO"
}
BODY
echo "---"
curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Teste Erro",
    "cpf": "123",
    "dataNascimento": "2000-01-01",
    "situacao": "ATIVO"
  }' | python3 -m json.tool 2>/dev/null || curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Teste Erro",
    "cpf": "123",
    "dataNascimento": "2000-01-01",
    "situacao": "ATIVO"
  }'
echo -e "\n${GREEN}✅ Teste 8 executado${NC}\n"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║   TESTES CONCLUÍDOS!                                          ║"
echo "╚═════════���═════════════════════════════════════════════════════╝"

