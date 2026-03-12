// Formatar CPF: 12345678901 -> 123.456.789-01
export const formatarCpf = (cpf) => {
  if (!cpf) return '';
  const cpfLimpo = cpf.replace(/\D/g, '');
  return cpfLimpo.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
};

// Remover formatação do CPF
export const limparCpf = (cpf) => {
  if (!cpf) return '';
  return cpf.replace(/\D/g, '');
};

// Formatar data: yyyy-mm-dd -> dd/mm/yyyy
export const formatarData = (data) => {
  if (!data) return '';
  const partes = data.split('-');
  if (partes.length === 3) {
    return `${partes[2]}/${partes[1]}/${partes[0]}`;
  }
  return data;
};

// Converter data: dd/mm/yyyy -> yyyy-mm-dd
export const converterDataParaISO = (data) => {
  if (!data) return '';
  const partes = data.split('/');
  if (partes.length === 3) {
    return `${partes[2]}-${partes[1]}-${partes[0]}`;
  }
  return data;
};

// Validar CPF
export const validarCpf = (cpf) => {
  const cpfLimpo = limparCpf(cpf);

  if (cpfLimpo.length !== 11) return false;

  // Verifica se todos os dígitos são iguais
  if (/^(\d)\1{10}$/.test(cpfLimpo)) return false;

  // Validação dos dígitos verificadores
  let soma = 0;
  let resto;

  for (let i = 1; i <= 9; i++) {
    soma += parseInt(cpfLimpo.substring(i - 1, i)) * (11 - i);
  }

  resto = (soma * 10) % 11;
  if (resto === 10 || resto === 11) resto = 0;
  if (resto !== parseInt(cpfLimpo.substring(9, 10))) return false;

  soma = 0;
  for (let i = 1; i <= 10; i++) {
    soma += parseInt(cpfLimpo.substring(i - 1, i)) * (12 - i);
  }

  resto = (soma * 10) % 11;
  if (resto === 10 || resto === 11) resto = 0;
  if (resto !== parseInt(cpfLimpo.substring(10, 11))) return false;

  return true;
};

// Formatar situação
export const formatarSituacao = (situacao) => {
  const situacoes = {
    ATIVO: 'Ativo',
    INATIVO: 'Inativo',
    SUSPENSO: 'Suspenso',
  };
  return situacoes[situacao] || situacao;
};

// Cor do badge de situação
export const corSituacao = (situacao) => {
  const cores = {
    ATIVO: 'success',
    INATIVO: 'secondary',
    SUSPENSO: 'warning',
  };
  return cores[situacao] || 'secondary';
};

