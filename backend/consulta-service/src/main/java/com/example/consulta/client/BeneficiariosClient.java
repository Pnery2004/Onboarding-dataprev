package com.example.consulta.client;

import com.example.consulta.dto.BeneficiarioView;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@FeignClient(name = "beneficiarios-service", path = "/api/v1/beneficiarios")
public interface BeneficiariosClient {

    @GetMapping
    List<BeneficiarioView> listarTodos();

    @GetMapping("/{id}")
    BeneficiarioView buscarPorId(@PathVariable("id") Long id);

    @GetMapping("/cpf/{cpf}")
    BeneficiarioView buscarPorCpf(@PathVariable("cpf") String cpf);
}

