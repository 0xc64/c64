1 REM Program: test.bas
2 REM About: Cycle screen colour in BASIC
3 REM
10 LET c = 0
20 POKE 53281, C
30 C = C + 1 AND 255
40 GOTO 20
