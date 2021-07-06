# PingPongAssemblyICMC
Esse projeto consiste em um jogo de Ping Pong feito em Assembly para rodar no processador do ICMC. Este processador possui arquitetura Risc e utilizamos seu 
suporte para entrada e saída de dados para realizar a lógica do jogo

## Link para o video de explicação

Link aqui

## Funcionalidades de cada Arquivo

### Pong_mk2.asm
Código mais atualizado do Jogo

### Charmap.mif
Mapa de caracteres utilizados para impressão do jogo no simulador

### Pong.mif
Executável do jogo no simulador do ICMC

### Pong.asm
Versão antiga do jogo (não precisa olhar esse arquivo)

## Como o jogo funciona?

Para rodar o jogo, você deve utilizar o simulador da arquitetura, que está presente [aqui](https://github.com/simoesusp/Processador-ICMC).
Como o .mif já está no projeto, você só precisa rodar ./sim pong.mif charmap.mif e jogar!

Imagem 1 aqui

Ao iniciar o simulador, você irá se deparar com esta tela, que é o início do jogo. Basta clicar qualquer tecla e continuar

Imagem 2 aqui

O jogo possui a interface da imagem acima. Nele, os jogadores se movimentam para cima e para baixo para rebater a bolinha e marcar pontos no adversário.
Uma partida acaba quando alguém marca 3 pontos.

### Controles

Para movimentar o jogador da esquerda, são utilizadas as teclas 'W' e 'S', sendo 'W' para subir o jogador e 'S' para descer o mesmo. Para o jogador da direita,
são utilizadas as teclas 'I' e 'K', sendo 'I' para cima e 'K' para baixo.

### Bolinha

A bolinha se movimenta apenas em direções inclinadas, ou seja, a bolinha sempre possui uma velocidade diferente de 0 em relação aos eixos x e y.
Ela rebate e muda de direção ao encontrar as bordas superior e inferior do cenário ou ao encontrar um dos jogadores.

### Pontuação

Para um ponto ser computado, a bolinha deve passar a coordenada x de um dos jogadores, computando o ponto para o adversário.
Quando um ponto é marcado, a bolinha é reposicionada no meio e a rodada se reinicia.

Imagem 3 aqui

A imagem acima é mostrada quando um dos jogadores marca 3 pontos, indicando o vencedor e solicitando a entrada de um ENTER para reiniciar o jogo.

# Colaboradores

[João Pedro Favoretti](https://github.com/joaofavoretti)

[Lucas Pilla](https://github.com/LucasPilla)

[Ciro Grossi Falsarella](https://github.com/cirofalsarella)

[Gabriel Vicente Rodrigues](https://github.com/gabriel-vr/)
