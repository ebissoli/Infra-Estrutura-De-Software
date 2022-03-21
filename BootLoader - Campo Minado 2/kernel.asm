org 0x7e00
jmp 0x0000:start

data:
	
    ;Strings para o Menu
    stringTitle db 'CAMPO MINADO ASM',0
    stringPlay db 'Start(1)',0
    stringCredits db 'Creditos(2)',0
    stringGameOver db 'GAME OVER!', 0
    stringWinScreen db 'PARABENS, VOCE GANHOU!', 0
    stringPlacar db 'SCORE:XY/48',0
    stringYaxis db 'Coluna: 0Y',0
    stringXaxis db 'Linha: 0X',0

    posVirtual db 00h            ;Qual o atual index da matriz na legenda, considera matriz 8x8
    posReal db 00h               ;Qual o elemento dessas matriz campo
    ponto db 00h                 ;Se tirar programa crasha

    ;Matriz do campo minado 
    campoInicio     db 219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219,' ',219, 0 ;Esse 0 a mais sinaliza o fim!

    campoResposta   db '0',' ','0',' ','1',' ','1',' ','1',' ','0',' ','0',' ','0'
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db '0',' ','0',' ','1',' ',219,' ','1',' ','0',' ','1',' ','1'
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db '1',' ','1',' ','1',' ','1',' ','1',' ','0',' ','1',' ',219
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ','1',' ','1',' ','1',' ','1',' ','0',' ','1',' ','1'
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db '1',' ','1',' ','2',' ',219,' ','2',' ','0',' ','0',' ','0'
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db '0',' ','0',' ','2',' ',219,' ','2',' ','0',' ','0',' ','0'
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db '1',' ','1',' ','1',' ','1',' ','1',' ','1',' ','2',' ','2'
                    db ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
                    db 219,' ','1',' ','0',' ','0',' ','0',' ','1',' ',219,' ',219, 0

    ;Strings para os Creditos
    stringCreditsTitle db 'CREDITOS',0
    stringCredits1 db '<MATHEUS LAFAYETTE>',0
    stringCredits2 db '<ENZO BISSOLI>',0
    stringCredits3 db '<LUCAS MONTERAZO>',0

    stringEsc   db 'Press ESC to return...',0

    whiteColor equ 15
    redColor equ 4

strcmp:         ;Função que sera responsavel em corrigir o resultado!
                ; mov si, string1, mov di, string2
    .loop1:

        lodsb
        cmp al, byte[di]
            jne .notequal
        cmp al, 0
        je .equal
        inc di
        jmp .loop1

    .notequal:

        clc
        ret

    .equal:

        stc
        ret

    ;; Atualiza legendas com coordenadas atuais
updateCoord:
    pusha
    xor dx,dx
    xor ax, ax
    mov al,[posVirtual]
    mov bx, 08h                 ;quociente:ax, resto:dx
    div bx                      ;Divida valor de ax por 8, suponha 35, temos q=4 e r=3 isto é na quarta linha no terceiro elemento se encontra as coordenadas do cursor

    add dl, 48d                 ;Convertendo para ASCII a dezena
    add al, 48d

    mov bx, stringXaxis
    add bx, 08h                ;Primeiro 'X'
    mov [bx], byte al                ;0ah é a unidade

    mov bx, stringYaxis
    add bx, 09h                ;Primeiro 'Y'
    mov [bx],byte dl                ;0al é a unidade
    
    mov ah, 02h
	mov bh, 0
    mov bl, whiteColor
	mov dh, 20
	mov dl, 31
	int 10h
    mov si, stringXaxis
    call prints

    mov ah, 02h
	mov bh, 0
    mov bl, whiteColor
	mov dh, 21
	mov dl, 31
	int 10h
    mov si, stringYaxis
    call prints

    popa
    ret

clearTela:  ;Função para limpar a tela (mudar de tela)

    mov ah,00h   
    mov al,02h
    int 10h
    ret

putChar:    ;Função responsavel por printar um caracter

    mov ah, 0x0e
    int 10h
    ret

getChar:    ;Pega o caractere lido no teclado e salva em al

    mov AH, 0x00
    int 16h
    ret

prints: ;mov si, string (Vai printar a string que o SI esta apontando)

    .loop:

        lodsb               ; bota character apontado por si em al 
        cmp al, 0           ; 0 é o valor atribuido ao final de uma string
            je .endloop     ; Se for o final da string, acaba o loop
        call putChar        ; printa o caractere

        jmp .loop           ; volta para o inicio do loop

    .endloop:

        ret

