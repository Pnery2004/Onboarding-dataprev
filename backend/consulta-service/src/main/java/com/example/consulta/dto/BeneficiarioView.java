package com.example.consulta.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDate;

public record BeneficiarioView(
        @Schema(description = "Identificador do beneficiario", example = "1")
        Long id,
        @Schema(description = "Nome completo do beneficiario", example = "Maria Silva")
        String nome,
        @Schema(description = "CPF do beneficiario", example = "12345678901")
        String cpf,
        @Schema(description = "Data de nascimento", example = "1990-05-20")
        LocalDate dataNascimento,
        @Schema(description = "Situacao cadastral", example = "ATIVO")
        String situacao,
        @Schema(description = "Data de criacao do registro", example = "2025-01-10")
        LocalDate dataCriacao,
        @Schema(description = "Data da ultima atualizacao", example = "2025-02-15")
        LocalDate dataAtualizacao
) {
}

