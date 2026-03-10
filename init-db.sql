-- Script SQL para criar a estrutura do banco de dados
-- Este script cria a tabela de beneficiários

-- Tabela de Beneficiários
CREATE TABLE IF NOT EXISTS beneficiarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    situacao VARCHAR(50) NOT NULL,
    data_criacao DATE NOT NULL DEFAULT CURRENT_DATE,
    data_atualizacao DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criando índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_beneficiarios_cpf ON beneficiarios(cpf);
CREATE INDEX IF NOT EXISTS idx_beneficiarios_situacao ON beneficiarios(situacao);

-- Inserindo dados de exemplo
INSERT INTO beneficiarios (nome, cpf, data_nascimento, situacao, data_criacao, data_atualizacao)
VALUES
    ('João Silva Santos', '12345678901', '1990-05-15', 'ATIVO', CURRENT_DATE, CURRENT_DATE),
    ('Maria Oliveira Costa', '98765432101', '1985-08-22', 'ATIVO', CURRENT_DATE, CURRENT_DATE),
    ('Carlos Eduardo Souza', '55555555555', '1992-03-10', 'INATIVO', CURRENT_DATE, CURRENT_DATE)
ON CONFLICT (cpf) DO NOTHING;

-- Verificando os dados inseridos
SELECT * FROM beneficiarios;

