
jmp main



; =================
; === VARIAVEIS ===
; =================

; Legenda coordenadas jogadores:
;0   +-----------> (x)
;    |           +
;    |
;    |
;    | +
;   (y)
posicaoXJogadorEsq: var #1              ; Coordenada X jogador esquerda. Variavel se mantem estatica no jogo
static posicaoXJogadorEsq, #1           ; Jogador da esquerda permanece estatico na coordenada X
posicaoYJogadorEsq: var #1              ; Posicao atual do jogador. É atualizada quando a posição do jogador deve ser atualizada
static posicaoYJogadorEsq, #14          ; Posicao incial do jogador da esquerda (Linha central: 600 + coluna max direita + 1) = 601
posicaoYAnteriorJogadorEsq: var #1      ; Posicao anterior do jogador. Facilita a impressão. É mantida a antiga quando atualiza a posicao atual do jogador e atualizada depois da impressao
static posicaoYAnteriorJogadorEsq, #14  ; Originalmente a posicao anterior do jogador é igual a posicao atual

posicaoXJogadorDir: var #37             ; Coordenada X jogador direita. Variavel se mantem estatica no jogo
static posicaoXJogadorDir, #37          ; 
posicaoYJogadorDir: var #1              ; Posicao atual do jogador. É atualizada quando a posicao do jogador deve ser atualizada
static posicaoYJogadorDir, #14          ; Posicao incial do jogador da direita (Linha central: 600 + coluna max esquerda - 2) = 637
posicaoYAnteriorJogadorDir: var #1      ; Posicao anterior do jogador. Facilita a impressao. É mantida a antiga quando atualiza a posicao atual do jogador e atualizada depois da impressao
static posicaoYAnteriorJogadorDir, #14  ; Originalmente a posicao anterior do jogador é igual a posicao atual

posicaoXBola: var #1                    ; Posicao da bola, é o que guia qual a posicao atual da bola
static posicaoXBola, #14                ; (Centro das duas posicoes (637 + 601)/2)
posicaoXAnteriorBola: var #1            ; A mesma ideia da posicao anterior ao imprimir os jogadores
static posicaoXAnteriorBola, #14        ; Mesma posicao inical da bola
posicaoYBola: var #1                    ; Posicao da bola, é o que guia qual a posicao atual da bola
static posicaoYBola, #14                ; (Centro das duas posicoes (637 + 601)/2)
posicaoYAnteriorBola: var #1            ; A mesma ideia da posicao anterior ao imprimir os jogadores
static posicaoYAnteriorBola, #14        ; Mesma posicao inical da bola


; Legenda velocidade bola:
;    -1
;     |
;-1 --+-- +1
;     |
;    +1
; velocidadeXBola: var #1
; static velocidadeXBola, #1              ; Velocidade incial X para a direita
; 
; velocidadeYBola: var #2
; static velocidadeYBola, #-1             ; Velocidade incial Y para cima



; ============
; === MAIN ===
; ============
; Funcao principal do programa
main:

    ; =============
    ; === SETUP ===
    ; =============

    call zera_tela                      ; Apagar toda a tela antes de comecar o programa

    loadn r0, #cenario1linha1           ; Endereco para o cenario default
    loadn r2, #0                        ; Cor do cenario. Branco=#0
    call imprime_tela_absoluto          ; Imprime o cenario vazio em cima da tela vazia

    loadn r0, #cenario2linha1           ; Endereço para rede do jogo
    loadn r2, #0                        ; Cor do cenario. Branco=0
    call imprime_tela_sobre             ; Imprime cenario sobre o ja existente

    loadn r0, #cenario3linha1           ; Endereço para posicionar jogadores e bolinha
    loadn r2, #0                        ; Cor. Branco=0
    call imprime_tela_sobre             ; Imprime cenario sobre o ja existente


    ; ============
    ; === LOOP ===
    ; ============
    ; Loop principal do programa
    loop:
    
    call reposicionar_jogadores

    call DELAY
    jmp loop 
    halt



