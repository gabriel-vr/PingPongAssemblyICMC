
jmp main



; =================
; === VARIAVEIS ===
; =================

	iterador: var #1
	static iterador, #67

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

    ; Legenda coordenada bola:
        posicaoXBola: var #1                    ; Posicao da bola, é o que guia qual a posicao atual da bola
        static posicaoXBola, #19                ; (Centro das duas posicoes (637 + 601)/2)
        posicaoXAnteriorBola: var #1            ; A mesma ideia da posicao anterior ao imprimir os jogadores
        static posicaoXAnteriorBola, #19        ; Mesma posicao inical da bola
        posicaoYBola: var #1                    ; Posicao da bola, é o que guia qual a posicao atual da bola
        static posicaoYBola, #14                ; (Centro das duas posicoes (637 + 601)/2)
        posicaoYAnteriorBola: var #1            ; A mesma ideia da posicao anterior ao imprimir os jogadores
        static posicaoYAnteriorBola, #14        ; Mesma posicao inical da bola

    ; Placar
        placarEsquerdo: var #1
        static placarEsquerdo, #'0'
        placarDireito: var #1
        static placarDireito, #'0'

        ; Legenda velocidade bola:
        ;     0
        ;     |
        ; 0 --+-- +1
        ;     |
        ;    +1
        velocidadeXBola: var #1
        static velocidadeXBola, #1              ; Velocidade incial X para a direita

        velocidadeYBola: var #1
        static velocidadeYBola, #1              ; Velocidade incial Y para cima



; ============
; === MAIN ===
; ============
; Funcao principal do programa
main:

    ; =============
    ; === SETUP ===
    ; =============

    call zera_tela                      ; Apagar toda a tela antes de comecar o programa

    loadn r0, #cenario4linha1           ; Carrega tela inicial
    loadn r2, #0
    call imprime_tela_absoluto          ; Imprime a tela

    call espera_entrada                 ; Espera caractere ENTER para iniciar o jogo

reiniciar:
    loadn r2, #'0'
    store placarDireito, r2              ; Zera o placar
    store placarEsquerdo, r2

    loadn r2, #1                         ; Posicao inicial dos jogadores
    loadn r3, #14
    store posicaoXJogadorEsq, r2                    
    store posicaoYJogadorEsq, r3
    loadn r2, #37
    store posicaoXJogadorDir, r2                    
    store posicaoYJogadorDir, r3 

    call zera_tela                      ; Apaga a tela para iniciar o jogo

    loadn r0, #cenario1linha1           ; Endereco para o cenario default
    loadn r2, #512                      ; Cor do cenario. Verde=#512
    call imprime_tela_absoluto          ; Imprime o cenario vazio em cima da tela vazia

    loadn r0, #cenario2linha1           ; Endereço para rede do jogo
    loadn r2, #3328                        ; Cor do cenario. Roxo=3328
    call imprime_tela_sobre             ; Imprime cenario sobre o ja existente

    loadn r0, #cenario3linha1           ; Endereço para posicionar jogadores
    loadn r2, #2304                        ; Cor. Vermoelho=2304
    call imprime_tela_sobre             ; Imprime cenario sobre o ja existente

    loadn r0, #cenario6linha1           ; Endereço para posicionar  bolinha
    loadn r2, #0                        ; Cor. Branco=0
    call imprime_tela_sobre             ; Imprime cenario sobre o ja existente
    
    loadn r0, #0
    store iterador, r0


    ; ============
    ; === LOOP ===
    ; ============
    ; Loop principal do programa
    loop:
		load r3, iterador
		inc r3
		store iterador, r3
		call reposicionar_jogadores
		call DELAY

		loadn r4, #2
		mod r3, r3, r4
		loadn r4, #0
		cmp r3, r4
		jeq loop

	    call reposicionar_bola
	    call atualiza_placar
	    call verifica_ganhador

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

    ; VARIAVEL PARA REAJUSTAR A VELOCIDADE DO JOGO
    loadn r2, #1000            ; Inicio loop externo, decrementa r2 até chegar a 0
    load r3, iterador
    sub r2, r2, r3
    DELAY_L1:

    loadn r1, #1000        ; Inicio do loop interno, decremente r1 até chegar a 0
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



