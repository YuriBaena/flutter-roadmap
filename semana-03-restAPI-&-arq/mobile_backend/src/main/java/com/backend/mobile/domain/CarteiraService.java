package com.backend.mobile.domain;

import java.math.BigDecimal;
import java.util.List;
import java.util.Locale;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.backend.mobile.DTOs.PortfolioTickerRequestDTO;
import com.backend.mobile.DTOs.PortfolioTickerResponseDTO;
import com.backend.mobile.models.CarteiraAtivo;
import com.backend.mobile.models.Usuario;
import com.backend.mobile.repositories.AuthRepository;
import com.backend.mobile.repositories.CarteiraAtivoRepository;

@Service
public class CarteiraService {

    private final AuthRepository authRepository;
    private final CarteiraAtivoRepository carteiraRepository;

    public CarteiraService(
        AuthRepository authRepository,
        CarteiraAtivoRepository carteiraRepository
    ) {
        this.authRepository = authRepository;
        this.carteiraRepository = carteiraRepository;
    }

    @Transactional(readOnly = true)
    public List<PortfolioTickerResponseDTO> listar(Long usuarioId) {
        return carteiraRepository.findAllByUsuario_IdOrderBySymbolAsc(usuarioId)
            .stream()
            .map(this::toResponse)
            .toList();
    }

    @Transactional
    public PortfolioTickerResponseDTO adicionar(
        Long usuarioId,
        PortfolioTickerRequestDTO request
    ) {
        if (request == null || request.symbol() == null) {
            throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Informe o ticker e o preço médio."
            );
        }

        String symbol = request.symbol().trim().toUpperCase(Locale.ROOT);
        BigDecimal averagePrice = request.averagePrice();
        if (!symbol.matches("[A-Z0-9]{1,16}")) {
            throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Ticker inválido."
            );
        }
        if (averagePrice == null || averagePrice.signum() <= 0) {
            throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "O preço médio deve ser maior que zero."
            );
        }
        if (carteiraRepository.existsByUsuario_IdAndSymbol(usuarioId, symbol)) {
            throw new ResponseStatusException(
                HttpStatus.CONFLICT,
                "Este ticker já está na carteira."
            );
        }

        Usuario usuario = authRepository.findById(usuarioId)
            .orElseThrow(() -> new ResponseStatusException(
                HttpStatus.NOT_FOUND,
                "Usuário não encontrado."
            ));

        CarteiraAtivo ativo = carteiraRepository.save(
            new CarteiraAtivo(usuario, symbol, averagePrice)
        );
        return toResponse(ativo);
    }

    @Transactional
    public void remover(Long usuarioId, Long ativoId) {
        CarteiraAtivo ativo = carteiraRepository.findByIdAndUsuario_Id(
            ativoId,
            usuarioId
        ).orElseThrow(() -> new ResponseStatusException(
            HttpStatus.NOT_FOUND,
            "Ativo não encontrado na carteira."
        ));
        carteiraRepository.delete(ativo);
    }

    private PortfolioTickerResponseDTO toResponse(CarteiraAtivo ativo) {
        return new PortfolioTickerResponseDTO(
            ativo.getId(),
            ativo.getSymbol(),
            ativo.getAveragePrice()
        );
    }
}
