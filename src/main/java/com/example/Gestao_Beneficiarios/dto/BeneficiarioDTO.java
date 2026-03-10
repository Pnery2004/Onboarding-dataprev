package com.example.Gestao_Beneficiarios.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "DTO para criação e atualização de beneficiários")
public class BeneficiarioDTO {

    @Schema(description = "ID do beneficiário", example = "1")
    private Long id;

    @NotBlank(message = "Nome é obrigatório")
    @Schema(description = "Nome completo do beneficiário", example = "João Silva")
    private String nome;

    @NotBlank(message = "CPF é obrigatório")
    @Pattern(regexp = "\\d{11}", message = "CPF deve conter 11 dígitos")
    @Schema(description = "CPF do beneficiário (11 dígitos)", example = "12345678901")
    private String cpf;

    @NotNull(message = "Data de nascimento é obrigatória")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "Data de nascimento do beneficiário", example = "1990-05-15")
    private LocalDate dataNascimento;

    @NotBlank(message = "Situação é obrigatória")
    @Schema(description = "Situação do beneficiário", example = "ATIVO", allowableValues = {"ATIVO", "INATIVO", "SUSPENSO"})
    private String situacao;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "Data de criação do registro")
    private LocalDate dataCriacao;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "Data da última atualização")
    private LocalDate dataAtualizacao;
}

