package com.example.consulta.dto;

import java.time.LocalDate;

public record BeneficiarioView(
        Long id,
        String nome,
        String cpf,
        LocalDate dataNascimento,
        String situacao,
        LocalDate dataCriacao,
        LocalDate dataAtualizacao
) {
}

