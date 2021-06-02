
jmp main


; ================
; ===   MAIN   ===
; ================
main:
    ; Funcao para apagar toda a tela antes de comecar o programa (DESABILITADO PARA DEBUGGING)
    ; call zera_tela

    loadn r0, #cenario1linha1       ; Endereco para o cenario default
    loadn r2, #0                    ; Cor do cenario. Branco=#0
    call imprime_tela_absoluto         ; Imprime o cenario vazio em cima da tela vazia


    halt




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

; Cenário base do jogo PING PONG
cenario1linha1:    string "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
cenario1linha2:    string "                   %                    "
cenario1linha3:    string "                   %                    "
cenario1linha4:    string "                   %                    "
cenario1linha5:    string "                   %                    "
cenario1linha6:    string "                   %                    "
cenario1linha7:    string "                   %                    "
cenario1linha8:    string "                   %                    "
cenario1linha9:    string "                   %                    "
cenario1linha10:   string "                   %                    "
cenario1linha11:   string "                   %                    "
cenario1linha12:   string "                   %                    "
cenario1linha13:   string "                   %                    "
cenario1linha14:   string "                   %                    "
cenario1linha15:   string "                   %                    "
cenario1linha16:   string "                   %                    "
cenario1linha17:   string "                   %                    "
cenario1linha18:   string "                   %                    "
cenario1linha19:   string "                   %                    "
cenario1linha20:   string "                   %                    "
cenario1linha21:   string "                   %                    "
cenario1linha22:   string "                   %                    "
cenario1linha23:   string "                   %                    "
cenario1linha24:   string "                   %                    "
cenario1linha25:   string "                   %                    "
cenario1linha26:   string "                   %                    "
cenario1linha27:   string "                   %                    "
cenario1linha28:   string "                   %                    "
cenario1linha29:   string "                   %                    "
cenario1linha30:   string "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