; =========================
; === REPOSICIONAR BOLA ===
; =========================
; Funcao para adicionar dentro do loop para realizar a movimentação da bola
reposicionar_bola:
    ; Salvar registradores
        push fr
        push r0                             
        push r1
        push r2
        push r3
        push r4
        push r5
        push r6


    load r1, posicaoYBola
    load r2, posicaoXBola
    
    ; Checar colisao bola e mudar velocidade
    reposicionar_bola_redirecionar:
    
        ; Se de cima for parede mirar pra baixo
        reposicionar_bola_redirecionar_baixo:
            loadn r3, #1
            cmp r1, r3
            jne reposicionar_bola_redirecionar_cima
            store velocidadeYBola, r3
            jmp reposicionar_bola_redirecionar_jogadorEsq
        
        ; Se de baixo for parece mirar pra cima
        reposicionar_bola_redirecionar_cima:
            loadn r3, #28
            cmp r1, r3
            jne reposicionar_bola_redirecionar_jogadorEsq
            loadn r3, #0
            store velocidadeYBola, r3



        ; Se vai bater no jogador esquerdo
        reposicionar_bola_redirecionar_jogadorEsq:
            loadn r3, #2
            cmp r2, r3
            jne reposicionar_bola_redirecionar_jogadorDir
        
            load r3, posicaoYJogadorEsq
        
            ; meio
                cmp r1, r3
                jeq reposicionar_bola_redirecionar_dir
                
            ; 1 p cima
                loadn r4, #1
                sub r3, r3, r4
                cmp r1, r3
                jeq reposicionar_bola_redirecionar_dir
            
            ; 1 p baixo
            ; flag ADDN
                addn r3, r3, #2
                cmp r1, r3
                jeq reposicionar_bola_redirecionar_dir
            
            ; quina (em função da velocidade y da bolinha)
                load r4, velocidadeYBola
                loadn r5, #1
                cmp r4, r5
                jeq reposicionar_bola_redirecionar_jogadorDir_descendo
                
                reposicionar_bola_redirecionar_jogadorDir_subindo:
                ; flag ADDN
                    addn r3, r3, #1
                    cmp r1, r3
                    jne reposicionar_bola_reposicionar
                    
                    store velocidadeYBola, r4
                    jmp reposicionar_bola_redirecionar_dir
                    
                reposicionar_bola_redirecionar_jogadorDir_descendo:
                    loadn r4, #3
                    sub r3, r3, r4
                    cmp r1, r3
                    jne reposicionar_bola_reposicionar
                    
                    loadn r4, #0
                    store velocidadeYBola, r4
                    jmp reposicionar_bola_redirecionar_dir
            
            jmp reposicionar_bola_redirecionar_jogadorDir
            reposicionar_bola_redirecionar_dir:
                loadn r3, #1
                store velocidadeXBola, r3
                jmp reposicionar_bola_redirecionar_golEsq
        
        ; Se vai bater no jogador direito
        reposicionar_bola_redirecionar_jogadorDir:
            loadn r3, #36
            cmp r2, r3
            jne reposicionar_bola_redirecionar_golEsq
        
            load r3, posicaoYJogadorDir
        
            ; meio
                cmp r1, r3
                jeq reposicionar_bola_redirecionar_esq
                
            ; 1 p cima
                loadn r4, #1
                sub r3, r3, r4
                cmp r1, r3
                jeq reposicionar_bola_redirecionar_esq
            
            ; 1 p baixo
                loadn r4, #2
                add r3, r3, r4
                cmp r1, r3
                jeq reposicionar_bola_redirecionar_esq
            
            ; quina (em função da velocidade y da bolinha)
                load r4, velocidadeYBola
                loadn r5, #1
                cmp r4, r5
                jeq reposicionar_bola_redirecionar_jogadorDir_descendo
                
                reposicionar_bola_redirecionar_jogadorDir_subindo:
                    loadn r4, #1
                    add r3, r3, r4
                    cmp r1, r3
                    jne reposicionar_bola_reposicionar
                    
                    store velocidadeYBola, r4
                    jmp reposicionar_bola_redirecionar_esq
                    
                reposicionar_bola_redirecionar_jogadorDir_descendo:
                    loadn r4, #3
                    sub r3, r3, r4
                    cmp r1, r3
                    jne reposicionar_bola_reposicionar
                    
                    loadn r4, #0
                    store velocidadeYBola, r4
                    jmp reposicionar_bola_redirecionar_esq
            
            jmp reposicionar_bola_redirecionar_golDir
            reposicionar_bola_redirecionar_esq:
                loadn r3, #0
                store velocidadeXBola, r3
        
        
        ; Se for gol esquerdo marcar ponto direito
        reposicionar_bola_redirecionar_golEsq:
            loadn r3, #1
            cmp r2, r3
            jeq incrementa_placar_direito

        ; Se for gol direito marcar ponto esquerdo
        reposicionar_bola_redirecionar_golDir:
            loadn r3, #37
            cmp r2, r3
            jeq incrementa_placar_esquerdo


        jmp reposicionar_bola_reposicionar

        ; Incrementa placar esquerdo
        incrementa_placar_esquerdo:
            loadn r5, #1                
            load r4, placarEsquerdo
            add r4, r4, r5;
            store placarEsquerdo, r4
            jmp posiciona_bola_meio

        ; Incrementa placar direito
        incrementa_placar_direito:
            loadn r5, #1                
            load r4, placarDireito
            add r4, r4, r5;
            store placarDireito, r4

        ; Posiciona a bola na posicao central
        posiciona_bola_meio:
            loadn r4, #19
            loadn r5, #14
            store posicaoXBola, r4 
            store posicaoYBola, r5
            jmp reposicionar_bola_imagem


    ; Reposicionar coordenadas da bola
    reposicionar_bola_reposicionar:
        loadn r4, #1
        
        ; Coordenada y
        reposicionar_bola_reposicionar_vertical:
            load r3, velocidadeYBola
            cmp r3, r4
            jeq reposicionar_bola_reposicionar_vertical_baixo
            
            reposicionar_bola_reposicionar_vertical_cima:
                sub r1, r1, r4
                store posicaoYBola, r1
                jmp reposicionar_bola_reposicionar_horizontal
            
            reposicionar_bola_reposicionar_vertical_baixo:
                add r1, r1, r4
                store posicaoYBola, r1
        
        ; Coordenada x
        reposicionar_bola_reposicionar_horizontal:
            load r3, velocidadeXBola
            cmp r3, r4
            jeq reposicionar_bola_reposicionar_horizontal_dir
            
            reposicionar_bola_reposicionar_horizontal_esq:
                sub r2, r2, r4
                store posicaoXBola, r2
                jmp reposicionar_bola_imagem
            
            reposicionar_bola_reposicionar_horizontal_dir:
                add r2, r2, r4
                store posicaoXBola, r2


    ; Reajustar imagem da bola
    reposicionar_bola_imagem:
        ; 40 * posy + posx
            loadn r3, #40
                
        ; Limpar a imagem da bola
            load r4, posicaoYAnteriorBola
            load r5, posicaoXAnteriorBola
            mul r4, r4, r3
            add r4, r4, r5
            
            ; confere se esta na linha do meio
            loadn r6, #19
            cmp r5, r6
            jeq reposicionar_bola_imagem_meio
            
            loadn r5, #' '
            jmp reposicionar_bola_imagem_escreve
            
            reposicionar_bola_imagem_meio:
            loadn r5, #'%'
            loadn r6, #3328

            add r5, r5, r6
            
            reposicionar_bola_imagem_escreve:
            outchar r5, r4
            
        load r4, posicaoYBola
        load r5, posicaoXBola
        ; Ajustar os valores anteriores
            store posicaoYAnteriorBola, r4
            store posicaoXAnteriorBola, r5

        ; Escrever bola em nova posição
            mul r4, r4, r3
            add r4, r4, r5
            
            loadn r5, #'$'
            outchar r5, r4


    ; Reatribuir registradores
        pop r6
        pop r5
        pop r4
        pop r3
        pop r2
        pop r1
        pop r0
        pop fr
        rts



