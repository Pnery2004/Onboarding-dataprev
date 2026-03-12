import React, { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import beneficiarioService from '../services/beneficiarioService';
import Loading from '../components/Loading';
import { formatarCpf, formatarData, formatarSituacao, corSituacao } from '../utils/formatters';
import './DetalhesBeneficiario.css';

const DetalhesBeneficiario = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [beneficiario, setBeneficiario] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    carregarBeneficiario();
  }, [id]);

  const carregarBeneficiario = async () => {
    try {
      setLoading(true);
      setError(null);
      const dados = await beneficiarioService.buscarPorId(id);
      setBeneficiario(dados);
    } catch (err) {
      setError('Erro ao carregar beneficiário.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleDeletar = async () => {
    if (window.confirm(`Deseja realmente deletar o beneficiário ${beneficiario.nome}?`)) {
      try {
        await beneficiarioService.deletar(id);
        alert('Beneficiário deletado com sucesso!');
        navigate('/beneficiarios');
      } catch (err) {
        alert('Erro ao deletar beneficiário.');
        console.error(err);
      }
    }
  };

  if (loading) {
    return <Loading message="Carregando dados..." />;
  }

  if (error || !beneficiario) {
    return (
      <div className="detalhes-container">
        <div className="container-lg">
          <div className="alert alert-danger">{error || 'Beneficiário não encontrado'}</div>
          <Link to="/beneficiarios" className="br-button secondary">
            Voltar para lista
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="detalhes-container">
      <div className="container-lg">
        <div className="detalhes-card">
          <div className="card-header">
            <h1 className="card-title">Detalhes do Beneficiário</h1>
            <span className={`badge badge-${corSituacao(beneficiario.situacao)}`}>
              {formatarSituacao(beneficiario.situacao)}
            </span>
          </div>

          <div className="card-body">
            <div className="info-grid">
              <div className="info-item">
                <label className="info-label">ID</label>
                <div className="info-value">{beneficiario.id}</div>
              </div>

              <div className="info-item">
                <label className="info-label">Nome Completo</label>
                <div className="info-value">{beneficiario.nome}</div>
              </div>

              <div className="info-item">
                <label className="info-label">CPF</label>
                <div className="info-value">{formatarCpf(beneficiario.cpf)}</div>
              </div>

              <div className="info-item">
                <label className="info-label">Data de Nascimento</label>
                <div className="info-value">{formatarData(beneficiario.dataNascimento)}</div>
              </div>

              <div className="info-item">
                <label className="info-label">Situação</label>
                <div className="info-value">
                  <span className={`badge badge-${corSituacao(beneficiario.situacao)}`}>
                    {formatarSituacao(beneficiario.situacao)}
                  </span>
                </div>
              </div>

              {beneficiario.dataCriacao && (
                <div className="info-item">
                  <label className="info-label">Data de Criação</label>
                  <div className="info-value">{formatarData(beneficiario.dataCriacao)}</div>
                </div>
              )}

              {beneficiario.dataAtualizacao && (
                <div className="info-item">
                  <label className="info-label">Última Atualização</label>
                  <div className="info-value">{formatarData(beneficiario.dataAtualizacao)}</div>
                </div>
              )}
            </div>
          </div>

          <div className="card-footer">
            <Link to="/beneficiarios" className="br-button secondary">
              Voltar
            </Link>
            <div className="action-group">
              <Link to={`/editar/${beneficiario.id}`} className="br-button primary">
                Editar
              </Link>
              <button onClick={handleDeletar} className="br-button danger">
                Deletar
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DetalhesBeneficiario;

