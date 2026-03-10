# ⚡ Teste Rápido da API

## 🚀 3 Formas de Testar (escolha uma):

---

### **1️⃣ SWAGGER (Mais Fácil - Interface Gráfica)**

```
1. Abra no navegador:
   http://localhost:8080/swagger-ui.html

2. Expanda a seção "Beneficiários"

3. Clique em um endpoint (ex: GET /api/v1/beneficiarios)

4. Clique em "Try it out"

5. Clique em "Execute"

6. Veja a resposta em "Response"
```

**Vantagem:** Não precisa de terminal, interface visual completa.

---

### **2️⃣ POSTMAN (Desktop App)**

```
1. Instale Postman: https://www.postman.com/downloads/

2. Importe o arquivo:
   API-Gestao-Beneficiarios.postman_collection.json

3. Clique em "Import"

4. Expanda a collection "API Gestão de Beneficiários"

5. Clique em um teste (ex: "1. Listar todos")

6. Clique em "Send"

7. Veja o resultado em "Response"
```

**Vantagem:** Mais rápido para múltiplos testes, histórico salvo.

---

### **3️⃣ CURL (Terminal)**

**Teste rápido:**

```bash
# Listar todos (retorna dados do banco)
curl http://localhost:8080/api/v1/beneficiarios

# Obter um específico
curl http://localhost:8080/api/v1/beneficiarios/1

# Criar novo
curl -X POST http://localhost:8080/api/v1/beneficiarios \
  -H "Content-Type: application/json" \
  -d '{"nome":"Teste","cpf":"99911122233","dataNascimento":"2000-01-01","situacao":"ATIVO"}'

# Atualizar
curl -X PUT http://localhost:8080/api/v1/beneficiarios/1 \
  -H "Content-Type: application/json" \
  -d '{"nome":"Teste Atualizado","cpf":"12345678901","dataNascimento":"1990-05-15","situacao":"INATIVO"}'

# Deletar
curl -X DELETE http://localhost:8080/api/v1/beneficiarios/1
```

**Vantagem:** Direto no terminal, sem dependências.

---

## ✅ Resposta Esperada

Se tudo funcionar, verá algo assim:

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
  },
  {
    "id": 2,
    "nome": "Maria Oliveira Costa",
    "cpf": "98765432101",
    "dataNascimento": "1985-08-22",
    "situacao": "ATIVO",
    "dataCriacao": "2026-03-10",
    "dataAtualizacao": "2026-03-10"
  }
]
```

---

## 🎯 Checklist Rápido

- [ ] GET /api/v1/beneficiarios - Retorna lista? ✅
- [ ] GET /api/v1/beneficiarios/1 - Retorna 1 registro? ✅
- [ ] GET /api/v1/beneficiarios/cpf/12345678901 - Funciona? ✅
- [ ] POST - Criar novo funciona? ✅
- [ ] PUT - Atualizar funciona? ✅
- [ ] DELETE - Deletar funciona? ✅

Se todos ✅, sua API está 100% funcional! 🎉

---

## 📌 Pré-requisitos

Antes de testar, certifique-se que:

```bash
# 1. Banco de dados rodando
PGPASSWORD='secret' psql -h localhost -U myuser -d mydatabase -c "SELECT COUNT(*) FROM beneficiarios;"

# 2. Aplicação rodando (na porta 8080)
curl http://localhost:8080/swagger-ui.html
```

Se ambos retornarem OK, você está pronto para testar! 🚀

