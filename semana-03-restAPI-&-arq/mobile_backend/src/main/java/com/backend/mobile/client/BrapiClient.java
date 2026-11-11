package com.backend.mobile.client;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import com.backend.mobile.DTOs.StockResponseDTO;
import com.backend.mobile.enums.Tickers;

@Component
public class BrapiClient {

    private final RestClient restClient;
    private final String apiKey;

    public BrapiClient(
            RestClient.Builder restClientBuilder,
            @Value("${brapi.url}") String baseUrl,
            @Value("${brapi.api.key}") String apiKey) {
        
        this.restClient = restClientBuilder.baseUrl(baseUrl).build();
        this.apiKey = apiKey;
    }

    public StockResponseDTO getInfo(int codigo) {
        if (codigo >= 7) {
            return null;
        }

        String tickerName = Tickers.porCodigo(codigo);

        BrapiResponseDto response = this.restClient.get()
                .uri(uriBuilder -> uriBuilder
                    .path("/quote/" + tickerName)
                    .build())
                .header("Authorization", this.apiKey)
                .retrieve()
                .body(BrapiResponseDto.class);

        return response.results().get(0);
    }

    public List<StockResponseDTO> getAllInfo() {
        return Arrays.stream(Tickers.values())
                .map(Tickers::getCodigo)
                .map(this::getInfo)
                .toList();
    }

    public record BrapiResponseDto(
        List<StockResponseDTO> results
    ) {}
}