printsCampo:               ; mov si, string (Vai printar a string que o SI esta apontando)


    xor cx, cx              ;Contador utilizado para pular as linhas!

    .loop:

        lodsb               ; bota character em SI para o AL 
        cmp al, 0
        je .endloop
        
        call putChar

        inc cx              ;Contando a quantidade de digitos
        cmp cx, 15          ;Se for igual a 15 precisa pular a linha
        je .putEndl

        jmp .loop

    .putEndl:

        xor cx, cx  ;       Zerando novamente o contador!     
        mov al, 13
        call putChar
        mov al, 10
        call putChar
        call colocaEspaco
        jmp .loop

    .endloop:
        call updateCoord

        ret

colocaEspaco:       ;Usada para centralizar o campo no meio da tela

    xor cx,cx

    .loop:

        cmp cx,32   ;Modificar esse número para centralização
            je .done

        mov al, ' '
        call putChar
        inc cx
        
        jmp .loop

    .done:

        xor cx,cx
        ret

    ;; Move cursor imaginário com atual posiçao da matriz campoInicio
moveCursor:
    push bp                     ;Frame pointer para acessar al
    mov bp, sp
    call getChar
    pusha                       ;Guarda valor de todos registradores no Stack, estamos interessados em al
    mov ax, [bp - 2]            ;Armazena al em ax para checar se input é wasd
    mov bx, [posVirtual]
    mov cx, [posReal]
    xor dx,dx               ;Garantir divisão correta

    cmp al, 77h                 ;Compara com 'w', cursor sobe
    je .movYUp
    cmp al, 73h
    je .movYDown

    cmp al, 61h                 ;Compara com 'a', movimento á esquerda
    je .movXLeft

    cmp al, 64h
    je .movXRight

    jmp exit

    ;; Movimento no eixo-Y?Se sim execute as instruções abaixo //COMENTAR
    .movY:
        .movYDown:              ;Queremos calcular (n+/- 8) mod 8, visto que nos dá a distância vertical isto é a(x)(k+1) - a(x)k = 8, para posVirtual, anaólogo para posReal, mas distância é 30d
                add bx ,8d
                add cx, 30d
                jmp .contY

        .movYUp:
                sub bx, 8d
                sub cx, 30d

    .contY:
        push cx
        xchg bx, ax
        mov cx, 64d
        idiv  cx                 ;Resultado de interesse em dl, idiv para não ter problema com o módulo
        mov [posVirtual], dl          ;Nova posição atual para legenda, coordY

        pop ax                  ;Atualizar posReal, atual endereço do elemento da matriz
        xor dx, dx
        mov bx, 225d            ;Matriz campoInicio/Resposta tem 225 elementos
        idiv bx
        mov [posReal], dx
        jmp exit

    ;; Movimento no eixo-X?Se sim execute as instruções abaixo
    .movX:
        .movXLeft:              ;Aqui queremos achar o próximo elewmento na sequência para posReal dado por [posReal] + 2d
            sub cx, 2h
            mov [posReal], cx
            sub bx, 1h
            jmp .contX

        .movXRight:
            add cx, 2h
            mov [posReal], cx
            add bx, 01h

    .contX:
        xchg bx, ax                 ;Resultado da expressão está em ax, (n +/- 1)
        mov cx, 08h
        idiv cx                     ;(n+1) mod 8, resultado em dl
        push dx

        xor dx,dx
        mov cx, [posVirtual]
        xchg cx, ax
        mov cx, 08h
        idiv cx                     ;Devemos achar o quociente e aplicar nessa fórmula (n+1) mod 8 + 8*quociente, análoga a superior, mas é a distância horizontal dada por a(x+1)k - a(x)k
        mul cx               ;al * 8
        pop dx               ;Temos aqui a primeira parcela
        add dx, ax                  ;(n+/-1) mod 8 + (n/8)*8
        mov [posVirtual], dl

    ;;     ;; Atualiza conteúdo da matriz dada nova posição do cursor
    exit:                               ;

        call getChar                    ;Checar conteúdo do quadrado
        cmp al, 20h             ;Apertou SPC
        je .interage
        jmp .exitCont

    .interage:
        call pontoOuBomba

    .exitCont:
        popa
        pop bp
        ret

    ;; Atualizar conteúdo de campoInicio
