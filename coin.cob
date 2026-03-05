IDENTIFICATION DIVISION.
       PROGRAM-ID. CONVERTER.

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
       01 WS-ARG1         PIC X(30).
       01 WS-ARG2         PIC X(10).

       01 WS-VALOR-TXT    PIC X(30).
       01 WS-VALOR-NORM   PIC X(30).
       01 WS-VALOR        PIC 9(10)V9(10).
       01 WS-DESTINO      PIC X(3).

       01 WS-TAXA-ENCONTRADA   PIC 9(10)V9(10).
       01 WS-TEMP-INT          PIC 9(10).
       01 WS-TEMP-FRAC         PIC 9(10).

       01 FLAG-FOUND      PIC X VALUE "N".

       01 I               PIC 9(3).

       PROCEDURE DIVISION.

       MAIN-START.
           ACCEPT WS-VALOR-TXT FROM ARGUMENT-VALUE.
           ACCEPT WS-DESTINO   FROM ARGUMENT-VALUE.

      *---------------------------------------------------------
      * VALIDAR INPUT – PERMITIR SOMENTE: 0–9 . ,
      *---------------------------------------------------------
           MOVE ZERO TO I.
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

      * Trocar vírgula por ponto
           MOVE WS-VALOR-TXT TO WS-VALOR-NORM.
           INSPECT WS-VALOR-NORM REPLACING ALL "," BY ".".

      * Converter para número
           COMPUTE WS-VALOR = FUNCTION NUMVAL(WS-VALOR-NORM).

      *---------------------------------------------------------
      * Ler arquivo de moedas
      *---------------------------------------------------------
           OPEN INPUT MOEDAS.

           PERFORM UNTIL FLAG-FOUND = "Y" OR EOF
              READ MOEDAS
                 AT END MOVE "Y" TO EOF
              END-READ

              IF COD-MOEDA = WS-DESTINO
                 MOVE INT-PARTE  TO WS-TEMP-INT
                 MOVE FRAC-PARTE TO WS-TEMP-FRAC
                 COMPUTE WS-TAXA-ENCONTRADA =
                     WS-TEMP-INT + (WS-TEMP-FRAC / 100000)
                 MOVE "Y" TO FLAG-FOUND
              END-IF
           END-PERFORM.

           CLOSE MOEDAS.

           IF FLAG-FOUND NOT = "Y"
              DISPLAY "ERRO: Moeda nao encontrada."
              STOP RUN
           END-IF.

      *---------------------------------------------------------
      * Calcular conversão
      *---------------------------------------------------------
           COMPUTE WS-VALOR = WS-VALOR * WS-TAXA-ENCONTRADA.

           DISPLAY "RESULTADO: " WS-VALOR.

           STOP RUN.
