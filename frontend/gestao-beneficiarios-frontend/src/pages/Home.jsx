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

        </div>
      </div>
    </div>
  );
};

export default Home;

