# 🧪 Guia de Testes - API de Gestão de Beneficiários

## 📌 Como Testar a API

Existem **3 formas principais** de testar a API:

---

## **Opção 1: Swagger/OpenAPI (Interface Gráfica) ✨**

### Passo 1: Acessar o Swagger

Após iniciar a aplicação, abra no navegador:

```
http://localhost:8080/swagger-ui.html
```

### Passo 2: Testar os Endpoints

1. **Expanda** a seção "Beneficiários"
2. **Clique** no endpoint desejado (GET, POST, PUT, DELETE)
3. **Preencha** os parâmetros/body
4. **Clique** em "Try it out" → "Execute"

**Vantagens:**
- ✅ Interface visual e amigável
- ✅ Documentação completa integrada
- ✅ Mostra exemplos de request/response
- ✅ Não precisa de ferramentas extras

---

## **Opção 2: Postman (Desktop/Web) 🚀**

### Passo 1: Importar Collection

1. Abra o **Postman**
2. Clique em **Import**
3. Selecione o arquivo: `API-Gestao-Beneficiarios.postman_collection.json`
4. Clique em **Import**

### Passo 2: Executar Requests

1. Expanda a coleção **"API Gestão de Beneficiários"**
2. Clique em qualquer request (ex: "1. Listar todos")
3. Clique em **Send**
4. Veja o resultado na aba **Response**

**Vantagens:**
- ✅ Mais funcionalidades que curl
- ✅ Facilita testes repetidos
- ✅ Histórico de requests
- ✅ Variáveis de ambiente

---

## **Opção 3: CURL (Terminal/CLI) 💻**

### Passo 1: Exemplos básicos

#### **GET - Listar todos**
```bash
curl -X GET http://localhost:8080/api/v1/beneficiarios
```

#### **GET - Por ID**
```bash
curl -X GET http://localhost:8080/api/v1/beneficiarios/1
```

#### **GET - Por CPF**
```bash
curl -X GET http://localhost:8080/api/v1/beneficiarios/cpf/12345678901
```

#### **POST - Criar novo**
```bash
curl -X POST http://localhost:8080/api/v1/beneficiarios \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Pedro Mendes",
    "cpf": "33344455566",
    "dataNascimento": "1988-12-01",
    "situacao": "ATIVO"
  }'
```

#### **PUT - Atualizar**
```bash
curl -X PUT http://localhost:8080/api/v1/beneficiarios/1 \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Atualizado",
    "cpf": "12345678901",
    "dataNascimento": "1990-05-15",
    "situacao": "INATIVO"
  }'
```

#### **DELETE - Remover**
```bash
curl -X DELETE http://localhost:8080/api/v1/beneficiarios/1
```

### Passo 2: Usar script de testes

```bash
# Dar permissão
chmod +x test-api.sh

# Executar
./test-api.sh
```

**Vantagens:**
- ✅ Funciona em qualquer terminal
- ✅ Ótimo para automação
- ✅ Sem dependências externas

---

## 📊 Dados de Teste

### Beneficiários pré-cadastrados:

| ID | Nome | CPF | Situação |
|---|---|---|---|
| 1 | João Silva Santos | 12345678901 | ATIVO |
| 2 | Maria Oliveira Costa | 98765432101 | ATIVO |
| 3 | Carlos Eduardo Souza | 55555555555 | INATIVO |

### Valores válidos para `situacao`:
- `ATIVO`
- `INATIVO`
- `SUSPENSO`

---

## ✅ Checklist de Testes

Use este checklist para testar todos os endpoints:

### **GET Endpoints**

- [ ] `GET /beneficiarios` - Retorna lista de todos
  - Esperado: Status 200 com array de beneficiários

- [ ] `GET /beneficiarios/1` - Retorna um por ID
  - Esperado: Status 200 com um beneficiário

- [ ] `GET /beneficiarios/cpf/12345678901` - Retorna por CPF
  - Esperado: Status 200 com um beneficiário

- [ ] `GET /beneficiarios/9999` - ID inexistente
  - Esperado: Status 404 (Not Found)

### **POST Endpoint**

- [ ] `POST /beneficiarios` - Criar novo válido
  - Esperado: Status 201 com novo beneficiário

- [ ] `POST /beneficiarios` - CPF duplicado
  - Esperado: Status 400 com mensagem de erro

- [ ] `POST /beneficiarios` - CPF inválido (menos de 11 dígitos)
  - Esperado: Status 400 com erro de validação

