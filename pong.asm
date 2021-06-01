jmp main

posxJogador1: var #1
posyJogador1: var #1

static posxJogador1, #1
static posyJogador1, #20

posxJogador2: var #1
posyJogador2: var #1

static posxJogador2, #38
static posyJogador2, #20

main:

    ;loadn r0, #canto
    ;loadn r1, #0
    ;loadn r2, #0
    ;call printaString
    call PrintaCenario

    call DesenhaJogador1
    call DesenhaJogador2

    halt




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
    loadn r7, #30   ;numero de linhas

    loadn r2 , #0   ;posição do centro do jogador será salva em r2

    mul r1, r1, r7 ;descobre valor de y a ser printado o jogador
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
    loadn r7, #30   ;numero de linhas

    loadn r2 , #0   ;posição do centro do jogador será salva em r2

    mul r1, r1, r7 ;descobre valor de y a ser printado o jogador
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

canto: string "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
meio: string  "                   %                    "