; =============
; === DELAY ===
; =============
; Funcao para adicionar intervalo entre ações
; Valor atribuido ao registrador r2 dentro da função é o principal causador do delay. Mude-o caso precise de mais ou menos delay
DELAY:
    push fr                 ; Salvar registradores
    push r0
    push r1
    push r2

    loadn r0, #0

    ; loadn r2, #128        ; VARIAVEL PARA REAJUSTAR A VELOCIDADE DO JOGO
    loadn r2, #1            ; Inicio loop externo, decrementa r2 até chegar a 0
    DELAY_L1:

    loadn r1, #32768        ; Inicio do loop interno, decremente r1 até chegar a 0
    DELAY_L2:
    dec r1                  ; Parte para decrementar o valor de r1
    cmp r1, r0
    jne DELAY_L2
    
    dec r2                  ; Parte para decrementar o valor de r2
    cmp r2, r0
    jne DELAY_L1

    pop r2                  ; Reatribuir registradores
    pop r1
    pop r0
    pop fr
    rts


; ==============================
; === REPOSICIONAR JOGADORES ===
; ==============================
; Funcao para adicionar dentro do loop para realizar a movimentação dos jogador da esquerda e da direita a cada iteracao
reposicionar_jogadores:
    push r0                             ; Salvar registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
   
    inchar r1                           ; Le entrada para controlar a nave

    ; [DEBUG]. Parte de código foi utilizada nessa funcao para mostrar no canto superior esquerdo qual o valor do teclado encontrado
    push fr
    loadn r3, #255
    cmp r1, r3
    jeq A
    loadn r3, #0
    outchar r1, r3
    A:
    pop fr
    ; [FIM DEBUG]. Pode ser removido inteiro sem prejudicar o programa

    ; Identificando comandos para o jogador da esquerda
    loadn r2, #'w'                      ; Atribui a r2 o valor do char 'w'
    cmp r1, r2
    ceq reposicionar_jogador_esq_cima   ; Chama funcao para reposicionar jogador da esquerda para cima caso leia 'w'
    loadn r2, #'s'                      ; Atribui a r2 o valor do char 's'
    cmp r1, r2
    ceq reposicionar_jogador_esq_baixo  ; Chama funcao para reposicionar jogador da esquerda para baixo caso leia 's'

    ; Identificando comandos para o jogador da direita
    loadn r2, #'i'                      ; Atribui a r2 o valor do char 'i'
    cmp r1, r2
    ceq reposicionar_jogador_dir_cima   ; Chama funcao para reposicionar jogador da direita para cima caso leia 'i'
    loadn r2, #'k'                      ; Atribui a r2 o valor do char 'k'
    cmp r1, r2
    ceq reposicionar_jogador_dir_baixo  ; Chama funcao para reposicionar jogador da direita para baixo caso leia 'k'


    call reajustar_imagem_jogador_esq   ; Chama funcao para reajustar a imagem do jogador da esquerda, independente do caractere de entrada
    call reajustar_imagem_jogador_dir   ; Chama funcao para reajustar a imagem do jogador da direita, independente do caractere de entrada

    pop r6                              ; Reatribuir registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts


; ==========================================
; === REPOSICIONAR JOGADOR ESQUERDA CIMA ===
; ==========================================
; Recalcular as variaveis de posicao do jogador da esquerda para se mover para cima
reposicionar_jogador_esq_cima:
    push r0                                 ; Salva registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    load r0, posicaoYJogadorEsq             ; r0 recebe a posicao atual do jogador da esquerda
    loadn r1, #2                            ; Posição máxima y = 2
    cmp r0, r1
    jeq reposicionar_jogador_esq_cima_OUT1  ; Se ja estiver na posicao maxima => termina procedimento
   
    loadn r2, #1                            ; Decrementar por 1
    sub r0, r0, r2                          ; Ajusta a posicao (-1) para se referenciar à linha de cima 
    store posicaoYJogadorEsq, r0            ; Salva variavel modificada

    reposicionar_jogador_esq_cima_OUT1:
    pop r6                                  ; Reatribui regitradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts


; ===========================================
; === REPOSICIONAR JOGADOR ESQUERDA BAIXO ===
; ===========================================
; Recalcular as variaveis de posicao do jogador da esquerda para se mover para cima
reposicionar_jogador_esq_baixo:
    push r0                                     ; Salva registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    load r0, posicaoYJogadorEsq                 ; r0 recebe a posicao atual do jogador da esquerda
    loadn r1, #27                               ; Posição minima 37
    cmp r0, r1
    jeq reposicionar_jogador_esq_baixo_out1     ; Se ja estiver na posicao minima, termina procedimento
    
    loadn r2, #1                                ; Incrementar por 1
    add r0, r0, r2                              ; Ajusta a posicao (+1) para se referenciar à linha de abaixo 
    store posicaoYJogadorEsq, r0                ; Salva variavel modificada

    reposicionar_jogador_esq_baixo_out1:
    pop r6                                      ; Reatribui registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts


; =========================================
; === REAJUSTAR IMAGEM JOGADOR ESQUERDA ===
; =========================================
; Funcao reajusta a imagem do jogador da esquerda, com a variavel posicaoAnteriorJogadorEsq desatualizado. Depois atualiza a variavel posicaoAnteriorJogadorEsq
reajustar_imagem_jogador_esq:
    push r0                                     ; Salva registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    load r0, posicaoYAnteriorJogadorEsq         ; r0 recebe a posicao desatualizada do jogador da esquerda
    load r1, posicaoXJogadorEsq                 ; r1 recebe a coordenada X do jogador

    ; Limpar(com o caractere ' ') todo o delta y ocupado pelo jogador da esquerda
    loadn r3, #' '                              ; Espaço para colocar nas posicoes
    loadn r2, #40                               ; Fator de multiplicacao para posicionar na tela
    
    mul r0, r0, r2                              ; Acha linha do jogador multiplicando coordenada Y * 40 (numeros de coluna por linha)
    add r0, r0, r1                              ; Acha posicao do jogador na linha adicionando a coordenada X + posicao da coluna

    add r0, r0, r2                              ; Primeira posicao para limpar
    outchar  r3, r0
    sub r0, r0, r2                              ; Segunda posicao para limpar
    outchar r3, r0
    sub r0, r0, r2                              ; Terceira posicao para limpar
    outchar r3, r0

    load r0, posicaoYJogadorEsq                 ; r0 recebe a posicao atualizada do jogador da esquerda
    load r1, posicaoXJogadorEsq                 ; r1 recebe a coordenada X do jogador

    ; Reatribuir(com o caractere '$') todo o delta y ocupado pelo jogador da esquerda
    loadn r3, #'$'                              ; Espaço para colocar nas posicoes
    loadn r2, #40                               ; Quantidade de incremento

    mul r0, r0, r2                              ; Acha linha do jogador multiplicando coordenada Y * 40 (numeros de coluna por linha)
    add r0, r0, r1                              ; Acha posicao do jogador na linha adicionando a coordenada X + posicao da coluna

    add r0, r0, r2                              ; Primeira posicao para limpar
    outchar r3, r0
    sub r0, r0, r2                              ; Segunda posicao para limpar
    outchar r3, r0
    sub r0, r0, r2                              ; Terceira posicao para limpar
    outchar r3, r0

    load r0, posicaoYJogadorEsq                  ; r0 recebe a posicao atualizada do jogador da esquerda
    store posicaoYAnteriorJogadorEsq, r0         ; armazenar o valor atualizado na variavel desatualizada

    pop r6                                      ; Reatribui registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts



; =========================================
; === REPOSICIONAR JOGADOR DIREITA CIMA ===
; =========================================
; Recalcular as variaveis de posicao do jogador da direita para se mover para cima
reposicionar_jogador_dir_cima:
    push r0                                 ; Salva registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    load r0, posicaoYJogadorDir             ; r0 recebe a posicao atual do jogador da direita
    loadn r1, #2                            ; Posição máxima y = 2
    cmp r0, r1
    jeq reposicionar_jogador_dir_cima_OUT1  ; Se ja estiver na posicao maxima => termina procedimento
   
    loadn r2, #1                            ; Decrementar por 1
    sub r0, r0, r2                          ; Ajusta a posicao (-1) para se referenciar à linha de cima 
    store posicaoYJogadorDir, r0            ; Salva variavel modificada

    reposicionar_jogador_dir_cima_OUT1:
    pop r6                                  ; Reatribui regitradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts



; ==========================================
; === REPOSICIONAR JOGADOR DIREITA BAIXO ===
; ==========================================
; Recalcular as variaveis de posicao do jogador para da direita se mover para cima
reposicionar_jogador_dir_baixo:
    push r0                                     ; Salva registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    load r0, posicaoYJogadorDir                 ; r0 recebe a posicao atual do jogador da direita
    loadn r1, #27                               ; Posição minima 37
    cmp r0, r1
    jeq reposicionar_jogador_dir_baixo_out1     ; Se ja estiver na posicao minima, termina procedimento
    
    loadn r2, #1                                ; Incrementar por 1
    add r0, r0, r2                              ; Ajusta a posicao (+1) para se referenciar à linha de abaixo 
    store posicaoYJogadorDir, r0                ; Salva variavel modificada

    reposicionar_jogador_dir_baixo_out1:
    pop r6                                      ; Reatribui registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts



; ========================================
; === REAJUSTAR IMAGEM JOGADOR DIREITA ===
; ========================================
; Funcao reajusta a imagem do jogador da direita, com a variavel posicaoAnteriorJogadorDir desatualizado. Depois atualiza a variavel posicaoAnteriorJogadorDir
reajustar_imagem_jogador_dir:
    push r0                                     ; Salva registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    load r0, posicaoYAnteriorJogadorDir         ; r0 recebe a posicao desatualizada do jogador da direita
    load r1, posicaoXJogadorDir                 ; r1 recebe a coordenada X do jogador

    ; Limpar(com o caractere ' ') todo o delta y ocupado pelo jogador da direita
    loadn r3, #' '                              ; Espaço para colocar nas posicoes
    loadn r2, #40                               ; Fator de multiplicacao para posicionar na tela
    
    mul r0, r0, r2                              ; Acha linha do jogador multiplicando coordenada Y * 40 (numeros de coluna por linha)
    add r0, r0, r1                              ; Acha posicao do jogador na linha adicionando a coordenada X + posicao da coluna

    add r0, r0, r2                              ; Primeira posicao para limpar
    outchar  r3, r0
    sub r0, r0, r2                              ; Segunda posicao para limpar
    outchar r3, r0
    sub r0, r0, r2                              ; Terceira posicao para limpar
    outchar r3, r0

    load r0, posicaoYJogadorDir                 ; r0 recebe a posicao atualizada do jogador da direita
    load r1, posicaoXJogadorDir                 ; r1 recebe a coordenada X do jogador

    ; Reatribuir(com o caractere '$') todo o delta y ocupado pelo jogador da direita
    loadn r3, #'$'                              ; Espaço para colocar nas posicoes
    loadn r2, #40                               ; Quantidade de incremento

    mul r0, r0, r2                              ; Acha linha do jogador multiplicando coordenada Y * 40 (numeros de coluna por linha)
    add r0, r0, r1                              ; Acha posicao do jogador na linha adicionando a coordenada X + posicao da coluna

    add r0, r0, r2                              ; Primeira posicao para limpar
    outchar r3, r0
    sub r0, r0, r2                              ; Segunda posicao para limpar
    outchar r3, r0
    sub r0, r0, r2                              ; Terceira posicao para limpar
    outchar r3, r0

    load r0, posicaoYJogadorDir                  ; r0 recebe a posicao atualizada do jogador da direita
    store posicaoYAnteriorJogadorDir, r0         ; armazenar o valor atualizado na variavel desatualizada

    pop r6                                      ; Reatribui registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts



; =============================
; === IMPRIME TELA ABSOLUTO ===
; =============================
; Imprime o conteudo do CENARIO na tela, trocando tudo o que ja esta presente na tela com o conteudo do CENARIO passado como parametro
; r0: Endereco para string CENARIO
; r2: COR
imprime_tela_absoluto:
    push fr                     ; Salvar registradores
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    loadn r1, #0                ; Primeira posicao na TELA
    loadn r3, #40               ; Incremento de linha TELA
    loadn r4, #41               ; Incremento de linha CENARIO (\0 no fim da string fora os 40 bytes da string)
    loadn r5, #1200             ; POSICAO maxima

    imprime_tela_absoluto_L1:   ; while(r0 != 1200) { Imprime cada linha na tela }
        cmp r1, r5              ; Endereco CENARIO == #1200
        jeq imprime_tela_absoluto_OUT1
        call imprime_string_absoluto
        add r1, r1, r3          ; posicao da TELA += #40
        add r0, r0, r4          ; posicao do CENARIO += #41
        jmp imprime_tela_absoluto_L1

    imprime_tela_absoluto_OUT1:
    pop r6                      ; Recarregar os registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts


; ==========================
; === IMPRIME TELA SOBRE ===
; ==========================
; Imprime o conteudo do CENARIO na tela, não mudando onde o CENARIO tem ' '
; Caso o caractere da string que será imprimida seja ' ', entao não escreve nada naquela posicao (Para preservar o que ja esta na tela)
; r0: Endereco para string CENARIO
; r2: COR
imprime_tela_sobre:
    push fr                     ; Salvar registradores
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    loadn r1, #0                ; Primeira posicao na TELA
    loadn r3, #40               ; Incremento de linha TELA
    loadn r4, #41               ; Incremento de linha CENARIO (\0 no fim da string fora os 40 bytes da string)
    loadn r5, #1200             ; POSICAO maxima

    imprime_tela_sobre_L1:      ; while(r0 != 1200) { Imprime cada linha na tela }
        cmp r1, r5              ; Endereco CENARIO == #1200
        jeq imprime_tela_sobre_OUT1
        call imprime_string_sobre
        add r1, r1, r3          ; posicao da TELA += #40
        add r0, r0, r4          ; posicao do CENARIO += #41
        jmp imprime_tela_sobre_L1

    imprime_tela_sobre_OUT1:
    pop r6                      ; Recarregar os registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts



; ===============================
; === IMPRIME STRING ABSOLUTO ===
; ===============================
; Imprime a string do CENARIO na tela, substituindo tudo o que ja esta presente 
; r0: Endereco para linha CENARIO
; r1: Endereco para linha TELA
; r2: COR
imprime_string_absoluto:
    push fr                     ; Salvar os registradores
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    loadn r3, #'\0'

    loadi r5, r0                ; Caractere (C) que sera colocado no cenario padrao
    imprime_string_absoluto_L1:
        cmp r5, r3              ; Se C == '\0' => fim da funcao
        jeq imprime_string_absoluto_OUT1

        add r5, r5, r2          ; Adiciona cor
        outchar r5, r1          ; Coloca o caractere da linha na tela
        
        imprime_string_absoluto_OUT2:
        inc r0
        inc r1
        loadi r5, r0            ; Caractere (C) que sera colocado no cenario padrao
        jmp imprime_string_absoluto_L1


    imprime_string_absoluto_OUT1:
    pop r6                      ; Recarregar os registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts



; ============================
; === IMPRIME STRING SOBRE ===
; ============================
; Imprime a string do CENARIO na tela, não mudando onde o CENARIO tem ' '
; r0: Endereco para linha CENARIO
; r1: Endereco para linha TELA
; r2: COR
imprime_string_sobre:
    push fr                     ; Salvar os registradores
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    loadn r3, #'\0'
    loadn r4, #' '

    loadi r5, r0                ; Caractere (C) que sera colocado no cenario padrao
    imprime_string_sobre_L1:
        cmp r5, r3              ; Se C == '\0' => fim da funcao
        jeq imprime_string_sobre_OUT1

        cmp r5, r4              ; Se C == ' ' => continue
        jeq imprime_string_sobre_OUT2

        add r5, r5, r2          ; Adiciona cor
        outchar r5, r1          ; Coloca o caractere da linha na tela
        
        imprime_string_sobre_OUT2:
        inc r0
        inc r1
        loadi r5, r0            ; Caractere (C) que sera colocado no cenario padrao
        jmp imprime_string_sobre_L1


    imprime_string_sobre_OUT1:
    pop r6                      ; Recarregar os registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts



; =================
; === ZERA TELA ===
; =================
; Zera toda a tela 
zera_tela:
    push fr                     ; Salvar registradores
    push r0
    push r1
    push r2

    loadn r0, #1200             ; Condicao de parada da tela
    loadn r1, #' '              ; Caractere espaço
    loadn r2, #'\0'

    zera_tela_L1:               ; do { Escreve caractere ' ' na posicao r0 } while(r0 != 0)
        dec r0
        outchar r1, r0
        cmp r0, r2              ; Compare r0 != 0
        jne zera_tela_L1

    pop r2
    pop r1                      ; Retornar registradores
    pop r0
    pop fr
    rts



; =============
; === TELAS ===
; =============

; CENARIO 0: CENARIO VAZIO
cenario0linha1:    string "                                        "
cenario0linha2:    string "                                        "
cenario0linha3:    string "                                        "
cenario0linha4:    string "                                        "
cenario0linha5:    string "                                        "
cenario0linha6:    string "                                        "
cenario0linha7:    string "                                        "
cenario0linha8:    string "                                        "
cenario0linha9:    string "                                        "
cenario0linha10:   string "                                        "
cenario0linha11:   string "                                        "
cenario0linha12:   string "                                        "
cenario0linha13:   string "                                        "
cenario0linha14:   string "                                        "
cenario0linha15:   string "                                        "
cenario0linha16:   string "                                        "
cenario0linha17:   string "                                        "
cenario0linha18:   string "                                        "
cenario0linha19:   string "                                        "
cenario0linha20:   string "                                        "
cenario0linha21:   string "                                        "
cenario0linha22:   string "                                        "
cenario0linha23:   string "                                        "
cenario0linha24:   string "                                        "
cenario0linha25:   string "                                        "
cenario0linha26:   string "                                        "
cenario0linha27:   string "                                        "
cenario0linha28:   string "                                        "
cenario0linha29:   string "                                        "
cenario0linha30:   string "                                        "

