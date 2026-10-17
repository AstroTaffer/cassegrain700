PROGRAM REGSEP2015; {ДЛЯ 24 ПРОПУСКОВ И БЕЗ СЧЕТЧИКА Ф5007,
             ПРОГРАММА ДЛЯ СВОБОДНОГО ПАСКАЛЯ И БЫСТРЫХ КОМПЬЮТНРОВ}

USES CRT,PORTS;

LABEL M1,M2,M3,M4,M5,M6,
      ZA1,ZA2,ZA3,Z01,Z02,Z03,KON;

CONST F = 'A';    {ФАЙЛ С НАЧАЛЬНЫМИ УСТАНОВКАМИ}
CONST FFF = 'A2';   {ФАЙЛ С НАЧАЛЬНЫМИ УСТАНОВКАМИ ДЛЯ BVR}
CONST FF = 'B';   {ФАЙЛ С ИМЕНАМИ ФАЙЛОВ ДЛЯ АВТОМАТИЧЕСКОЙ ЗАПИСИ}
CONST KO = 14000; {СКОРОСТЬ ПО АЛЬФА, ИЗМ. КОЭФФИЦИЕНТА НА 0.25 ЗА 1400 С ПРИ СКОРОСТИ 1}
CONST KD = 400{600};

VAR
   A:             ARRAY[1..6,1..3200] OF WORD;
   NAMEAFT:       ARRAY[1..96] OF STRING[11];
   NAME:          STRING[11];
   NAMEZ:         STRING[11];
   NAMEFILE:      STRING[11];
   FILEDATA:      TEXT;
   FILEFILE:      TEXT;
   BASE:          WORD;
   MODE:          BYTE;
   B1,B2,B3,B4:   BYTE;    {БИТЫ}
   R,R1,R2,R3,R4: BYTE;    {ПОЛУБАЙТЫ}
   W,W1,W2,W3,W4,W5,W6: WORD;    {КАНАЛЫ}
   N3:            BYTE;    {НОМЕРА КАНАЛОВ 0,4,8,12}
   N1,N2:         BYTE;    {МАСШТАБНЫЕ КОЭФФИЦИЕНТЫ}
   KANAL:         BYTE;    {ВЫВОД НА САМОПИСЕЦ}
   N:             BYTE;    {НОМЕР ЗАПИСИ}
   F1,F2,F3,F4,F5,F6:   WORD;    {ФОН}
   T1,T2,T3,T4:   BYTE;    {ЧАСЫ, МИНУТЫ, СЕКУНДЫ, ДЕСЯТЫЕ СЕКУНД}
   T:             REAL;    {ВРЕМЯ В СЕКУНДАХ}
   T5:            REAL;    {ВРЕМЯ УСТАНОВКИ ЧАСОВОГО УГЛА}
   U:             REAL;    {НАЧАЛЬНЫЕ СЕКУНДЫ}
   US:            REAL;    {ВРЕМЯ СЧЕТЧИКА}
   UN:            REAL;    {ВРЕМЯ НАЧАЛА ИЗМЕРЕНИЯ}
   UK:            REAL;    {ВРЕМЯ КОНЦА ИЗМЕРЕНИЯ}
   UF:            REAL;    {ВРЕМЯ ФОНА}
   UD:            REAL;    {ВРЕМЯ ДЕЛИТЕЛЯ}
   UDEL:          REAL;    {ВРЕМЯ ДЕЛЬТА}
   BA:            BYTE;    {СКОРОСТЬ ПО АЛЬФА}
   H:             BYTE;    {НАПРАВЛЕНИЕ ПО АЛЬФА}
   BD:            BYTE;    {СКОРОСТЬ ПО ДЕЛЬТА}
   FAZA:          BYTE;    {НАЧАЛЬНАЯ ФАЗА ЧЕРВЯКА}
   FAZA1:         BYTE;    {ТЕКУЩАЯ ФАЗА ЧЕРВЯКА}
   ZS:            BYTE;    {РАЗРЕШЕНИЕ ЗВУКОВОГО СИГНАЛА}
   Y:             REAL;    {НАЧАЛЬНЫЙ ЧАСОВОЙ УГОЛ}
   Y1,Y2:         BYTE;    {ЧАСЫ И МИНУТЫ ЧАСОВОГО УГЛА}
   I1:            INTEGER; {НОМЕРА И НАПРАВЛЕНИЕ ШД}
   I:             INTEGER; {СЧЕТЧИК ЦИКЛОВ}
   IS:            INTEGER; {СЧЕТЧИК ЦИКЛОВ}
   J:             INTEGER; {СЧЕТЧИК ЦИКЛОВ}
   II:            INTEGER; {СЧЕТЧИК ЦИКЛОВ}
   JJ:            INTEGER; {СЧЕТЧИК ЦИКЛОВ}
   K:             BYTE;    {КОМАНДА}
   KI:            INTEGER; {ИМПУЛЬСЫ "КОНЕЦ ИЗМЕРЕНИЯ"}
   TI:            INTEGER; {ТАКТОВЫЕ ИМПУЛЬСЫ}
   Z1,Z2:         INTEGER; {ЗВУК}
   S:             INTEGER; {СЧЕТЧИК}
   D:             REAL;    {КОЭФФИЦИЕНТ ДЕЛЕНИЯ}
   DP:            REAL;    {КОЭФФИЦИЕНТ ДЕЛЕНИЯ ИСПРАВЛЕННЫЙ}
   A3:            BYTE;    {ОСТАНОВ = 1}
   AM:            REAL;    {АМПЛИТУДА КОМПЕНСАЦИИ ПЕРИОДА}
   NST:           WORD;    {К-ВО ШАГОВ ШД}
   RA:            BYTE;    {1 ПОСЛЕ ПРИВЯЗКИ ВРЕМЕНИ}
   RAN:           BYTE;    {НОМЕР ПРИВЯЗКИ ВРЕМЕНИ}
   G:             BYTE;    {ГИД 8421}
   FO:            WORD;
   FO1:           REAL;
   NN:            INTEGER;    {ЦИКЛ ГИДА}
   KZ,KZ1:        INTEGER;    {КОЭФФИЦИЕНТ ДЛЯ ЯРКОЙ ЗВЕЗДЫ}
   B5,B6:         INTEGER;       {СКОРОСТИ ПО ДЕЛЬТА И АЛЬФА}
   NG:            INTEGER;       {СИГНАЛ ГИДИРОВАНИЯ}
   PERE:          BYTE;
   DELL:          BYTE;
   FOK1,FOK2:     BYTE;
   TRE1,TRE2:     WORD;
   ALC:           BYTE;
   ALSK:          REAL;
   A1,A2:         BYTE;
   KOMPA:         BYTE;     {РАЗРЕШЕНИЕ КОМПЕНСАЦИИ}
   KOMPD:         BYTE;     {РАЗРЕШЕНИЕ КОМПЕНСАЦИИ}
   SKOD:          INTEGER;     {CКОРОСТЬ КОМПЕНСАЦИИ ПО ДЕЛЬТА}
   FI:            BYTE;        {1,2 - ДВИГАТЕЛИ ФИЛЬТРОВ}
   NFI{1,NFI2}:     BYTE;        {НОМЕРА ФИЛЬТРОВ}
   NAPF:          BYTE;        {0,8 - НАПРАВЛЕНИЕ ФИЬТРОВ}
   OFI:           WORD;  {НОМЕР ОТСЧЕТА ДЛЯ ФИЛЬТРА}
   ZF:            WORD;  {ЦИКЛ СМЕНЫ ФИЛЬТРОВ}
   D1,D2:         BYTE;  {ДЫРЫ ФИЛЬТРОВ}
   TFI:           WORD;  {ВРЕМЯ ФИЛЬТРА}
   NFF:           BYTE;  {НОМЕР ФИЛЬТРА ДЛЯ ФОНА}
   REN:           BYTE;  {КОЛИЧЕСТВО АВТ. ИЗМЕРЕНИЙ (64)}


PROCEDURE ZWET1;
   BEGIN;
   TEXTCOLOR(11);
   TEXTBACKGROUND(3);
   END;

PROCEDURE ZWET2;
  BEGIN;
  TEXTCOLOR(11);
  TEXTBACKGROUND(1);
  END;

  PROCEDURE ZWET3;
  BEGIN;
  TEXTCOLOR(11);
  TEXTBACKGROUND(2);
  END;

PROCEDURE EX;
   BEGIN;
   PORT[BASE]:=A[4,3101];
   PORT[BASE+2]:=0;
   PORT[BASE+2]:=10;
   PORT[BASE+2]:=0;
   END;

PROCEDURE ZAPIS;
   LABEL M1, M2;
   VAR M: BYTE;
   BEGIN;
   M:=0;
M1:
   M:=M+1;
   IF M=3 THEN GOTO M2;
   PORT[BASE+2]:=0;
   PORT[BASE+2]:=K;
   PORT[BASE+2]:=0;
   GOTO M1;
M2: EX;
   END;

PROCEDURE RES;
   BEGIN;
   R:=PORT[BASE+1];
   R:=R SHL 1;
   R:=R SHR 4;
   END;

PROCEDURE BIT;
   BEGIN;
   RES;
   B4:=R SHL 4;
   B4:=B4 SHR 7;
   B3:=R SHL 5;
   B3:=B3 SHR 7;
   B2:=R SHL 6;
   B2:=B2 SHR 7;
   B1:=R SHL 7;
   B1:=B1 SHR 7;
  { WRITE(B4,B3,B2,B1,'    '); }
   END;

PROCEDURE BITIN;
   BEGIN;
   RES;
   R:=15-R;
   B4:=R SHL 4;
   B4:=B4 SHR 7;
   B3:=R SHL 5;
   B3:=B3 SHR 7;
   B2:=R SHL 6;
   B2:=B2 SHR 7;
   B1:=R SHL 7;
   B1:=B1 SHR 7;
   END;

PROCEDURE OST;
   BEGIN;
   PORT[BASE]:=38;
   K:=1;
   ZAPIS;
   BITIN;
   END;

PROCEDURE TUM;
  BEGIN;
  PORT[BASE]:=52;
  K:=1;
  ZAPIS;
  BITIN;
  END;

PROCEDURE WRERA;
   LABEL M1,M2,M3;
   VAR
       T5: BYTE;
       U1,U2: REAL;
       U3,U4: INTEGER;
       I1,J1,K1: REAL;
   BEGIN;
M3:
   I1:=A[1,3103]; J1:=A[2,3103]; K1:=A[3,3103];
   U:=I1*60*60+J1*60+K1;
   U:=U*10;
   K:=1;
   PORT[BASE]:=56;
   ZAPIS;
   RES;
   T5:=R;
   PORT[BASE]:=57;
   ZAPIS;
   RES;
   T4:=R;
   PORT[BASE]:=58;
   ZAPIS;
   RES;
   T3:=R;
   PORT[BASE]:=59;
   ZAPIS;
   RES;
   T2:=R;
   PORT[BASE]:=60;
   ZAPIS;
   RES;
   T1:=R;
   U3:=T5+T4*16+T3*16*16;
   U4:=T2+T1*16;
   U2:=U4;
   U1:=U3;
   U1:=U1+U2*16*16*16;
   US:=U1;
   {GOTOXY(5,4); WRITELN('ВРЕМЯ СЧЕТЧИКА ',U1:8:1);}
   U1:=U+U1;
   U1:=U1/10;
   T:=U1;
   T1:=TRUNC(U1/3600);
   U1:=U1/3600-T1;
   T2:=TRUNC(U1*60);
   U1:=U1*60-T2;
   T3:=TRUNC(U1*60);
   U1:=U1*60-T3;
   U1:=U1*10;
   T4:=TRUNC(U1);
   IF T1>23 THEN GOTO M1;
   GOTO M2;
M1: T1:=T1-24;
M2:
   GOTOXY(5,5);
   CLREOL; TEXTCOLOR(3+RAN); WRITELN('ВРЕМЯ     ',T1,'Ч ',T2,'М ',T3,'С, ',T4,'     ');
   END;

PROCEDURE RADIO;

  LABEL M1;
  BEGIN;
  TUM;
  IF B2=1 THEN GOTO M1;
  IF RA=1 THEN GOTO M1;
  PORT[BASE]:=44;
  K:=1;
  ZAPIS;
  BITIN;
  {WRITELN(B1,B2,B3,B4);}
  IF B2=1 THEN GOTO M1;
  WRERA;
  A[1,3185+RAN]:=T1; A[2,3185+RAN]:=T2; A[3,3185+RAN]:=T3; A[4,3185+RAN]:=T4;
  A[1,3184]:=A[1,3100]; A[2,3184]:=A[2,3100];
  A[3,3184]:=A[3,3100]; A[4,3184]:=A[4,3100];
  RA:=1;
  RAN:=RAN+1;
M1:
  {WRITELN('RA');}
  DELAY(10);
  END;

PROCEDURE WORD;
   BEGIN;
   K:=1;
   PORT[BASE]:=N3;
   ZAPIS;
   RES;
   R1:=R;
   PORT[BASE]:=N3+1;
   ZAPIS;
   RES;
   R2:=R;
   PORT[BASE]:=N3+2;
   ZAPIS;
   RES;
   R3:=R;
   PORT[BASE]:=N3+3;
   ZAPIS;
   RES;
   R4:=R;
   W:=R1+R2*16+R3*16*16+R4*16*16*16;
   END;



PROCEDURE EXP;
   LABEL M0;
   VAR N: BYTE;
       N1: REAL;
   BEGIN;
M0:
   GOTOXY(5,5);
   WRITE ('  ЭКСПОЗИЦИЯ СЧЕТА N * 0.1 С, N=?  ');
   READLN (N);
   PORT[BASE]:=N;
   K:=10;
   ZAPIS;
   A[4,3101]:=N;
   N1:=A[4,3101];
   N1:=N1/10;
   GOTOXY(5,10);
   WRITELN('  ЭКСПОЗИЦИЯ СЧЕТА  ',N1:1:1,' C');
   WRITELN('');
   WRITE('      ПОВТОРИТЬ ? ');
   READLN(I);
   IF I=1 THEN GOTO M0;
   END;



   PROCEDURE CANALI;
   BEGIN;
   N3:=0;
   WORD;
   W1:=W;
   N3:=4;
   WORD;
   W2:=W;
   N3:=8;
   WORD;
   W3:=W;
   N3:=12;
   WORD;
   W4:=W;
   N3:=16;
   WORD;
   W5:=W;
   N3:=20;
   WORD;
   W6:=W;
   {WRITELN (I,'    ',W1,'   ',W2,'   ',W3,'   ',W4,'   ',W5,'   ',W6);}
   END;

PROCEDURE KII;
   LABEL M1;
   VAR K1: BYTE;
   BEGIN;
   PORT[BASE]:=KI;
   K:=2;
   ZAPIS;
   K:=3;
   ZAPIS;
M1:
   DELAY(1);
   K1:=PORT[BASE+1];
   K1:=K1 SHR 7;
   IF K1=0 THEN GOTO M1;
   END;

PROCEDURE KII2;
   LABEL M1;
   VAR K1: BYTE;
   BEGIN;
   PORT[BASE]:=KI;
   K:=2;
   ZAPIS;
   K:=3;
   ZAPIS;
M1:
   DELAY(1);
   RADIO;
   K1:=PORT[BASE+1];
   K1:=K1 SHR 7;
   IF K1=0 THEN GOTO M1;
   END;


PROCEDURE KI1;
   BEGIN;
   KI:=0;
   KII;
   END;

PROCEDURE KI2;
   BEGIN;
   KI:=1;
   KII2;
   END;

PROCEDURE KI3;
   BEGIN;
   KI:=2;
   KII;
   END;

PROCEDURE KI4;
   BEGIN;
   KI:=3;
   KII;
   END;

PROCEDURE TI1P;
   BEGIN;
   PORT[BASE]:=0;
   K:=7;
   ZAPIS;
   END;

PROCEDURE TI1;
   LABEL M1;
   BEGIN;
   PORT[BASE+2]:=6;
   PORT[BASE+2]:=0;
   PORT[BASE]:=52;
   K:=1;
   ZAPIS;
M1:
   R:=PORT[BASE+1];
   R:=R SHL 1;
   R:=R SHR 4;
   B1:=R SHL 7;
   B1:=B1 SHR 7;
   IF B1=0 THEN GOTO M1;
   END;

PROCEDURE TII;
   LABEL M1;
   BEGIN;
   PORT[BASE]:=TI;
   K:=7;
   ZAPIS;
   K:=6;
   ZAPIS;
   PORT[BASE]:=52;
   K:=1;
   ZAPIS;
M1:
   BIT;
   IF B1=0 THEN GOTO M1;
   END;


PROCEDURE TI3;
   BEGIN;
   TI:=2;
   TII;
   END;


PROCEDURE TISHDR;
   BEGIN;
   TI1P;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;{TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;}
   END;

PROCEDURE TISHDA;
   BEGIN;
   TI1P;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   END;

PROCEDURE UMASH;
   BEGIN;
   PORT[BASE]:=1;
   K:=14;
   ZAPIS;
   END;

PROCEDURE UKLAW;
   BEGIN;
   PORT[BASE]:=0;
   K:=14;
   ZAPIS;
   END;

PROCEDURE SHAG;
   BEGIN;
   PORT[BASE+2]:=0;
   PORT[BASE+2]:=5;
   PORT[BASE+2]:=0;
   END;

PROCEDURE SHAGL;
   BEGIN;
   PORT[BASE+2]:=0;
   PORT[BASE+2]:=5;
   delay(2);
   PORT[BASE+2]:=0;
   END;

PROCEDURE SHAG1;
   LABEL M1,M2;
   VAR J: INTEGER;
   BEGIN;
   UMASH;
   J:=0;
M1:
   J:=J+1;
   PORT[BASE]:=I1;
   K:=4;
   ZAPIS;
   SHAG;
   TISHDR;
   IF J=1 THEN GOTO M2;
   GOTO M1;
M2:
   UKLAW;
   END;


PROCEDURE ALFAPLUS1;
   BEGIN;
   I1:=15;
   SHAG1;
   A1:=A1+1;
   END;