; ======================
; === ESPERA ENTRADA ===
; ======================
; Funcao para adicionar dentro do loop para realizar a movimentação da bola
espera_entrada:
    push fr
    push r0                             ; Salvar registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    espera_entrada_L1:
    inchar r0                           ; Le entrada
    loadn r1, #255                      ; Armazena a entrada vazia em r1 (255)

    cmp r0, r1                          ; Compara se não teve entrada
    jeq espera_entrada_L1               ; Se não teve entrada => Le entrada novamente

    pop r6                              ; Reatribuir registradores
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    pop fr
    rts



; ==============================
; === REPOSICIONAR JOGADORES ===
; ==============================
; Funcao para adicionar dentro do loop para realizar a movimentação dos jogador da esquerda e da direita a cada iteracao
reposicionar_jogadores:
    push fr
    push r0                             ; Salvar registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
   
    inchar r1                           ; Le entrada para controlar a nave

    ; [DEBUG]. Parte de código foi utilizada nessa funcao para mostrar no canto superior esquerdo qual o valor do teclado encontrado
    ;push fr
    ;loadn r3, #255
    ;cmp r1, r3
    ;jeq A
    ;loadn r3, #0
    ;outchar r1, r3
    ;A:
    ;pop fr
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
    pop fr
    rts



