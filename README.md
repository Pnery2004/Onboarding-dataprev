# Gestão de Beneficiários

Plataforma para gerenciamento de beneficiários da Dataprev, desenvolvida com arquitetura de **microserviços Spring Cloud**, frontend React integrado ao Design System GOV.BR.

## Características

- **Arquitetura de microserviços** com Spring Cloud
- **API Gateway** centraliza e roteia as requisições
- **Service Discovery** com Netflix Eureka
- **Comunicação entre serviços** via OpenFeign
- **API REST completa** com endpoints GET, POST, PUT e DELETE
- **Persistência com JPA e PostgreSQL**
- **Documentação interativa com Swagger/OpenAPI**
- **Frontend React com Design System GOV.BR**

## Tecnologias

### Backend
- **Java 17**
- **Spring Boot 3.2.4**
- **Spring Cloud 2023.0.1** (Gateway, Eureka, OpenFeign)
- **Spring Data JPA / Hibernate**
- **PostgreSQL 13+**
- **Springdoc OpenAPI 2.3.0** (Swagger UI)
- **Lombok**
- **Maven Wrapper**

### Frontend
- **React 19**
- **React Router DOM 7**
- **Axios 1.x** — cliente HTTP para comunicação com a API
- **Design System GOV.BR** (`@govbr-ds/core ^3.7.0`)
- **Node.js 18+**

## Instalação

### Pré-requisitos

- Java 17 ou superior
- Node.js 18 ou superior
- PostgreSQL 13 ou superior
- Git

### 1. Clonar o repositório

```bash
git clone https://github.com/seu-usuario/Gestao-Beneficiarios.git
cd Gestao-Beneficiarios
```

### 2. Baixar todas as dependências (Backend + Frontend)

```bash
./install.sh
```

O script verifica Java, Node.js e npm, baixa as dependências Maven de todos os módulos e instala os pacotes npm do frontend.

### 3. Configurar o banco de dados PostgreSQL

```bash
sudo -u postgres psql << EOF
CREATE USER myuser WITH PASSWORD 'secret';
CREATE DATABASE beneficiarios OWNER myuser;
GRANT ALL PRIVILEGES ON DATABASE beneficiarios TO myuser;
EOF
```

#### Importar dados de exemplo (opcional)

```bash
PGPASSWORD='secret' psql -h localhost -U myuser -d beneficiarios < backend/init-db.sql
```

## Executando a aplicação

### Executar com Docker (stack completa)

Este repositório já possui Dockerfiles por serviço e um `docker-compose.yml` para subir todo o ambiente:

- PostgreSQL
- Discovery Server (Eureka)
- Beneficiarios Service
- Consulta Service
- API Gateway
- Frontend React (servido por Nginx)

#### 1. (Opcional) criar `.env`

```bash
cp .env.example .env
```

#### 2. Subir todos os containers

```bash
docker compose up --build -d
```

#### 3. Ver logs

```bash
docker compose logs -f
```

#### 4. Parar ambiente

```bash
docker compose down
```

#### URLs no modo Docker

| Serviço          | Endereço              |
|------------------|-----------------------|
| Frontend         | http://localhost:3000 |
| API Gateway      | http://localhost:8080 |
| Eureka Dashboard | http://localhost:8761 |

### Iniciar tudo de uma vez

```bash
./start.sh
```

O script sobe os serviços **na ordem correta**:
1. Discovery Server (Eureka)
2. Beneficiarios Service
3. Consulta Service
4. API Gateway
5. Frontend React

### Verificar status

```bash
./status.sh
```

### Parar todos os serviços

```bash
./stop.sh
```

### Iniciar serviços manualmente

```bash
cd backend

# 1. Discovery Server
./mvnw -pl discovery-server spring-boot:run &

# 2. Beneficiarios Service
./mvnw -pl beneficiarios-service spring-boot:run &

# 3. Consulta Service
./mvnw -pl consulta-service spring-boot:run &

# 4. API Gateway
./mvnw -pl api-gateway spring-boot:run &

# 5. Frontend
cd ../frontend/gestao-beneficiarios-frontend
npm start
```

### URLs disponíveis

| Serviço              | Endereço                              |
|----------------------|---------------------------------------|
| Frontend             | http://localhost:3000                 |
| API Gateway          | http://localhost:8080                 |
| Swagger (gateway)    | http://localhost:8080/swagger-ui.html |
| Eureka Dashboard     | http://localhost:8761                 |
| Beneficiarios direto | http://localhost:8081                 |
| Consulta direto      | http://localhost:8082                 |

## Estrutura do projeto

