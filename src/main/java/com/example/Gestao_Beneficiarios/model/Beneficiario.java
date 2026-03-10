package com.example.Gestao_Beneficiarios.model;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Entity
@Table(name = "beneficiarios")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "Entidade que representa um beneficiário")
public class Beneficiario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Schema(description = "ID único do beneficiário", example = "1")
    private Long id;

    @NotBlank(message = "Nome é obrigatório")
    @Column(nullable = false, length = 100)
    @Schema(description = "Nome completo do beneficiário", example = "João Silva")
    private String nome;

    @NotBlank(message = "CPF é obrigatório")
    @Pattern(regexp = "\\d{11}", message = "CPF deve conter 11 dígitos")
    @Column(nullable = false, unique = true, length = 11)
    @Schema(description = "CPF do beneficiário (11 dígitos)", example = "12345678901")
    private String cpf;

    @NotNull(message = "Data de nascimento é obrigatória")
    @Column(nullable = false)
    @Schema(description = "Data de nascimento do beneficiário", example = "1990-05-15")
    private LocalDate dataNascimento;

    @NotBlank(message = "Situação é obrigatória")
    @Column(nullable = false, length = 50)
    @Schema(description = "Situação do beneficiário", example = "ATIVO", allowableValues = {"ATIVO", "INATIVO", "SUSPENSO"})
    private String situacao;

    @Column(name = "data_criacao", nullable = false, updatable = false)
    @Schema(description = "Data de criação do registro")
    private LocalDate dataCriacao;

    @Column(name = "data_atualizacao")
    @Schema(description = "Data da última atualização")
    private LocalDate dataAtualizacao;

    @PrePersist
    protected void onCreate() {
        dataCriacao = LocalDate.now();
        dataAtualizacao = LocalDate.now();
    }

    @PreUpdate
    protected void onUpdate() {
        dataAtualizacao = LocalDate.now();
    }
}