PROCEDURE ALFAMINUS1;
   BEGIN;
   I1:=7;
   SHAG1;
   A2:=A2+1;
   END;

PROCEDURE SHAG300;
   LABEL M1, M2;
   VAR J: INTEGER;
   BEGIN;
   UMASH;
   J:=0;
M1:
   J:=J+1;
   PORT[BASE]:=I1;
   K:=4;
   ZAPIS;
   SHAG;
   TISHDR;
   IF J=250 THEN GOTO M2;
   GOTO M1;
M2:
   DELAY(300);
   UKLAW;
   END;

PROCEDURE SHAGN;
   LABEL M1, M2;
   VAR J: INTEGER;
   BEGIN;
   UMASH;
   J:=0;
M1:
   J:=J+1;
   PORT[BASE]:=I1;
   K:=4;
   ZAPIS;
   SHAG;
   TISHDR;
   IF J=NST THEN GOTO M2;
   GOTO M1;
M2:
   DELAY(300);
   UKLAW;
   END;

PROCEDURE ALFAPLUS300;
   BEGIN;
   I1:=15;
   SHAG300;
   END;

PROCEDURE ALFAMINUS300;
   BEGIN;
   I1:=7;
   SHAG300;
   END;

PROCEDURE DELTAPLUS300;
   BEGIN;
   I1:=14;
   SHAG300;
   END;

PROCEDURE DELTAMINUS300;
   BEGIN;
   I1:=6;
   SHAG300;
   END;

PROCEDURE ALFAPLUSN;
   BEGIN;
   I1:=15;
   SHAGN;
   END;

PROCEDURE ALFAMINUSN;
   BEGIN;
   I1:=7;
   SHAGN;
   END;

PROCEDURE DELTAPLUSN;
   BEGIN;
   I1:=14;
   SHAGN;
   END;

PROCEDURE DELTAMINUSN;
   BEGIN;
   I1:=6;
   SHAGN;
   END;

PROCEDURE DELTAPLUS;
   BEGIN;
   UMASH;
   PORT[BASE]:=14;
   K:=4;
   ZAPIS;
   SHAG;
   DELAY(2);
   UKLAW;
   END;

PROCEDURE DELTAMINUS;
   BEGIN;
   UMASH;
   PORT[BASE]:=6;
   K:=4;
   ZAPIS;
   SHAG;
   DELAY(2);
   UKLAW;
   END;


PROCEDURE FOKUSPLUS;
   BEGIN;
   UMASH;
   PORT[BASE]:=12;
   K:=4;
   ZAPIS;
   I:=0;
   REPEAT
   SHAGL;
   I:=I+1;
   FO:=FO+1;
   UNTIL I=FOK2;
   UKLAW;
   END;

PROCEDURE FOKUSMINUS;
   BEGIN;
   UMASH;
   PORT[BASE]:=4;
   K:=4;
   ZAPIS;
   I:=0;
   REPEAT
   SHAGL;
   I:=I+1;
   FO:=FO-1;
   UNTIL I=FOK2;
   UKLAW;
   END;

PROCEDURE FOKUSPLUS05;
   BEGIN;
   UMASH;
   PORT[BASE]:=12;
   K:=4;
   ZAPIS;
   I:=0;
   REPEAT
   SHAGL;
   I:=I+1;
   FO:=FO+1;
   UNTIL I=FOK1;
   UKLAW;
   END;

PROCEDURE FOKUSMINUS05;
   BEGIN;
   UMASH;
   PORT[BASE]:=4;
   K:=4;
   ZAPIS;
   I:=0;
   REPEAT
   SHAGL;
   I:=I+1;
   FO:=FO-1;
   UNTIL I=FOK1;
   UKLAW;
   END;


PROCEDURE KON4_1;
   BEGIN;
   PORT[BASE]:=48;
   K:=1;
   ZAPIS;
   BIT;
   END;

PROCEDURE KON4_2;
   BEGIN;
   PORT[BASE]:=49;
   K:=1;
   ZAPIS;
   BIT;
   END;

PROCEDURE WWOD1;
   LABEL M1,M2;
   VAR J: INTEGER;
   BEGIN;
   J:=0;
M1:
   KON4_1;
   IF B1=0 THEN GOTO M2;
   PORT[BASE]:=0;
   K:=4;
   ZAPIS;
   SHAG;
   TISHDA{TI3};
   J:=J+1;
   GOTO M1;
M2:
   WRITELN('    ПОДСМОТР 1 ВВЕДЕН    ',J);
   END;


PROCEDURE WIWOD1;
   LABEL M1,M2;
   VAR J: INTEGER;
   BEGIN;
   J:=0;
M1:
   KON4_1;
   IF B2=0 THEN GOTO M2;
   PORT[BASE]:=8;
   K:=4;
   ZAPIS;
   SHAG;
   TISHDA{TI3};
   J:=J+1;
   GOTO M1;
M2:
   WRITELN('    ПОДСМОТР 1 ВЫВЕДЕН   ',J);
   END;

PROCEDURE WWOD2;
   LABEL M1,M2;
   VAR J: INTEGER;
   BEGIN;
   J:=0;
M1:
   KON4_1;
   IF B3=0 THEN GOTO M2;
   PORT[BASE]:=1;
   K:=4;
   ZAPIS;
   SHAG;
   TISHDA{TI3};
   J:=J+1;
   GOTO M1;
M2:
   WRITELN('    ПОДСМОТР 2 ВВЕДЕН    ',J);
   END;


PROCEDURE WIWOD2;
   LABEL M1,M2;
   VAR J: INTEGER;
   BEGIN;
   J:=0;
M1:
   KON4_1;
   IF B4=0 THEN GOTO M2;
   PORT[BASE]:=9;
   K:=4;
   ZAPIS;
   SHAG;
   TISHDA{TI3};
   J:=J+1;
   GOTO M1;
M2:
   WRITELN('    ПОДСМОТР 2 ВЫВЕДЕН   ',J);
   END;



PROCEDURE SHAGFIL1P;
BEGIN;
   PORT[BASE]:=2+NAPF;
   K:=4;
   ZAPIS;
   TI1P;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;

   TI1;TI1;TI1;{TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;}

  SHAG;
END;

PROCEDURE SHAGFIL2P;
BEGIN;
   PORT[BASE]:=3+NAPF;
   K:=4;
   ZAPIS;
   TI1P;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;

   TI1;TI1;TI1;{TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;
   TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;TI1;}

   SHAG;
END;

PROCEDURE SHAGFIL1L;
BEGIN;
   NAPF:=8;
   SHAGFIL1P;
   NAPF:=0;
END;

PROCEDURE SHAGFIL2L;
BEGIN;
   NAPF:=8;
   SHAGFIL2P;
   NAPF:=0;
END;


PROCEDURE NUFIL1;
   LABEL M1,M2;
   VAR J: INTEGER;
   BEGIN;
   FOR J:=1 TO 30 DO SHAGFIL1P;

M1:
   KON4_2;
   IF B1=0 THEN GOTO M2;
   SHAGFIL1P;
   J:=J+1;
   GOTO M1;

M2:
   D1:=J;
   {WRITELN('    ДЫРА 1 УСТАНОВЛЕНА  ',J);
   delay(1);}
   END;

PROCEDURE NUFIL2;
   LABEL M1,M2;
   VAR J: INTEGER;
   BEGIN;
   FOR J:=1 TO 30 DO SHAGFIL2P;

M1:
   KON4_2;
   IF B3=0 THEN GOTO M2;
   SHAGFIL2P;
   J:=J+1;
   GOTO M1;
M2:
   D2:=J;
   {WRITELN('    ДЫРА 2 УСТАНОВЛЕНА  ',J);
   delay(1);}
   END;



PROCEDURE NFIL;
   VAR I,J: INTEGER;
   FILTR: CHAR;
   BEGIN;
   J:=NFI*32{33};
   NUFIL1;
   FOR I:=1 TO J DO SHAGFIL1P;
   {delay(200);}
   NUFIL2;
   FOR I:=1 TO J DO SHAGFIL2P;
   IF NFI=5 THEN FILTR:='U';
   IF NFI=4 THEN FILTR:='B';
   IF NFI=3 THEN FILTR:='V';
   IF NFI=2 THEN FILTR:='R';
   IF NFI=1 THEN FILTR:='I';
   IF NFI=0 THEN FILTR:='О';
   WRITELN('   ФИЛЬТР     ',FILTR);
   END;

PROCEDURE FB;
   VAR I,J: INTEGER;
   BEGIN;
   NFI:=4;
   J:=NFI*32{33};
   NUFIL1;
   FOR I:=1 TO J DO SHAGFIL1P;
   {delay(200);}
   NUFIL2;
   FOR I:=1 TO J DO SHAGFIL2P;
   DELAY(500);
   END;

PROCEDURE FV;
   VAR I,J: INTEGER;
   BEGIN;
   NFI:=3;
   J:=NFI*32{33};
   NUFIL1;
   FOR I:=1 TO J DO SHAGFIL1P;
   {delay(200);}
   NUFIL2;
   FOR I:=1 TO J DO SHAGFIL2P;
   DELAY(500);
   END;

PROCEDURE FR;
   VAR I,J: INTEGER;
   BEGIN;
   NFI:=2;
   J:=NFI*32{33};
   NUFIL1;
   FOR I:=1 TO J DO SHAGFIL1P;
   {delay(200);}
   NUFIL2;
   FOR I:=1 TO J DO SHAGFIL2P;
   DELAY(500);
   END;

PROCEDURE FUR;
   VAR I,J: INTEGER;
   BEGIN;
   NFI:=1;
   J:=NFI*32{33};
   NUFIL1;
   FOR I:=1 TO J DO SHAGFIL1P;
   {delay(200);}
   NUFIL2;
   FOR I:=1 TO J DO SHAGFIL2P;
   DELAY(500);
   END;

PROCEDURE MAXSAM;
   BEGIN;
   PORT[BASE]:=235;
   K:=9;
   ZAPIS;
   END;

PROCEDURE MINSAM;
   BEGIN;
   PORT[BASE]:=20;
   K:=9;
   ZAPIS;
   END;

PROCEDURE NSAM;
   LABEL M1;
   VAR I: BYTE;
       N: INTEGER;
   BEGIN;
M1:
   GOTOXY(5,5);
   WRITE('ОТСЧЕТ (0-235) ?   ');
   READ(N);
   N:=N+20;
   PORT[BASE]:=N;
   K:=9;
   ZAPIS;
   GOTOXY(5,7);
   WRITE('ПОВТОРИТЬ ?   ');
   READ(I);
   IF I=1 THEN GOTO M1;
   END;

PROCEDURE MASHSAM;
   LABEL M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,M13,M14,M15,M16;
   VAR I,J: BYTE;
   BEGIN;
M13:
   N1:=0;
   N2:=0;
   CANALI;
   CLRSCR;
   GOTOXY(2,3);
   WRITELN('  КАНАЛЫ  ',W1,'  ',W2,'  ',W3,'  ',W4,'  ',W5,'  ',W6);
   WRITELN('');
   WRITE('   МАСШТАБ МАЛЫЙ - 0, БОЛЬШОЙ - 1 ?  ');
   READ(J);
   WRITELN('');
   WRITE('   МАСШТАБ САМОПИСЦА ПО КАНАЛУ 1,2,3,4,5,6 ?  ');
   READ(I);
   WRITELN('');
   CANALI;
   WRITELN(I);
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M15;
   IF I=6 THEN GOTO M16;
   GOTO M5;
M1:   W:=W1;
      GOTO M6;
M2:   W:=W2;
      GOTO M6;
M3:   W:=W3;
      GOTO M6;
M4:   W:=W4;
      GOTO M6;
M15:  W:=W5;
      GOTO M6;
M16:  W:=W6;
M6:
   WRITELN(W);
   IF W=0 THEN GOTO M5;
M10:
   IF J=1 THEN GOTO M11;
   IF W>64 THEN GOTO M7;
   IF W<32 THEN GOTO M8;
   GOTO M12;
M11:
   IF W>128 THEN GOTO M7;
   IF W<64  THEN GOTO M8;
M12:
   GOTO M9;
M8:   W:=W SHL 1;
      N1:=N1+1;
      GOTO M10;
M7:   W:=W SHR 1;
      N2:=N2+1;
      GOTO M10;

M5:   CLRSCR;
      GOTOXY(3,3);
      WRITELN('МАСШТАБ НЕ УСТАНОВЛЕН   ');
      WRITE('  ПОВТОРИТЬ  ?  ');
      READ(I);
      IF I=1 THEN GOTO M13;
      GOTO M14;
M9:   CLRSCR;
      GOTOXY(3,3);
      WRITELN('МАСШТАБНЫЕ КОЭФФИЦИЕНТЫ   ',N1,'   ',N2);
      WRITELN('');
      WRITE('  ПОВТОРИТЬ  ?  ');
      READ(I);
      CLRSCR;
      IF I=1 THEN GOTO M13;
M14:
   A[3,3104]:=N1; A[4,3104]:=N2;
   END;

PROCEDURE REGSAM;
   BEGIN;
   W:=W SHR N2;
   W:=W SHL N1;
   PORT[BASE]:=W+20;
   K:=9;
   ZAPIS;
   END;

PROCEDURE REGSAM64;
   LABEL M1;
   BEGIN;
   I:=0;
   REPEAT
   OST;
   IF B3=1 THEN GOTO M1;
   KI1;
   CANALI;
   GOTOXY(10,10);
   WRITELN(W1,'   ',W2,'   ',W3,'   ',W4,'   ',W5,'   ',W6);
   W:=W1;
   REGSAM;
   I:=I+1;
   UNTIL I=64;
   MINSAM;
   DELAY(1000);
   I:=0;
   REPEAT
   OST;
   IF B3=1 THEN GOTO M1;
   KI1;
   CANALI;
   GOTOXY(10,10);
   WRITELN(W1,'   ',W2,'   ',W3,'   ',W4,'   ',W5,'   ',W6);
   W:=W3;
   REGSAM;
   I:=I+1;
   UNTIL I=64;
   MINSAM;
   DELAY(1000);
   I:=0;
   REPEAT
   OST;
   IF B3=1 THEN GOTO M1;
   KI1;
   CANALI;
   GOTOXY(10,10);
   WRITELN(W1,'   ',W2,'   ',W3,'   ',W4,'   ',W5,'   ',W6);
   W:=W5;
   REGSAM;
   I:=I+1;
   UNTIL I=64;
M1:
   END;

PROCEDURE REGSAM2K;
   LABEL M1;
   BEGIN;
   I:=0;
   REPEAT
   OST;
   IF B3=1 THEN GOTO M1;
   KI1;
   CANALI;
   GOTOXY(10,10);
   WRITELN(W1,'   ',W2,'   ',W3,'   ',W4,'   ',W5,'   ',W6);
   W:=W5;
   REGSAM;
   I:=I+1;
   UNTIL I=64;
   MINSAM;
   DELAY(1000);
M1:
   END;

PROCEDURE NEPSAM;
   LABEL M0,M1,M2,M3,M4,M5,M6,M7,M15,M16;
   BEGIN;
M6:
   TEXTMODE(MODE);
   ZWET1;
   CLRSCR;
   MINSAM;
   GOTOXY(3,3);
   WRITE('  НЕПР. ЗАПИСЬ НА САМОПИСЕЦ, КАНАЛЫ 1,2,3,4,5,6,0-BЫХОД (OCT. - ПУЛЬТ) ?  ');
   ZWET1;
   READ(I);
   IF I=0 THEN GOTO M0;
   TEXTMODE(0);
   CLRSCR;
   ZWET2;
M7:

   PORT[BASE]:=38;
   K:=1;
   ZAPIS;
   BIT;
   IF B3=0 THEN GOTO M6;
   KI1;
   CANALI;
   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M15;
   IF I=6 THEN GOTO M16;
M1:  W:=W1;
     GOTO M5;
M2:  W:=W2;
     GOTO M5;
M3:  W:=W3;
     GOTO M5;
M4:  W:=W4;
     GOTO M5;
M15: W:=W5;
     GOTO M5;
M16: W:=W6;
M5:
     GOTOXY(5,5);
     WRITELN('    ',W,'   ');
     REGSAM;
     GOTO M7;
M0:  MINSAM;
   END;

PROCEDURE USAM;
   LABEL M0,M1,M2,M3,M4,M5,M6;
   BEGIN;
M6:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(18,6,61,15);
   GOTOXY(1,1);
   WRITELN('                                           ');
   WRITELN('                 САМОПИСЕЦ                 ');
   WRITELN('   ВЫХОД...............................0   ');
   WRITELN('   МИНИМУМ САМОПИСЦА...................1   ');
   WRITELN('   МАКСИМУМ САМОПИСЦА..................2   ');
   WRITELN('   ОТСЧЕТ НА САМОПИСЕЦ (0-235).........3   ');
   WRITELN('   МАСШТАБ САМОПИСЦА...................4   ');
   WRITELN('   НЕПРЕРЫВНАЯ ЗАПИСЬ..................5   ');
   WRITELN('                                           ');
   GOTOXY(1,1);
   READ(I);
   CLRSCR;
   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M5;
M1:   MINSAM;
      GOTO M6;
M2:   MAXSAM;
      GOTO M6;
M3:   NSAM;
      GOTO M6;
M4:   MASHSAM;
      GOTO M6;
M5:   NEPSAM;
      GOTO M6;
M0:   END;

PROCEDURE UKLAWISHA;
   LABEL M1,M2;
   VAR
   A1,A2,A3,A4,A5,A6,A7,A8,A17: BYTE;
   C1,C2: BYTE;
   BEGIN;