; ==========================================
; === REPOSICIONAR JOGADOR ESQUERDA CIMA ===
; ==========================================
; Recalcular as variaveis de posicao do jogador da esquerda para se mover para cima
reposicionar_jogador_esq_cima:
    push fr
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
    pop fr
    rts



; ===========================================
; === REPOSICIONAR JOGADOR ESQUERDA BAIXO ===
; ===========================================
; Recalcular as variaveis de posicao do jogador da esquerda para se mover para cima
reposicionar_jogador_esq_baixo:
    push fr
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
    pop fr
    rts



; =========================================
; === REAJUSTAR IMAGEM JOGADOR ESQUERDA ===
; =========================================
; Funcao reajusta a imagem do jogador da esquerda, com a variavel posicaoAnteriorJogadorEsq desatualizado. Depois atualiza a variavel posicaoAnteriorJogadorEsq
reajustar_imagem_jogador_esq:
    push fr
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
    loadn r3, #'$'
    loadn r7, #2304
    add r3, r3, r7                              ; Espaço para colocar nas posicoes
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
    pop fr
    rts



; =========================================
; === REPOSICIONAR JOGADOR DIREITA CIMA ===
; =========================================
; Recalcular as variaveis de posicao do jogador da direita para se mover para cima
reposicionar_jogador_dir_cima:
    push fr
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
    pop fr
    rts



; ==========================================
; === REPOSICIONAR JOGADOR DIREITA BAIXO ===
; ==========================================
; Recalcular as variaveis de posicao do jogador da direita se mover para cima
reposicionar_jogador_dir_baixo:
    push fr
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
    pop fr
    rts



; ========================================
; === REAJUSTAR IMAGEM JOGADOR DIREITA ===
; ========================================
; Funcao reajusta a imagem do jogador da direita, com a variavel posicaoAnteriorJogadorDir desatualizado. Depois atualiza a variavel posicaoAnteriorJogadorDir
reajustar_imagem_jogador_dir:
    push fr
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
    loadn r3, #'$'
    loadn r7, #2304
    add r3, r3, r7                           ; Espaço para colocar nas posicoes
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
    pop fr
    rts


; =======================
; === ATUALIZA PLACAR ===
; =======================
; Incrementa o placar se algum jogador pontuou.
atualiza_placar:
    push fr
    push r0                     ; Salvar registradores
    push r1
    push r2
    push r3

    load r0, placarEsquerdo
    loadn r1, #18
    load r2, placarDireito
    loadn r3, #20

    outchar r0, r1
    outchar r2, r3

    pop r3                      ; Recarregar os registradores
    pop r2
    pop r1
    pop r0
    pop fr
    rts


