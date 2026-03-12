import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import beneficiarioService from '../services/beneficiarioService';
import Loading from '../components/Loading';
import { limparCpf, validarCpf, formatarCpf } from '../utils/formatters';
import './FormBeneficiario.css';

const FormBeneficiario = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdicao = !!id;

  const [loading, setLoading] = useState(false);
  const [salvando, setSalvando] = useState(false);
  const [errors, setErrors] = useState({});

  const [formData, setFormData] = useState({
    nome: '',
    cpf: '',
    dataNascimento: '',
    situacao: 'ATIVO',
  });

  useEffect(() => {
    if (isEdicao) {
      carregarBeneficiario();
    }
  }, [id]);

  const carregarBeneficiario = async () => {
    try {
      setLoading(true);
      const dados = await beneficiarioService.buscarPorId(id);
      setFormData({
        nome: dados.nome,
        cpf: dados.cpf,
        dataNascimento: dados.dataNascimento,
        situacao: dados.situacao,
      });
    } catch (err) {
      alert('Erro ao carregar beneficiário.');
      console.error(err);
      navigate('/beneficiarios');
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;

    // Formatação especial para CPF
    if (name === 'cpf') {
      const cpfLimpo = limparCpf(value);
      if (cpfLimpo.length <= 11) {
        setFormData({ ...formData, [name]: cpfLimpo });
      }
    } else {
      setFormData({ ...formData, [name]: value });
    }

    // Limpar erro do campo ao digitar
    if (errors[name]) {
      setErrors({ ...errors, [name]: '' });
    }
  };

  const validarFormulario = () => {
    const novosErros = {};

    // Validar nome
    if (!formData.nome.trim()) {
      novosErros.nome = 'Nome é obrigatório';
    } else if (formData.nome.trim().length < 3) {
      novosErros.nome = 'Nome deve ter no mínimo 3 caracteres';
    }

    // Validar CPF
    if (!formData.cpf) {
      novosErros.cpf = 'CPF é obrigatório';
    } else if (!validarCpf(formData.cpf)) {
      novosErros.cpf = 'CPF inválido';
    }

    // Validar data de nascimento
    if (!formData.dataNascimento) {
      novosErros.dataNascimento = 'Data de nascimento é obrigatória';
    } else {
      const dataNasc = new Date(formData.dataNascimento);
      const hoje = new Date();
      if (dataNasc > hoje) {
        novosErros.dataNascimento = 'Data de nascimento não pode ser futura';
      }
    }

    // Validar situação
    if (!formData.situacao) {
      novosErros.situacao = 'Situação é obrigatória';
    }

    setErrors(novosErros);
    return Object.keys(novosErros).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!validarFormulario()) {
      return;
    }

    try {
      setSalvando(true);

      if (isEdicao) {
        await beneficiarioService.atualizar(id, formData);
        alert('Beneficiário atualizado com sucesso!');
      } else {
        await beneficiarioService.criar(formData);
        alert('Beneficiário cadastrado com sucesso!');
      }

      navigate('/beneficiarios');
    } catch (err) {
      if (err.response?.data?.message) {
        alert(`Erro: ${err.response.data.message}`);
      } else {
        alert('Erro ao salvar beneficiário. Verifique se a API está rodando.');
      }
      console.error(err);
    } finally {
      setSalvando(false);
    }
  };

  if (loading) {
    return <Loading message="Carregando dados..." />;
  }

  return (
    <div className="form-container">
      <div className="container-lg">
        <div className="form-card">
          <h1 className="form-title">
            {isEdicao ? 'Editar Beneficiário' : 'Novo Beneficiário'}
          </h1>

          <form onSubmit={handleSubmit} className="beneficiario-form">
            <div className="form-group">
              <label htmlFor="nome" className="form-label required">
                Nome Completo
              </label>
              <input
                type="text"
                id="nome"
                name="nome"
                className={`br-input ${errors.nome ? 'is-invalid' : ''}`}
                value={formData.nome}
                onChange={handleChange}
                placeholder="Digite o nome completo"
                maxLength={100}
              />
              {errors.nome && <div className="error-message">{errors.nome}</div>}
            </div>

            <div className="form-group">
              <label htmlFor="cpf" className="form-label required">
                CPF
              </label>
              <input
                type="text"
                id="cpf"
                name="cpf"
                className={`br-input ${errors.cpf ? 'is-invalid' : ''}`}
                value={formatarCpf(formData.cpf)}
                onChange={handleChange}
                placeholder="000.000.000-00"
                disabled={isEdicao}
              />
              {errors.cpf && <div className="error-message">{errors.cpf}</div>}
              {isEdicao && (
                <small className="form-text">CPF não pode ser alterado</small>
              )}
            </div>

            <div className="form-group">
              <label htmlFor="dataNascimento" className="form-label required">
                Data de Nascimento
              </label>
              <input
                type="date"
                id="dataNascimento"
                name="dataNascimento"
                className={`br-input ${errors.dataNascimento ? 'is-invalid' : ''}`}
                value={formData.dataNascimento}
                onChange={handleChange}
              />
              {errors.dataNascimento && (
                <div className="error-message">{errors.dataNascimento}</div>
              )}
            </div>

            <div className="form-group">
              <label htmlFor="situacao" className="form-label required">
                Situação
              </label>
              <select
                id="situacao"
                name="situacao"
                className={`br-select ${errors.situacao ? 'is-invalid' : ''}`}
                value={formData.situacao}
                onChange={handleChange}
              >
                <option value="ATIVO">Ativo</option>
                <option value="INATIVO">Inativo</option>
                <option value="SUSPENSO">Suspenso</option>
              </select>
              {errors.situacao && <div className="error-message">{errors.situacao}</div>}
            </div>

            <div className="form-actions">
              <button
                type="button"
                className="br-button secondary"
                onClick={() => navigate('/beneficiarios')}
                disabled={salvando}
              >
                Cancelar
              </button>
              <button
                type="submit"
                className="br-button primary"
                disabled={salvando}
              >
                {salvando ? 'Salvando...' : isEdicao ? 'Atualizar' : 'Cadastrar'}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default FormBeneficiario;

