# 🧪 Guia de Testes - Frontend

Este documento descreve como testar todas as funcionalidades do frontend do Sistema de Gestão de Beneficiários.

## 📋 Pré-requisitos

Antes de testar, certifique-se de que:

1. ✅ O backend está rodando em `http://localhost:8080`
2. ✅ O frontend está rodando em `http://localhost:3000`
3. ✅ O PostgreSQL está rodando e com o banco `mydatabase` criado

## 🎯 Cenários de Teste

### 1. Teste da Página Inicial

**Objetivo:** Verificar se a página inicial carrega corretamente

**Passos:**
1. Acesse `http://localhost:3000`
2. Verifique se o header aparece (logo e menu)
3. Verifique se os 3 cards aparecem:
   - Listar Beneficiários
   - Novo Cadastro
   - Documentação API
4. Verifique se o footer aparece

**Resultado Esperado:**
- ✅ Página carrega sem erros
- ✅ Todos os elementos visuais aparecem
- ✅ Links estão funcionais

---

### 2. Teste de Cadastro - Sucesso

**Objetivo:** Cadastrar um novo beneficiário com dados válidos

**Passos:**
1. Clique em "Novo Cadastro" ou acesse `http://localhost:3000/novo`
2. Preencha os campos:
   - Nome: `Ana Paula Silva`
   - CPF: `11122233344`
   - Data de Nascimento: `1995-07-20`
   - Situação: `Ativo`
3. Clique em "Cadastrar"

**Resultado Esperado:**
- ✅ Mensagem: "Beneficiário cadastrado com sucesso!"
- ✅ Redirecionamento para `/beneficiarios`
- ✅ Novo beneficiário aparece na lista

---

### 3. Teste de Cadastro - CPF Inválido

**Objetivo:** Verificar validação de CPF inválido

**Passos:**
1. Acesse `http://localhost:3000/novo`
2. Preencha os campos:
   - Nome: `Teste Validação`
   - CPF: `11111111111` (CPF inválido)
   - Data de Nascimento: `1990-01-01`
   - Situação: `Ativo`
3. Clique em "Cadastrar"

**Resultado Esperado:**
- ❌ Mensagem de erro: "CPF inválido"
- ❌ Formulário não é enviado
- ❌ Campo CPF fica destacado em vermelho

---

### 4. Teste de Cadastro - CPF Duplicado

**Objetivo:** Verificar se o sistema impede cadastro de CPF duplicado

**Passos:**
1. Cadastre um beneficiário com CPF `12345678901`
2. Tente cadastrar outro beneficiário com o mesmo CPF
3. Clique em "Cadastrar"

**Resultado Esperado:**
- ❌ Mensagem de erro do backend
- ❌ Cadastro não é realizado

---

### 5. Teste de Cadastro - Campos Vazios

**Objetivo:** Verificar validação de campos obrigatórios

**Passos:**
1. Acesse `http://localhost:3000/novo`
2. Deixe todos os campos vazios
3. Clique em "Cadastrar"

**Resultado Esperado:**
- ❌ Mensagens de erro aparecem abaixo dos campos:
  - "Nome é obrigatório"
  - "CPF é obrigatório"
  - "Data de nascimento é obrigatória"

---

### 6. Teste de Cadastro - Data Futura

**Objetivo:** Verificar validação de data de nascimento

**Passos:**
1. Acesse `http://localhost:3000/novo`
2. Preencha:
   - Nome: `Teste Data`
   - CPF: `22233344455`
   - Data de Nascimento: `2030-01-01` (data futura)
   - Situação: `Ativo`
3. Clique em "Cadastrar"

**Resultado Esperado:**
- ❌ Mensagem de erro: "Data de nascimento não pode ser futura"
- ❌ Formulário não é enviado

---

### 7. Teste de Listagem - Sem Dados

**Objetivo:** Verificar comportamento quando não há dados

**Passos:**
1. Certifique-se de que o banco está vazio
2. Acesse `http://localhost:3000/beneficiarios`

