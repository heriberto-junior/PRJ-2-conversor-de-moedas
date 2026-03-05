      IDENTIFICATION DIVISION.
       PROGRAM-ID. COIN.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MOEDAS ASSIGN TO "cotacao.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD MOEDAS.
       01 MOEDA-REG.
          05 COD-MOEDA    PIC X(3).
          05 INT-PARTE    PIC 9(3).
          05 FRAC-PARTE   PIC 9(5).

       WORKING-STORAGE SECTION.

       *> Argumentos recebidos

       01 WS-ARGUMENTO PIC X(100).
       01 LEN1          PIC 9(3).
       01 LEN2          PIC 9(3).
      
       01 WS-VALOR-TXT       PIC X(30).
       01 WS-DESTINO         PIC X(3).

       *> Normalização e conversão
       01 WS-VALOR-NORM      PIC X(30).
       01 WS-VALOR-NUM       PIC 9(10)V9(10).

       *> Leitura de moedas
       01 WS-TEMP-INT        PIC 9(10).
       01 WS-TEMP-FRAC       PIC 9(10).
       01 WS-TAXA            PIC 9(10)V9(10).

       *> Campo editado para exibir o valor final sem zeros à esquerda
       01 WS-VALOR-EDIT PIC ZZ9.999.
      
       01 EOF-FLAG           PIC X VALUE "N".
       01 FOUND-FLAG         PIC X VALUE "N".

       01 I                  PIC 9(3).

       PROCEDURE DIVISION.

       MAIN-START.

      *> Receber todos os argumentos da linha de comando do YAML
           ACCEPT WS-ARGUMENTO FROM COMMAND-LINE.
           
      *> Analisar os argumentos recebidos e separa em 2 campos
           UNSTRING WS-ARGUMENTO DELIMITED BY SPACE
               INTO WS-VALOR-TXT COUNT IN LEN1
                    WS-DESTINO COUNT IN LEN2
           END-UNSTRING.

           *> ---------------------------------------------------
           *> Validar caracteres: somente 0-9 . ,
           *> ---------------------------------------------------
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF WS-VALOR-TXT
              EVALUATE WS-VALOR-TXT(I:1)
                 WHEN "0" THRU "9"
                    CONTINUE
                 WHEN "."
                    CONTINUE
                 WHEN ","
                    CONTINUE
                 WHEN SPACE
                    CONTINUE
                 WHEN OTHER
                    DISPLAY "ERRO: Valor invalido. Use apenas numeros, ponto ou virgula."
                    STOP RUN
              END-EVALUATE
           END-PERFORM.

           *> Trocar vírgula por ponto
           MOVE WS-VALOR-TXT TO WS-VALOR-NORM.
           INSPECT WS-VALOR-NORM REPLACING ALL "," BY ".".

           *> Converter string → número
           COMPUTE WS-VALOR-NUM = FUNCTION NUMVAL(WS-VALOR-NORM).

           *> ---------------------------------------------------
           *> Ler arquivo moeda.txt
           *> ---------------------------------------------------
           OPEN INPUT MOEDAS.

           PERFORM UNTIL EOF-FLAG = "Y" OR FOUND-FLAG = "Y"
              READ MOEDAS
                 AT END MOVE "Y" TO EOF-FLAG
              END-READ

              IF EOF-FLAG NOT = "Y"
                 IF COD-MOEDA = WS-DESTINO
                    MOVE INT-PARTE  TO WS-TEMP-INT
                    MOVE FRAC-PARTE TO WS-TEMP-FRAC
                    COMPUTE WS-TAXA =
                       WS-TEMP-INT + (WS-TEMP-FRAC / 100000)
                    MOVE "Y" TO FOUND-FLAG
                 END-IF
              END-IF
           END-PERFORM.

           CLOSE MOEDAS.

           IF FOUND-FLAG NOT = "Y"
              DISPLAY "ERRO: Moeda nao encontrada."
              STOP RUN
           END-IF.

           *> ---------------------------------------------------
           *> Calcular conversão
           *> ---------------------------------------------------
           *> Calcular conversão
           COMPUTE WS-VALOR-NUM ROUNDED = WS-VALOR-NUM * WS-TAXA.

           *> Mover para o campo editado (aplica máscara ZZ9.999)
           MOVE WS-VALOR-NUM TO WS-VALOR-EDIT.

           *> Exibir no formato desejado
           DISPLAY "Resultado: " WS-VALOR-EDIT " " WS-DESTINO.

           STOP RUN.