; =========================
; === Verifica ganhador ===
; =========================
; Verifica se algum jogador atingiu 3 pontos e indica o ganhador
verifica_ganhador:
    push fr
    push r0                     ; Salvar registradores
    push r1
    push r2
    push r3

    load r0, placarEsquerdo     ; Carrega pontuacao do jogador esquerdo
    load r1, placarDireito      ; Carrega pontuacao do jogador direito
    loadn r2, #'3'              ; Pontuacao maxima

    cmp r0, r2
    jeq jogador_esquerdo

    cmp r1, r2
    jeq jogador_direito

    jmp verifica_ganhador_out

jogador_esquerdo:
    loadn r0, #cenario5_esquerda
    jmp imprime_resultado

jogador_direito:
    loadn r0, #cenario5_direita

imprime_resultado:
    loadn r2, #0                    ; Cor branco

    call zera_tela

    loadn r1, #560               
    call imprime_string_sobre

    loadn r0, #cenario5_reiniciar   ; String indicando para pressionar ENTER
    loadn r1, #640               
    call imprime_string_sobre

    call espera_entrada
    jmp reiniciar


verifica_ganhador_out:
    pop r3                      ; Recarregar os registradores
    pop r2
    pop r1
    pop r0
    pop fr
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
    cenario1linha1:    string "$$$$$$$$$$$$$$$$$$ x $$$$$$$$$$$$$$$$$$ "
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
    cenario3linha15:   string " $                                   $  "
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

; CENÁRIO: Dois jogadores e bola na posição default
    cenario4linha1:    string "                                        "
    cenario4linha2:    string "                                        "
    cenario4linha3:    string "                                        "
    cenario4linha4:    string "                                        "
    cenario4linha5:    string "                                        "
    cenario4linha6:    string "                                        "
    cenario4linha7:    string "                                        "
    cenario4linha8:    string "                                        "
    cenario4linha9:    string "                                        "
    cenario4linha10:   string "                                        "
    cenario4linha11:   string "                                        "
    cenario4linha12:   string "                                        "
    cenario4linha13:   string "                                        "
    cenario4linha14:   string "                                        "
    cenario4linha15:   string "  Para iniciar o jogo pressione ENTER:  "
    cenario4linha16:   string "                                        "
    cenario4linha17:   string "                                        "
    cenario4linha18:   string "                                        "
    cenario4linha19:   string "                                        "
    cenario4linha20:   string "                                        "
    cenario4linha21:   string "                                        "
    cenario4linha22:   string "                                        "
    cenario4linha23:   string "                                        "
    cenario4linha24:   string "                                        "
    cenario4linha25:   string "                                        "
    cenario4linha26:   string "                                        "
    cenario4linha27:   string "                                        "
    cenario4linha28:   string "                                        "
    cenario4linha29:   string "                                        "
    cenario4linha30:   string "                                        "
    
; CENARIO - Indica o ganhador
    cenario5_direita:   string "      O jogador da direita ganhou       "
    cenario5_esquerda:  string "      O jogador da esquerda ganhou      "
    cenario5_reiniciar: string "    Pressione <ENTER> para reiniciar    "


; CENÁRIO: Dois jogadores e bola na posição default
    cenario6linha1:    string "                                        "
    cenario6linha2:    string "                                        "
    cenario6linha3:    string "                                        "
    cenario6linha4:    string "                                        "
    cenario6linha5:    string "                                        "
    cenario6linha6:    string "                                        "
    cenario6linha7:    string "                                        "
    cenario6linha8:    string "                                        "
    cenario6linha9:    string "                                        "
    cenario6linha10:   string "                                        "
    cenario6linha11:   string "                                        "
    cenario6linha12:   string "                                        "
    cenario6linha13:   string "                                        "
    cenario6linha14:   string "                                        "
    cenario6linha15:   string "                   $                    "
    cenario6linha16:   string "                                        "
    cenario6linha17:   string "                                        "
    cenario6linha18:   string "                                        "
    cenario6linha19:   string "                                        "
    cenario6linha20:   string "                                        "
    cenario6linha21:   string "                                        "
    cenario6linha22:   string "                                        "
    cenario6linha23:   string "                                        "
    cenario6linha24:   string "                                        "
    cenario6linha25:   string "                                        "
    cenario6linha26:   string "                                        "
    cenario6linha27:   string "                                        "
    cenario6linha28:   string "                                        "
    cenario6linha29:   string "                                        "
    cenario6linha30:   string "                                        "