M1:
   K:=1;
   PORT[BASE]:=40;
   ZAPIS;
   BITIN;
   WRITELN(B1,B2,B3,B4);
   C1:=B4+B3*2+B2*2*2+B1*2*2*2;
   A1:=B1; A2:=B2; A3:=B3; A4:=B4;
   PORT[BASE]:=41;
   ZAPIS;
   BIT;
   WRITELN(B1,B2,B3,B4);
   C2:=B4+B3*2+B2*2*2+B1*2*2*2;
   A5:=B1; A6:=B2; A7:=B3; A8:=B4;
   PORT[BASE]:=52;
   ZAPIS;
   BITIN;
   WRITELN(B1,B2,B3,B4);
   A17:=B3;
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(6,5,77,20);
   GOTOXY(1,1);
   WRITELN('                                                                     ');
   WRITELN('                                КЛАВИША                              ');
   WRITELN('                                                                     ');
   WRITELN('                                                                     ');
   WRITELN('                                 АДРЕС     В1   В2   В3   В4   ЧИСЛО ');
   WRITELN('                                                                     ');
   WRITELN('  ВЕРХНИЙ РЯД (ИНВ. БИТЫ).......   40       ',A1,'    ',A2,'    ',A3,'    ',A4,'      ',C1,'  ');
   WRITELN('                                                                     ');
   WRITELN('  КРЕСТ (НЕИНВ. БИТЫ)...........   41       ',A5,'    ',A6,'    ',A7,'    ',A8,'      ',C2,'  ');
   WRITELN('                                                                     ');
   WRITELN('  ТУМБЛЕР (НЕ ПОДКЛЮЧЕН)........   52       -    -    ',A17,'    -      -  ');
   WRITELN('                                                                     ');
   WRITELN('                                                                     ');
   WRITELN('  ПОВТОРИТЬ  ?                                                       ');
   WRITELN('                                                                     ');
   GOTOXY(15,14);
   READ(I);
   IF I=1 THEN GOTO M1;
   END;

PROCEDURE UPULT;
   LABEL M1,M2;
   VAR
   A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17: BYTE;
   C1,C2,C3,C4: BYTE;
   BEGIN;
M1:
   K:=1;
   PORT[BASE]:=37;
   ZAPIS;
   BITIN;
   WRITELN(B1,B2,B3,B4);
   C1:=B4+B3*2+B2*2*2+B1*2*2*2;
   A1:=B1; A2:=B2; A3:=B3; A4:=B4;
   PORT[BASE]:=36;
   ZAPIS;
   BITIN;
   WRITELN(B1,B2,B3,B4);
   C2:=B4+B3*2+B2*2*2+B1*2*2*2;
   A5:=B1; A6:=B2; A7:=B3; A8:=B4;
   PORT[BASE]:=39;
   ZAPIS;
   BITIN;
   WRITELN(B1,B2,B3,B4);
   C3:=B4+B3*2+B2*2*2+B1*2*2*2;
   A9:=B1; A10:=B2; A11:=B3; A12:=B4;
   PORT[BASE]:=38;
   ZAPIS;
   BITIN;
   WRITELN(B1,B2,B3,B4);
   C4:=B4+B3*2+B2*2*2+B1*2*2*2;
   A13:=B1; A14:=B2; A15:=B3; A16:=B4;
   PORT[BASE]:=52;
   ZAPIS;
   BITIN;
   WRITELN(B1,B2,B3,B4);
   A17:=B2;
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(8,5,78,23);
   GOTOXY(1,1);
   WRITELN('                                                                  ');
   WRITELN('                    ПУЛЬТ  (ИНВЕРТИРОВАННЫЕ БИТЫ)                 ');
   WRITELN('                                                                  ');
   WRITELN('                                                                  ');
   WRITELN('  НОМЕР РЯДА (CНИЗУ)....... АДРЕС      В1   В2   В3   В4   ЧИСЛО  ');
   WRITELN('                                                                  ');
   WRITELN('  ПЕРВЫЙ РЯД...............   37       ',A1,'    ',A2,'    ',A3,'    ',A4,'      ',C1,'    ');
   WRITELN('                                                                  ');
   WRITELN('  ВТОРОЙ РЯД...............   36       ',A5,'    ',A6,'    ',A7,'    ',A8,'      ',C2,'    ');
   WRITELN('                                                                  ');
   WRITELN('  ТРЕТИЙ РЯД (ФАЗА ЧЕРВЯКА)   39       ',A9,'    ',A10,'    ',A11,'    ',A12,'      ',C3,'    ');
   WRITELN('                                                                  ');
   WRITELN('  ЧЕТВЕРТЫЙ РЯД............   38       ',A13,'    ',A14,'    ',A15,'    ',A16,'      ',C4,'    ');
   WRITELN('                                                                  ');
   WRITELN('  ТУМБЛЕР..................   52       -    ',A17,'    -    -      -    ');
   WRITELN('                                                                  ');
   WRITELN('  ПОВТОРИТЬ  ?                                                    ');
   WRITELN('                                                                  ');
   GOTOXY(14,17);
   READ(I);
   IF I=1 THEN GOTO M1;
   END;

PROCEDURE ZWUK;
   LABEL M1,M2;
   VAR I,J: INTEGER;
   BEGIN;
   TI1P;
   I:=0;
M1:
   I:=I+1;
   IF I=Z1 THEN GOTO M2;
   PORT[BASE]:=32;
   K:=14;
   ZAPIS;
   N:=A[4,3100];
   J:=0;
   REPEAT TI1; J:=J+1; UNTIL J=Z2;
   PORT[BASE]:=0;
   K:=14;
   ZAPIS;
   N:=A[4,3100];
   J:=0;
   REPEAT TI1; J:=J+1; UNTIL J=Z2;
   GOTO M1;
M2:
   END;

PROCEDURE DOO;
   BEGIN;
   Z1:=50;
   Z2:=20;
   ZWUK;
   END;

PROCEDURE DODO;
   BEGIN;
   Z1:=50;
   Z2:=30;
   ZWUK;
   END;

PROCEDURE RE;
   BEGIN;
   Z1:=70;
   Z2:=15;
   ZWUK;
   END;

PROCEDURE MI;
   BEGIN;
   Z1:=90;
   Z2:=12;
   ZWUK;
   END;

PROCEDURE FA;
   BEGIN;
   Z1:=50;
   Z2:=5;
   ZWUK;
   END;

PROCEDURE FAK;
   BEGIN;
   Z1:=30;
   Z2:=3;
   ZWUK;
   END;

PROCEDURE SOL;
   BEGIN;
   Z1:=110;
   Z2:=9;
   ZWUK;
   END;

PROCEDURE SOLSOL;
   BEGIN;
   Z1:=110;
   Z2:=6;
   ZWUK;
   END;

PROCEDURE SOLK;
   BEGIN;
   Z1:=11;
   Z2:=3;
   ZWUK;
   END;

PROCEDURE ZWUK1;
   BEGIN;

   DOO;
   FA;
   SOL;
   END;

PROCEDURE ZWUK2;
   BEGIN;
   SOL;
   FA;
   DOO;
   END;

PROCEDURE ZWUK3;
   BEGIN;
   DOO;
   RE;
   MI;
   FA;
   SOL;
   END;

PROCEDURE ZWUK4;
   BEGIN;
   SOL;
   FA;
   MI;
   RE;
   DOO;
   END;

PROCEDURE ORGAN;
   VAR I: BYTE;
   BEGIN;
   I:=0;
   REPEAT
   Z1:=10;
   Z2:=30;
   ZWUK;
   Z1:=10;
   Z2:=29;
   ZWUK;
   Z1:=10;
   Z2:=28;
   ZWUK;
   I:=I+1;
   Z1:=10;
   Z2:=27;
   ZWUK;
   UNTIL I=5;
   END;

PROCEDURE UZWUK;
   LABEL M0,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,M13,
   M12A;
   BEGIN;
M13:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(24,5,57,22);
   GOTOXY(1,1);
   WRITELN('                                 ');
   WRITELN('               ЗВУК              ');
   WRITELN('                                 ');
   WRITELN('   ВЫХОД.................... 0   ');
   WRITELN('   DODO..................... 1   ');
   WRITELN('   DOO...................... 2   ');
   WRITELN('   RE....................... 3   ');
   WRITELN('   MI....................... 4   ');
   WRITELN('   FA....................... 5   ');
   WRITELN('   SOL...................... 6   ');
   WRITELN('   SOLSOL................... 7   ');
   WRITELN('   ZWUK1.................... 8   ');
   WRITELN('   ZWUK2.................... 9   ');
   WRITELN('   ZWUK3....................10   ');
   WRITELN('   ZWUK4....................11   ');
   WRITELN('   ORGAN....................12   ');
   GOTOXY(1,1);
   READ(I);
   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M5;
   IF I=6 THEN GOTO M6;
   IF I=7 THEN GOTO M7;
   IF I=8 THEN GOTO M8;
   IF I=9 THEN GOTO M9;
   IF I=10 THEN GOTO M10;
   IF I=11 THEN GOTO M11;
   IF I=12 THEN GOTO M12;
M1: DODO; GOTO M13;
M2: DOO; GOTO M13;
M3: RE; GOTO M13;
M4: MI; GOTO M13;
M5: FA; GOTO M13;
M6: SOL; GOTO M13;
M7: SOLSOL; GOTO M13;
M8: ZWUK1; GOTO M13;
M9: ZWUK2; GOTO M13;
M10: ZWUK3; GOTO M13;
M11: ZWUK4; GOTO M13;
M12: ORGAN; GOTO M13;
M0:
   END;


PROCEDURE REG64;
   LABEL M1,M2,
         M11,M12,M13,M14,M15,M16,M17;
   VAR FR1,FR2,FR3,FR4,FR5,FR6: REAL;
       WR1,WR2,WR3,WR4,WR5,WR6: REAL;
   BEGIN;
   FR1:=0; FR2:=0; FR3:=0; FR4:=0; FR5:=0; FR6:=0;
   I:=1;
M1:
   KI1;
   CANALI;
   GOTOXY(1,5); CLREOL;
   WRITELN('  ',I,'   ',W1,'   ',W2,'   ',W3,'   ',W4,'   ',W5,'   ',W6);
   WR1:=W1; WR2:=W2; WR3:=W3; WR4:=W4; WR5:=W5; WR6:=W6;
   FR1:=FR1+WR1;FR2:=FR2+WR2;FR3:=FR3+WR3;FR4:=FR4+WR4;FR5:=FR5+WR5;FR6:=FR6+WR6;
   I:=I+1;
   IF KANAL=1 THEN GOTO M11;
   IF KANAL=2 THEN GOTO M12;
   IF KANAL=3 THEN GOTO M13;
   IF KANAL=4 THEN GOTO M14;
   IF KANAL=5 THEN GOTO M15;
   IF KANAL=6 THEN GOTO M16;
M11: W:=W1; GOTO M17;
M12: W:=W2; GOTO M17;
M13: W:=W3; GOTO M17;
M14: W:=W4; GOTO M17;
M15: W:=W5; GOTO M17;
M16: W:=W6; GOTO M17;
M17:
   REGSAM;
   IF I=REN+1 THEN GOTO M2;
   GOTO M1;
M2:
   MINSAM;
   FR1:=FR1/REN*10/KZ; FR2:=FR2/REN*10/KZ; FR3:=FR3/REN*10/KZ;
   FR4:=FR4/REN*10/KZ; FR5:=FR5/REN*10/KZ; FR6:=FR6/REN*10/KZ;
{   FR1:=FR1/REN; FR2:=FR2/REN; FR3:=FR3/REN;
   FR4:=FR4/REN; FR5:=FR5/REN; FR6:=FR6/REN;}
   F1:=ROUND(FR1); F2:=ROUND(FR2); F3:=ROUND(FR3);
   F4:=ROUND(FR4); F5:=ROUND(FR5); F6:=ROUND(FR6);
   WRITELN('');
   WRITELN('');
   WRITELN(' СР. ОТСЧЕТ * 10/KZ  ',F1,' ',F2,' ',F3,' ',F4,' ',F5,' ',F6);
   {ORGAN;}
   END;

PROCEDURE PROWFON;
   BEGIN;
   MINSAM;
   GOTOXY(1,3);
   WRITELN('   ПРОВЕРКА ФОНА ПО ЧЕТЫРЕМ НАПРАВЛЕНИЯМ');
   WRITELN('   НАПРАВЛЕНИЕ 1');
   ALFAPLUS300;
   REGSAM64;
   MINSAM;
   ALFAMINUS300;
   ORGAN;
   GOTOXY(1,5);
   WRITELN('   НАПРАВЛЕНИЕ 2');
   ALFAMINUS300;
   REGSAM64;
   MINSAM;
   ALFAPLUS300;
   ORGAN;
   GOTOXY(1,6);
   WRITELN('   НАПРАВЛЕНИЕ 3');
   DELTAPLUS300;
   REGSAM64;
   MINSAM;
   DELTAMINUS300;
   ORGAN;
   GOTOXY(1,7);
   WRITELN('   НАПРАВЛЕНИЕ 4');
   DELTAMINUS300;
   REGSAM64;
   MINSAM;
   DELTAPLUS300;
   ZWUK4;
   END;

PROCEDURE CANFON;
   BEGIN;
   MINSAM;
   GOTOXY(1,3);
   WRITELN('   ПРОВЕРКА КАНАЛА ФОНА');
   WRITE('   КОЛИЧЕСТВО ШАГОВ ?');
   READ(NST);
   WRITELN('   НАПРАВЛЕНИЕ 1');
   ALFAPLUSN;
   REGSAM2K;
   MINSAM;
   ALFAMINUSN;
   ORGAN;
   GOTOXY(1,6);
   WRITELN('   НАПРАВЛЕНИЕ 2');
   ALFAMINUSN;
   REGSAM2K;
   MINSAM;
   ALFAPLUSN;
   ORGAN;
   GOTOXY(1,7);
   WRITELN('   НАПРАВЛЕНИЕ 3');
   DELTAPLUSN;
   REGSAM2K;
   MINSAM;
   DELTAMINUSN;
   ORGAN;
   GOTOXY(1,8);
   WRITELN('   НАПРАВЛЕНИЕ 4');
   DELTAMINUSN;
   REGSAM2K;
   MINSAM;
   DELTAPLUSN;
   ZWUK4;
   END;

PROCEDURE FONDO;
   BEGIN;
   {A[1,3105]:=A[1,3100]; A[2,3105]:=A[2,3100];
   A[3,3105]:=A[3,3100];A[4,3105]:=A[4,3100];}

   FB; DELAY(15); REG64;
   A[1,3106]:=F1; A[2,3106]:=F2; A[3,3106]:=F3;
   A[4,3106]:=F4; A[5,3106]:=F5; A[6,3106]:=F6;

   FV; DELAY(15); REG64;
   A[1,3107]:=F1; A[2,3107]:=F2; A[3,3107]:=F3;
   A[4,3107]:=F4; A[5,3107]:=F5; A[6,3107]:=F6;

   FR; DELAY(15); REG64;
   A[1,3108]:=F1; A[2,3108]:=F2; A[3,3108]:=F3;
   A[4,3108]:=F4; A[5,3108]:=F5; A[6,3108]:=F6;

   FUR; DELAY(15); REG64;
   A[1,3109]:=F1; A[2,3109]:=F2; A[3,3109]:=F3;
   A[4,3109]:=F4; A[5,3109]:=F5; A[6,3109]:=F6;

   END;

PROCEDURE UFON;
   LABEL M00,M0,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,
         M41,M42,M43,M44,M45,
         M51,M52,M53,M54,M55,M56;
   VAR A: BYTE;
   BEGIN;
M00:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(17,5,64,22);
   GOTOXY(1,1);
   WRITELN('                                               ');
   WRITELN('                     ФОН                       ');
   WRITELN('                                               ');
   WRITELN('   ВЫХОД.................................. 0   ');
   WRITELN('   ВВОД ПОДСМОТРОВЫХ МИКРОСКОПОВ.......... 1   ');
   WRITELN('   ВЫВОД ПОДСМОТРОВЫХ МИКРОСКОПОВ..........2   ');
   WRITELN('   МАСШТАБ САМОПИСЦА...................... 3   ');
   WRITELN('   ВЫВОД ЗВЕЗД ИЗ ДИАФРАГМ................ 4   ');
   WRITELN('   ВОЗВРАЩЕНИЕ В ДИАФРАГМЫ................ 5   ');
   WRITELN('   НЕПР. ЗАПИСЬ ФОНА (ВЫХОД - ПУЛЬТ)...... 6   ');
   WRITELN('   ПРОВЕРКА ФОНА ПО ЧЕТЫРЕМ НАПРАВЛЕНИЯМ.. 7   ');
   WRITELN('   РЕГИСТРАЦИЯ 64 ОТСЧЕТОВ ФОНА........... 8   ');
   WRITELN('   ПРОВЕРКА КАНАЛА ФОНА................... 9   ');
   WRITELN('   ЗАПИСЬ В ФИЛЬТРАХ B И V................10   ');
   WRITELN('   ЗАПИСЬ В ФИЛЬТРАХ B И R................11   ');
   WRITELN('   УСТАНОВКА ФИЛЬТРА......................12   ');
   WRITELN('                                               ');
   GOTOXY(1,1);
   READ(I);
   CLRSCR;
   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M5;
   IF I=6 THEN GOTO M6;
   IF I=7 THEN GOTO M7;
   IF I=8 THEN GOTO M8;
   IF I=9 THEN GOTO M9;
   IF I=10 THEN GOTO M10;
   IF I=11 THEN GOTO M11;
   IF I=12 THEN GOTO M12;
M1:
   GOTOXY(1,5);
   WWOD1;
   WWOD2;
   DODO;
   DELAY(1000);
   GOTO M00;
M2:
   GOTOXY(1,5);
   WIWOD1;
   WIWOD2;
   RE;
   DELAY(1000);
   GOTO M00;
M3:
   MASHSAM;
   GOTO M00;
M4:
   GOTOXY(1,5);
   WRITE('    НАПРАВЛЕНИЕ СМЕЩЕНИЯ - 1,2,3,4 ? ');
   READ(A);
   IF A=1 THEN GOTO M41;
   IF A=2 THEN GOTO M42;
   IF A=3 THEN GOTO M43;
   IF A=4 THEN GOTO M44;
   M41: ALFAPLUS300;
        GOTO M45;
   M42: ALFAMINUS300;
        GOTO M45;
   M43: DELTAPLUS300;
        GOTO M45;
   M44: DELTAMINUS300;
   M45: ZWUK1;
   GOTO M00;
