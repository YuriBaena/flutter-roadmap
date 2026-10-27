enum Mes{
    janeiro('Janeiro',1),
    fevereiro('Fevereiro',2),
    marco('Março',3),
    abril('Abril',4),
    maio('Maio',5),
    junho('Junho',6),
    julho('Julho',7),
    agosto('Agosto',8),
    setembro('Setembro',9),
    outubro('Outubro',10),
    novembro('Novembro',11),
    dezembro('Dezembro',12);

    final String extenso;
    final int numerico;

    Mes(this.extenso, this.numerico);

    bool temFerias(){
        return (this.numerico >= 6 && this.numerico <= 8) || (this.numerico <= 2 || this.numerico == 12);
    }
}

void main(){
    List<Mes> meses = [
        Mes.janeiro,
        Mes.fevereiro,
        Mes.marco,
        Mes.abril,
        Mes.maio,
        Mes.junho,
        Mes.julho,
        Mes.agosto,
        Mes.setembro,
        Mes.outubro,
        Mes.novembro,
        Mes.dezembro
    ];

    meses.forEach((mes_do_ano) {
        if(mes_do_ano.temFerias()) print(mes_do_ano.extenso);
    });
}