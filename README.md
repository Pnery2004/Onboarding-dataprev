# API de Gestão de Beneficiários

API REST para gerenciamento de beneficiários da Dataprev, desenvolvida com Spring Boot 4.0.3, JPA/Hibernate e PostgreSQL.

## 📋 Características

- ✅ **API REST completa** com endpoints GET, POST, PUT e DELETE
- ✅ **Entidade Beneficiario** com validações completas
- ✅ **Persistência com JPA e PostgreSQL**
- ✅ **Documentação interativa com Swagger/OpenAPI**
- ✅ **Tratamento de exceções global**
- ✅ **Validação de dados com Jakarta Validation**
- ✅ **Auditoria com datas de criação/atualização**

## 🛠️ Tecnologias

- **Java 17**
- **Spring Boot 4.0.3**
- **Spring Data JPA**
- **PostgreSQL 16**
- **Swagger/OpenAPI 3.0**
- **Lombok**
- **Maven**

## 📦 Instalação

### Pré-requisitos

- Java 17 ou superior
- PostgreSQL 13 ou superior
- Maven 3.8 ou superior
- Git

### Clonando o repositório

```bash
git clone https://github.com/seu-usuario/Gestao-Beneficiarios.git
cd Gestao-Beneficiarios
```

### Configurando o banco de dados

#### 1. Criar o usuário e banco de dados no PostgreSQL

```bash
sudo -u postgres psql << EOF
CREATE USER myuser WITH PASSWORD 'secret';
CREATE DATABASE mydatabase OWNER myuser;
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO myuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO myuser;
EOF
```

#### 2. Importar o script SQL (opcional)

```bash
PGPASSWORD='secret' psql -h localhost -U myuser -d mydatabase < init-db.sql
```

#### 3. Criar arquivo `.pgpass` para conectar sem senha

```bash
echo "localhost:5432:mydatabase:myuser:secret" > ~/.pgpass
chmod 600 ~/.pgpass
```

### Compilando o projeto

```bash
cd /caminho/para/Gestao-Beneficiarios
./mvnw clean install
```

## 🚀 Executando a aplicação

### Usando Maven

```bash
./mvnw spring-boot:run
```

### Usando JAR

```bash
./mvnw clean package
java -jar target/Gestao-Beneficiarios-0.0.1-SNAPSHOT.jar
```

A aplicação estará disponível em: `http://localhost:8080`

## 📚 Documentação da API

### Swagger UI

Após iniciar a aplicação, acesse a documentação interativa:

```
http://localhost:8080/swagger-ui.html
```

### OpenAPI JSON

```
http://localhost:8080/api-docs
```

## 📝 Endpoints da API

### Base URL
```
http://localhost:8080/api/v1/beneficiarios
```

### 1. Listar todos os beneficiários

**GET** `/api/v1/beneficiarios`

```bash
curl -X GET http://localhost:8080/api/v1/beneficiarios
```

**Resposta (200 OK):**
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

### 2. Obter beneficiário por ID

**GET** `/api/v1/beneficiarios/{id}`

```bash
curl -X GET http://localhost:8080/api/v1/beneficiarios/1
```

**Resposta (200 OK):**
```json
{
  "id": 1,
  "nome": "João Silva Santos",
  "cpf": "12345678901",
  "dataNascimento": "1990-05-15",
  "situacao": "ATIVO",
  "dataCriacao": "2026-03-10",
  "dataAtualizacao": "2026-03-10"
}
```

### 3. Obter beneficiário por CPF

**GET** `/api/v1/beneficiarios/cpf/{cpf}`

```bash
curl -X GET http://localhost:8080/api/v1/beneficiarios/cpf/12345678901
```

**Resposta (200 OK):**
```json
{
  "id": 1,
  "nome": "João Silva Santos",
  "cpf": "12345678901",
  "dataNascimento": "1990-05-15",
  "situacao": "ATIVO",
  "dataCriacao": "2026-03-10",
  "dataAtualizacao": "2026-03-10"
}
```

### 4. Criar novo beneficiário

**POST** `/api/v1/beneficiarios`

```bash
curl -X POST http://localhost:8080/api/v1/beneficiarios \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Ana Paula Silva",
    "cpf": "11122233344",
    "dataNascimento": "1995-07-20",
    "situacao": "ATIVO"
  }'
```

