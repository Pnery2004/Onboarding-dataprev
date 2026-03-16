package com.example.consulta.service;

import com.example.consulta.client.BeneficiariosClient;
import com.example.consulta.dto.BeneficiarioView;
import feign.FeignException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BeneficiarioConsultaService {

    private final BeneficiariosClient beneficiariosClient;

    public List<BeneficiarioView> listarTodos() {
        return beneficiariosClient.listarTodos();
    }

    public Optional<BeneficiarioView> buscarPorId(Long id) {
        try {
            return Optional.ofNullable(beneficiariosClient.buscarPorId(id));
        } catch (FeignException.NotFound ex) {
            return Optional.empty();
        }
    }

    public Optional<BeneficiarioView> buscarPorCpf(String cpf) {
        try {
            return Optional.ofNullable(beneficiariosClient.buscarPorCpf(cpf));
        } catch (FeignException.NotFound ex) {
            return Optional.empty();
        }
    }
}