M5:
   IF A=0 THEN GOTO M56;
   IF A=1 THEN GOTO M51;
   IF A=2 THEN GOTO M52;
   IF A=3 THEN GOTO M53;
   IF A=4 THEN GOTO M54;
   M51: ALFAMINUS300;
        GOTO M55;
   M52: ALFAPLUS300;
        GOTO M55;
   M53: DELTAMINUS300;
        GOTO M55;
   M54: DELTAPLUS300;
   M55: ZWUK2;
        A:=0;
        GOTO M00;
   M56: GOTOXY(1,5);
        WRITELN('   ЗВЕЗДЫ НЕ ВЫВОДИЛИСЬ');
        DELAY(1000);
        GOTO M00;
M6:
   NEPSAM;
   GOTO M00;
M7:
   PROWFON;
   GOTO M00;
M8:
   FONDO;
   GOTO M00;
M9:
   CANFON;
   GOTO M00;
M10:
   NFI:=4;
   NFIL;
   FONDO;
   NFI:=3;
   NFIL;
   FONDO;
   GOTO M00;
M11:
   NFI:=4;
   NFIL;
   FONDO;
   NFI:=2;
   NFIL;
   FONDO;
   GOTO M00;
M12:
   WRITE(' НОМЕР ФИЛЬТРА ? (0-ДЫРА,1-I,2-R,3-V,4-B,5-U) ');
   READ(NFI);
   NFIL;
   DELAY(1000);
   GOTO M00;

M0:
   END;

PROCEDURE WREMA;
   LABEL M1,M2,M3;
   VAR
       T5: BYTE;
       U1,U2: REAL;
       U3,U4: INTEGER;
       I1,J1,K1: REAL;
   BEGIN;
M3:
   I1:=A[1,3103]; J1:=A[2,3103]; K1:=A[3,3103];
   U:=I1*60*60+J1*60+K1;
   U:=U*10;
   K:=1;
   PORT[BASE]:=56;
   ZAPIS;
   RES;
   T5:=R;
   PORT[BASE]:=57;
   ZAPIS;
   RES;
   T4:=R;
   PORT[BASE]:=58;
   ZAPIS;
   RES;
   T3:=R;
   PORT[BASE]:=59;
   ZAPIS;
   RES;
   T2:=R;
   PORT[BASE]:=60;
   ZAPIS;
   RES;
   T1:=R;
   U3:=T5+T4*16+T3*16*16;
   U4:=T2+T1*16;
   U2:=U4;
   U1:=U3;
   U1:=U1+U2*16*16*16;
   US:=U1;
   {GOTOXY(5,4); WRITELN('ВРЕМЯ СЧЕТЧИКА ',U1:8:1);}
   U1:=U+U1;
   U1:=U1/10;
   T:=U1;
   T1:=TRUNC(U1/3600);
   U1:=U1/3600-T1;
   T2:=TRUNC(U1*60);
   U1:=U1*60-T2;
   T3:=TRUNC(U1*60);
   U1:=U1*60-T3;
   U1:=U1*10;
   T4:=TRUNC(U1);
   IF T1>23 THEN GOTO M1;
   GOTO M2;
M1: T1:=T1-24;
M2:
   GOTOXY(5,2);
   CLREOL; WRITELN('ВРЕМЯ     ',T1,'Ч ',T2,'М ',T3,'С, ',T4,'     ');
   END;

PROCEDURE SHASI;
   LABEL M0,M1,M2,M3;
   VAR U1,U2,U3: BYTE;
       U4,U5,U6: REAL;
   BEGIN;
M2:
   CLRSCR;
   GOTOXY(1,5);
   WRITE('     УСТАНОВКА ЧАСОВ  ? ');
   READ(I);
   IF I=0 THEN GOTO M0;
   WRITE('     ЧАС      ');
   READLN(U1);
   WRITE('     МИНУТА   ');
   READLN(U2);
   WRITE('     СЕКУНДА  ');
   READLN(U3);
   A[1,3103]:=U1;
   A[2,3103]:=U2;
   A[3,3103]:=U3;
   K:=13;
   ZAPIS;
   {WRITELN(A[5,10]);
   WRITELN(A[5,11]);
   WRITELN(A[5,12]);}
   U4:=A[1,3103];
   U5:=A[2,3103];
   U6:=A[3,3103];
   {WRITELN(U4:2:1);
   WRITELN(U5:2:1);
   WRITELN(U6:2:1);}
   U:=U4*60*60+U5*60+U6;
   U:=U*10;
M1:
   WREMA;
   GOTOXY(1,12);
   WRITELN('     ПОВТОРИТЬ УСТАНОВКУ - 2,     ');
   WRITE('     ОТСЧЕТ ВРЕМЕНИ      - 1  ?   ');
   READ(I);
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
M0:
   END;

PROCEDURE WREMANEP;
   LABEL M1;
   BEGIN;
   ZWET1;
   TEXTMODE(0);
   CLRSCR;
   ZWET2;
M1:
   WREMA;
   TI3;
   K:=1;
   PORT[BASE]:=38;
   ZAPIS;
   BITIN;
   IF B3=0 THEN GOTO M1;
   TEXTMODE(MODE);
   END;


PROCEDURE UGOL;
   LABEL M1,M2;
   VAR A1,B: REAL;
       I,J,K: REAL;
   BEGIN;
   WREMA;
   I:=A[1,3104];
   J:=A[2,3104];
   Y:=I*3600+J*60;
   I:=A[1,3105];
   J:=A[2,3105];
   K:=A[3,3105];
   T5:=I*3600+J*60+K;
   A1:=T-T5;
   A1:=A1+Y;
   Y1:=TRUNC(A1/3600);
   B:=A1/3600-Y1;
   Y2:=TRUNC(B*60);
   IF Y1>23 THEN GOTO M1;
   GOTO M2;
M1: Y1:=Y1-24;
M2:
   WRITELN('');
   CLREOL; WRITELN('    ЧАСОВОЙ УГОЛ    ',Y1,'Ч  ',Y2,'М');
   END;

PROCEDURE USUGOL;
   LABEL M0,M1,M2;
   VAR A1,B: REAL;
   BEGIN;
M1:
   CLRSCR;
   GOTOXY(1,6);
   WRITE('     НАЧАЛЬНАЯ УСТАНОВКА ЧАСОВОГО УГЛА ? ');
   READLN(I);
   IF I=0 THEN GOTO M0;
   WRITE('     ЧАС       ');
   READLN(A1);
   A[1,3104]:=TRUNC(A1);
   WRITE('     МИНУТА    ');
   READLN(B);
   A[2,3104]:=TRUNC(B);
   Y:=A1*3600+B*60;
   WREMA;
   A[1,3105]:=T1;
   A[2,3105]:=T2;
   A[3,3105]:=T3;
M2:
   UGOL;
   GOTOXY(1,14);
   WRITELN('     ПОВТОРИТЬ УСТАНОВКУ - 2,');
   WRITE('     ОТСЧЕТ............. - 1  ?   ');
   READ(I);
   IF I=1 THEN GOTO M2;
   IF I=2 THEN GOTO M1;
M0:
   END;

PROCEDURE UWREMA;
   LABEL M0,M1,M2,M3,M4,M5,M6,M7;
   BEGIN;
   {CLRSCR;}
M7:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(18,6,63,23);
   GOTOXY(1,1);
   WRITELN('                                             ');
   WRITELN('                   ВРЕМЯ                     ');
   WRITELN('                                             ');
   WRITELN('   ВЫХОД................................ 0   ');
   WRITELN('                                             ');
   WRITELN('   УСТАНОВКА ЧАСОВ...................... 1   ');
   WRITELN('                                             ');
   WRITELN('   ОТСЧЕТ ВРЕМЕНИ ПО НАЖАТИЮ ENTER...... 2   ');
   WRITELN('                                             ');
   WRITELN('   НЕПРЕРЫВНЫЙ ОТСЧЕТ (ВЫХОД - ПУЛЬТ)... 3   ');
   WRITELN('                                             ');
   WRITELN('   УСТАНОВКА ЧАСОВОГО УГЛА ТЕЛЕСКОПА.... 4   ');
   WRITELN('                                             ');
   WRITELN('   ОТСЧЕТ ЧАСОВОГО УГЛА................. 5   ');
   WRITELN('                                             ');
   WRITELN('   УСТАНОВКА ЭКСПОЗИЦИИ СЧЕТА........... 6   ');
   WRITELN('                                             ');
   GOTOXY(1,1);
   READ(I);
   CLRSCR;
   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M5;
   IF I=6 THEN GOTO M6;
M1:  SHASI;
     GOTO M7;
M2:
     WREMA;
     GOTOXY(1,10);
     WRITE('     ПОВТОРИТЬ ? ');
     READ(J);
     IF J=1 THEN GOTO M2;
     GOTO M7;
M3:
     WREMANEP;
     GOTO M7;
M4:  USUGOL;
     GOTO M7;
M5:  GOTOXY(1,6);
     UGOL;
     GOTOXY(1,12);
     WRITE('     ПОВТОРИТЬ ? ');
     READ(J);
     IF J=1 THEN GOTO M5;
     GOTO M7;
M6:  EXP;
     GOTO M7;
M0:
     END;

PROCEDURE UDZW;
   LABEL M0,M1,M2,M3,M4;
   VAR I: BYTE;
   BEGIN;
   I:=A[3,3101];
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   GOTO M0;
M1: ALFAPLUS300;
   GOTO M0;
M2: ALFAMINUS300;
   GOTO M0;
M3: DELTAPLUS300;
   GOTO M0;
M4: DELTAMINUS300;
M0:
    DELAY(500);
   END;

PROCEDURE WOZW;
   LABEL M0,M1,M2,M3,M4;
   VAR I: BYTE;
   BEGIN;
   I:=A[3,3101];
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   GOTO M0;
M1: ALFAMINUS300;
   GOTO M0;
M2: ALFAPLUS300;
   GOTO M0;
M3: DELTAMINUS300;
   GOTO M0;
M4: DELTAPLUS300;
M0:
   DELAY(500);
   END;

PROCEDURE RAD;  {АНАЛИЗ КЛАВИШИ}
   BEGIN;
   K:=1;
   PORT[BASE]:=40;
   ZAPIS;
   BITIN;
   END;

PROCEDURE SRAWNENIE;
   LABEL M00,M0,M1,M2,M3,M4,M5,
         M11,M12,M13,M14,M15,M16,M17,M17A,M17B,M17C,
         M41,M42,M43,M44,M45,M46,M47,
         M51,M52,M53,M54,M55,M56,M57,
         M21,
         M31,M32,M33,
         FB1,FV1,FB2,FV2,ZB1,ZV1,ZB2,ZV2,ZB3,ZV3;
   VAR I,J,KZ0: BYTE;
   BEGIN;
M00:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(18,5,62,22);
   GOTOXY(1,1);
   WRITELN('                                            ');
   WRITELN('     СРАВНЕНИЕ ЧУВСТВИТЕЛЬНОСТИ КАНАЛОВ     ');
   WRITELN('                                            ');
   WRITELN('     ВЫХОД........................... 0     ');
   WRITELN('                                            ');
   WRITELN('     CРАВНЕНИЕ ПЕРВОЕ................ 1     ');
   WRITELN('                                            ');
   WRITELN('     СРАВНЕНИЕ ВТОРОЕ................ 2     ');
   WRITELN('                                            ');
   WRITELN('     ЗАПИСЬ КОНТРОЛЬНОЙ ЗВЕЗДЫ....... 3     ');
   WRITELN('                                            ');
   WRITELN('     ЯРКАЯ ЗВЕЗДА.................... 4     ');
   WRITELN('                                            ');
   GOTOXY(1,1);
   READLN(I);
   CLRSCR;
   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M21;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;

M21:    I:=30; GOTO M2;
M1: I:=1;
M2:
{    J:=0;
    REPEAT
    J:=J+1;
    A[1,3110+J+I]:=0; A[2,3110+J+I]:=0; A[3,3110+J+I]:=0;
    A[4,3110+J+I]:=0; A[5,3110+J+I]:=0; A[6,3110+J+I]:=0;
    UNTIL J=28;}
    KZ0:=KZ;
    KZ:=KZ1;
    GOTOXY(1,5); WRITELN('        ИЗМЕРЕНИЕ ФОНА');
    ZWUK4;
    CLRSCR; GOTOXY(1,2); WIWOD1; WIWOD2;
    UDZW;
    KANAL:=1;

    FB; DELAY(15);             REG64;
    A[1,3110+I]:=F1; A[2,3110+I]:=F2; A[3,3110+I]:=F3;
    A[4,3110+I]:=F4; A[5,3110+I]:=F5; A[6,3110+I]:=F6;
    WREMA;
    A[1,3130+I]:=T1; A[2,3130+I]:=T2; A[3,3130+I]:=T3; A[4,3130+I]:=T4;

    FV; DELAY(15);              REG64;
    A[1,3111+I]:=F1; A[2,3111+I]:=F2; A[3,3111+I]:=F3;
    A[4,3111+I]:=F4; A[5,3111+I]:=F5; A[6,3111+I]:=F6;

    FR; DELAY(15);              REG64;
    A[1,3112+I]:=F1; A[2,3112+I]:=F2; A[3,3112+I]:=F3;
    A[4,3112+I]:=F4; A[5,3112+I]:=F5; A[6,3112+I]:=F6;

    FUR; DELAY(15);              REG64;       ORGAN;
    A[1,3113+I]:=F1; A[2,3113+I]:=F2; A[3,3113+I]:=F3;
    A[4,3113+I]:=F4; A[5,3113+I]:=F5; A[6,3113+I]:=F6;

    WOZW;
    DOO;
    WWOD1;
    DELAY(1000);
    CLRSCR;
M11:
    GOTOXY(1,2); WRITELN('    КАНАЛЫ 1-2 ГОТОВЫ ? ');
    OST;
    IF B3=1 THEN GOTO M0;
    RAD;
    IF B2=0 THEN GOTO M11;
    SOLSOL;
    WIWOD1;
    KANAL:=1;

    FB; DELAY(15);            REG64;
    A[1,3114+I]:=F1; A[2,3114+I]:=F2;
    WREMA;
    A[1,3131+I]:=T1; A[2,3131+I]:=T2; A[3,3131+I]:=T3; A[4,3131+I]:=T4;

    FV; DELAY(15);            REG64;
    A[1,3115+I]:=F1; A[2,3115+I]:=F2;

    FR; DELAY(15);            REG64;
    A[1,3116+I]:=F1; A[2,3116+I]:=F2;

    FUR; DELAY(15);            REG64;       ORGAN;
    A[1,3117+I]:=F1; A[2,3117+I]:=F2;

    SOL;
    WWOD2;
    DELAY(1000);
    CLRSCR;
M12:
    GOTOXY(1,2); WRITELN('    КАНАЛЫ 3-4 ГОТОВЫ ? ');
    OST;
    IF B3=1 THEN GOTO M0;
    RAD;
    IF B2=0 THEN GOTO M12;
    SOLSOL;
    WIWOD2;
    KANAL:=3;

    FB; DELAY(15);            REG64;
    A[3,3114+I]:=F3; A[4,3114+I]:=F4;
    WREMA;
    A[1,3132+I]:=T1; A[2,3132+I]:=T2; A[3,3132+I]:=T3; A[4,3132+I]:=T4;

    FV; DELAY(15);             REG64;
    A[3,3115+I]:=F3; A[4,3115+I]:=F4;

    FR; DELAY(15);            REG64;
    A[3,3116+I]:=F3; A[4,3116+I]:=F4;

    FUR; DELAY(15);            REG64;       ORGAN;
    A[3,3117+I]:=F3; A[4,3117+I]:=F4;

    DOO; DELAY(100); DOO;
    WWOD1;
    DELAY(1000);
    CLRSCR;
M13:
    GOTOXY(1,2); WRITELN('    КАНАЛЫ 1-2 ГОТОВЫ ? ');
    OST;
    IF B3=1 THEN GOTO M0;
    RAD;
    IF B2=0 THEN GOTO M13;
    SOLSOL;
    WIWOD1;
    KANAL:=1;

    FB; DELAY(15);           REG64;
    A[1,3118+I]:=F1; A[2,3118+I]:=F2;
    WREMA;
    A[1,3133+I]:=T1; A[2,3133+I]:=T2; A[3,3133+I]:=T3; A[4,3133+I]:=T4;

    FV; DELAY(15);            REG64;
    A[1,3119+I]:=F1; A[2,3119+I]:=F2;

    FR; DELAY(15);           REG64;
    A[1,3120+I]:=F1; A[2,3120+I]:=F2;

    FUR; DELAY(15);           REG64;      ORGAN;
    A[1,3121+I]:=F1; A[2,3121+I]:=F2;

    SOL; DELAY(100); SOL;
    WWOD2;
    DELAY(1000);
    CLRSCR;
M14:
    GOTOXY(1,2); WRITELN('    КАНАЛЫ 3-4 ГОТОВЫ ? ');
    OST;
    IF B3=1 THEN GOTO M0;
    RAD;
    IF B2=0 THEN GOTO M14;
    SOLSOL;
    WIWOD2;
    KANAL:=3;

    FB; DELAY(15);             REG64;
    A[3,3118+I]:=F3; A[4,3118+I]:=F4;
    WREMA;
    A[1,3134+I]:=T1; A[2,3134+I]:=T2; A[3,3134+I]:=T3; A[4,3134+I]:=T4;

    FV; DELAY(15);              REG64;
    A[3,3119+I]:=F3; A[4,3119+I]:=F4;

    FR; DELAY(15);              REG64;
    A[3,3120+I]:=F3; A[4,3120+I]:=F4;

    FUR; DELAY(15);              REG64;     ORGAN;
    A[3,3121+I]:=F3; A[4,3121+I]:=F4;

    DOO; DELAY(100); DOO; DELAY(100); DOO;
    WWOD1;
    DELAY(1000);
    CLRSCR;
