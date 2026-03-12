import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/Header';
import Footer from './components/Footer';
import Home from './pages/Home';
import ListaBeneficiarios from './pages/ListaBeneficiarios';
import FormBeneficiario from './pages/FormBeneficiario';
import DetalhesBeneficiario from './pages/DetalhesBeneficiario';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Header />
        <main className="main-content">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/beneficiarios" element={<ListaBeneficiarios />} />
            <Route path="/beneficiarios/:id" element={<DetalhesBeneficiario />} />
            <Route path="/novo" element={<FormBeneficiario />} />
            <Route path="/editar/:id" element={<FormBeneficiario />} />
          </Routes>
        </main>
        <Footer />
      </div>
    </Router>
  );
}

export default App;