pontoOuBomba:
    mov cx, [posReal]           ;Posição que será acessada de ambos os campos
    mov si, campoResposta
    repne lodsb                 ;Repete o "traversal" de si cx vezes, até cx ativar ZF
    mov dx, [si]
    mov ax,dx
    ;Atualizando indíce da matriz atual
    mov cx, [posReal]
    mov si, campoInicio
    repne lodsb
    mov bx, si
    cmp dl, 219d                ;Checa se é bomba
    je gameOverScreen

    mov [bx], dx                ;Atualiza posição dada por posReal no campoInicio com conteúdo de campoResposta

    .scoreInc:                  ;Ganhou o jogo?
        mov si, campoInicio
        mov di, campoResposta
        call strcmp
        jc winScreen

    .exit2:
    ret

    ;; Imprime na tela uma string, PARAM:SI,DX
stringPlace:
    push bp
    mov bp, sp
    pusha
    ;Colocando string "stringCreditsTitle"
    mov bx, [bp - 4]
	mov ah, 02h  ;Permite que a gente coloque a string em alguma posicao da tela (set cursor)
	mov bh, 0    ;Pagina 0
	mov dx, [bp - 6]    ;dx no stack
	int 10h        ;realiza a interrupcao pra colocar o cursor na posicao
    mov si, [bp - 14]            ;si no stack
    call prints  ;printa a string (como antes selecionamos onde o cursor tava, ela ira printar nessa posicao)
    popa
    pop bp
    ret

    ;; Subrotina para "Ativar modo de vídeo"
render:
    call clearTela  ;Limpa a tela e escolhe o modo de video

    mov ah, 0bh ; inicia configuracao de background
    mov bh, 00h ; configuracao da cor do background
    mov bl, 01h ; azul escuro
    int 10h     ; interrupcao para executar as configuracoes dessas linhas acima
    ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    call menuScreen

menuScreen:
    call render
    mov bp, sp

    ;Colocando string "stringTitle"
    mov bl, 0ah   ;Cor da String em bl (verde clara)
	mov dh, 3    ;Linha
	mov dl, 33   ;Coluna
    mov si, stringTitle
    call stringPlace

    mov bl, whiteColor
	mov dh, whiteColor
	mov dl, 32
    mov si, stringPlay
    call stringPlace

	mov bh, 0
	mov dh, 20
	mov dl, 31
    mov si, stringCredits
    call stringPlace

    .selecao:

        call getChar

        cmp al, 49      ;Comparando com '1', reseta posVirtual,posReal e ponto
        mov bl, [ponto]
        mov [bx], byte 00h
        mov bx, posVirtual
        mov [bx], byte 00h
        mov bx, posReal
        mov [bx], byte 00h
        je playScreen
        
        cmp al, 50      ;Comparando com '2'
        je creditsScreen

        jmp .selecao

playScreen:   ;Aqui ficara toda a lógica do jogo!

    call render
    ;Colocando o campo
        mov ah, 02h  ;Permite que a gente coloque a string em alguma posicao da tela (set cursor)
        mov bh, 0    ;Pagina 0
        mov dh, 4    ;Linha
        mov dl, 32   ;Coluna
        int 10h 
        mov SI, campoInicio
        call printsCampo
        call moveCursor

    .retornoEsc:

        cmp al, 1Bh  ;Se ele receber o Esc volta para o Menu
        je menuScreen

        jmp playScreen

gameOverScreen:
    call render

	mov dh, 10
	mov dl, 35
    mov si, stringGameOver
    call stringPlace
    call getChar
    jmp creditsScreen
        mov si, campoInicio
        mov di, campoResposta
        call strcmp

winScreen:
    call render

	mov dh, 10
	mov dl, 35
    mov si, stringWinScreen  ;
    call stringPlace
    call getChar
    jmp creditsScreen

creditsScreen:
    call render

	mov dh, 10
	mov dl, 35   ;
    mov si, stringCreditsTitle
    call stringPlace

	mov dh, 16
	mov dl, 32
    mov si, stringCredits1
    call stringPlace

	mov dh, 17
	mov dl, 32
    mov si, stringCredits2
    call stringPlace

	mov dh, 18
	mov dl, 32
    mov si, stringCredits3
    call stringPlace

	mov dh, 29
	mov dl, 0
    mov si, stringEsc
    call stringPlace

    .retornoEsc:

        call getChar

        cmp al, 27  ;Se ele receber o Esc volta para o Menu
        je menuScreen

        jne .retornoEsc
jmp $
