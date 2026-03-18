package com.example.consulta.controller;

import com.example.consulta.dto.BeneficiarioView;
import com.example.consulta.service.BeneficiarioConsultaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/consultas/beneficiarios")
@RequiredArgsConstructor
@Tag(name = "Consultas", description = "Consultas consolidadas de beneficiários")
public class ConsultaBeneficiarioController {

    private final BeneficiarioConsultaService consultaService;

    @GetMapping
    @Operation(summary = "Listar beneficiários", description = "Consulta todos os beneficiários via serviço remoto")
    @ApiResponse(responseCode = "200", description = "Lista retornada com sucesso")
    public ResponseEntity<List<BeneficiarioView>> listarTodos() {
        return ResponseEntity.ok(consultaService.listarTodos());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Consultar por ID", description = "Buscar beneficiário específico por ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Beneficiário encontrado"),
            @ApiResponse(responseCode = "404", description = "Beneficiário não encontrado")
    })
    public ResponseEntity<BeneficiarioView> buscarPorId(
            @Parameter(description = "ID do beneficiário", example = "1", required = true)
            @PathVariable Long id) {
        return consultaService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/cpf/{cpf}")
    @Operation(summary = "Consultar por CPF", description = "Buscar beneficiário específico por CPF")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Beneficiário encontrado"),
            @ApiResponse(responseCode = "404", description = "Beneficiário não encontrado")
    })
    public ResponseEntity<BeneficiarioView> buscarPorCpf(
            @Parameter(description = "CPF com 11 dígitos", example = "12345678901", required = true)
            @PathVariable String cpf) {
        return consultaService.buscarPorCpf(cpf)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}

