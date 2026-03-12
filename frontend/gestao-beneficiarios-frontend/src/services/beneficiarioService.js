import api from './api';

const beneficiarioService = {
  // Listar todos os beneficiários
  listarTodos: async () => {
    try {
      const response = await api.get('/beneficiarios');
      return response.data;
    } catch (error) {
      throw error;
    }
  },

  // Buscar beneficiário por ID
  buscarPorId: async (id) => {
    try {
      const response = await api.get(`/beneficiarios/${id}`);
      return response.data;
    } catch (error) {
      throw error;
    }
  },

  // Buscar beneficiário por CPF
  buscarPorCpf: async (cpf) => {
    try {
      const response = await api.get(`/beneficiarios/cpf/${cpf}`);
      return response.data;
    } catch (error) {
      throw error;
    }
  },

  // Criar novo beneficiário
  criar: async (beneficiario) => {
    try {
      const response = await api.post('/beneficiarios', beneficiario);
      return response.data;
    } catch (error) {
      throw error;
    }
  },

  // Atualizar beneficiário
  atualizar: async (id, beneficiario) => {
    try {
      const response = await api.put(`/beneficiarios/${id}`, beneficiario);
      return response.data;
    } catch (error) {
      throw error;
    }
  },

  // Deletar beneficiário
  deletar: async (id) => {
    try {
      await api.delete(`/beneficiarios/${id}`);
    } catch (error) {
      throw error;
    }
  },
};

export default beneficiarioService;

