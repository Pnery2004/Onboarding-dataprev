import React from 'react';
import { Link } from 'react-router-dom';
import './Home.css';

const Home = () => {
  return (
    <div className="home-container">
      <div className="container-lg">
        <div className="home-hero">
          <h1 className="home-title">Sistema de Gestão de Beneficiários</h1>
          <p className="home-subtitle">
            Plataforma completa para gerenciamento de beneficiários da Dataprev
          </p>
        </div>

        <div className="home-cards">
          <div className="card">
            <div className="card-icon">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
              </svg>
            </div>
            <h2 className="card-title">Listar Beneficiários</h2>
            <p className="card-description">
              Visualize todos os beneficiários cadastrados no sistema com filtros e busca avançada
            </p>
            <Link to="/beneficiarios" className="br-button primary">
              Acessar Lista
            </Link>
          </div>

          <div className="card">
            <div className="card-icon">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="16"></line>
                <line x1="8" y1="12" x2="16" y2="12"></line>
              </svg>
            </div>
            <h2 className="card-title">Novo Cadastro</h2>
            <p className="card-description">
              Cadastre um novo beneficiário no sistema com todas as informações necessárias
            </p>
            <Link to="/novo" className="br-button primary">
              Novo Cadastro
            </Link>
          </div>

          <div className="card">
            <div className="card-icon">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
                <line x1="16" y1="13" x2="8" y2="13"></line>
                <line x1="16" y1="17" x2="8" y2="17"></line>
                <polyline points="10 9 9 9 8 9"></polyline>
              </svg>
            </div>
            <h2 className="card-title">Documentação API</h2>
            <p className="card-description">
              Acesse a documentação completa da API REST com Swagger/OpenAPI
            </p>
            <a
              href="http://localhost:8080/swagger-ui.html"
              target="_blank"
              rel="noopener noreferrer"
              className="br-button primary"
            >
              Ver Documentação
            </a>
          </div>
        </div>

        <div className="home-info">
          <h2>Sobre o Sistema</h2>
          <div className="info-grid">
            <div className="info-item">
              <h3>✅ API REST Completa</h3>
              <p>Endpoints para todas as operações CRUD (GET, POST, PUT, DELETE)</p>
            </div>
            <div className="info-item">
              <h3>✅ Validações Robustas</h3>
              <p>Validação de CPF, datas e campos obrigatórios</p>
            </div>
            <div className="info-item">
              <h3>✅ Design System GOV.BR</h3>
              <p>Interface moderna seguindo padrões do governo federal</p>
            </div>
            <div className="info-item">
              <h3>✅ Persistência Segura</h3>
              <p>Dados armazenados com segurança em PostgreSQL</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;

