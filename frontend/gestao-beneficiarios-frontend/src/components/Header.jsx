import React from 'react';
import { Link } from 'react-router-dom';
import './Header.css';

const Header = () => {
  return (
    <header className="br-header">
      <div className="container-lg">
        <div className="header-top">
          <div className="header-logo">
            <img
              src="https://www.gov.br/++theme++padrao_govbr/img/govbr-logo-large.png"
              alt="Governo Federal"
              className="header-logo-img"
            />
            <div className="header-sign">
              Sistema de Gestão de Beneficiários
            </div>
          </div>
        </div>
        <div className="header-bottom">
          <div className="header-menu">
            <nav className="menu">
              <ul className="menu-list">
                <li className="menu-item">
                  <Link to="/" className="menu-link">
                    Início
                  </Link>
                </li>
                <li className="menu-item">
                  <Link to="/beneficiarios" className="menu-link">
                    Beneficiários
                  </Link>
                </li>
                <li className="menu-item">
                  <Link to="/novo" className="menu-link">
                    Novo Cadastro
                  </Link>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;