M15:
    GOTOXY(1,2); WRITELN('    КАНАЛЫ 1-2 ГОТОВЫ ? ');
    OST;
    IF B3=1 THEN GOTO M0;
    RAD;
    IF B2=0 THEN GOTO M15;
    SOLSOL;
    WIWOD1;
    KANAL:=1;

    FB; DELAY(15);              REG64;
    A[1,3122+I]:=F1; A[2,3122+I]:=F2;
    WREMA;
    A[1,3135+I]:=T1; A[2,3135+I]:=T2; A[3,3135+I]:=T3; A[4,3135+I]:=T4;

    FV; DELAY(15);              REG64;
    A[1,3123+I]:=F1; A[2,3123+I]:=F2;

    FR; DELAY(15);              REG64;
    A[1,3124+I]:=F1; A[2,3124+I]:=F2;

    FUR; DELAY(15);              REG64;    ORGAN;
    A[1,3125+I]:=F1; A[2,3125+I]:=F2;

    SOL; DELAY(100); SOL; DELAY(100); SOL;
    WWOD2;
    DELAY(1000);
    CLRSCR;
M16:
    GOTOXY(1,2); WRITELN('    КАНАЛЫ 3-4 ГОТОВЫ ? ');
    OST;
    IF B3=1 THEN GOTO M0;
    RAD;
    IF B2=0 THEN GOTO M16;
    SOLSOL;
    WIWOD2;
    KANAL:=3;

    FB; DELAY(15);            REG64;
    A[3,3122+I]:=F3; A[4,3122+I]:=F4;
    WREMA;
    A[1,3136+I]:=T1; A[2,3136+I]:=T2; A[3,3136+I]:=T3; A[4,3136+I]:=T4;

    FV; DELAY(15);            REG64;
    A[3,3123+I]:=F3; A[4,3123+I]:=F4;

    FR; DELAY(15);           REG64;
    A[3,3124+I]:=F3; A[4,3124+I]:=F4;

    FUR; DELAY(15);           REG64;      ORGAN;
    A[3,3125+I]:=F3; A[4,3125+I]:=F4;

    CLRSCR; GOTOXY(1,5); WRITELN('          ИЗМЕРЕНИЕ ФОНА');
    ZWUK1;
    UDZW;
    KANAL:=1;

    FB; DELAY(15);          REG64;
    A[1,3126+I]:=F1; A[2,3126+I]:=F2; A[3,3126+I]:=F3;
    A[4,3126+I]:=F4; A[5,3126+I]:=F5; A[6,3126+I]:=F6;

    IF I=30 THEN GOTO M17;
    A[1,3106]:=F1; A[2,3106]:=F2; A[3,3106]:=F3;
    A[4,3106]:=F4; A[5,3106]:=F5; A[6,3106]:=F6;
M17:
    WREMA;
    A[1,3137+I]:=T1; A[2,3137+I]:=T2; A[3,3137+I]:=T3; A[4,3137+I]:=T4;

    FV; DELAY(15);           REG64;
    A[1,3127+I]:=F1; A[2,3127+I]:=F2; A[3,3127+I]:=F3;
    A[4,3127+I]:=F4; A[5,3127+I]:=F5; A[6,3127+I]:=F6;

    IF I=30 THEN GOTO M17A;
    A[1,3107]:=F1; A[2,3107]:=F2; A[3,3107]:=F3;
    A[4,3107]:=F4; A[5,3107]:=F5; A[6,3107]:=F6;
M17A:

    FR; DELAY(15);           REG64;
    A[1,3128+I]:=F1; A[2,3128+I]:=F2; A[3,3128+I]:=F3;
    A[4,3128+I]:=F4; A[5,3128+I]:=F5; A[6,3128+I]:=F6;

    IF I=30 THEN GOTO M17B;
    A[1,3108]:=F1; A[2,3108]:=F2; A[3,3108]:=F3;
    A[4,3108]:=F4; A[5,3108]:=F5; A[6,3108]:=F6;
M17B:

    FUR; DELAY(15);           REG64;
    A[1,3129+I]:=F1; A[2,3129+I]:=F2; A[3,3129+I]:=F3;
    A[4,3129+I]:=F4; A[5,3129+I]:=F5; A[6,3129+I]:=F6;

    IF I=30 THEN GOTO M17C;
    A[1,3109]:=F1; A[2,3109]:=F2; A[3,3109]:=F3;
    A[4,3109]:=F4; A[5,3109]:=F5; A[6,3109]:=F6;
M17C:
    KZ:=KZ0;
    WOZW;
    ORGAN; DELAY(100); ORGAN;
    A[1,3109+I]:=A[1,3100]; A[2,3109+I]:=A[2,3100];
    A[3,3109+I]:=A[3,3100]; A[4,3109+I]:=A[4,3100];
    WWOD1;
    WWOD2;
    GOTO M00;
M3:
    {CLRSCR;
    GOTOXY(5,5);
    WRITE('ЗАПИСЬ КОНТР. ЗВЕЗДЫ НОМЕР ? (1,2,3,4) ');
    READLN(I);
    I:=(I-1)*4;
    J:=0;
    REPEAT
    A[1,3157+J+I]:=0; A[2,3157+J+I]:=0; A[3,3157+J+I]:=0;
    A[4,3157+J+I]:=0; A[5,3157+J+I]:=0; A[6,3157+J+I]:=0;
    J:=J+1;
    UNTIL J=4;
    WRITELN('');
    WRITE('    ЗВЕЗДА В КАНАЛАХ 3,4 ? (0,1) ');
    READLN(J);
    WWOD1;
    WWOD2;
    SOLK;
    IF J=1 THEN GOTO M31;
M32:
    GOTOXY(1,2); WRITELN('    КАНАЛЫ 1-2 ГОТОВЫ ? ');
    OST;
    IF B3=1 THEN GOTO M0;
    RAD;
    IF B2=0 THEN GOTO M32;
    SOLSOL;
    WIWOD1;
    WIWOD2;
    KANAL:=1;

    FB; KZ1:=KZ; REG64;
    WREMA;
    A[1,3158+I]:=T1; A[2,3158+I]:=T2; A[3,3158+I]:=T3; A[4,3158+I]:=T4;
    A[1,3159+I]:=F1;

    FV;          REG64;
    A[2,3159+I]:=F1;

    FR;          REG64; KZ1:=1;
    A[3,3159+I]:=F1; A[4,3159+I]:=12;

    A[1,3157+I]:=A[1,3100]; A[2,3157+I]:=A[2,3100];
    A[3,3157+I]:=A[3,3100]; A[4,3157+I]:=A[4,3100];
    UDZW;
    FB; REG64;    A[1,3160+I]:=F1;
    FV; REG64;    A[2,3160+I]:=F1;
    FR; REG64;    A[3,3160+I]:=F1;
    WOZW;
    ORGAN;
    WWOD1;
    WWOD2;
    GOTO M00;
M31:
    SOLK; DELAY(50); SOLK;
M33:
    GOTOXY(1,2); WRITELN('    КАНАЛЫ 3-4 ГОТОВЫ ? ');
    OST;
    IF B3=1 THEN GOTO M0;
    RAD;
    IF B2=0 THEN GOTO M33;
    SOLSOL;
    WIWOD1;
    WIWOD2;
    KANAL:=3;

    FB; KZ1:=KZ; REG64;
    WREMA;
    A[1,3158+I]:=T1; A[2,3158+I]:=T2; A[3,3158+I]:=T3; A[4,3158+I]:=T4;
    A[1,3159+I]:=F3;

    FV;          REG64;
    A[2,3159+I]:=F3;

    FR;          REG64; KZ1:=1;
    A[3,3159+I]:=F3; A[4,3159+I]:=34;

    A[1,3157+I]:=A[1,3100]; A[2,3157+I]:=A[2,3100];
    A[3,3157+I]:=A[3,3100]; A[4,3157+I]:=A[4,3100];
    UDZW;
    FB; REG64;    A[1,3160+I]:=F3;
    FV; REG64;    A[2,3160+I]:=F3;
    FR; REG64;    A[3,3160+I]:=F3;
    WOZW;
    ORGAN;
    WWOD1;
    WWOD2;}
    GOTO M00;
M4:
    WRITE('  КОЭФФИЦИЕНТ ДЛЯ ЯРКОЙ ЗВЕЗДЫ? (10)  ');
    READ(KZ1);
    GOTO M00;

M0:
    KANAL:=1;
    END;

PROCEDURE NASHALO;
   LABEL M1,M2;

   BEGIN;
M1:
   WRITE('  ИМЕЮЩИЕСЯ УСТАНОВКИ ? ');
   READLN(I);
   IF I=1 THEN GOTO M2;
   WRITELN('         ТОЛЬКО ЦЕЛЫЕ ЧИСЛА !');
   WRITELN('');
   WRITELN('                ДАТА:');
   WRITELN('');
   WRITE('                ЧИСЛО ? ');
   READLN(A[1,3100]);
   WRITE('           ПРОДОЛЖИТЬ ? ');
   READLN(I);
   IF I=0 THEN GOTO M1;
   WRITE('                МЕСЯЦ ? ');
   READLN(A[2,3100]);
   WRITE('                ГОД   ? ');
   READLN(A[3,3100]);
   WRITELN('');
   WRITE('  РАЗНИЦА ВРЕМЕНИ (ЗИМОЙ-5, ЛЕТОМ-6) ? ');
   READLN(A[1,3101]);
   WRITE('  ЦВЕТА (ИНТЕГР-1, С,К-2, B,R-3, BVR-4)     ? ');
   READLN(A[2,3101]);
   WRITE('  НАПРАВЛЕНИЕ СМЕЩЕНИЯ (1,2,3,4)     ? ');
   READLN(A[3,3101]);
   WRITE('  К-ВО ПРОПУСКОВ (ДЛЯ ФОНА И ФИЛЬТРОВ, (24) ? ');
   READLN(A[1,3102]);
   WRITE('  К-ВО ИЗМЕРЕНИЙ ФОНА (13)               ? ');
   READLN(A[2,3102]);
   WRITE('  НОМЕР ЗВЕЗДЫ СРАВНЕНИЯ             ? ');
   READLN(A[3,3102]);
M2:
   WRITELN('');
   WRITELN('  ДАТА    ',A[1,3100],'   ',A[2,3100],'   ',A[3,3100]);
   A[4,3100]:=1;
   WRITELN('');
   WRITELN('  РАЗНИЦА  ',A[1,3101],'    ЦВЕТА  ',A[2,3101],'    ЭКСПОЗИЦИЯ  ',A[4,3101]);
   WRITELN('');
   WRITELN('  НАПРАВЛЕНИЕ ',A[3,3101],'  К-ВО ПРОПУСКОВ ',A[1,3102]);
   WRITELN('');
   WRITELN('  К-ВО ИЗМ. ФОНА ',A[2,3102],'  НОМЕР ЗВЕЗДЫ СРАВНЕНИЯ  ',A[3,3102]);
   WRITELN('');
   WRITE('  ПОВТОРИТЬ ? ');
   READLN(I);
   IF I=1 THEN GOTO M1;
   END;


PROCEDURE READF;
    BEGIN;
    ASSIGN(FILEDATA, NAME);
    RESET(FILEDATA);
    FOR J:=1 TO 3200 DO
    READLN(FILEDATA,A[1,J],A[2,J],A[3,J],A[4,J],A[5,J],A[6,J]);
    CLOSE(FILEDATA);
    END;

PROCEDURE READN;
    BEGIN;
    ASSIGN(FILEFILE, NAMEFILE);
    RESET(FILEFILE);
    FOR J:=1 TO 96 DO READLN(FILEFILE, NAMEAFT[J]);
    WRITELN(NAMEAFT[33]);
    {DELAY(2000);}
    END;

PROCEDURE WRITEF;
    BEGIN;
    ASSIGN(FILEDATA,NAMEZ);
    REWRITE(FILEDATA);
    FOR J:=1 TO 3200 DO
    WRITELN(FILEDATA, A[1,J],' ',A[2,J],' ',A[3,J],' ',A[4,J],' ',A[5,J],' ',A[6,J]);
    CLOSE(FILEDATA);
    END;


{PROCEDURE WRITEN;
    BEGIN;
    ASSIGN(FILEFILE, NAMEFILE);
    REWRITE(FILEFILE);
    FOR J:=1 TO 96 DO WRITELN(FILEFILE, NAMEAFT[J]);
    CLOSE(FILEFILE);
    END;}

PROCEDURE FILES;
   LABEL M0,M1,M2,M3,M4,M5,M6,M7,M8,M88,M888,M8888,
         M11,M12,M13,
         M31;
   VAR I1,J1: INTEGER;
   BEGIN;
M7:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(15,3,70,25);
   GOTOXY(1,1);
   WRITELN('                                                    ');
   WRITELN('                     ФАЙЛЫ                          ');
   WRITELN('                                                    ');
   WRITELN('   ВЫХОД....................................... 0   ');
   WRITELN('                                                    ');
   WRITELN('   НАЗВАНИЯ ФАЙЛОВ ДЛЯ АВТ. ЗАПИСИ (MAX. 96)... 1   ');
   WRITELN('                                                    ');
   WRITELN('   ЧТЕНИЕ ФАЙЛА................................ 2   ');
   WRITELN('                                                    ');
   WRITELN('   ЦИКЛ СМЕНЫ ФИЛЬТРОВ ZF (192-8=184).......... 3   ');
   WRITELN('                                                    ');
   WRITELN('   ВВОД НАЧАЛЬНЫХ ДАННЫХ....................... 4   ');
   WRITELN('                                                    ');
   WRITELN('   ЗАПИСЬ ФАЙЛА................................ 5   ');
   WRITELN('                                                    ');
   WRITELN('   ИЗМЕНЕНИЕ ФОКУСА............................ 7   ');
   WRITELN('                                                    ');
   WRITELN('   НАЧАЛЬНЫЙ ОТСЧЕТ ФОКУСА..................... 8   ');
   WRITELN('                                                    ');
   WRITELN('   КОЛИЧЕСТВО АВТ. ИЗМЕРЕНИЙ REN (16).......... 9   ');
   WRITELN('                                                    ');
   WRITELN('   КОЭФ. УМЕНЬШЕНИЯ ДЛЯ ФОНА*10 KZ (1)........ 10   ');

   GOTOXY(1,1);
   READLN(I);
   CLRSCR;
   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M5;
   IF I=7 THEN GOTO M8;
   IF I=8 THEN GOTO M88;
   IF I=9 THEN GOTO M888;
   IF I=10 THEN GOTO M8888;
M1:
    WRITELN('');
    WRITELN('    НАЗВАНИЯ ФАЙЛОВ ДЛЯ АВТОМАТИЧЕСКОЙ ЗАПИСИ');
    WRITELN('');
    WRITE('    ПОКАЗАТЬ ЧТО ЕСТЬ ? ');
    READLN(I);
    IF I=1 THEN GOTO M13;
    WRITELN('');
    WRITE('    КОЛИЧЕСТВО ФАЙЛОВ (MAX 96) ? ');
    READLN(J);
    I:=0;
    REPEAT
    I:=I+1;
    WRITE('       ',I,' ?   ');
    READLN(NAMEAFT[I]);
    UNTIL I=J;
    WRITELN('');
    WRITELN('');
    I:=1;
M13:
    REPEAT
    WRITELN('   ',I,'   ',NAMEAFT[I],'         ',I+1,'   ',NAMEAFT[I+1]);
    I:=I+2;
    UNTIL I=33;
    WRITELN('');
    WRITE('        ПОВТОРИТЬ  ? ');
    READLN(I);
    GOTOXY(1,1);
    CLRSCR;
    IF I=1 THEN GOTO M1;

    GOTO M7;
M2: GOTOXY(1,5);
    WRITE('            НАЗВАНИЕ ФАЙЛА ДЛЯ ЧТЕНИЯ  ? ');
    READLN(NAME);
    READF;
    WRITELN('');
    WRITELN(' 1 ',A[1,1],' ',A[2,1],' ',A[3,1],' ',A[4,1],' ',A[5,1],' ',A[6,1]);
    DELAY(2000);
    GOTO M7;
M3: GOTOXY(1,5);
    WRITE('  ЦИКЛ СМЕНЫ ФИЛЬТРОВ ZF (192-8=184) ? ');
    READ(ZF);
    GOTO M7;
M4:
    GOTOXY(1,3);
    NASHALO;
    GOTO M7;
M5:
    GOTOXY(1,5);
    WRITE('         НАЗВАНИЕ ФАЙЛА ДЛЯ ЗАПИСИ ? ');
    READLN(NAMEZ);
    WRITEF;
    GOTO M7;
M8:
    WRITE(' ИЗМЕНЕНИЕ ФОКУСА 1 (1) ? ');
    READ(FOK1);
    WRITE(' ИЗМЕНЕНИЕ ФОКУСА 2 (3) ? ');
    READ(FOK2);
    GOTO M7;
M88:
    WRITE(' НАЧАЛЬНЫЙ ОТСЧЕТ ФОКУСА ? (0,1)  ');
    READ(I);
    IF I=0 THEN GOTO M7;
    WRITE(' ВЕЛИЧИНА ОТСЧЕТА ? (5000)  ');
    READ(A[1,3197]);
    FO:=A[1,3197];
    GOTO M7;
M888:
    WRITE(' КОЛИЧЕСТВО АВТ. ИЗМЕРЕНИЙ REN (16) ? ');
    READ(REN);
    GOTO M7;
M8888:
    WRITE(' КОЭФ. УМЕНЬШЕНИЯ ДЛЯ ФОНА*10 KZ (1) ? ');
    READ(KZ);
    GOTO M7;
M0:
   END;


PROCEDURE IZMENENIE;
   LABEL M1,M2,
         M11,M12;
   VAR BA1: REAL;
   BEGIN;
   K:=1;
   PORT[BASE]:=36;
   ZAPIS;
   BITIN;
   H:=B1;
   BA:=B6;{B2*4+B3*2+B4};
   BA1:=BA;
   IF BA=3{0} THEN GOTO M2;
   IF BA=0 THEN GOTO M2;
   WREMA;
   {GOTOXY(4,24); WRITELN(US:10:1);}
   IF US-KO/BA1>UD THEN GOTO M1;
   GOTO M2;
M1:
   IF B1=0 THEN GOTO M11;
   D:=D+0.25;
   GOTO M12;
M11:
   D:=D-0.25;
M12:
   UD:=US;
M2:
   END;