**Resultado Esperado:**
- ✅ Mensagem: "Nenhum beneficiário encontrado"
- ✅ Botão "Cadastrar Primeiro Beneficiário" aparece

---

### 8. Teste de Listagem - Com Dados

**Objetivo:** Verificar exibição da lista de beneficiários

**Passos:**
1. Cadastre 3 beneficiários
2. Acesse `http://localhost:3000/beneficiarios`

**Resultado Esperado:**
- ✅ Tabela aparece com os 3 beneficiários
- ✅ Colunas: ID, Nome, CPF, Data de Nascimento, Situação, Ações
- ✅ CPF formatado: `111.222.333-44`
- ✅ Data formatada: `20/07/1995`
- ✅ Badge de situação com cor (verde para Ativo)

---

### 9. Teste de Filtro - Por Nome

**Objetivo:** Filtrar beneficiários por nome

**Passos:**
1. Acesse a lista de beneficiários
2. Digite no campo de busca: `Ana`

**Resultado Esperado:**
- ✅ Lista atualiza em tempo real
- ✅ Mostra apenas beneficiários com "Ana" no nome
- ✅ Contador atualiza: "Exibindo X de Y beneficiários"

---

### 10. Teste de Filtro - Por CPF

**Objetivo:** Filtrar beneficiários por CPF

**Passos:**
1. Acesse a lista de beneficiários
2. Digite no campo de busca: `111` (parte do CPF)

**Resultado Esperado:**
- ✅ Lista atualiza em tempo real
- ✅ Mostra apenas beneficiários com CPF contendo "111"

---

### 11. Teste de Filtro - Por Situação

**Objetivo:** Filtrar beneficiários por situação

**Passos:**
1. Acesse a lista de beneficiários
2. Selecione no filtro: `Inativo`

**Resultado Esperado:**
- ✅ Lista mostra apenas beneficiários inativos
- ✅ Contador atualiza corretamente

---

### 12. Teste de Visualização - Detalhes

**Objetivo:** Visualizar detalhes completos de um beneficiário

**Passos:**
1. Na lista, clique no ícone 👁️ de um beneficiário
2. Verifique a página de detalhes

**Resultado Esperado:**
- ✅ Redireciona para `/beneficiarios/:id`
- ✅ Card com todas as informações aparece
- ✅ Badge de situação aparece no topo
- ✅ Dados formatados corretamente
- ✅ Botões "Voltar", "Editar" e "Deletar" aparecem

---

### 13. Teste de Edição - Sucesso

**Objetivo:** Editar um beneficiário existente

**Passos:**
1. Na lista, clique no ícone ✏️
2. Altere o nome para: `João Silva Santos Atualizado`
3. Altere a situação para: `Inativo`
4. Clique em "Atualizar"

**Resultado Esperado:**
- ✅ Mensagem: "Beneficiário atualizado com sucesso!"
- ✅ Redireciona para lista
- ✅ Dados atualizados aparecem na lista

---

### 14. Teste de Edição - CPF Bloqueado

**Objetivo:** Verificar que CPF não pode ser editado

**Passos:**
1. Acesse a edição de um beneficiário
2. Tente alterar o campo CPF

**Resultado Esperado:**
- ✅ Campo CPF está desabilitado (cinza)
- ✅ Mensagem: "CPF não pode ser alterado"
- ✅ Não é possível editar o CPF

---

### 15. Teste de Edição - Cancelar

**Objetivo:** Cancelar edição sem salvar

**Passos:**
1. Acesse a edição de um beneficiário
2. Altere alguns campos
3. Clique em "Cancelar"

**Resultado Esperado:**
- ✅ Redireciona para `/beneficiarios`
- ✅ Alterações não são salvas
- ✅ Dados originais permanecem

---

### 16. Teste de Deleção - Sucesso

**Objetivo:** Deletar um beneficiário

**Passos:**
1. Na lista, clique no ícone 🗑️
2. Confirme na janela de confirmação

