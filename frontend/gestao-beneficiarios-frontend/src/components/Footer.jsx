import React from 'react';
import './Footer.css';

const Footer = () => {
  return (
    <footer className="br-footer">
      <div className="container-lg">
        <div className="footer-content">
          <div className="footer-info">
            <div className="footer-logo">
              <img
                src="https://www.gov.br/++theme++padrao_govbr/img/govbr-logo-large.png"
                alt="Governo Federal"
                className="footer-logo-img"
              />
            </div>
            <div className="footer-text">
              <p>Sistema de Gestão de Beneficiários</p>
              <p className="footer-description">
                Plataforma de gerenciamento de beneficiários da Dataprev
              </p>
            </div>
          </div>
          <div className="footer-copyright">
            <p>© 2026 Dataprev - Todos os direitos reservados</p>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;

