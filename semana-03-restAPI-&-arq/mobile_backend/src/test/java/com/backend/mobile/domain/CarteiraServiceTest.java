package com.backend.mobile.domain;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.util.Optional;

import org.mockito.ArgumentCaptor;
import org.junit.jupiter.api.Test;

import com.backend.mobile.DTOs.PortfolioTickerRequestDTO;
import com.backend.mobile.models.CarteiraAtivo;
import com.backend.mobile.models.Usuario;
import com.backend.mobile.repositories.AuthRepository;
import com.backend.mobile.repositories.CarteiraAtivoRepository;

class CarteiraServiceTest {

    @Test
    void savesThePositionForTheAuthenticatedUser() {
        AuthRepository authRepository = mock(AuthRepository.class);
        CarteiraAtivoRepository carteiraRepository =
            mock(CarteiraAtivoRepository.class);
        Usuario usuario = new Usuario("user@example.com", "hashed-password");
        when(authRepository.findById(42L)).thenReturn(Optional.of(usuario));
        when(carteiraRepository.existsByUsuario_IdAndSymbol(42L, "PETR4"))
            .thenReturn(false);
        when(carteiraRepository.save(any(CarteiraAtivo.class)))
            .thenAnswer(invocation -> invocation.getArgument(0));
        CarteiraService service = new CarteiraService(
            authRepository,
            carteiraRepository
        );

        service.adicionar(
            42L,
            new PortfolioTickerRequestDTO("PETR4", new BigDecimal("32.50"))
        );

        ArgumentCaptor<CarteiraAtivo> ativoCaptor =
            ArgumentCaptor.forClass(CarteiraAtivo.class);
        verify(carteiraRepository).save(ativoCaptor.capture());
        assertEquals(usuario, ativoCaptor.getValue().getUsuario());
        assertEquals("PETR4", ativoCaptor.getValue().getSymbol());
        assertEquals(
            new BigDecimal("32.50"),
            ativoCaptor.getValue().getAveragePrice()
        );
    }

    @Test
    void listsOnlyTheAuthenticatedUsersPositions() {
        AuthRepository authRepository = mock(AuthRepository.class);
        CarteiraAtivoRepository carteiraRepository =
            mock(CarteiraAtivoRepository.class);
        CarteiraService service = new CarteiraService(
            authRepository,
            carteiraRepository
        );

        service.listar(42L);

        verify(carteiraRepository).findAllByUsuario_IdOrderBySymbolAsc(42L);
    }

    @Test
    void removesAPositionOnlyWhenItBelongsToTheAuthenticatedUser() {
        AuthRepository authRepository = mock(AuthRepository.class);
        CarteiraAtivoRepository carteiraRepository =
            mock(CarteiraAtivoRepository.class);
        CarteiraAtivo ativo = mock(CarteiraAtivo.class);
        when(carteiraRepository.findByIdAndUsuario_Id(7L, 42L))
            .thenReturn(Optional.of(ativo));
        CarteiraService service = new CarteiraService(
            authRepository,
            carteiraRepository
        );

        service.remover(42L, 7L);

        verify(carteiraRepository).findByIdAndUsuario_Id(7L, 42L);
        verify(carteiraRepository).delete(ativo);
    }
}
