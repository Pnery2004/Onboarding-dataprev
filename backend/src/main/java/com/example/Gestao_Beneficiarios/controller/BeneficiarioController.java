package com.example.Gestao_Beneficiarios.controller;

import com.example.Gestao_Beneficiarios.model.Beneficiario;
import com.example.Gestao_Beneficiarios.service.BeneficiarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/beneficiarios")
@RequiredArgsConstructor
@Tag(name = "Beneficiários", description = "Endpoints para gerenciamento de beneficiários")
public class BeneficiarioController {

    private final BeneficiarioService beneficiarioService;

    /**
     * GET - Obtém todos os beneficiários
     */
    @GetMapping
    @Operation(summary = "Listar todos os beneficiários", description = "Retorna uma lista com todos os beneficiários cadastrados")
    @ApiResponse(responseCode = "200", description = "Lista de beneficiários obtida com sucesso")
    public ResponseEntity<List<Beneficiario>> listarTodos() {
        List<Beneficiario> beneficiarios = beneficiarioService.obterTodos();
        return ResponseEntity.ok(beneficiarios);
    }

    /**
     * GET - Obtém um beneficiário pelo ID
     */
    @GetMapping("/{id}")
    @Operation(summary = "Obter beneficiário por ID", description = "Retorna um beneficiário específico pelo seu ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Beneficiário encontrado"),
            @ApiResponse(responseCode = "404", description = "Beneficiário não encontrado")
    })
    public ResponseEntity<?> obterPorId(
            @Parameter(description = "ID do beneficiário", example = "1", required = true)
            @PathVariable Long id) {
        return beneficiarioService.obterPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * GET - Obtém um beneficiário pelo CPF
     */
    @GetMapping("/cpf/{cpf}")
    @Operation(summary = "Obter beneficiário por CPF", description = "Retorna um beneficiário específico pelo seu CPF")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Beneficiário encontrado"),
            @ApiResponse(responseCode = "404", description = "Beneficiário não encontrado")
    })
    public ResponseEntity<?> obterPorCpf(
            @Parameter(description = "CPF do beneficiário (11 dígitos)", example = "12345678901", required = true)
            @PathVariable String cpf) {
        return beneficiarioService.obterPorCpf(cpf)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * POST - Cria um novo beneficiário
     */
    @PostMapping
    @Operation(summary = "Criar novo beneficiário", description = "Cria um novo registro de beneficiário")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Beneficiário criado com sucesso"),
            @ApiResponse(responseCode = "400", description = "Dados inválidos")
    })
    public ResponseEntity<?> criar(
            @Valid @RequestBody Beneficiario beneficiario) {
        try {
            Beneficiario novo = beneficiarioService.criar(beneficiario);
            return ResponseEntity.status(HttpStatus.CREATED).body(novo);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Erro: " + e.getMessage());
        }
    }

    /**
     * PUT - Atualiza um beneficiário existente
     */
    @PutMapping("/{id}")
    @Operation(summary = "Atualizar beneficiário", description = "Atualiza um beneficiário existente pelo ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Beneficiário atualizado com sucesso"),
            @ApiResponse(responseCode = "404", description = "Beneficiário não encontrado"),
            @ApiResponse(responseCode = "400", description = "Dados inválidos")
    })
    public ResponseEntity<?> atualizar(
            @Parameter(description = "ID do beneficiário", example = "1", required = true)
            @PathVariable Long id,
            @Valid @RequestBody Beneficiario beneficiario) {
        try {
            Beneficiario atualizado = beneficiarioService.atualizar(id, beneficiario);
            return ResponseEntity.ok(atualizado);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Erro: " + e.getMessage());
        }
    }

    /**
     * DELETE - Deleta um beneficiário
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "Deletar beneficiário", description = "Remove um beneficiário do sistema")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Beneficiário deletado com sucesso"),
            @ApiResponse(responseCode = "404", description = "Beneficiário não encontrado")
    })
    public ResponseEntity<?> deletar(
            @Parameter(description = "ID do beneficiário", example = "1", required = true)
            @PathVariable Long id) {
        try {
            beneficiarioService.deletar(id);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }
}

