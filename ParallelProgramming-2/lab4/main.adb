
-- Parallel and Distributed Computing
-- Laboratory work #4. Ada Randeveuz
-- Task: MA = (B*C)*MZ + min(Z)*(MX*MC)
-- Koval Rostyslav IO-71

   with Ada.Text_IO, Ada.Integer_text_iO, Ada.Synchronous_Task_Control, Data;
   use Ada.Text_IO, Ada.Integer_text_iO, Ada.Synchronous_Task_Control;

   procedure main is

    Value : Integer := 1;
    N : Natural := 12;
    P : Natural := 6;
    H : Natural := N/P;

    package DataN is new Data(N, H);
    use DataN;

    procedure StartTasks is

    task T1 is
         entry DATA_C2H_MX(C2H: in Vector2H; MX: in MatrixN);
         entry DATA_A6(a6: in Integer);
         entry DATA_X6(x6: in Integer);
         entry DATA_ZH(ZH: in VectorH);
         entry DATA_MZH(MZH: in MatrixH);
         entry DATA_A(a: in Integer);
         entry DATA_X(x: in Integer);
         entry RESULT_T1(MA11 : out MatrixH; MA61 : out MatrixH);
    end T1;

    task T2 is
         entry DATA_MC3H_B3H(MC3H: in Matrix3H; B3H: in Vector3H);
         entry DATA_CH_MX(CH: in VectorH; MX: in MatrixN);
         entry DATA_A1(a1: in Integer);
         entry DATA_X1(x1: in Integer);
         entry DATA_A5(a5: in Integer);
         entry DATA_X5(x5: in Integer);
         entry DATA_A3(a3: in Integer);
         entry DATA_X3(x3: in Integer);
         entry DATA_Z3H(Z3H: in Vector3H);
         entry DATA_MZ2H(MZH: in Matrix2H);
         entry RESULT_T2(MA12 : out MatrixH;MA62 : out MatrixH;MA22 : out MatrixH;MA52 : out MatrixH);
    end T2;

    task T3 is
         entry DATA_MC2H_B2H(MC2H: in Matrix2H; B2H: in Vector2H);
         entry DATA_CH_MX(CH: in VectorH; MX: in MatrixN);
         entry DATA_A4(a4: in Integer);
         entry DATA_X4(x4: in Integer);
         entry DATA_ZH(ZH: in VectorH);
         entry DATA_A(a: in Integer);
         entry DATA_X(x: in Integer);

    end T3;

    task T4 is
         entry DATA_MCH_BH(MCH: in MatrixH; BH: in VectorH);
         entry DATA_MZ3H(MZ: in Matrix3H);
         entry DATA_C2H_MX(C2H: in Vector2H; MX: in MatrixN);
         entry DATA_ZH(ZH: in VectorH);
         entry DATA_A(a: in Integer);
         entry DATA_X(x: in Integer);
         entry RESULT_T4(MA : out MatrixH);


    end T4;

    task T5 is
         entry DATA_MCH_BH(MCH: in MatrixH; BH: in VectorH);
         entry DATA_MZ2H(MZ2H: in Matrix2H);
         entry DATA_C3H_MX(C3H: in Vector3H; MX: in MatrixN);
         entry DATA_A(a: in Integer);
         entry DATA_X(x: in Integer);
         entry RESULT_T5(MA : out MatrixH);
    end T5;

    task T6 is
         entry DATA_MC2H_B2H(MC2H: in Matrix2H; B2H: in Vector2H);
         entry DATA_MZH(MZ: in MatrixH);
         entry DATA_ZH(ZH: in VectorH);
         entry DATA_A(a: in Integer);
         entry DATA_X(x: in Integer);
         entry RESULT_T6(MA : out MatrixH);
    end T6;

    task body T1 is
         MA6: MatrixH;
         MA1: MatrixH;
         MQ1: MatrixH;
         MB1: MatrixH;
         B1: VectorN;
         C1: Vector2H;
         MZ1: MatrixH;
         Z1: VectorH;
         MX1: MatrixN;
         MC1: MatrixN;
         x_1 : Integer := 0;
         x6_1: Integer := 0;
         a6_1: Integer := 0;
         minZ1 : Integer := 99999;
         MT1: MatrixH;
         MT2: MatrixH;
    begin
         Put_Line("T1 started");
         Input(MC1,1);
         Input(B1,1);
         accept DATA_C2H_MX (C2H: in Vector2H; MX: in MatrixN) do
            C1 := C2H;
            MX1 := MX;
         end DATA_C2H_MX;
         T6.DATA_MC2H_B2H(MC1(4*H+1..N), B1(4*H+1..N));
         T2.DATA_MC3H_B3H(MC1(H+1..4*H), B1(H+1..4*H));
         accept DATA_MZH (MZH : in MatrixH) do
            MZ1:=MZH;
         end DATA_MZH;
         accept DATA_ZH (ZH : in VectorH) do
            Z1 := ZH;
         end DATA_ZH;
         T2.DATA_CH_MX(C1(H+1..2*H), MX1);

         for I in 1..H loop
            if Z1(I) < minZ1 then
               minZ1 := Z1(I);
            end if;
         end loop;

         accept DATA_A6 (A6: in Integer) do
            a6_1 := A6;
         end DATA_A6;
         minZ1 := Min(a6_1, minZ1);
         T2.DATA_A1(minZ1);
         accept DATA_A (A : in Integer) do
            minZ1:=A;
         end DATA_A;
         T6.DATA_A(minZ1);
         for I in 1..H loop
            x_1 := x_1 + B1(I)*C1(I);
         end loop;
         accept DATA_X6 (X6: in Integer) do
            x6_1 := X6;
         end DATA_X6;
         x_1 := x_1 + x6_1;
         T2.DATA_X1(x_1);
         accept DATA_X (X: in Integer) do
            x_1 := X;
         end DATA_X;
         T6.DATA_X(x_1);

         for i in 1..H loop
            for j in 1..N loop
               MT1(i)(j):= MZ1(i)(j);
               MT2(i)(j):= MC1(i)(j);
            end loop;
         end loop;
         MA1:=Calculation(x_1,minZ1,MT1,MX1,MT2);
         T6.RESULT_T6(MA6);
         accept RESULT_T1 (MA11 : out MatrixH; MA61 : out MatrixH) do
            MA11:=MA1;
            MA61:=MA6;
         end RESULT_T1;
    Put_Line("T1 finished");
    end T1;


    task body T2 is
         MT2: MatrixH;
         MT22: MatrixH;
         MA1: MatrixH;
         MA5: MatrixH;
         MA6: MatrixH;
         MA2: MatrixH;
         B2: Vector3H;
         C2: VectorH;
         MZ2: Matrix2H;
         Z2: Vector3H;
         MX2: MatrixN;
         MC2: Matrix3H;
         x_2 : Integer:=0;
         x1_2: Integer;
         a1_2: Integer;
         x5_2: Integer;
         a5_2: Integer;
         x3_2: Integer;
         a3_2: Integer;
         minZ2 : Integer := 99999;
    begin
         Put_Line("T2 started");
         accept DATA_Z3H (Z3H : in Vector3H) do
            Z2 := Z3H;
         end DATA_Z3H;
         accept DATA_MZ2H (MZH : in Matrix2H) do
            MZ2:=MZH;
         end DATA_MZ2H;
         accept DATA_MC3H_B3H (MC3H : in Matrix3H; B3H: in Vector3H) do
            MC2 := MC3H;
            B2 := B3H;
         end DATA_MC3H_B3H;
         T1.DATA_MZH(MZ2(1..H));
         T1.DATA_ZH(Z2(1..H));
         T3.DATA_ZH(Z2(2*H+1..3*H));
         T3.DATA_MC2H_B2H(MC2(H+1..3*H), B2(H+1..3*H));
         accept DATA_CH_MX (CH: in VectorH; MX: in MatrixN) do
            C2 := CH;
            MX2 := MX;
         end DATA_CH_MX;
         for I in 1..H loop
            if Z2(I) < minZ2 then
               minZ2 := Z2(I);
            end if;
         end loop;
         accept DATA_A1 (A1: in Integer) do
            a1_2 := A1;
         end DATA_A1;
         minZ2 := Min(a1_2, minZ2);
         accept DATA_A3 (A3: in Integer) do
            a3_2 := A3;
         end DATA_A3;
         minZ2 := Min(a3_2, minZ2);
         accept DATA_A5 (A5: in Integer) do
            a5_2 := A5;
         end DATA_A5;
         minZ2 := Min(a5_2, minZ2);
         T1.DATA_A(minZ2);
         T3.DATA_A(minZ2);
         T5.DATA_A(minZ2);
         for I in 1..H loop
            x_2 := x_2 + B2(I)*C2(I);
         end loop;
         accept DATA_X1 (X1: in Integer) do
            x1_2 := X1;
         end DATA_X1;
         x_2 := CalcSumX(x_2, x1_2);
         accept DATA_X3 (X3: in Integer) do
            x3_2 := X3;
         end DATA_X3;
         x_2 := CalcSumX(x_2, x3_2);
         accept DATA_X5 (X5: in Integer) do
            x5_2 := X5;
         end DATA_X5;
         x_2 := CalcSumX(x_2, x5_2);
         T1.DATA_X(x_2);
         T3.DATA_X(x_2);
         T5.DATA_X(x_2);
         for i in 1..H loop
            for j in 1..N loop
               MT2(i)(j):= MZ2(H+i)(j);
               MT22(i)(j):= MC2(i)(j);
            end loop;
         end loop;

         MA2:=Calculation(x_2,minZ2,MT2,MX2,MT22);
         T1.RESULT_T1(MA1,MA6);
         T5.RESULT_T5(MA5);
         accept RESULT_T2 (MA12 : out MatrixH; MA62 : out MatrixH; MA22 : out MatrixH; MA52 : out MatrixH) do
            MA12:=MA1;
            MA62:=MA6;
            MA22:=MA2;
            MA52:=MA5;
         end RESULT_T2;
    Put_Line("T2 finished");
    end T2;


    task body T3 is
         MT3: MatrixH;
         MT32: MatrixH;
         MA3: MatrixH;
         MA1: MatrixH;
         MA2: MatrixH;
         MA4: MatrixH;
         MA5: MatrixH;
         MA6: MatrixH;
         B3: Vector2H;
         C3: VectorH;
         MZ3: MatrixN;
         Z3: VectorH;
         MX3: MatrixN;
         MC3: Matrix2H;
         x_3 : Integer;
         MA: MatrixN;
         x4_3: Integer;
         a4_3: Integer;
         minZ3 : Integer := 99999;
    begin
         Put_Line("T3 started");
         Input(MZ3,1);
         T2.DATA_MZ2H(MZ3(1..2*H));
         T4.DATA_MZ3H(MZ3(3*H+1..N));
         accept DATA_ZH (ZH : in VectorH) do
            Z3 := ZH;
         end DATA_ZH;
         accept DATA_MC2H_B2H (MC2H : in Matrix2H; B2H: in Vector2H) do
            MC3 := MC2H;
            B3 := B2H;
         end DATA_MC2H_B2H;
         T4.DATA_MCH_BH(MC3(H+1..2*H), B3(H+1..2*H));
         accept DATA_CH_MX (CH: in VectorH; MX: in MatrixN) do
            C3 := CH;
            MX3 := MX;
         end DATA_CH_MX;
         for I in 1..H loop
            if Z3(I) < minZ3 then
               minZ3 := Z3(I);
            end if;
         end loop;
         accept DATA_A4 (A4: in Integer) do
            a4_3 := A4;
         end DATA_A4;
         minZ3 := Min(a4_3, minZ3);
         T2.DATA_A3(minZ3);
         accept DATA_A (A : in Integer) do
            minZ3:=A;
         end DATA_A;
         T4.DATA_A(minZ3);
         x_3 := CalcX(B3, C3);
         accept DATA_X4 (X4: in Integer) do
            x4_3 := X4;
         end DATA_X4;
         x_3 := x_3 + x4_3;
         T2.DATA_X3(x_3);
         accept DATA_X (X: in Integer) do
            x_3 := X;
         end DATA_X;
         T4.DATA_X(x_3);
         for i in 1..H loop
            for j in 1..N loop
               MT3(i)(j):= MZ3(2*H+i)(j);
               MT32(i)(j):= MC3(i)(j);
            end loop;
         end loop;
         MA3:=Calculation(x_3,minZ3,MT3,MX3,MT32);
         T2.RESULT_T2(MA1,MA6,MA2,MA5);
         T4.RESULT_T4(MA4);
         for i in 1..H loop
            for j in 1..N loop
            MA(i)(j):=MA1(i)(j);
            MA(H+i)(j):=MA2(i)(j);
            MA(2*H+i)(j):=MA3(i)(j);
            MA(3*H+i)(j):=MA4(i)(j);
            MA(4*H+i)(j):=MA5(i)(j);
            MA(5*H+i)(j):=MA6(i)(j);
         end loop;
         end loop;
         Output(MA);
    Put_Line("T3 finished");
    end T3;


    task body T4 is
         MT4: MatrixH;
         MT42: MatrixH;
         MA4: MatrixH;
         B4: VectorH;
         C4: Vector2H;
         MZ4: Matrix3H;
         Z4: VectorH;
         MX4: MatrixN;
         MC4: MatrixH;
         x_4 : Integer;
         minZ4 : Integer := 99999;
    begin
         Put_Line("T4 started");
         accept DATA_ZH (ZH : in VectorH) do
            Z4 := ZH;
         end DATA_ZH;
         accept DATA_MZ3H (MZ : in Matrix3H) do
            MZ4:=MZ;
         end DATA_MZ3H;
         accept DATA_MCH_BH (MCH : in MatrixH; BH: in VectorH) do
            MC4 := MCH;
            B4 := BH;
         end DATA_MCH_BH;
         T5.DATA_MZ2H(MZ4(H+1..3*H));
         accept DATA_C2H_MX (C2H: in Vector2H; MX: in MatrixN) do
            C4 := C2H;
            MX4 := MX;
         end DATA_C2H_MX;
         T3.DATA_CH_MX(C4(1..H), MX4);
         for I in 1..H loop
            if Z4(I) < minZ4 then
               minZ4 := Z4(I);
            end if;
         end loop;
         T3.DATA_A4(minZ4);
         accept DATA_A (A : in Integer) do
            minZ4:=A;
         end DATA_A;
         x_4 := CalcX(B4, C4);
         T3.DATA_X4(x_4);
         accept DATA_X (X: in Integer) do
            x_4 := X;
         end DATA_X;
         for i in 1..H loop
            for j in 1..N loop
               MT4(i)(j):= MZ4(i)(j);
               MT42(i)(j):= MC4(i)(j);
            end loop;
         end loop;
         MA4:=Calculation(x_4,minZ4,MT4,MX4,MT42);
         accept RESULT_T4 (MA : out MatrixH) do
            MA:= MA4;
         end RESULT_T4;
    Put_Line("T4 finished");
    end T4;


    task body T5 is
         MT5: MatrixH;
         MT52: MatrixH;
         MA5: MatrixH;
         B5: VectorH;
         C5: Vector3H;
         MZ5: Matrix2H;
         Z5: VectorN;
         MX5: MatrixN;
         MC5: MatrixH;
         x_5 : Integer := 0;
         minZ5 : Integer := 99999;
    begin
         Put_Line("T5 started");
         Input(Z5,1);
         T2.DATA_Z3H(Z5(2*H+1..5*H));
         T6.DATA_ZH(Z5(5*H+1..6*H));
         T4.DATA_ZH(Z5(1..H));
         accept DATA_C3H_MX (C3H: in Vector3H; MX: in MatrixN) do
            C5 := C3H;
            MX5 := MX;
         end DATA_C3H_MX;
         accept DATA_MCH_BH (MCH : in MatrixH; BH: in VectorH) do
            MC5 := MCH;
            B5 := BH;
         end DATA_MCH_BH;
         accept DATA_MZ2H (MZ2H : in Matrix2H) do
            MZ5:=MZ2H;
         end DATA_MZ2H;
         T4.DATA_C2H_MX(C5(1..2*H), MX5);
         T6.DATA_MZH(MZ5(H+1..2*H));
         for I in 1..H loop
            if Z5(I) < minZ5 then
               minZ5 := Z5(I);
            end if;
         end loop;
         T2.DATA_A5(minZ5);
         accept DATA_A (A : in Integer) do
            minZ5:=A;
         end DATA_A;
         x_5 := CalcX(B5, C5);
         T2.DATA_X5(x_5);
         accept DATA_X (X: in Integer) do
            x_5 := X;
         end DATA_X;
         for i in 1..H loop
            for j in 1..N loop
               MT5(i)(j):= MZ5(i)(j);
               MT52(i)(j):= MC5(i)(j);
            end loop;
         end loop;
         MA5:=Calculation(x_5,minZ5,MT5,MX5,MT52);
         accept RESULT_T5 (MA : out MatrixH) do
            MA:= MA5;
         end RESULT_T5;
    Put_Line("T5 finished");
    end T5;


    task body T6 is
         MT6: MatrixH;
         MT62: MatrixH;
         MA6: MatrixH;
         B6: Vector2H;
         C6: VectorN;
         MZ6: MatrixH;
         Z6: VectorH;
         MX6: MatrixN;
         MC6: Matrix2H;
         x_6 : Integer;

         minZ6 : Integer := 99999;
    begin
         Put_Line("T6 started");
         Input(C6,1);
         Input(MX6,1);
         T1.DATA_C2H_MX(C6(1..2*H),MX6);
         accept DATA_ZH (ZH: in VectorH) do
            Z6 := ZH;
         end DATA_ZH;
         T5.DATA_C3H_MX(C6(2*H+1..5*H),MX6);
         accept DATA_MC2H_B2H (MC2H : in Matrix2H; B2H: in Vector2H) do
            MC6 := MC2H;
            B6 := B2H;
         end DATA_MC2H_B2H;
         T5.DATA_MCH_BH(MC6(1..H),B6(1..H));
         accept DATA_MZH (MZ : in MatrixH) do
            MZ6:=MZ;
         end DATA_MZH;
         for I in 1..H loop
            if Z6(I) < minZ6 then
               minZ6 := Z6(I);
            end if;
         end loop;
         T1.DATA_A6(minZ6);
         accept DATA_A (A : in Integer) do
            minZ6:=A;
         end DATA_A;
         x_6 := CalcX(B6, C6);
         T1.DATA_X6(x_6);
         accept DATA_X (X: in Integer) do
            x_6 := X;
         end DATA_X;
         for i in 1..H loop
            for j in 1..N loop
               MT6(i)(j):= MZ6(i)(j);
               MT62(i)(j):= MC6(H+i)(j);
            end loop;
         end loop;
         MA6:=Calculation(x_6,minZ6,MT6,MX6,MT62);
         accept RESULT_T6 (MA : out MatrixH) do
            MA:= MA6;
         end RESULT_T6;
    Put_Line("T6 finished");
    end T6;

    begin
        null;
        end StartTasks;
   begin
       Put_Line ("Lab4 started");
       StartTasks;
       Put_Line ("Lab4 finished");
   end main;