; CENÁRIO: Limites lateriais jogo de ping-pong
cenario1linha1:    string "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ "
cenario1linha2:    string "&                                     ! "
cenario1linha3:    string "&                                     ! "
cenario1linha4:    string "&                                     ! "
cenario1linha5:    string "&                                     ! "
cenario1linha6:    string "&                                     ! "
cenario1linha7:    string "&                                     ! "
cenario1linha8:    string "&                                     ! "
cenario1linha9:    string "&                                     ! "
cenario1linha10:   string "&                                     ! "
cenario1linha11:   string "&                                     ! "
cenario1linha12:   string "&                                     ! "
cenario1linha13:   string "&                                     ! "
cenario1linha14:   string "&                                     ! "
cenario1linha15:   string "&                                     ! "
cenario1linha16:   string "&                                     ! "
cenario1linha17:   string "&                                     ! "
cenario1linha18:   string "&                                     ! "
cenario1linha19:   string "&                                     ! "
cenario1linha20:   string "&                                     ! "
cenario1linha21:   string "&                                     ! "
cenario1linha22:   string "&                                     ! "
cenario1linha23:   string "&                                     ! "
cenario1linha24:   string "&                                     ! "
cenario1linha25:   string "&                                     ! "
cenario1linha26:   string "&                                     ! "
cenario1linha27:   string "&                                     ! "
cenario1linha28:   string "&                                     ! "
cenario1linha29:   string "&                                     ! "
cenario1linha30:   string "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ "

; CENÁRIO: Rede do jogo de ping-pong
cenario2linha1:    string "                                        "
cenario2linha2:    string "                   %                    "
cenario2linha3:    string "                   %                    "
cenario2linha4:    string "                   %                    "
cenario2linha5:    string "                   %                    "
cenario2linha6:    string "                   %                    "
cenario2linha7:    string "                   %                    "
cenario2linha8:    string "                   %                    "
cenario2linha9:    string "                   %                    "
cenario2linha10:   string "                   %                    "
cenario2linha11:   string "                   %                    "
cenario2linha12:   string "                   %                    "
cenario2linha13:   string "                   %                    "
cenario2linha14:   string "                   %                    "
cenario2linha15:   string "                   %                    "
cenario2linha16:   string "                   %                    "
cenario2linha17:   string "                   %                    "
cenario2linha18:   string "                   %                    "
cenario2linha19:   string "                   %                    "
cenario2linha20:   string "                   %                    "
cenario2linha21:   string "                   %                    "
cenario2linha22:   string "                   %                    "
cenario2linha23:   string "                   %                    "
cenario2linha24:   string "                   %                    "
cenario2linha25:   string "                   %                    "
cenario2linha26:   string "                   %                    "
cenario2linha27:   string "                   %                    "
cenario2linha28:   string "                   %                    "
cenario2linha29:   string "                   %                    "
cenario2linha30:   string "                                        "

; CENÁRIO: Dois jogadores e bola na posição default
cenario3linha1:    string "                                        "
cenario3linha2:    string "                                        "
cenario3linha3:    string "                                        "
cenario3linha4:    string "                                        "
cenario3linha5:    string "                                        "
cenario3linha6:    string "                                        "
cenario3linha7:    string "                                        "
cenario3linha8:    string "                                        "
cenario3linha9:    string "                                        "
cenario3linha10:   string "                                        "
cenario3linha11:   string "                                        "
cenario3linha12:   string "                                        "
cenario3linha13:   string "                                        "
cenario3linha14:   string " $                                   $  "
cenario3linha15:   string " $                 $                 $  "
cenario3linha16:   string " $                                   $  "
cenario3linha17:   string "                                        "
cenario3linha18:   string "                                        "
cenario3linha19:   string "                                        "
cenario3linha20:   string "                                        "
cenario3linha21:   string "                                        "
cenario3linha22:   string "                                        "
cenario3linha23:   string "                                        "
cenario3linha24:   string "                                        "
cenario3linha25:   string "                                        "
cenario3linha26:   string "                                        "
cenario3linha27:   string "                                        "
cenario3linha28:   string "                                        "
cenario3linha29:   string "                                        "
cenario3linha30:   string "                                        "