```
Gestao-Beneficiarios/
├── install.sh                        # Baixa todas as dependências
├── start.sh                          # Inicia todos os serviços
├── stop.sh                           # Para todos os serviços
├── status.sh                         # Verifica status individual de cada serviço
├── backend/
│   ├── pom.xml                       # Agregador Maven (packaging=pom)
│   ├── mvnw                          # Maven Wrapper
│   ├── init-db.sql                   # Script de criação e dados iniciais
│   ├── discovery-server/             # Eureka Server (porta 8761)
│   ├── api-gateway/                  # Spring Cloud Gateway (porta 8080)
│   ├── beneficiarios-service/        # CRUD de beneficiários (porta 8081)
│   │   └── src/main/java/.../
│   │       ├── config/               # Swagger, CORS
│   │       ├── controller/           # Endpoints REST
│   │       ├── dto/                  # Request/Response DTOs
│   │       ├── exception/            # Tratamento global de erros
│   │       ├── model/                # Entidade JPA Beneficiario
│   │       ├── repository/           # Spring Data Repository
│   │       └── service/              # Regras de negócio
│   └── consulta-service/             # Consultas via Feign (porta 8082)
│       └── src/main/java/.../
│           ├── client/               # BeneficiariosClient (OpenFeign)
│           ├── controller/           # Endpoints de consulta
│           ├── dto/                  # BeneficiarioView
│           └── service/              # BeneficiarioConsultaService
└── frontend/
    └── gestao-beneficiarios-frontend/
        ├── src/
        │   ├── components/           # Header, Footer, Loading
        │   ├── pages/                # Home, Lista, Form, Detalhes
        │   ├── services/             # api.js, beneficiarioService.js
        │   └── utils/                # formatters.js
        └── package.json
```

## Configuração

### application.properties (beneficiarios-service)

```properties
spring.application.name=beneficiarios-service
server.port=8081

spring.datasource.url=jdbc:postgresql://localhost:5432/beneficiarios
spring.datasource.username=myuser
spring.datasource.password=secret

spring.jpa.hibernate.ddl-auto=update

eureka.client.service-url.defaultZone=http://localhost:8761/eureka
```

### application.yml (api-gateway)

```yaml
server:
  port: 8080

spring:
  cloud:
    gateway:
      routes:
        - id: beneficiarios-service
          uri: lb://beneficiarios-service
          predicates:
            - Path=/api/v1/beneficiarios/**
        - id: consulta-service
          uri: lb://consulta-service
          predicates:
            - Path=/api/v1/consultas/**
```

## Modelo de dados

### Tabela: beneficiarios

| Campo            | Tipo         | Constraints       | Descrição                        |
|------------------|--------------|-------------------|----------------------------------|
| id               | SERIAL       | PRIMARY KEY       | Identificador único              |
| nome             | VARCHAR(100) | NOT NULL          | Nome completo                    |
| cpf              | VARCHAR(11)  | NOT NULL, UNIQUE  | CPF (11 dígitos, sem formatação) |
| data_nascimento  | DATE         | NOT NULL          | Data de nascimento               |
| situacao         | VARCHAR(50)  | NOT NULL          | ATIVO, INATIVO ou SUSPENSO       |
| data_criacao     | DATE         | DEFAULT NOW()     | Data de criação do registro      |
| data_atualizacao | DATE         | DEFAULT NOW()     | Data da última atualização       |

## Interface Web

### Telas disponíveis

| Tela          | Rota                | Descrição                                             |
|---------------|---------------------|-------------------------------------------------------|
| Página Inicial | `/`                | Cards com acesso rápido às funcionalidades            |
| Listagem      | `/beneficiarios`    | Tabela com filtro por nome/CPF e por situação         |
| Cadastro      | `/novo`             | Formulário com validação de CPF                       |
| Edição        | `/editar/:id`       | Formulário pré-preenchido (CPF somente leitura)       |
| Detalhes      | `/beneficiario/:id` | Visualização completa com badge de situação           |

### Design System GOV.BR

- Cores oficiais: Azul `#1351b4`, Azul escuro `#0c326f`
- Tipografia: Fonte Rawline (padrão GOV.BR)

## Endpoints da API

Todas as requisições passam pelo **API Gateway** em `http://localhost:8080`.

| Método | Endpoint                          | Descrição                     |
|--------|-----------------------------------|-------------------------------|
| GET    | `/api/v1/beneficiarios`           | Listar todos                  |
| GET    | `/api/v1/beneficiarios/{id}`      | Buscar por ID                 |
| GET    | `/api/v1/beneficiarios/cpf/{cpf}` | Buscar por CPF                |
| POST   | `/api/v1/beneficiarios`           | Cadastrar novo beneficiário   |
| PUT    | `/api/v1/beneficiarios/{id}`      | Atualizar beneficiário        |
| DELETE | `/api/v1/beneficiarios/{id}`      | Deletar beneficiário          |

Documentação interativa: http://localhost:8080/swagger-ui.html

## Logs

| Serviço              | Arquivo de log                      |
|----------------------|-------------------------------------|
| Discovery Server     | `/tmp/discovery-server.log`         |
| Beneficiarios Service| `/tmp/beneficiarios-service.log`    |
| Consulta Service     | `/tmp/consulta-service.log`         |
| API Gateway          | `/tmp/api-gateway.log`              |
| Frontend             | `/tmp/frontend.log`                 |

```bash
# Acompanhar logs em tempo real
tail -f /tmp/api-gateway.log
tail -f /tmp/beneficiarios-service.log
```

## Testes

### Executar testes do backend

```bash
cd backend
./mvnw -pl beneficiarios-service test
./mvnw -pl consulta-service test
```

### Testar a API via curl

```bash
# Listar beneficiários
curl http://localhost:8080/api/v1/beneficiarios

# Cadastrar
curl -X POST http://localhost:8080/api/v1/beneficiarios \
  -H "Content-Type: application/json" \
  -d '{"nome":"João Silva","cpf":"12345678901","dataNascimento":"1990-01-15","situacao":"ATIVO"}'
```
