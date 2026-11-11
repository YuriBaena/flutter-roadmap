package com.backend.mobile.enums;

public enum Tickers {
    PETR4(1,"PETR4"),
    VALE3(2,"VALE3"),
    MGLU3(3,"MGLU3"),
    ITUB4(4,"ITUB4"),
    MXRF11(5,"MXRF11"),
    HGLG11(6,"HGLG11");

    private final int codigo;
    private final String ticker;

    Tickers(int codigo, String ticker){
        this.codigo=codigo;
        this.ticker=ticker;
    }

    public int getCodigo(){
        return this.codigo;
    }

    public String getTicker(){
        return this.ticker;
    }

    public static String porCodigo(int codigo){
        for(Tickers t: Tickers.values()){
            if(t.getCodigo() == codigo){
                return t.getTicker();
            }
        }
        return "Codigo Inválido";
    }
}
