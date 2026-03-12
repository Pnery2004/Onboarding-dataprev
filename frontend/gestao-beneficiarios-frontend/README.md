# Frontend - Sistema de Gestão de Beneficiários

Frontend moderno desenvolvido com React e Design System GOV.BR para o Sistema de Gestão de Beneficiários da Dataprev.

## 📋 Características

- ✅ **Interface moderna** com Design System GOV.BR
- ✅ **Listagem de beneficiários** com filtros e busca
- ✅ **Cadastro de novos beneficiários** com validações
- ✅ **Edição de beneficiários** existentes
- ✅ **Visualização detalhada** de dados
- ✅ **Integração completa** com API REST
- ✅ **Validação de CPF** em tempo real
- ✅ **Design responsivo** para mobile e desktop

## 🛠️ Tecnologias

- **React 18**
- **React Router DOM 6**
- **Axios** para requisições HTTP
- **Design System GOV.BR**
- **CSS3** com layout moderno

## 📦 Instalação

### Pré-requisitos

- Node.js 16 ou superior
- npm 8 ou superior
- API Backend rodando em `http://localhost:8080`

### Instalando dependências

```bash
cd frontend/gestao-beneficiarios-frontend
npm install
```

## 🚀 Executando a aplicação

### Modo de desenvolvimento

```bash
npm start
```

A aplicação estará disponível em: `http://localhost:3000`

### Build para produção

```bash
npm run build
```

Os arquivos otimizados serão gerados na pasta `build/`.

## 🎨 Estrutura do projeto

```
gestao-beneficiarios-frontend/
├── src/
│   ├── components/            # Componentes reutilizáveis
│   │   ├── Header.jsx         # Cabeçalho da aplicação
│   │   ├── Footer.jsx         # Rodapé da aplicação
│   │   └── Loading.jsx        # Componente de loading
│   ├── pages/                 # Páginas da aplicação
│   │   ├── Home.jsx           # Página inicial
│   │   ├── ListaBeneficiarios.jsx    # Lista de beneficiários
│   │   ├── FormBeneficiario.jsx      # Formulário criar/editar
│   │   └── DetalhesBeneficiario.jsx  # Detalhes do beneficiário
│   ├── services/              # Serviços de integração
│   │   ├── api.js             # Configuração do Axios
│   │   └── beneficiarioService.js    # Serviço de beneficiários
│   ├── utils/                 # Funções utilitárias
│   │   └── formatters.js      # Formatação de dados (CPF, datas, etc)
│   ├── App.js                 # Componente principal com rotas
│   └── index.js               # Ponto de entrada
└── README.md
```

## 📱 Páginas e Rotas

### 1. Página Inicial (`/`)
- Apresentação do sistema
- Cards com links rápidos
- Informações sobre funcionalidades

### 2. Lista de Beneficiários (`/beneficiarios`)
- Tabela com todos os beneficiários
- Filtro por nome ou CPF
- Filtro por situação (Ativo, Inativo, Suspenso)
- Ações: Visualizar, Editar, Deletar

### 3. Novo Beneficiário (`/novo`)
- Formulário de cadastro
- Validações em tempo real
- Validação de CPF
- Campos: Nome, CPF, Data de Nascimento, Situação

### 4. Editar Beneficiário (`/editar/:id`)
- Formulário de edição
- CPF não editável
- Carregamento automático dos dados

### 5. Detalhes do Beneficiário (`/beneficiarios/:id`)
- Visualização completa dos dados
- Badge de situação
- Ações: Editar e Deletar

## 🔧 Configuração da API

O frontend está configurado para se conectar à API em `http://localhost:8080/api/v1`.

Para alterar a URL da API, edite o arquivo `src/services/api.js`:

```javascript
const api = axios.create({
  baseURL: 'http://localhost:8080/api/v1',
  // ...
});
```

## 🎨 Design System GOV.BR

O projeto segue as diretrizes do Design System GOV.BR:

- **Cores**: Paleta oficial do governo federal
- **Tipografia**: Fonte Rawline
- **Componentes**: Botões, formulários e tabelas padronizados
- **Responsividade**: Mobile-first design

## ✅ Validações

### CPF
- Validação de formato (11 dígitos)
- Validação de dígitos verificadores
- Formatação automática (000.000.000-00)

### Nome
- Mínimo de 3 caracteres
- Máximo de 100 caracteres

### Data de Nascimento
- Não pode ser futura
- Formato: yyyy-mm-dd

## 🔄 Fluxo de uso

1. **Acessar o sistema**: Abra `http://localhost:3000`
2. **Visualizar beneficiários**: Clique em "Beneficiários" no menu
3. **Filtrar dados**: Use os campos de busca e filtros
4. **Cadastrar novo**: Clique em "+ Novo Beneficiário"
5. **Preencher formulário**: Digite os dados e clique em "Cadastrar"
6. **Visualizar detalhes**: Clique no ícone 👁️ na tabela
7. **Editar**: Clique no ícone ✏️ ou no botão "Editar" nos detalhes
8. **Deletar**: Clique no ícone 🗑️ e confirme

## 🔗 Integração com Backend

O frontend consome os seguintes endpoints da API:

- `GET /api/v1/beneficiarios` - Listar todos
- `GET /api/v1/beneficiarios/{id}` - Buscar por ID
- `GET /api/v1/beneficiarios/cpf/{cpf}` - Buscar por CPF
- `POST /api/v1/beneficiarios` - Criar novo
- `PUT /api/v1/beneficiarios/{id}` - Atualizar
- `DELETE /api/v1/beneficiarios/{id}` - Deletar

---

**Desenvolvido com ❤️ para Dataprev - Março 2026**

