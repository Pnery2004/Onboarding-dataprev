package com.example.Gestao_Beneficiarios.repository;

import com.example.Gestao_Beneficiarios.model.Beneficiario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BeneficiarioRepository extends JpaRepository<Beneficiario, Long> {
    Optional<Beneficiario> findByCpf(String cpf);
    boolean existsByCpf(String cpf);
}