PROCEDURE KOEF;
   VAR DD,D1,D2: REAL;
       D3,D4: BYTE;
   BEGIN;
   DD:=D*4/1.333333333;
   D1:=DD/256;
   D3:=TRUNC(D1);
   D2:=D1-D3;
   D2:=D2*256;
   D4:=TRUNC(D2);
   K:=12;
   PORT[BASE]:=D3;
   ZAPIS;
   K:=11;
   PORT[BASE]:=D4;
   ZAPIS;
   END;
PROCEDURE KOEFP;
   VAR DD,D1,D2: REAL;
       D3,D4: BYTE;
   BEGIN;
   DD:=DP*4/1.333333333;
   D1:=DD/256;
   D3:=TRUNC(D1);
   D2:=D1-D3;
   D2:=D2*256;
   D4:=TRUNC(D2);
   K:=12;
   PORT[BASE]:=D3;
   ZAPIS;
   K:=11;
   PORT[BASE]:=D4;
   ZAPIS;
   END;

PROCEDURE IZPU;
   LABEL M0,M1,M2;
   BEGIN;
   K:=1;
   PORT[BASE]:=52;
   ZAPIS;
   BITIN;
   IF B2=1 THEN GOTO M0;
   PORT[BASE]:=38;
   ZAPIS;
   BITIN;
   IF B1=1 THEN GOTO M1;
   IF B2=1 THEN GOTO M2;
   GOTO M0;
M1:
   D:=D+0.25;
   KOEF;
   GOTO M0;
M2:
   D:=D-0.25;
   KOEF;
M0:
   END;

PROCEDURE DELTA;
   LABEL M1,M2,M3,
         M11,M12;
   VAR BD1: REAL;
   BEGIN;
   K:=1;
   PORT[BASE]:=37;
   ZAPIS;
   BITIN;
   H:=B1;
   BD:={B5}B2*4+B3*2+B4;
   BD1:=BD;
   IF BD=0 THEN GOTO M2;
   WREMA;
   {GOTOXY(4,24); WRITELN(US:10:1);}
   IF US-KD/BD1>UDEL THEN GOTO M1;
   GOTO M2;
M1:
   IF B1=0 THEN GOTO M11;
   DELTAPLUS;
   GOTOXY(32,16); TEXTBACKGROUND(3); TEXTCOLOR(14); WRITELN('+');
   GOTO M12;
M11:
   DELTAMINUS;
   GOTOXY(32,16); TEXTBACKGROUND(3); TEXTCOLOR(14); WRITELN('-');
M12:
   UDEL:=US;
   IF ZS=0 THEN GOTO M3;
   SOLK;
   GOTO M3;
M2:
   GOTOXY(31,16); CLREOL; GOTOXY(1,1); ZWET2;
M3:
   GOTOXY(1,1); ZWET2;
   END;

PROCEDURE DELTA2;
   LABEL M1,M2,M3,
         M11,M12,
         MK1,MK2;

   VAR BD1: REAL;
   BEGIN;
   IF KOMPD=0 THEN GOTO M3;
   {K:=1;
   PORT[BASE]:=37;
   ZAPIS;
   BITIN;
   H:=B1;
   BD:=B5B2*4+B3*2+B4;}
   IF SKOD>0 THEN GOTO MK1;
   H:=0;
   GOTO MK2;
MK1: H:=1;
MK2:
   B1:=H;
   BD:=ABS(SKOD);
   BD1:=BD;
   IF BD=0 THEN GOTO M2;
   WREMA;
   {GOTOXY(4,24);
   WRITELN(US:10:1);}
   IF US-KD/BD1>UDEL THEN GOTO M1;
   GOTO M2;
M1:
   IF B1=0 THEN GOTO M11;
   DELTAPLUS;
   GOTOXY(32,16); TEXTBACKGROUND(3); TEXTCOLOR(14); WRITELN('+');
   GOTO M12;
M11:
   DELTAMINUS;
   GOTOXY(32,16); TEXTBACKGROUND(3); TEXTCOLOR(14); WRITELN('-');
M12:
   UDEL:=US;
   IF ZS=0 THEN GOTO M3;
   SOLK;
   GOTO M3;
M2:
   GOTOXY(31,16); CLREOL; GOTOXY(1,1); ZWET2;
M3:
   GOTOXY(1,1); ZWET2;
   END;



PROCEDURE ALFA;
   LABEL M0,M00,M01,M02,M1,M2,M3,M4,M5,
         M11,
         M21,M210,
         M100,M101,M102,M103,M104,M105,M106,M107,M108,
         M109,M110,M111,M112,M113,M114,M115,M110A;
   VAR AA: BYTE;
        N,N1: REAL;
   BEGIN;
   N1:=4;
   ZS:=0;
   K:=1;
   PORT[BASE]:=38;
   ZAPIS;
   BITIN;

   AA:=B4;
   PORT[BASE]:=39;
   ZAPIS;
   BITIN;
   FAZA1:=B4+B3*2+B2*4+B1*8;
   PORT[BASE]:=52;
   ZAPIS;
   BITIN;
   TEXTCOLOR(12); WRITELN(B2);
   IF B2=1 THEN GOTO M3;
   PORT[BASE]:=38;
   ZAPIS;
   BITIN;
   IF B1=1 THEN GOTO M4;
   IF B2=1 THEN GOTO M5;
   GOTO M3;
M4:
   GOTO M3;
M5:

M3:
   N:=N1+AM;
   GOTOXY(5,24); TEXTBACKGROUND(1); TEXTCOLOR(7); WRITELN('АМПЛИТУДА ',N:1:2);
   IF FAZA1=FAZA THEN GOTO M0;

   IF FAZA1=1 THEN GOTO M101;
   IF FAZA1=2 THEN GOTO M102;
   IF FAZA1=3 THEN GOTO M103;
   IF FAZA1=4 THEN GOTO M104;
   IF FAZA1=5 THEN GOTO M105;
   IF FAZA1=6 THEN GOTO M106;
   IF FAZA1=7 THEN GOTO M107;
   IF FAZA1=8 THEN GOTO M108;

   IF FAZA1=9 THEN GOTO M109;
   IF FAZA1=10 THEN GOTO M110;
   IF FAZA1=11 THEN GOTO M111;
   IF FAZA1=12 THEN GOTO M112;
   IF FAZA1=13 THEN GOTO M113;
   IF FAZA1=14 THEN GOTO M114;
   IF FAZA1=15 THEN GOTO M115;
   IF FAZA1=0 THEN GOTO M100;

M101:
   IF AA=1 THEN GOTO M11;
   DP:=D+N-1*1;
   KOEFP;
   GOTO M11;
M102:
   IF AA=1 THEN GOTO M11;
   DP:=D+N+N+N;
   KOEFP;
   GOTO M11;
M103:
   IF AA=1 THEN GOTO M11;
   DP:=D+N+N+N+N;
   KOEFP;
   GOTO M11;
M104:
   IF AA=1 THEN GOTO M11;
   DP:=D+N+N+N+N;
   KOEFP;
   GOTO M11;
M105:
   IF AA=1 THEN GOTO M11;
   DP:=D+N+N+N+N+1*1;
   KOEFP;
   GOTO M11;
M106:
   IF AA=1 THEN GOTO M11;
   DP:=D+N+N+N+1*1;
   KOEFP;
   GOTO M11;
M107:
   IF AA=1 THEN GOTO M11;
   DP:=D+N;
   KOEFP;
   GOTO M11;
M108:
   IF AA=1 THEN GOTO M11;
   DP:=D+1*1;
   KOEFP;
   GOTO M11;

M11:
   IF ZS=0 THEN GOTO M110A;

M110A:
   GOTOXY(22,20); TEXTBACKGROUND(3); TEXTCOLOR(14); WRITELN('-     ',DP:6:2);
   FAZA:=FAZA1;
   GOTO M0;

M109:
   IF AA=1 THEN GOTO M21;
   DP:=D-N;
   KOEFP;
   GOTO M21;
M110:
   IF AA=1 THEN GOTO M21;
   DP:=D-N-N-N-2*1;
   KOEFP;
   GOTO M21;
M111:
   IF AA=1 THEN GOTO M21;
   DP:=D-N-N-N-N+2*1;
   KOEFP;
   GOTO M21;
M112:
   IF AA=1 THEN GOTO M21;
   DP:=D-N-N-N-N+1*1;
   KOEFP;
   GOTO M21;

M113:
   IF AA=1 THEN GOTO M21;
   DP:=D-N-N-N-N+1*1;
   KOEFP;
   GOTO M21;

M114:
   IF AA=1 THEN GOTO M21;
   DP:=D-N-N-N+1*1;
   KOEFP;
   GOTO M21;

M115:
   IF AA=1 THEN GOTO M21;
   DP:=D-N-2*1;
   KOEFP;
   GOTO M21;
M100:
   IF AA=1 THEN GOTO M21;
   DP:=D-3*1;
   KOEFP;
   GOTO M21;




M21:
   IF ZS=0 THEN GOTO M210;

   M210:
   GOTOXY(22,20); TEXTBACKGROUND(3); TEXTCOLOR(14); WRITELN('+      ',DP:6:2);
   FAZA:=FAZA1;
   GOTO M0;
M02:
   FAZA:=FAZA1;
   GOTOXY(21,20); CLREOL; GOTOXY(1,1); ZWET2;
   GOTO M0;
M01:
   FAZA:=FAZA1;
   GOTOXY(21,20); CLREOL; GOTOXY(1,1); ZWET2;
M0:
   IF AA=0 THEN GOTO M00;
   KOEF;
M00:
   GOTOXY(1,1); ZWET2;
   END;

PROCEDURE WREKO;
   BEGIN;
   WREMA;
   UK:=US;
   A[1,3199]:=T1;
   A[2,3199]:=T2;
   A[3,3199]:=T3;
   A[4,3199]:=T4;
   END;

PROCEDURE WRENA;
   BEGIN;
   WREMA;
   UN:=US;
   A[1,3198]:=T1;
   A[2,3198]:=T2;
   A[3,3198]:=T3;
   A[4,3198]:=T4;
   END;

PROCEDURE WREFO;
   BEGIN;
   WREMA;
   UF:=US;
   END;

PROCEDURE WRERA2;
   BEGIN;
   WREMA;
   A[1,3197]:=T1;
   A[2,3197]:=T2;
   A[3,3197]:=T3;
   A[4,3197]:=T4;
   END;

PROCEDURE GID;
   BEGIN
   K:=1;
   PORT[BASE]:=32;
   ZAPIS;
   BITIN;
   G:=B4+B3*2+B2*2*2+B1*2*2*2;
   END;

PROCEDURE DEL;
   BEGIN
   FOR IS:=1 TO DELL DO DELAY(10);
   END;

PROCEDURE FIL;
LABEL     M00,M01,M1,M2,M3,M4,M5;
   BEGIN
   IF OFI=0 THEN GOTO M1;
   IF OFI=ZF THEN GOTO M2;
   IF OFI=ZF*2 THEN GOTO M3;
   IF OFI=ZF*3 THEN GOTO M4;
   GOTO M00;
M1:
   FB;
   J:=J+8;
   GOTO M01;
M2:
   FV;
   J:=J+8;
   GOTO M01;
M3:
   FR;
   J:=J+8;
   GOTO M01;
M4:
   FUR;
   J:=J+8;
   GOTO M01;

M01:
   DELAY(15);
   WREMA;
   WRITELN(US-UK);
   IF US-UK<40 THEN GOTO M01;
   TFI:=1;
M00:
   END;


PROCEDURE REGMINUSN;
   LABEL M0,M1,M2,M3,M4,M41,M5,M6,M7,M8,M8A,M8B,M9,M10,M11,M12,M13,M14,M15,
   M101,M101A,M102,M103,
   M111,M112,M113,M114,M115,M115Z,M115ZZ,M116,
   MK1,MK2,MK3,MK4,MK5,MK1A,MK2A,MK3A,MK4A,MK4AA,MK5A,
   MG,
   MF1,MF2,MF3,MF4,MM,MF1A,MF2A,
   MP1,MP2,MP3,MP4,MP1A,MP2A,MP3A,MP4A,MP1B,MP2B,MP3B,MP4B,
   LEW,PRA,LEW2,PRA2,
   IF1,IF2,
   MNKO,MD,MD1,MD2,
   MFIL1,MFIL2,MFIL3;
   VAR B7: BYTE;
       E: REAL;
       S1,S2: INTEGER; {УПРАВЛЕНИЕ САМОПИСЦЕМ}
       S3: INTEGER;
       S3A: INTEGER;
       {A1,A2,}A4,D1A,D2A,D4A,II,BG: INTEGER; {ГИДИРОВАНИЕ}
       C1,C2,III: INTEGER; {ФОКУСИРОВКА}
       B11,B21,B31,B41: BYTE; {МИКРОСКОПЫ}
       AA1,AA2,AA3,AA4,DD1,DD2,DD3,DD4: BYTE; {СКОРОСТИ}
       REZH: BYTE; {РЕЖИМ 0,1}
       NR:   BYTE; {КОМПЕНСАЦИЯ НЕ РАЗРЕШЕНА}
       FILTR: CHAR;
   BEGIN;
   {TEXTMODE(0);}
   OFI:=0;
   A1:=0; A2:=0; A4:=0;
   D1A:=0; D2A:=0; D4A:=0;
   ZWET1;   CLRSCR;   ZWET2;
   {WINDOW(21,4,59,29);}
   WINDOW(41,1,80,25); CLRSCR;
   N1:=A[3,3104];
   N2:=A[4,3104];
   J:=A[1,3102];
   J:=J+1;
   S1:=J;
   S2:=0;
   S3:=32;
   S3A:=32;
   A3:=1;
   RAN:=0;
  { PORT[BASE]:=38;
   ZAPIS  BITIN;
   GOTOXY(5,22);
   NR:=B4; }

M1:
   IF RAN=12 THEN GOTO M102;
   RA:=0;
M102:
   KI1;
   CANALI;
   WREKO;
{   IF J>A[1,3102]+9 THEN GOTO M101;
   WRENA;
M101:}
         IF NR=1 THEN GOTO MFIL3;
         IF OFI=ZF*4 THEN GOTO MFIL1;
         GOTO MFIL2;
MFIL1:   OFI:=0;
MFIL2:
         FIL; GOTOXY(1,9); CLREOL;
         IF NFI=4 THEN FILTR:='B';
         IF NFI=3 THEN FILTR:='V';
         IF NFI=2 THEN FILTR:='R';
         IF NFI=1 THEN FILTR:='I';
      WRITELN('    ФИЛЬТР   ',FILTR,'        ',D1,' ',D2,'  ',NFF,'  ',TFI);

         OFI:=OFI+1;
         TFI:=TFI+1;
MFIL3:
   IF J>A[1,3102]+9 THEN GOTO M101A;
   WRENA; {DELAY(1000); WRITELN('BREMA HAZHALA'); DELAY(3000);}
M101A:

   CANALI;
   A[1,J]:=W1; A[2,J]:=W2; A[3,J]:=W3; A[4,J]:=W4; A[5,J]:=W5; A[6,J]:=W6;
   WREKO;
   IF RA=0 THEN GOTO M103;
   IF RAN=12 THEN GOTO M103;
   A[1,3186+RAN-1]:=T1; A[2,3186+RAN-1]:=T2;
   A[3,3186+RAN-1]:=T3; A[4,3186+RAN-1]:=T4;
   RAN:=RAN+1;
M103:
   GOTOXY (2,11); TEXTCOLOR(14); WRITELN(N);
   IF S2>736 THEN GOTO M12;
   TEXTCOLOR(10);
   GOTO M13;
M12: TEXTCOLOR(13);
M13:
   GOTOXY(5,11); CLREOL;   WRITELN(J);
   GOTOXY(11,11); TEXTCOLOR(11); CLREOL;   WRITELN(W1);
   GOTOXY(18,11); TEXTCOLOR(12); CLREOL;   WRITELN(W2);
   GOTOXY(25,11); TEXTCOLOR(11); CLREOL;   WRITELN(W3);
   GOTOXY(32,11); TEXTCOLOR(12); CLREOL;   WRITELN(W4);
   GOTOXY(11,13); TEXTCOLOR(11); CLREOL;   WRITELN(W5);
   GOTOXY(18,13); TEXTCOLOR(12); CLREOL;   WRITELN(W6);
   TEXTCOLOR(3);
   WREMA;
   UGOL;
   GOTOXY(5,6);
   CLREOL; WRITELN('КОЭФФИЦИЕНТ ДЕЛЕНИЯ  ',D:6:2);
   E:=A[4,3101];
   E:=E/10;
   GOTOXY(5,8);
   CLREOL; WRITELN('ЭКСПОЗИЦИЯ СЧЕТА  ',E:1:1,' C');
   GOTOXY(5,13);
   TEXTCOLOR(3);
   WRITELN('ФОН');
   PORT[BASE]:=37;
   K:=1;
   ZAPIS;
   BITIN;
   DD1:=B1; DD2:=B2; DD3:=B3; DD4:=B4;
   B5:=B4+B3*2+B2*4;
   IF KOMPD=0 THEN GOTO MNKO;
   K:=1;
   PORT[BASE]:=52;
   ZAPIS;
   BITIN;
   REZH:=B2;
   IF REZH=0 THEN GOTO MNKO;
   B5:=SKOD;
MNKO:
   GOTOXY(5,16);
   IF DD1=1 THEN GOTO M3;
   CLREOL; WRITELN('ДЕЛЬТА "-"    СКОРОСТЬ ',B5);
   GOTO M4;
M3:
   CLREOL; WRITELN('ДЕЛЬТА "+"    СКОРОСТЬ ',B5);
M4:
   PORT[BASE]:=36;
   ZAPIS;
   BITIN;
   AA1:=B1; AA2:=B2; AA3:=B3; AA4:=B4;
   B6:=B4+B3*2{+B2*4};
   IF B6=0 THEN GOTO M41;
   B6:=B6+3;
M41:
   GOTOXY(5,18);
   IF B1=1 THEN GOTO M5;
   WRITELN('АЛЬФА  "-"    СКОРОСТЬ ',B6);
   GOTO M6;
M5:
   WRITELN('АЛЬФА  "+"    СКОРОСТЬ ',B6);
