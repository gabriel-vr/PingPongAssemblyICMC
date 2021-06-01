jmp main

posxJogador1: var #1
posyJogador1: var #1
posyAntJogador1: var #1

static posxJogador1, #1
static posyJogador1, #20
static posyAntJogador1, #20

posxJogador2: var #1
posyJogador2: var #1
posyAntJogador2: var #1


static posxJogador2, #38
static posyJogador2, #20
static posyAntJogador2, #20

main:

    ;loadn r0, #canto
    ;loadn r1, #0
    ;loadn r2, #0
    ;call printaString
    call PrintaCenario

    call DesenhaJogador1
    call DesenhaJogador2
    ;breakp
    LoopLeituraEntradas:
        call delay
        ;breakp
        call leEntrada
        jmp LoopLeituraEntradas     ;loop de leitura de entradas com delay antes da leitura

    halt

leEntrada:
    push fr
    push r0
    push r1

    inchar r0 ;le entrada e guarda em r0
    ;breakp
    loadn r1, #'w'
    cmp r0, r1
    jne Continua1        
    call SobeJogador1 ;movimenta jogador 1 para cima caso entrada seja w

    Continua1:
        loadn r1, #'s'
        cmp r0, r1
        jne Continua2   
        call DesceJogador1 ;movimenta jogador 1 para baixo caso entrada seja s

    Continua2:
        loadn r1, #'i'
        cmp r0, r1
        jne Continua3    
        call SobeJogador2 ;movimenta jogador 2 para cima caso entrada seja i
    Continua3:
        loadn r1, #'k'
        cmp r0, r1
        jne FimLeEntrada
        call DesceJogador2   ;movimenta jogador 2 para baixo caso entrada seja j

    FimLeEntrada:

        pop r1
        pop r0
        pop fr
        rts


SobeJogador1:
    push fr
    push r0
    push r1

    load r0, posyJogador1   ;posicao atual do jogador 1

    loadn r1, #2    ;limite onde posição central do jogador pode chegar

    cmp r0, r1
    jeq fimSobeJogador1     ;não movimenta jogador 1 para cima pois ele está no limite

    call ApagaJogador1      ;apaga jogador 1 para poder reprintá-lo

    dec r0      ;decrementa posição atual
    ;breakp

    store posyJogador1, r0  ;guarda valor decrementado na variavel de posição

    call DesenhaJogador1    ;redesenha jogador 1
    fimSobeJogador1:
        pop r1
        pop r0
        pop fr
        rts

SobeJogador2:
    push fr
    push r0
    push r1

    load r0, posyJogador2   ;posicao atual do jogador 2

    loadn r1, #2    ;limite onde posição central do jogador pode chegar

    cmp r0, r1
    jeq fimSobeJogador2     ;não movimenta jogador 2 para cima pois ele está no limite

    call ApagaJogador2      ;apaga jogador 2 para poder reprintá-lo

    dec r0      ;decrementa posição atual
    ;breakp

    store posyJogador2, r0  ;guarda valor decrementado na variavel de posição

    call DesenhaJogador2    ;redesenha jogador 2
    fimSobeJogador2:
        pop r1
        pop r0
        pop fr
        rts

DesceJogador1:
    push fr
    push r0
    push r1

    load r0, posyJogador1   ;posicao atual do jogador 1

    loadn r1, #27    ;limite onde posição central do jogador pode chegar

    cmp r0, r1
    jeq fimDesceJogador1     ;não movimenta jogador 1 para baixo pois ele está no limite

    call ApagaJogador1      ;apaga jogador 1 para poder reprintá-lo

    inc r0      ;incrementa posição atual
    ;breakp

    store posyJogador1, r0  ;guarda valor decrementado na variavel de posição

    call DesenhaJogador1    ;redesenha jogador 1
    fimDesceJogador1:
        pop r1
        pop r0
        pop fr
        rts

DesceJogador2:
    push fr
    push r0
    push r1

    load r0, posyJogador2   ;posicao atual do jogador 2

    loadn r1, #27    ;limite onde posição central do jogador pode chegar

    cmp r0, r1
    jeq fimDesceJogador2     ;não movimenta jogador 2 para baixo pois ele está no limite

    call ApagaJogador2      ;apaga jogador 2 para poder reprintá-lo

    inc r0      ;incrementa posição atual
    ;breakp

    store posyJogador2, r0  ;guarda valor decrementado na variavel de posição

    call DesenhaJogador2    ;redesenha jogador 2
    fimDesceJogador2:
        pop r1
        pop r0
        pop fr
        rts


delay:
    push fr
    push r0
    push r1
    push r2
    

    loadn r0, #5
    loadn r2, #0
    Delay_volta:
        loadn r1, #60000
        dec r0
        cmp r0, r2
        jeq fimDelay

        Delay_volta2:
            dec r1
            cmp r1, r2
            jeq Delay_volta
            jmp Delay_volta2

    fimDelay:
        pop r2
        pop r1
        pop r0
        pop fr
        rts





