import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import beneficiarioService from '../services/beneficiarioService';
import Loading from '../components/Loading';
import GovDialog from '../components/GovDialog';
import { formatarCpf, formatarData, formatarSituacao, corSituacao } from '../utils/formatters';
import './ListaBeneficiarios.css';

const MAX_RETRIES = 5;
const RETRY_DELAY_MS = 4000;

const ListaBeneficiarios = () => {
  const [beneficiarios, setBeneficiarios] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filtro, setFiltro] = useState('');
  const [filtroSituacao, setFiltroSituacao] = useState('TODOS');
  const [confirmDelete, setConfirmDelete] = useState({ isOpen: false, id: null, nome: '' });
  const [showDeleteSuccess, setShowDeleteSuccess] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    carregarBeneficiarios();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const carregarBeneficiarios = async (tentativa = 0) => {
    try {
      setLoading(true);
      setError(null);
      const dados = await beneficiarioService.listarTodos();
      setBeneficiarios(dados);
      setLoading(false);
    } catch (err) {
      console.error(`Tentativa ${tentativa + 1} falhou:`, err);
      if (tentativa < MAX_RETRIES) {
        const proxima = tentativa + 1;
        setError(`Conectando à API... tentativa ${proxima} de ${MAX_RETRIES}`);
        setTimeout(() => carregarBeneficiarios(proxima), RETRY_DELAY_MS);
      } else {
        setError('Erro ao carregar beneficiários. Verifique se a API está rodando.');
        setLoading(false);
      }
    }
  };

  const handleDeletar = (id, nome) => {
    setConfirmDelete({ isOpen: true, id, nome });
  };

  const confirmarDelecao = async () => {
    try {
      await beneficiarioService.deletar(confirmDelete.id);
      setShowDeleteSuccess(true);
      carregarBeneficiarios();
    } catch (err) {
      setError('Erro ao deletar beneficiário.');
      console.error(err);
    } finally {
      setConfirmDelete({ isOpen: false, id: null, nome: '' });
    }
  };

  const beneficiariosFiltrados = beneficiarios.filter((b) => {
    const matchFiltro =
      b.nome.toLowerCase().includes(filtro.toLowerCase()) ||
      b.cpf.includes(filtro.replace(/\D/g, ''));

    const matchSituacao =
      filtroSituacao === 'TODOS' || b.situacao === filtroSituacao;

    return matchFiltro && matchSituacao;
  });

  if (loading) {
    return <Loading message="Carregando beneficiários..." />;
  }

  return (
    <div className="lista-container">
      <div className="container-lg">
        <div className="page-header">
          <h1 className="page-title">Beneficiários</h1>
          <Link to="/novo" className="br-button primary">
            + Novo Beneficiário
          </Link>
        </div>

        {error && (
          <div className="alert alert-danger">
            <strong>Erro:</strong> {error}
          </div>
        )}

        <div className="filters-container">
          <div className="filter-group">
            <label htmlFor="filtro">Buscar por nome ou CPF:</label>
            <input
              type="text"
              id="filtro"
              className="br-input"
              placeholder="Digite o nome ou CPF..."
              value={filtro}
              onChange={(e) => setFiltro(e.target.value)}
            />
          </div>

          <div className="filter-group">
            <label htmlFor="filtroSituacao">Situação:</label>
            <select
              id="filtroSituacao"
              className="br-select"
              value={filtroSituacao}
              onChange={(e) => setFiltroSituacao(e.target.value)}
            >
              <option value="TODOS">Todos</option>
              <option value="ATIVO">Ativo</option>
              <option value="INATIVO">Inativo</option>
              <option value="SUSPENSO">Suspenso</option>
            </select>
          </div>
        </div>

        <div className="results-info">
          <p>
            Exibindo <strong>{beneficiariosFiltrados.length}</strong> de{' '}
            <strong>{beneficiarios.length}</strong> beneficiários
          </p>
        </div>

        {beneficiariosFiltrados.length === 0 ? (
          <div className="empty-state">
            <p>Nenhum beneficiário encontrado.</p>
            <Link to="/novo" className="br-button primary">
              Cadastrar Primeiro Beneficiário
            </Link>
          </div>
        ) : (
          <div className="table-responsive">
            <table className="br-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Nome</th>
                  <th>CPF</th>
                  <th>Data de Nascimento</th>
                  <th>Situação</th>
                  <th>Ações</th>
                </tr>
              </thead>
              <tbody>
                {beneficiariosFiltrados.map((beneficiario) => (
                  <tr key={beneficiario.id}>
                    <td>{beneficiario.id}</td>
                    <td>{beneficiario.nome}</td>
                    <td>{formatarCpf(beneficiario.cpf)}</td>
                    <td>{formatarData(beneficiario.dataNascimento)}</td>
                    <td>
                      <span className={`badge badge-${corSituacao(beneficiario.situacao)}`}>
                        {formatarSituacao(beneficiario.situacao)}
                      </span>
                    </td>
                    <td>
                      <div className="action-buttons">
                        <button
                          className="br-button secondary small"
                          onClick={() => navigate(`/beneficiarios/${beneficiario.id}`)}
                          title="Visualizar"
                        >
                          Visualizar
                        </button>
                        <button
                          className="br-button secondary small"
                          onClick={() => navigate(`/editar/${beneficiario.id}`)}
                          title="Editar"
                        >
                          Editar
                        </button>
                        <button
                          className="br-button danger small"
                          onClick={() => handleDeletar(beneficiario.id, beneficiario.nome)}
                          title="Deletar"
                        >
                          Excluir
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      <GovDialog
        isOpen={confirmDelete.isOpen}
        title="Confirmação de exclusão"
        message={`Deseja realmente deletar o beneficiário ${confirmDelete.nome}?`}
        confirmLabel="Deletar"
        cancelLabel="Cancelar"
        variant="danger"
        onConfirm={confirmarDelecao}
        onCancel={() => setConfirmDelete({ isOpen: false, id: null, nome: '' })}
      />

      <GovDialog
        isOpen={showDeleteSuccess}
        title="Beneficiário deletado"
        message="Beneficiário deletado com sucesso!"
        confirmLabel="Fechar"
        showCancel={false}
        variant="success"
        onConfirm={() => setShowDeleteSuccess(false)}
      />
    </div>
  );
};

export default ListaBeneficiarios;