M6:
   PORT[BASE]:=39;
   ZAPIS;
   BITIN;
   B7:=B4+B3*2+B2*4+B1*8;
   GOTOXY(5,20);
   CLREOL; WRITELN('ФАЗА ЧЕРВЯКА ',B7);
   PORT[BASE]:=38;
   ZAPIS;
   BITIN;
   GOTOXY(5,22);
   NR:=B4;
   IF B4=1 THEN GOTO M7;
   CLREOL; WRITELN('КОМПЕНСАЦИЯ РАЗРЕШЕНА');
   GOTO M8;
M7:
   TEXTCOLOR(13); WRITELN('КОМПЕНСАЦИЯ НЕ РАЗРЕШЕНА');
M8:
   TEXTCOLOR(3);
   IZMENENIE;
   {KOEF;}
   IZPU;
IF REZH=1 THEN GOTO M8B;
   DELTA;
   GOTO M8A;
M8B:
   DELTA2;
M8A:
   ALFA;
   TEXTCOLOR(5);
   S3:=S3+1;
   S3A:=S3A+1;
   S2:=S2+1;
   IF S2>736 THEN GOTO M9;
   W:=W1; {SAMOPISEZ}
   REGSAM;
   GOTO M11;
M9:
   W:=W3;  {SAMOPISEZ}
   REGSAM;
M11:
   TUM;
   IF B2=1 THEN GOTO M14; {ТУМБЛЕР ВВЕРХ - ОСТАНОВА ОТ ПУЛЬТА НЕ БУДЕТ}
   OST;
   IF B3=1 THEN GOTO M0;
M14:
   J:=J+1;
   IF J=1561 THEN GOTO M2;

   ZWET1;
   {CLRSCR; WINDOW(21,4,59,29);}
   WINDOW(1,1,40,25);
   TUM;
   IF B2=0 THEN GOTO MK2;
   II:=0;
   III:=0;
   REPEAT
   WREMA;
   IF US-UK<4 THEN GOTO MK1;
   GOTO MK2;
MK1:


   IF III>0 THEN GOTO MF4;
   IF US-UK<3 THEN GOTO MF4;
   K:=1;
   PORT[BASE]:=40;
   ZAPIS;
   BITIN;
   C1:=B4+B3*2+B2*2*2+B1*2*2*2;

   PORT[BASE]:=52;
   ZAPIS;
   BITIN;
   IF B2=0 THEN GOTO MM;
   PORT[BASE]:=38;
   ZAPIS;
   BITIN;
   C2:=B3*2+B2*2*2+B1*2*2*2;
   {IF B1=1 THEN GOTO MF1;
   IF B2=1 THEN GOTO MF2;}
   IF C2=8 THEN GOTO MF1;
   IF C2=4 THEN GOTO MF2;
   IF C2=12 THEN GOTO MD;
MM:

   IF C1=1 THEN GOTO MF1;
   IF C1=8 THEN GOTO MF2;
   IF C1=0 THEN GOTO MF4;

MF1:
   IF B4=1 THEN GOTO MF1A;
   FOKUSPLUS;
   GOTO MF3;

MF1A: SKOD:=SKOD+1;

   GOTO MF3;

MF2:
   IF B4=1 THEN GOTO MF2A;
   FOKUSMINUS;
   GOTO MF3;

MF2A: SKOD:=SKOD-1;

   GOTO MF3;
MD:
   IF KOMPD=1 THEN GOTO MD1;
   IF KOMPD=0 THEN GOTO MD2;
MD1: KOMPD:=0;
   GOTO MF3;
MD2: KOMPD:=1;
   GOTO MF3;
MF3:
   SOLK;
   GOTO MK2;
MF4:
   GOTOXY(4,4); CLREOL; WRITELN(' ФОКУС ',FO);

   I:=0;
   K:=1;
   PORT[BASE]:=41;
   ZAPIS;
   BIT;
   BG:=B1+B2+B3+B4;
   IF BG=0 THEN GOTO MG;
   B11:=B1;   B21:=B2;   B31:=B3;   B41:=B4;
   IF B11=0 THEN GOTO MP1;
MP1B:
   KON4_1;
   IF B3=0 THEN GOTO MP1A;
   PORT[BASE]:=1;
   K:=4;
   ZAPIS;
   SHAG;
   TI3;
   I:=I+1;   GOTOXY(26,6); WRITELN(I);
   WREMA;
   IF US-UK<4 THEN GOTO MP1B;
   GOTO MK2;
MP1A:
   GOTOXY(4,6); WRITELN(' ПОДСМОТР 2 ВВЕДЕН '); SOLK;
MP1:

   IF B21=0 THEN GOTO MP2;
MP2B:
   KON4_1;
   IF B1=0 THEN GOTO MP2A;
   PORT[BASE]:=0;
   K:=4;
   ZAPIS;
   SHAG;
   TI3;
   I:=I+1;   GOTOXY(26,8); WRITELN(I);
   WREMA;
   IF US-UK<4 THEN GOTO MP2B;
   GOTO MK2;
MP2A:
   GOTOXY(4,8); WRITELN(' ПОДСМОТР 1 ВВЕДЕН '); SOLK;
MP2:

   IF B31=0 THEN GOTO MP3;
MP3B:
   KON4_1;
   IF B4=0 THEN GOTO MP3A;
   PORT[BASE]:=9;
   K:=4;
   ZAPIS;
   SHAG;
   TI3;
   I:=I+1;   GOTOXY(26,6); WRITELN(I);
   WREMA;
   IF US-UK<4 THEN GOTO MP3B;
   GOTO MK2;
MP3A:
   GOTOXY(4,6); WRITELN(' ПОДСМОТР 2 ВЫВЕДЕН '); SOLK;
MP3:

   IF B41=0 THEN GOTO MP4;
MP4B:
   KON4_1;
   IF B2=0 THEN GOTO MP4A;
   PORT[BASE]:=8;
   K:=4;
   ZAPIS;
   SHAG;
   TI3;
   I:=I+1;   GOTOXY(26,8); WRITELN(I);
   WREMA;
   IF US-UK<4 THEN GOTO MP4B;
   GOTO MK2;
MP4A:
   GOTOXY(4,8); WRITELN(' ПОДСМОТР 1 ВЫВЕДЕН '); SOLK;
MP4:
   GOTO MK2;


MG:
   IF J<64 THEN GOTO M116;
   GID;
   TEXTCOLOR(10);
   IF B1=0 THEN GOTO M111;
   FOR IS:=1 TO ALC DO ALFAPLUS1;
   {A1:=A1+1;}
   GOTOXY(6,18);
   CLREOL; WRITELN('АЛЬФА  + ',A1);
M111:
   TEXTCOLOR(12);
   IF B2=0 THEN GOTO M112;
   IF PERE=0 THEN GOTO LEW;
   deltaminus;
   d2a:=d2a+1;
   GOTO PRA;
LEW:
   DELTAPLUS;
   D1A:=D1A+1;
PRA:
   GOTOXY(6,21);
   CLREOL; WRITELN('ДЕЛЬТА + ' ,D1A);
M112:
   TEXTCOLOR(13);
   IF B3=0 THEN GOTO M113;
IF PERE=0 THEN GOTO LEW2;
   deltaplus;
   d1a:=d1a+1;
   GOTO PRA2;
LEW2:
   DELTAMINUS;
   D2A:=D2A+1;
PRA2:
   GOTOXY(6,23);
   CLREOL; WRITELN('ДЕЛЬТА - ',D2A);
M113:
   TEXTCOLOR(14);
   IF B4=0 THEN GOTO M114;
   FOR IS:=1 TO ALC DO ALFAMINUS1;
   {A2:=A2+1;}
   GOTOXY(6,20);
   CLREOL; WRITELN('АЛЬФА  - ',A2);
M114:
   IF G=0 THEN GOTO M115;
   NG:=0;
   GOTO M116;
M115:
   GOTOXY(6,18);
   CLREOL;
   GOTOXY(6,20);
   CLREOL;
   GOTOXY(6,21);
   CLREOL;
   GOTOXY(6,23);
   CLREOL;
   A4:=A4+A1-A2;
   D4A:=D4A+D1A-D2A;
   NG:=NG+1;
   TEXTCOLOR(8);
   GOTOXY(10,10); CLREOL; WRITELN('ПЕРЕКЛАДКА            = ',PERE);
   GOTOXY(10,11); CLREOL; WRITELN('ЗАДЕРЖКА              = ',DELL);

   K:=1;
   PORT[BASE]:=36;
   ZAPIS;
   BITIN;
   IF B2=0 THEN GOTO IF1;
   GOTOXY(10,12); CLREOL; WRITELN('ИЗМЕНЕНИЕ ФОКУСА      = ',FOK1);
   GOTO IF2;
IF1:
   GOTOXY(10,12); CLREOL; WRITELN('ИЗМЕНЕНИЕ ФОКУСА      = ',FOK2);
IF2:
   GOTOXY(10,13); CLREOL; WRITELN('СКОРОСТЬ ПО АЛЬФА     = ',ALSK:1:2);
   GOTOXY(10,14); CLREOL; WRITELN('ЦИКЛ ПО АЛЬФА         = ',ALC);
   GOTOXY(10,15); CLREOL; WRITELN('КОМПЕНСАЦИЯ ПО АЛЬФА  = ',KOMPA);
   GOTOXY(10,16); CLREOL; WRITELN('КОМПЕНСАЦИЯ ПО ДЕЛЬТА = ',KOMPD);
   TEXTCOLOR(11); GOTOXY(14,19); CLREOL; WRITELN('СУММА ПО АЛЬФА  = ',A4);
   GOTOXY(14,22); CLREOL; WRITELN('СУММА ПО ДЕЛЬТА = ',D4A);
   TEXTCOLOR(14); GOTOXY(14,24); CLREOL; WRITELN('К-ВО ПРОПУСКОВ = ',NG);
   IF A4>TRE2 THEN GOTO M115ZZ;
   IF D4A>TRE2 THEN GOTO M115ZZ;
   IF A4<-TRE2 THEN GOTO M115ZZ;
   IF D4A<-TRE2 THEN GOTO M115ZZ;
   IF NG<TRE1 THEN GOTO M115Z;
M115ZZ:   FAK;
M115Z:
   A1:=0; A2:=0; D1A:=0; D2A:=0;
   TUM;
   IF B2=1 THEN GOTO M116;
   A4:=0; D4A:=0; NG:=0;
M116:
   DEL;
   II:=II+1;
   UNTIL II=100;

MK2:
   IF KOMPA=0 THEN GOTO MK3;
   IF S3<1500 THEN GOTO MK3;
MK4AA:
   IF A4<25 THEN GOTO MK4; IF D<6626 THEN GOTO MK4;
   D:=D-ALSK{0.50};   A4:=A4-25;  GOTO MK4AA;
MK4:
   IF A4>-25 THEN GOTO MK5; IF D>6676 THEN GOTO MK5;
   D:=D+ALSK{0.50};   A4:=A4+25; GOTO MK4;
MK5:
   A4:=0;
   S3:=0;
MK3:
   IF KOMPD=0 THEN GOTO MK3A;
   IF S3A<1500 THEN GOTO MK3A;
   IF D4A<25 THEN GOTO MK4A;
   SKOD:=SKOD+1;
MK4A:
   IF D4A>-25 THEN GOTO MK5A;
   SKOD:=SKOD-1;
MK5A:
   D4A:=0;
   S3A:=0;
MK3A:


   ZWET2;
   WINDOW(41,1,80,25);
   {CLRSCR;}



   GOTO M1;
M0:
   {TEXTMODE(MODE);}
   CLRSCR;
   MINSAM;
   {WRITELN(' ОСTАНОВ ОТ ПУЛЬТА N=',J);
   WRITE(' ПРОДОЛЖИТЬ ? ');
   READLN(A3);}
   A3:=0;
   IF A3=1 THEN GOTO M1;
M2:
   {TEXTMODE(MODE);}
   CLRSCR;
   MINSAM;
   END;

PROCEDURE FONN;
   LABEL M0,M1,M2,M3,M4,M5;
   VAR I,J,K: INTEGER;
       K1: REAL;
       W7,W8,W9,W10,W11,W12: REAL;
       W13,W14,W15,W16,W17,W18: REAL;
       FILTR: CHAR;
   BEGIN;
   {TEXTMODE(0);}
   ZWET2;
   CLRSCR;
   I:=1;
   K:=A[2,3102]; { К-ВО ИЗМЕРЕНИЙ ФОНА}
   K1:=K;
   W13:=0; W14:=0; W15:=0; W16:=0; W17:=0; W18:=0;
M1:
   KI1;
   CANALI;
   W7:=W1; W8:=W2; W9:=W3; W10:=W4; W11:=W5; W12:=W6;
   W13:=W13+W7; W14:=W14+W8; W15:=W15+W9; W16:=W16+W10; W17:=W17+W11; W18:=W18+W12;
   GOTOXY(4,6); TEXTCOLOR(7); CLREOL;
   IF NFF=1 THEN FILTR:='B';
   IF NFF=2 THEN FILTR:='V';
   IF NFF=3 THEN FILTR:='R';
   IF NFF=4 THEN FILTR:='I';
   WRITELN('ИЗМ. ФОНА ',K,' ОТСЧ., ФИЛЬТР   ',FILTR);
   GOTOXY(3,8);  TEXTCOLOR(10);  CLREOL; WRITELN(I);
   GOTOXY(8,8);  TEXTCOLOR(11);  CLREOL; WRITELN(W1);
   GOTOXY(13,8); TEXTCOLOR(12);  CLREOL; WRITELN(W2);
   GOTOXY(18,8); TEXTCOLOR(11);  CLREOL; WRITELN(W3);
   GOTOXY(23,8); TEXTCOLOR(12);  CLREOL; WRITELN(W4);
   GOTOXY(28,8); TEXTCOLOR(11);  CLREOL; WRITELN(W5);
   GOTOXY(33,8); TEXTCOLOR(12);  CLREOL; WRITELN(W6);
   W:=W1; REGSAM;
   I:=I+1;
   IF I=K+1 THEN GOTO M0;
   GOTO M1;
M0:
   W13:=W13/K1*10/KZ; W14:=W14/K1*10/KZ; W15:=W15/K1*10/KZ;
   W16:=W16/K1*10/KZ; W17:=W17/K1*10/KZ; W18:=W18/K1*10/KZ;
   W1:=ROUND(W13); W2:=ROUND(W14); W3:=ROUND(W15);
   W4:=ROUND(W16); W5:=ROUND(W17); W6:=ROUND(W18);
   A[1,3200]:=W1; A[2,3200]:=W2; A[3,3200]:=W3;
   A[4,3200]:=W4; A[5,3200]:=W5; A[6,3200]:=W6;
   {TEXTMODE(MODE);}
   CLRSCR;
   MINSAM;
   END;

PROCEDURE U0SH;
   BEGIN;
   K:=15;
   PORT[BASE]:=0;
   ZAPIS;
   PORT[BASE]:=4;
   ZAPIS;
   PORT[BASE]:=0;
   ZAPIS;
   END;

PROCEDURE FILT;
LABEL M1,M2,M3,M4,M5;
   BEGIN
     IF NFF>1 THEN GOTO M1;
     FB; GOTO M4;
M1:  IF NFF>2 THEN GOTO M2;
     FV; GOTO M4;
M2:  IF NFF>3 THEN GOTO M3;
     FR; GOTO M4;
M3:  FUR;

M4:  DELAY(15);
   END;


PROCEDURE REG;
   LABEL M0,M1,MF,MF1,MF2;
   VAR III: BYTE;
       NF: INTEGER;
       INTERVAL: REAL;
   BEGIN;
  {J:=0; REPEAT J:=J+1; A[1,J]:=0; A[2,J]:=0; A[3,J]:=0;
   A[4,J]:=0; A[5,J]:=0; A[5,J]:=0; UNTIL J=3096;}
   SKOD:=0;
   UDEL:=0;
   UD:=0;
   ZS:=0;
   FAZA:=0;
   NFF:=0;
   WREKO;

   WREFO;
   UK:=UF-120;
M0:
   WREFO;
   INTERVAL:=120-(UF-UK); {12.0 СЕКУНД - 24 ПРОПУСКА}
   WRITE(INTERVAL:5:1); DELAY(10); IF INTERVAL>0 THEN GOTO M0;

   N:=A[4,3100];
   NFF:=NFF+1;

   REGMINUSN;

   IF A3=0 THEN GOTO M1;
   {U0SH; СБРОС СЧЕТЧИКА ORGAN;}

   FILT;
   UDZW;
   FONN;
   IF NFF=4{3} THEN GOTO MF1;
   GOTO MF2;
MF1:  NFF:=0;
MF2:

   WOZW;
   NAMEZ:=NAMEAFT[N];
   WRITEF;
   {SOLSOL;}
   TUM;
   A[4,3100]:=N+1;
   NF:=30;
   K:=1;
   PORT[BASE]:=36;
   ZAPIS;
   BITIN;
   IF B2=0 THEN GOTO MF;
   FOKUSPLUS05;
   GOTO M0;
MF:


   FOKUSPLUS;



   {IF B2=0 THEN GOTO M1; ТУМБЛЕР ВНИЗ - РЕГИСТРАЦИЯ НЕ НАЧНЕТСЯ}
   IF N=97 THEN GOTO M1;
   GOTO M0;
M1:
   END;



PROCEDURE WEDENIE;
   LABEL M00,M0,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,M13,M14,M15,
         M21,M22,M23,
         M31,M32,
         M41,
         M51,M52,M53,
         M61,M62,
         M71,M72,
         MM9,M91,M92,M93,M94,M95,M96,M97,M9A,M9B,M9C,M9D;
   VAR D1,D2: REAL;
       D3,D4: BYTE;
       A,A1,A2,A3,A4,A5,A6,A7: REAL;
       KA: BYTE;
       OT: INTEGER;

   AA1,AA2,AA3,AA4,AA5,AA6,AA7,AA8: BYTE;
   C1,C2: BYTE;
   C3: BYTE;



   BEGIN;
