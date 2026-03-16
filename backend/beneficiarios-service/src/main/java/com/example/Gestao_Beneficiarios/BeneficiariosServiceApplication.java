package com.example.Gestao_Beneficiarios;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class BeneficiariosServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(BeneficiariosServiceApplication.class, args);
    }
}
