package com.backend.mobile.controllers;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import tools.jackson.databind.JsonNode;

import com.backend.mobile.client.BrapiClient;
import com.backend.mobile.DTOs.StockResponseDTO;

import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api-externa")
public class TestApiExterna {
    
    private BrapiClient api;

    public TestApiExterna(BrapiClient api){
        this.api = api;
    }

    @GetMapping("/dados")
    public ResponseEntity<List<StockResponseDTO>> getAllStocks(){
        return ResponseEntity.ok(this.api.getAllInfo());
    }

    @GetMapping("/dados/{codigo}")
    public ResponseEntity<?> getStockes(
        @PathVariable("codigo") int codigo
    ){
        return ResponseEntity.ok(this.api.getInfo(codigo));
    }

    @GetMapping("/tickers")
    public ResponseEntity<JsonNode> searchTickers(
        @RequestParam("search") String search
    ) {
        if (search.isBlank()) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(this.api.getTickers(search));
    }

}