M00:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(21,4,59,28);
   GOTOXY(1,1);
   WRITELN('          ВЕДЕНИЕ ТЕЛЕСКОПА           ');
   WRITELN('                                      ');
   WRITELN('   ВЫХОД......................... 0   ');
   WRITELN('   УСТАНОВКА КОЭФФИЦИЕНТА........ 1   ');
   WRITELN('   ПРОВЕРКА ИЗМЕНЕНИЯ............ 2   ');
   WRITELN('   ЭКСТРАПОЛЯЦИЯ НА ДВА ЧАСА..... 3   ');
   WRITELN('   ИЗМЕНЕНИЕ ОТ ПУЛЬТА........... 4   ');
   WRITELN('   ПРОВЕРКА ДВИЖЕНИЯ ПО ДЕЛЬТА... 5   ');
   WRITELN('   КОМПЕНСАЦИЯ ПЕРИОДА........... 6   ');
   WRITELN('   КОМПЕНСАЦИЯ ГИДИРОВАНИЯ....... 7   ');
   WRITELN('   РАЗЪЕМ ГИДИРОВЩИКА............ 8   ');
   WRITELN('   ФОКУСИРОВКА ОТ ЭВМ.............9   ');
   WRITELN('   ПЕРЕКЛАДКА....................10   ');
   WRITELN('   TRE1..........................11   ');
   WRITELN('   TRE2..........................12   ');
   WRITELN('   ЗАДЕРЖКА......................13   ');
   WRITELN('   ЦИКЛ ПО АЛЬФА.................14   ');
   WRITELN('   СКОРОСТЬ ИЗМЕНЕНИЯ КОЭФ. .....15   ');
   GOTOXY(1,1);
   READLN(I);

   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M5;
   IF I=6 THEN GOTO M6;
   IF I=7 THEN GOTO M7;
   IF I=8 THEN GOTO M8;
   IF I=9 THEN GOTO M9;
   IF I=10 THEN GOTO M10;
   IF I=11 THEN GOTO M11;
   IF I=12 THEN GOTO M12;
   IF I=13 THEN GOTO M13;
   IF I=14 THEN GOTO M14;
   IF I=15 THEN GOTO M15;

M1:
   CLRSCR;
   UGOL;
   WRITELN('');
   WRITE('    КОЗФФИЦИЕНТ (СРЕДНИЙ-6650) ? ');
   READLN(D);
   KOEF;
   WRITE('    ПОВТОРИТЬ ? ');
   READLN(I);
   IF I=1 THEN GOTO M1;
   GOTO M00;
M2:
   CLRSCR;
M21:
   IZMENENIE;
   IZPU;
   UGOL;
   GOTOXY(5,8);
   WRITELN('СКОРОСТЬ ',BA,'    КОЭФФИЦИЕНТ   ',D:6:2);
   IF H=1 THEN GOTO M22;
   GOTOXY(5,10);
   WRITELN('НАПРАВЛЕНИЕ - МИНУС');
   GOTO M23;
M22:
   GOTOXY(5,10); CLREOL;
   WRITELN('НАПРАВЛЕНИЕ - ПЛЮС');
M23:
   KOEF;
   OST;
   IF B3=1 THEN GOTO M00;
   DELAY(500);
   GOTO M21;
M3:
   CLRSCR;
   WRITELN('');
   WRITE('   ЭКСТРАПОЛЯЦИЯ ВПЕРЕД ? ');
   READLN(I);
   WRITELN('');
   WRITE('   НАЧАЛЬНЫЙ КОЭФФИЦИЕНТ ? ');
   READLN(A);
   WRITELN('');
   IF I=1 THEN GOTO M31;
   A1:=A-72000/KO*0.25;
   A2:=A-72000/KO*0.25*2;
   A3:=A-72000/KO*0.25*3;
   A4:=A-72000/KO*0.25*4;
   A5:=A-72000/KO*0.25*5;
   A6:=A-72000/KO*0.25*6;
   A7:=A-72000/KO*0.25*7;
   GOTO M32;
M31:
   A1:=A+72000/KO*0.25;
   A2:=A+72000/KO*0.25*2;
   A3:=A+72000/KO*0.25*3;
   A4:=A+72000/KO*0.25*4;
   A5:=A+72000/KO*0.25*5;
   A6:=A+72000/KO*0.25*6;
   A7:=A+72000/KO*0.25*7;
M32:
   WRITELN(' СКОРОСТЬ       КОНЕЧНЫЙ КОЭФФИЦИЕНТ ');
   WRITELN('');
   WRITELN('    1 .............. ',A1:8:2);
   WRITELN('    2 .............. ',A2:8:2);
   WRITELN('    3 .............. ',A3:8:2);
   WRITELN('    4 .............. ',A4:8:2);
   WRITELN('    5 .............. ',A5:8:2);
   WRITELN('    6 .............. ',A6:8:2);
   WRITELN('    7 .............. ',A7:8:2);
   WRITELN('');
   WRITE('   ПОВТОРИТЬ ? ');
   READLN(I);
   IF I=1 THEN GOTO M3;
   GOTO M00;
M4:
   CLRSCR;
M41:
   IZPU;
   GOTOXY(5,5);
   WRITELN('КОЭФФИЦИЕНТ   ',D:8:2);
   DELAY(500);
   OST;
   IF B3=1 THEN GOTO M00;
   GOTO M41;
M5:
   CLRSCR;
   GOTOXY(5,2);
   WRITE('СОПРОВОЖДЕНИЕ ЗВУКОМ ? ');
   READLN(ZS);
   A1:=KD/10/1;
   A2:=KD/10/2;
   A3:=KD/10/3;
   A4:=KD/10/4;
   A5:=KD/10/5;
   A6:=KD/10/6;
   A7:=KD/10/7;
   WRITELN('');
   WRITELN('  СКОРОСТЬ 1 - 1 ШАГ ЗА ',A1:5:1,'  СЕКУНД');
   WRITELN('  СКОРОСТЬ 2 - 1 ШАГ ЗА ',A2:5:1,'  СЕКУНД');
   WRITELN('  СКОРОСТЬ 3 - 1 ШАГ ЗА ',A3:5:1,'  СЕКУНД');
   WRITELN('  СКОРОСТЬ 4 - 1 ШАГ ЗА ',A4:5:1,'  СЕКУНД');
   WRITELN('  СКОРОСТЬ 5 - 1 ШАГ ЗА ',A5:5:1,'  СЕКУНД');
   WRITELN('  СКОРОСТЬ 6 - 1 ШАГ ЗА ',A6:5:1,'  СЕКУНД');
   WRITELN('  СКОРОСТЬ 7 - 1 ШАГ ЗА ',A7:5:1,'  СЕКУНД');
M51:
   DELTA;
   WREMA;
   GOTOXY(3,12);
   K:=1;
   PORT[BASE]:=37;
   ZAPIS;
   BITIN;
   BD:=B2*4+B3*2+B4;
   IF B1=1 THEN GOTO M52;
   WRITELN('  СКОРОСТЬ ',BD,'  НАПРАВЛЕНИЕ - МИНУС');
   GOTO M53;
M52:
   CLREOL; WRITELN('  СКОРОСТЬ ',BD,'  НАПРАВЛЕНИЕ - ПЛЮС');
M53:
   DELAY(500);
   OST;
   IF B3=1 THEN GOTO M00;
   GOTO M51;
M6:
  CLRSCR;
   GOTOXY(5,2);
   WRITE('СОПРОВОЖДЕНИЕ ЗВУКОМ ? ');
   READLN(ZS);
M61:
   OST;
   IF B3=1 THEN GOTO M00;
   K:=1;
   PORT[BASE]:=38;
   ZAPIS;
   BITIN;
   IF B4=1 THEN GOTO M62;
   ALFA;
   GOTOXY(5,6); CLREOL; WRITELN('ФАЗА ЧЕРВЯКА  ',FAZA1);
   DELAY(100);
   GOTO M61;
M62:
   GOTOXY(5,6); CLREOL; WRITELN('КОМПЕНСАЦИЯ НЕ РАЗРЕШЕНА');
   DELAY(100);
   GOTO M61;
M7:
   WRITELN(' КОМПЕНСАЦИЯ ПО АЛЬФА (0,1) ? ');
   READ(KOMPA);
   WRITELN(' КОМПЕНСАЦИЯ ПО ДЕЛЬТА (0,1) ? ');
   READ(KOMPD);
   GOTO M00;




M8:
   K:=1;
   PORT[BASE]:=32;
   ZAPIS;

   BITIN;
   C1:=B4+B3*2+B2*2*2+B1*2*2*2;
   AA1:=B1; AA2:=B2; AA3:=B3; AA4:=B4;
   PORT[BASE]:=32;
   ZAPIS;
   BIT;
   C2:=B4+B3*2+B2*2*2+B1*2*2*2;
   AA5:=B1; AA6:=B2; AA7:=B3; AA8:=B4;
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(6,5,77,20);
   GOTOXY(1,1);
   WRITELN('                                                                     ');
   WRITELN('                       РАЗЪЕМ ГИДИРОВЩИКА                            ');
   WRITELN('                                                                     ');
   WRITELN('                                                                     ');
   WRITELN('                             АДРЕС     В1   В2   В3   В4   ЧИСЛО     ');
   WRITELN('                                                                     ');
   WRITELN('  ИНВЕРТИРОВАННЫЕ БИТЫ......  32       ',AA1,'    ',AA2,'    ',AA3,'    ',AA4,'      ',C1,'       ');
   WRITELN('                                                                     ');
   WRITELN('  НЕИНВЕРТИРОВАННЫЕ БИТЫ....  32       ',AA5,'    ',AA6,'    ',AA7,'    ',AA8,'      ',C2,'       ');
   WRITELN('                                                                     ');
   WRITELN('                                                                     ');
   WRITELN('                                                                     ');
   DELAY(100);
   OST;
   IF B3=1 THEN GOTO M00;
   GOTO M8;

M9:
   WRITELN('  HAЧАЛЬНАЯ УСТАНОВКА ФОКУСА ? ');
   READ(I);
   IF I=0 THEN GOTO MM9;
   WRITELN('  ФОКУС ? ');
   READ(FO);

MM9:
   I:=0;
M94:
   CLRSCR;
   K:=1;
   PORT[BASE]:=40;
   ZAPIS;
   BITIN;
   C1:=B4+B3*2+B2*2*2+B1*2*2*2;
   WRITELN(C1);
   I:=0;
   IF C1=1 THEN GOTO M91;
   IF C1=8 THEN GOTO M92;
   IF C1=0 THEN GOTO M93;

M91:
   FOKUSPLUS;
   WRITELN('ФОКУС +');
   {FO:=FO+1;
   IF I=20 THEN GOTO M96;
   GOTO M91;}
M96:
   I:=0;
   SOLSOL;
   DELAY(200);
   GOTO M93;
M92:
   {I:=I+1;}
   FOKUSMINUS;
   WRITELN('ФОКУС -');
   {FO:=FO-1;
   IF I=20 THEN GOTO M97;
   GOTO M92;}
M97:
   I:=0;
   SOLSOL;
   DELAY(200);
   GOTO M93;

M93:
   GOTOXY(10,10);
   WRITELN('НЕТ СИГНАЛА');

   WRITELN('         ФОКУС ',FO);
   OST;
   IF B3=1 THEN GOTO M00;
   DELAY(100);
   GOTO M94;

M10:
   WRITE(' ТЕЛЕСКОП СПРАВА (0,1) ? ');
   READ(PERE);
   GOTO M00;

M11:
   WRITE(' СИГНАЛ ТРЕВОГИ 1 (6000) ? ');
   READ(TRE1);
   GOTO M00;

M12:
   WRITE(' СИГНАЛ ТРЕВОГИ 2 (250) ? ');
   READ(TRE2);
   GOTO M00;

M13:
   WRITE(' ЗАДЕРЖКА (4) ? ');
   READ(DELL);
   GOTO M00;

M14:
   WRITE(' ЦИКЛ ПО АЛЬФА (1) ? ');
   READ(ALC);
   GOTO M00;

M15:
   WRITE(' CКОРОСТЬ ПО ФЛЬФА (1) ? ');
   READ(ALSK);
   GOTO M00;

M0:
   END;

PROCEDURE FILTR;
   LABEL M00,M0,M1,M2,M3,M4,M5,M6;
   BEGIN;
M00:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(18,6,61,16);
   GOTOXY(1,1);
   WRITELN('                                           ');
   WRITELN('                 ФИЛЬТРЫ                   ');
   WRITELN('   ВЫХОД...............................0   ');
   WRITELN('   НАЧАЛЬНАЯ УСТАНОВКА.................1   ');
   WRITELN('   ВЫБОР ДВУХ ФИЛЬТРОВ.................2   ');
   WRITELN('   ЦИКЛИЧ. ПРАВАЯ НАЧ. УСТАНОВКА.......3   ');
   WRITELN('   ЦИКЛИЧ. ЛЕВАЯ НАЧ. УСТАНОВКА........4   ');
   WRITELN('                                           ');
   GOTOXY(1,1);
   READ(I);
   CLRSCR;
   IF I=0 THEN GOTO M0;
   IF I=1 THEN GOTO M1;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
M1:
      NUFIL1;
      NUFIL2;
      J:=J+1;
      DELAY(1000);
      GOTO M00;
M2:
      WRITE(' НОМЕР ФИЛЬТРA ( 0,1,2,3,4,5) ? ');
      READ(NFI);
      NFIL;
      WRITELN('ФИЛЬТРЫ ',NFI,' УСТАНОВЛЕНЫ');
      DELAY(1000);
      GOTO M00;
M3:
     J:=0;
REPEAT
      NUFIL1;
      NUFIL2;
      J:=J+1;
      DELAY(1000);
UNTIL J=20;
      DELAY(2000);
      GOTO M00;
M4:
      NAPF:=8;
      J:=0;
REPEAT
      NUFIL1;
      NUFIL2;
      J:=J+1;
      DELAY(1000);
UNTIL J=20;
      NAPF:=0;
      DELAY(2000);
      GOTO M00;
M0:   END;





PROCEDURE GLAW;
   LABEL M0,M00,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,M13,
         M81;
   BEGIN;
M00:
   ZWET1;
   CLRSCR;
   ZWET2;
   WINDOW(21,5,60,23);
   GOTOXY(1,1); TEXTCOLOR(15);
   WRITELN('                                      ');
   WRITELN('            ГЛАВНОЕ ОКНО              ');
   WRITELN('                                      ');
   WRITELN('   ВЫХОД......................... 0   ');
   WRITELN('   ВРЕМЯ......................... 2   ');
   WRITELN('   САМОПИСЕЦ..................... 3   ');
   WRITELN('   ФОН........................... 4   ');
   WRITELN('   ФАЙЛЫ......................... 5   ');
   WRITELN('   СРАВНЕНИЕ КАНАЛОВ............. 6   ');
   WRITELN('   РЕГИСТРАЦИЯ................... 7   ');
   WRITELN('   ФИЛЬТРЫ....................... 8   ');
   WRITELN('   ПУЛЬТ......................... 9   ');
   WRITELN('   КЛАВИША.......................10   ');
   WRITELN('   ЗВУК..........................11   ');
   WRITELN('   ВЕДЕНИЕ ТЕЛЕСКОПА.............12   ');
   WRITELN('                                      ');
   GOTOXY(1,1);
   READLN(I);

   IF I=0 THEN GOTO M0;
   IF I=2 THEN GOTO M2;
   IF I=3 THEN GOTO M3;
   IF I=4 THEN GOTO M4;
   IF I=5 THEN GOTO M5;
   IF I=6 THEN GOTO M6;
   IF I=7 THEN GOTO M7;
   IF I=8 THEN GOTO M8;
   IF I=9 THEN GOTO M9;
   IF I=10 THEN GOTO M10;
   IF I=11 THEN GOTO M11;
   IF I=12 THEN GOTO M12;
M2:
   UWREMA;
   GOTO M00;
M3:
   USAM;
   GOTO M00;
M4:
   UFON;
   GOTO M00;
M5:
   FILES;
   GOTO M00;
M6:
   SRAWNENIE;
   GOTO M00;
M7:
   SKOD:=0;
   WRITE(' НОМЕР ПЕРВОЙ ЗАПИСИ (1,2,3,...) ? ');
   READLN(I);
   A[4,3100]:=I;
   J:=0;
   REPEAT J:=J+1; A[1,J]:=0; A[2,J]:=0; A[3,J]:=0; A[4,J]:=0; UNTIL J=3096;
{   WREMA;
   A[1,3107]:=T1; A[2,3107]:=T2; A[3,3107]:=T3; A[4,3107]:=T4;}
   REG;
   GOTO M00;
M8:
   FILTR;
   GOTO M00;
M9:
   UPULT;
   GOTO M00;
M10:
   UKLAWISHA;
   GOTO M00;
M11:
   UZWUK;
   GOTO M00;
M12:
   WEDENIE;
   GOTO M00;
M0:
   END;



      BEGIN

      PERE:=0;
      DELL:=4{6};
      FOK1:=1;
      FOK2:=3;
      TRE1:=6000;
      TRE2:=250;
      ALC:=1;
      ALSK:=0.5;
      KOMPA:=1;
      KOMPD:=1;
      KZ:=1;{ДЛЯ ФОНА, ЕСЛИ 1 ТО В 10 РАЗ БОЛЬШЕ, ЕСЛИ 10 ТО КАК ОДИН ОТСЧЕТ}
      KZ1:=1;{ДЛЯ ЯРКОЙ ЗВЕЗДЫ ЕСЛИ 10 ТО КАК ОДИН ОТСЧЕТ}
      BASE:=MEMW[$0:$408];
      WRITELN(BASE);



      REN:=16{32};
      ZF:=184{248};
      UKLAW;
      ZWET2;
      MODE:=LASTMODE;
      CLRSCR;
      NAME:=FFF;
      READF;
      FO:=A[1,3197];
      NAMEFILE:=FF;
      READN;
      D:=6650;
      AM:=0;
      KOEF;
      EX;
      KANAL:=1;
      I:=1;
      REPEAT
      A[1,I]:=0; A[2,I]:=0; A[3,I]:=0; A[4,I]:=0; A[5,I]:=0; A[6,I]:=0;
      I:=I+1;
      UNTIL I=3097;
      GLAW;
      MINSAM;
      A[1,3197]:=FO;
      NAMEZ:=FFF;
      WRITEF;
     { NAMEFILE:=FF;
      WRITEN;}
      UMASH;
KON:

   END.
