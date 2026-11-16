package com.backend.mobile.models;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(
    name = "carteira_ativos",
    uniqueConstraints = @UniqueConstraint(
        name = "uk_carteira_ativo_usuario_symbol",
        columnNames = {"usuario_id", "symbol"}
    )
)
public class CarteiraAtivo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(nullable = false, length = 16)
    private String symbol;

    @Column(name = "preco_medio", nullable = false, precision = 19, scale = 6)
    private BigDecimal averagePrice;

    protected CarteiraAtivo() {
    }

    public CarteiraAtivo(Usuario usuario, String symbol, BigDecimal averagePrice) {
        this.usuario = usuario;
        this.symbol = symbol;
        this.averagePrice = averagePrice;
    }

    public Long getId() {
        return id;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public String getSymbol() {
        return symbol;
    }

    public BigDecimal getAveragePrice() {
        return averagePrice;
    }
}