**Resultado Esperado:**
- ✅ Mensagem: "Beneficiário deletado com sucesso!"
- ✅ Beneficiário desaparece da lista
- ✅ Contador atualiza

---

### 17. Teste de Deleção - Cancelar

**Objetivo:** Cancelar deleção

**Passos:**
1. Na lista, clique no ícone 🗑️
2. Clique em "Cancelar" na confirmação

**Resultado Esperado:**
- ✅ Beneficiário permanece na lista
- ✅ Nenhuma alteração é feita

---

### 18. Teste de Responsividade - Mobile

**Objetivo:** Verificar funcionamento em telas pequenas

**Passos:**
1. Abra o DevTools (F12)
2. Ative o modo de dispositivo móvel
3. Teste todas as páginas

**Resultado Esperado:**
- ✅ Layout se adapta à tela pequena
- ✅ Menu vira vertical
- ✅ Tabela tem scroll horizontal
- ✅ Botões ficam em coluna
- ✅ Formulários ficam legíveis

---

### 19. Teste de Navegação - Menu

**Objetivo:** Verificar navegação pelo menu

**Passos:**
1. No header, clique em "Início"
2. Clique em "Beneficiários"
3. Clique em "Novo Cadastro"

**Resultado Esperado:**
- ✅ Cada clique navega para a página correta
- ✅ URL muda corretamente
- ✅ Página carrega sem erros

---

### 20. Teste de Erro - API Offline

**Objetivo:** Verificar comportamento quando backend está offline

**Passos:**
1. Pare o backend
2. Acesse `http://localhost:3000/beneficiarios`

**Resultado Esperado:**
- ❌ Mensagem de erro: "Erro ao carregar beneficiários. Verifique se a API está rodando."
- ✅ Página não quebra
- ✅ UI permanece funcional

---

## 📊 Checklist de Testes

Use este checklist para validar todas as funcionalidades:

### Página Inicial
- [ ] Página carrega corretamente
- [ ] Header e Footer aparecem
- [ ] Cards são clicáveis
- [ ] Links funcionam

### Listagem
- [ ] Lista carrega com dados
- [ ] Lista vazia mostra mensagem
- [ ] Filtro por nome funciona
- [ ] Filtro por CPF funciona
- [ ] Filtro por situação funciona
- [ ] Contador de resultados está correto
- [ ] Ações (visualizar, editar, deletar) funcionam

### Cadastro
- [ ] Formulário carrega
- [ ] Validações funcionam
- [ ] CPF é validado
- [ ] Data futura é rejeitada
- [ ] Campos vazios são rejeitados
- [ ] CPF duplicado é rejeitado
- [ ] Cadastro com sucesso redireciona
- [ ] Mensagens de erro aparecem

### Edição
- [ ] Formulário carrega com dados
- [ ] CPF está bloqueado
- [ ] Edição salva corretamente
- [ ] Cancelar volta sem salvar
- [ ] Validações funcionam

### Visualização
- [ ] Detalhes carregam corretamente
- [ ] Formatação está correta
- [ ] Badge de situação aparece
- [ ] Botões funcionam

### Deleção
- [ ] Confirmação aparece
- [ ] Deleção remove o registro
- [ ] Cancelar mantém o registro

### Responsividade
- [ ] Mobile (< 768px)
- [ ] Tablet (768px - 1199px)
- [ ] Desktop (1200px+)

### Erros
- [ ] API offline é tratada
- [ ] Erros do backend são exibidos
- [ ] Validações são claras

---

## 🐛 Relatório de Bugs

Se encontrar problemas, documente:

1. **O que deveria acontecer:**
2. **O que aconteceu:**
3. **Passos para reproduzir:**
4. **Screenshot (se aplicável):**
5. **Console do navegador (F12):**

---

## ✅ Testes Automatizados (Futuros)

Para implementar no futuro:

```bash
# Testes unitários com Jest
npm test

# Testes E2E com Cypress
npm run cypress:open
```

---

**Documentação de Testes - Dataprev © 2026**

