package com.backend.mobile.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.backend.mobile.models.CarteiraAtivo;

public interface CarteiraAtivoRepository extends JpaRepository<CarteiraAtivo, Long> {
    List<CarteiraAtivo> findAllByUsuario_IdOrderBySymbolAsc(Long usuarioId);

    boolean existsByUsuario_IdAndSymbol(Long usuarioId, String symbol);

    Optional<CarteiraAtivo> findByIdAndUsuario_Id(Long id, Long usuarioId);
}
