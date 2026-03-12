# API de Gestão de Beneficiários

API REST para gerenciamento de beneficiários da Dataprev, desenvolvida com Spring Boot 4.0.3, JPA/Hibernate e PostgreSQL, com frontend React integrado ao Design System GOV.BR.

## 📋 Características

- ✅ **API REST completa** com endpoints GET, POST, PUT e DELETE
- ✅ **Entidade Beneficiario** com validações completas
- ✅ **Persistência com JPA e PostgreSQL**
- ✅ **Documentação interativa com Swagger/OpenAPI**
- ✅ **Tratamento de exceções global**
- ✅ **Validação de dados com Jakarta Validation**
- ✅ **Auditoria com datas de criação/atualização**
- ✅ **Frontend React com Design System GOV.BR**

## 🛠️ Tecnologias

### Backend
- **Java 17**
- **Spring Boot 4.0.3**
- **Spring Data JPA / Hibernate**
- **Spring Validation (Jakarta Bean Validation)**
- **Spring AI 2.0.0-M2** (integração PostgresML Embedding)
- **PostgreSQL 13+** (driver JDBC)
- **Springdoc OpenAPI 2.1.0** (Swagger UI)
- **Lombok**
- **Maven 3.8+** (via Maven Wrapper)

### Frontend
- **React 19**
- **React Router DOM 7**
- **Axios 1.x** — cliente HTTP para comunicação com a API
- **Design System GOV.BR** (`@govbr-ds/core ^3.7.0` + `@govbr-ds/webcomponents`)
- **CSS3** — Flexbox e Grid
- **Node.js 18+**

## 📦 Instalação

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

Execute o script de instalação na raiz do projeto:

```bash
./install.sh
```

O script irá:
- Verificar Java, Node.js e npm instalados
- Baixar todas as dependências Maven do backend (`dependency:go-offline`)
- Instalar todos os pacotes npm do frontend (`npm install`)

### 3. Configurar o banco de dados PostgreSQL

```bash
sudo -u postgres psql << EOF
CREATE USER myuser WITH PASSWORD 'secret';
CREATE DATABASE mydatabase OWNER myuser;
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO myuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO myuser;
EOF
```

#### Importar script SQL inicial (opcional)

```bash
PGPASSWORD='secret' psql -h localhost -U myuser -d mydatabase < backend/init-db.sql
```

#### Criar arquivo `.pgpass` para conectar sem senha

```bash
echo "localhost:5432:mydatabase:myuser:secret" > ~/.pgpass
chmod 600 ~/.pgpass
```

## 🚀 Executando a aplicação

### Iniciar tudo de uma vez

```bash
./start.sh
```

### Iniciar manualmente

**Backend:**
```bash
cd backend
./mvnw spring-boot:run
```

**Frontend:**
```bash
cd frontend/gestao-beneficiarios-frontend
npm start
```

| Serviço   | Endereço                              |
|-----------|---------------------------------------|
| Frontend  | http://localhost:3000                 |
| API       | http://localhost:8080                 |
| Swagger   | http://localhost:8080/swagger-ui.html |

## 🗂️ Estrutura do projeto

```
Gestao-Beneficiarios/
├── install.sh                        # Baixa todas as dependências
├── start.sh                          # Inicia backend + frontend
├── stop.sh                           # Para todos os serviços
├── status.sh                         # Verifica status dos serviços
├── backend/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/example/Gestao_Beneficiarios/
│   │   │   │   ├── config/           # Configurações (Swagger, CORS)
│   │   │   │   ├── controller/       # Controllers REST
│   │   │   │   ├── dto/              # Data Transfer Objects
│   │   │   │   ├── exception/        # Exception handling global
│   │   │   │   ├── model/            # Entidades JPA
│   │   │   │   ├── repository/       # Repositories (DAO)
│   │   │   │   ├── service/          # Lógica de negócio
│   │   │   │   └── GestaoBeneficiariosApplication.java
│   │   │   └── resources/
│   │   │       └── application.properties
│   │   └── test/
│   ├── init-db.sql                   # Script de inicialização do BD
│   ├── pom.xml                       # Dependências Maven
│   └── mvnw                          # Maven Wrapper
└── frontend/
    └── gestao-beneficiarios-frontend/
        ├── src/
        │   ├── components/           # Header, Footer, Loading
        │   ├── pages/                # Home, Lista, Form, Detalhes
        │   ├── services/             # api.js, beneficiarioService.js
        │   └── utils/                # formatters.js
        └── package.json              # Dependências npm
```

## 🔧 Configuração

### application.properties

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

| Campo            | Tipo         | Constraints       | Descrição                        |
|------------------|--------------|-------------------|----------------------------------|
| id               | SERIAL       | PRIMARY KEY       | Identificador único              |
| nome             | VARCHAR(100) | NOT NULL          | Nome completo                    |
| cpf              | VARCHAR(11)  | NOT NULL, UNIQUE  | CPF (11 dígitos, sem formatação) |
| data_nascimento  | DATE         | NOT NULL          | Data de nascimento               |
| situacao         | VARCHAR(50)  | NOT NULL          | ATIVO, INATIVO ou SUSPENSO       |
| data_criacao     | DATE         | DEFAULT NOW()     | Data de criação do registro      |
| data_atualizacao | DATE         | DEFAULT NOW()     | Data da última atualização       |

## 🎨 Frontend — Interface Web

### Funcionalidades

| Tela                    | Rota                    | Descrição                                                 |
|-------------------------|-------------------------|-----------------------------------------------------------|
| Página Inicial          | `/`                     | Cards com acesso rápido às funcionalidades                |
| Listagem                | `/beneficiarios`        | Tabela com filtro por nome/CPF e por situação             |
| Cadastro                | `/novo`                 | Formulário com validação de CPF e campos obrigatórios     |
| Edição                  | `/editar/:id`           | Formulário pré-preenchido (CPF somente leitura)           |
| Detalhes                | `/beneficiario/:id`     | Visualização completa com badge de situação               |

### Design System GOV.BR

- **Cores oficiais**: Azul `#1351b4`, Azul escuro `#0c326f`
- **Tipografia**: Fonte Rawline (padrão GOV.BR)
- **Acessibilidade**: Contraste adequado e navegação por teclado
- **Responsividade**: Mobile-first design

## 🧪 Testando o Sistema

### Verificar status dos serviços

```bash
./status.sh
```

### Endpoints da API

| Método | Endpoint                   | Descrição                         |
|--------|----------------------------|-----------------------------------|
| GET    | `/beneficiarios`           | Listar todos os beneficiários     |
| GET    | `/beneficiarios/{id}`      | Buscar beneficiário por ID        |
| POST   | `/beneficiarios`           | Cadastrar novo beneficiário       |
| PUT    | `/beneficiarios/{id}`      | Atualizar beneficiário            |
| DELETE | `/beneficiarios/{id}`      | Deletar beneficiário              |

Documentação interativa: http://localhost:8080/swagger-ui.html