PrintaCenario:
    push fr
    push r0
    push r1

    loadn r3, #40 ;tamanho da linha
    loadn r4, #1160 ;ultima linha a ser printada

    loadn r1, #0 ;posição inicial de print
    printaBordas:
        loadn r0, #canto    ;string a ser printada
        loadn r2, #512    ;cor da string a ser printada
        call printaString
        
        cmp r1, r4 
        jeq fimPrintaCenario    ;caso seja a ultima linha, sai da função


    loadn r0, #meio ;carrega meio do cenário para printar
    loadn r2, #0

    loopPrintaCenario:
        add r1, r1, r3  ;soma posição de print
        
        cmp r1, r4
        jeq printaBordas    ;caso seja posição 1160, printa a borda inferior
        
        call printaString
        jmp loopPrintaCenario
 

    fimPrintaCenario:
        pop r1
        pop r0
        pop fr
        rts

printaString:
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r3, #'\0' ;condição de parada

    loopPrintaLinha:
        loadi r4, r0 ;guarda em r4 o conteudo da posição r0 da string
        cmp r4, r3 ;compara r4 com a condição de parada da string
        jeq fimPrintaLinha

        add r4, r4, r2 ;soma caractere com sua cor

        outchar r4, r1  ;printa conteudo de r4 na posicao r1

        inc r0  ;incrementa ponteiro da string
        inc r1  ;incrementa ponteiro
        
        jmp loopPrintaLinha

    fimPrintaLinha:
        pop r4
        pop r3
        pop r2
        pop r1
        pop r0
        pop fr
        rts 


DesenhaJogador1:
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    load r0, posxJogador1 ;carrega posx jogador 1 em r0
    load r1, posyJogador1 ;carrega posy jogador 2 em r0
    loadn r3, #40   ;tamanho da linha
    ;loadn r7, #30   ;numero de linhas

    loadn r2 , #0   ;posição do centro do jogador será salva em r2

    mul r1, r1, r3 ;descobre valor de y a ser printado o jogador
    add r2, r2, r0
    add r2, r2, r1  ;descobre posição na tela a printar o jogador

    loadn r4, #'$'
    loadn r6, #2304
    add r4, r4, r6 ;caractere do player

    outchar r4, r2  ;printa centro do jogador

    sub r2, r2, r3  ;printa parte superior
    outchar r4, r2

    add r2, r2, r3
    add r2, r2, r3
    outchar r4, r2  ;printa parte inferior

    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts

ApagaJogador1:
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5

    load r0, posxJogador1
    load r1, posyJogador1
    loadn r2, #40   ;tamanho de uma linha
    ;loadn r3, #30   ;numero de linhas

    loadn r4, #0 ;registrador que guardara posicao do jogador na tela

    mul r1, r1, r2  ;obtem coordenada y

    add r4, r4, r0
    add r4, r4, r1  ;obtem posiçao real do centro do jogador na tela

    loadn r5, #' '  ;caractere a ser escrito por cima do jogador

    outchar r5, r4

    sub r4, r4, r2
    outchar r5, r4

    add r4, r4, r2
    add r4, r4, r2
    outchar r5, r4

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts


DesenhaJogador2:
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    load r0, posxJogador2 ;carrega posx jogador 1 em r0
    load r1, posyJogador2 ;carrega posy jogador 1 em r0
    loadn r3, #40   ;tamanho da linha
    ;loadn r7, #30   ;numero de linhas

    loadn r2 , #0   ;posição do centro do jogador será salva em r2

    mul r1, r1, r3 ;descobre valor de y a ser printado o jogador
    add r2, r2, r0
    add r2, r2, r1  ;descobre posição na tela a printar o jogador

    loadn r4, #'$'
    loadn r6, #2304
    add r4, r4, r6 ;caractere do player

    outchar r4, r2  ;printa centro do jogador

    sub r2, r2, r3  ;printa parte superior
    outchar r4, r2

    add r2, r2, r3
    add r2, r2, r3
    outchar r4, r2  ;printa parte inferior

    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts

ApagaJogador2:
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5

    load r0, posxJogador2
    load r1, posyJogador2
    loadn r2, #40   ;tamanho de uma linha
    ;loadn r3, #30   ;numero de linhas

    loadn r4, #0 ;registrador que guardara posicao do jogador na tela

    mul r1, r1, r2  ;obtem coordenada y

    add r4, r4, r0
    add r4, r4, r1  ;obtem posiçao real do centro do jogador na tela

    loadn r5, #' '  ;caractere a ser escrito por cima do jogador

    outchar r5, r4

    sub r4, r4, r2
    outchar r5, r4

    add r4, r4, r2
    add r4, r4, r2
    outchar r5, r4

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts


canto: string "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
meio: string  "                   %                    "