**Resposta (201 Created):**
```json
{
  "id": 4,
  "nome": "Ana Paula Silva",
  "cpf": "11122233344",
  "dataNascimento": "1995-07-20",
  "situacao": "ATIVO",
  "dataCriacao": "2026-03-10",
  "dataAtualizacao": "2026-03-10"
}
```

### 5. Atualizar beneficiário

**PUT** `/api/v1/beneficiarios/{id}`

```bash
curl -X PUT http://localhost:8080/api/v1/beneficiarios/1 \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "João Silva Santos Atualizado",
    "cpf": "12345678901",
    "dataNascimento": "1990-05-15",
    "situacao": "INATIVO"
  }'
```

**Resposta (200 OK):**
```json
{
  "id": 1,
  "nome": "João Silva Santos Atualizado",
  "cpf": "12345678901",
  "dataNascimento": "1990-05-15",
  "situacao": "INATIVO",
  "dataCriacao": "2026-03-10",
  "dataAtualizacao": "2026-03-10"
}
```

### 6. Deletar beneficiário

**DELETE** `/api/v1/beneficiarios/{id}`

```bash
curl -X DELETE http://localhost:8080/api/v1/beneficiarios/1
```

**Resposta (204 No Content):**
```
(sem conteúdo)
```

## ✅ Testes

### Executar todos os testes

```bash
./mvnw test
```

### Executar com cobertura

```bash
./mvnw jacoco:report
```

## 🗂️ Estrutura do projeto

```
Gestao-Beneficiarios/
├── src/
│   ├── main/
│   │   ├── java/com/example/Gestao_Beneficiarios/
│   │   │   ├── config/           # Configurações (Swagger, etc)
│   │   │   ├── controller/       # Controllers REST
│   │   │   ├── dto/              # Data Transfer Objects
│   │   │   ├── exception/        # Exception handling
│   │   │   ├── model/            # Entidades JPA
│   │   │   ├── repository/       # Repositories (DAO)
│   │   │   ├── service/          # Lógica de negócio
│   │   │   └── GestaoBeneficiariosApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/...
├── init-db.sql                   # Script de inicialização do BD
├── pom.xml                       # Dependências Maven
├── README.md                     # Este arquivo
└── .gitignore
```

## 🔧 Configuração

### application.properties

As principais configurações estão em `src/main/resources/application.properties`:

```properties
# Banco de dados
spring.datasource.url=jdbc:postgresql://localhost:5432/mydatabase
spring.datasource.username=myuser
spring.datasource.password=secret

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update

# Swagger
springdoc.swagger-ui.path=/swagger-ui.html
```

## 📊 Modelo de dados

### Tabela: beneficiarios

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| nome | VARCHAR(100) | NOT NULL | Nome completo |
| cpf | VARCHAR(11) | NOT NULL, UNIQUE | CPF (11 dígitos) |
| data_nascimento | DATE | NOT NULL | Data de nascimento |
| situacao | VARCHAR(50) | NOT NULL | Status (ATIVO, INATIVO, SUSPENSO) |
| data_criacao | DATE | DEFAULT CURRENT_DATE | Data de criação |
| data_atualizacao | DATE | DEFAULT CURRENT_DATE | Data de última atualização |

## 🐛 Troubleshooting

### Erro: "Connection refused"

**Causa:** PostgreSQL não está rodando

**Solução:**
```bash
sudo service postgresql start
# ou
sudo systemctl start postgresql
```

### Erro: "FATAL: Ident authentication failed"

**Causa:** Credenciais incorretas

**Solução:** Verifique `application.properties`

### Erro: "column xxx does not exist"

**Causa:** Schema não foi criado

**Solução:**
```bash
PGPASSWORD='secret' psql -h localhost -U myuser -d mydatabase < init-db.sql
```

## 📋 Checklist de Entrega

- [x] API REST funcional com GET, POST, PUT, DELETE
- [x] Entidade Beneficiario com todos os campos solicitados
- [x] Persistência com JPA e PostgreSQL
- [x] Documentação com Swagger/OpenAPI
- [x] Scripts SQL inclusos
- [x] README com instruções de execução
- [ ] Repositório GitHub (a ser enviado)

## 👤 Autor

Paulo Lobo  
Projeto Onboarding Dataprev - 2026

## 📄 Licença

Apache License 2.0

## 📞 Suporte

Para dúvidas ou problemas, entre em contato: suporte@dataprev.gov.br

---

**Data de Entrega:** 18/03/2026

