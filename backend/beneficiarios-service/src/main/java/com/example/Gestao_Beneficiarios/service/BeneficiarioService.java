package com.example.Gestao_Beneficiarios.service;

import com.example.Gestao_Beneficiarios.model.Beneficiario;
import com.example.Gestao_Beneficiarios.repository.BeneficiarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class BeneficiarioService {

    private final BeneficiarioRepository beneficiarioRepository;

    /**
     * Obtém todos os beneficiários
     */
    @Transactional(readOnly = true)
    public List<Beneficiario> obterTodos() {
        return beneficiarioRepository.findAll();
    }

    /**
     * Obtém um beneficiário pelo ID
     */
    @Transactional(readOnly = true)
    public Optional<Beneficiario> obterPorId(Long id) {
        return beneficiarioRepository.findById(id);
    }

    /**
     * Obtém um beneficiário pelo CPF
     */
    @Transactional(readOnly = true)
    public Optional<Beneficiario> obterPorCpf(String cpf) {
        return beneficiarioRepository.findByCpf(cpf);
    }

    /**
     * Cria um novo beneficiário
     */
    public Beneficiario criar(Beneficiario beneficiario) {
        if (beneficiarioRepository.existsByCpf(beneficiario.getCpf())) {
            throw new IllegalArgumentException("CPF já existe no sistema");
        }
        return beneficiarioRepository.save(beneficiario);
    }

    /**
     * Atualiza um beneficiário existente
     */
    public Beneficiario atualizar(Long id, Beneficiario beneficiarioAtualizado) {
        return beneficiarioRepository.findById(id)
                .map(beneficiario -> {
                    // Verifica se o CPF é diferente e já existe
                    if (!beneficiario.getCpf().equals(beneficiarioAtualizado.getCpf()) &&
                            beneficiarioRepository.existsByCpf(beneficiarioAtualizado.getCpf())) {
                        throw new IllegalArgumentException("CPF já existe no sistema");
                    }

                    beneficiario.setNome(beneficiarioAtualizado.getNome());
                    beneficiario.setCpf(beneficiarioAtualizado.getCpf());
                    beneficiario.setDataNascimento(beneficiarioAtualizado.getDataNascimento());
                    beneficiario.setSituacao(beneficiarioAtualizado.getSituacao());

                    return beneficiarioRepository.save(beneficiario);
                })
                .orElseThrow(() -> new IllegalArgumentException("Beneficiário não encontrado com ID: " + id));
    }

    /**
     * Deleta um beneficiário
     */
    public void deletar(Long id) {
        if (!beneficiarioRepository.existsById(id)) {
            throw new IllegalArgumentException("Beneficiário não encontrado com ID: " + id);
        }
        beneficiarioRepository.deleteById(id);
    }
}