- [ ] `POST /beneficiarios` - Campo obrigatório ausente
  - Esperado: Status 400 com detalhes do erro

### **PUT Endpoint**

- [ ] `PUT /beneficiarios/1` - Atualizar válido
  - Esperado: Status 200 com beneficiário atualizado

- [ ] `PUT /beneficiarios/9999` - ID inexistente
  - Esperado: Status 400 com mensagem de erro

- [ ] Verificar se `dataAtualizacao` foi atualizada

### **DELETE Endpoint**

- [ ] `DELETE /beneficiarios/3` - Deletar existente
  - Esperado: Status 204 (No Content)

- [ ] `DELETE /beneficiarios/9999` - ID inexistente
  - Esperado: Status 404

- [ ] Verificar se foi deletado do banco

---

## 🔍 Validações Esperadas

### CPF
- Deve ter exatamente **11 dígitos**
- Deve ser **único** no banco
- Exemplos válidos: `12345678901`, `98765432101`

### Nome
- Obrigatório
- Máximo 100 caracteres

### Data de Nascimento
- Obrigatória
- Formato: `YYYY-MM-DD`
- Exemplo: `1990-05-15`

### Situação
- Obrigatória
- Valores aceitos: `ATIVO`, `INATIVO`, `SUSPENSO`

---

## 📝 Exemplos de Response

### ✅ Sucesso (GET)
```json
[
  {
    "id": 1,
    "nome": "João Silva Santos",
    "cpf": "12345678901",
    "dataNascimento": "1990-05-15",
    "situacao": "ATIVO",
    "dataCriacao": "2026-03-10",
    "dataAtualizacao": "2026-03-10"
  }
]
```

### ✅ Sucesso (POST)
```json
{
  "id": 4,
  "nome": "Pedro Mendes",
  "cpf": "33344455566",
  "dataNascimento": "1988-12-01",
  "situacao": "ATIVO",
  "dataCriacao": "2026-03-10",
  "dataAtualizacao": "2026-03-10"
}
```

### ❌ Erro (Validação)
```json
{
  "timestamp": "2026-03-10T10:30:00",
  "status": 400,
  "message": "Erro de validação",
  "errors": {
    "cpf": "CPF deve conter 11 dígitos",
    "nome": "Nome é obrigatório"
  }
}
```

### ❌ Erro (Duplicado)
```json
{
  "timestamp": "2026-03-10T10:30:00",
  "status": 400,
  "message": "Erro: CPF já existe no sistema"
}
```

---

## 🚀 Dicas Úteis

### Verificar dados no banco (PostgreSQL)

```bash
# Listar todos
PGPASSWORD='secret' psql -h localhost -U myuser -d mydatabase -c "SELECT * FROM beneficiarios;"

# Contar registros
PGPASSWORD='secret' psql -h localhost -U myuser -d mydatabase -c "SELECT COUNT(*) FROM beneficiarios;"

# Buscar por CPF
PGPASSWORD='secret' psql -h localhost -U myuser -d mydatabase -c "SELECT * FROM beneficiarios WHERE cpf = '12345678901';"
```

### Formatar output do curl

Com `jq` instalado:
```bash
curl -s http://localhost:8080/api/v1/beneficiarios | jq .
```

Com Python:
```bash
curl -s http://localhost:8080/api/v1/beneficiarios | python3 -m json.tool
```

### Salvar response em arquivo

```bash
curl -s http://localhost:8080/api/v1/beneficiarios > response.json
```

---

## 🐛 Troubleshooting

### Erro: "Connection refused"
```
Verifique se a aplicação está rodando:
java -jar target/Gestao-Beneficiarios-0.0.1-SNAPSHOT.jar
```

### Erro: "404 Not Found"
```
Verifique a URL:
- GET /api/v1/beneficiarios/ ❌ (tem barra no final)
- GET /api/v1/beneficiarios ✅ (correto)
```

### Erro: "400 Bad Request"
```
Verifique:
1. Content-Type: application/json ✅
2. Validação de dados
3. Formato JSON válido
```

### Erro: "409 Conflict"
```
CPF já existe no banco de dados
Use um CPF diferente
```

---

## 📞 Suporte

Para dúvidas, verifique:
1. README.md - Instruções gerais
2. Swagger - Documentação completa
3. Logs da aplicação - Ver erros detalhados

---

**Data:** 10/03/2026
**Versão:** 1.0
**Status:** ✅ Todos os endpoints funcionando

