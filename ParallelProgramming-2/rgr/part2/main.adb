-- Parallel and Distributed Computing
-- RGR. Ada Rendezvous
-- Task: Z = X*(MA*MS) + min(Q)*(R*MF)
-- Koval Rostyslav IO-71

   with Ada.Text_IO, Ada.Integer_text_iO, Ada.Synchronous_Task_Control, Data;
   use Ada.Text_IO, Ada.Integer_text_iO, Ada.Synchronous_Task_Control;
   with Ada.Real_Time;
   use Ada.Real_Time;

   procedure main is

   Value : Integer := 1;
   N : Natural := 8;
   P : Natural := 4;
   H : Natural := N/P;
   firstTime: Ada.Real_Time.Time;
   secondTime: Ada.Real_Time.Time_Span;
   function Calc_Time return Ada.Real_Time.Time_Span is
   begin
      return Ada.Real_Time.Clock - firstTime;
   end Calc_Time;
   measure : Duration;

    package DataN is new Data(N, H);
    use DataN;

    procedure StartTasks is

    task T1 is
         pragma Storage_Size(1024*1024*1024);
         entry DATA_X(X: in VectorN);
         entry DATA_Q(q: in Integer);
         entry DATA_R_MSH(R: in VectorN; MSH: in MatrixH);
         entry DATA_QH_MFH(QH: in VectorH; MFH: in MatrixH);
         entry RESULT_T1(Z11 : out VectorH);
    end T1;

    task T2 is
         pragma Storage_Size(1024*1024*1024);
         entry DATA_MA(MA: in MatrixN);
         entry DATA_Q1(q1: in Integer);
         entry DATA_Q3(q3: in Integer);
         entry DATA_Q4(q4: in Integer);
         entry DATA_R_MSH(R: in VectorN; MSH: in MatrixH);
         entry DATA_QH_MFH(QH: in VectorH; MFH: in MatrixH);
    end T2;

    task T3 is
         pragma Storage_Size(1024*1024*1024);
         entry DATA_X(X: in VectorN);
         entry DATA_MA(MA: in MatrixN);
         entry DATA_Q(q: in Integer);
         entry DATA_QH_MFH(QH: in VectorH; MFH: in MatrixH);
         entry RESULT_T3(Z33 : out VectorH);
    end T3;

    task T4 is
         pragma Storage_Size(1024*1024*1024);
         entry DATA_X(X: in VectorN);
         entry DATA_MA(MA: in MatrixN);
         entry DATA_Q(q: in Integer);
         entry DATA_R_MSH(R: in VectorN; MSH: in MatrixH);
         entry RESULT_T4(Z44 : out VectorH);
    end T4;


    task body T1 is
         MA1: MatrixN;
         X1: VectorN;
         Q1 : VectorH;
         q11: Integer := 0;
         q_1: Integer := 0;
         MF1: MatrixH;
         MS1: MatrixH;
         R1: VectorN;
         Z1: VectorH;
    begin
         Put_Line("T1 started");
         Input(MA1,1);
         T2.DATA_MA(MA1);
         T3.DATA_MA(MA1);
         T4.DATA_MA(MA1);

         accept DATA_X (X : in VectorN) do
            X1 := X;
         end DATA_X;

         accept DATA_R_MSH (R : in VectorN; MSH : in MatrixH) do
            R1 := R;
            MS1 := MSH;
         end DATA_R_MSH;

         accept DATA_QH_MFH (QH : in VectorH; MFH : in MatrixH) do
            Q1 := QH;
            MF1 := MFH;
         end DATA_QH_MFH;

         FindMinZ(Q1,q11);

         T2.DATA_Q1(q11);
         accept DATA_Q (q : in Integer) do
            q_1 := q;
         end DATA_Q;

         Z1:=Calculation(X1,MA1,MS1,q_1,R1,MF1);
         accept RESULT_T1 (Z11 : out VectorH) do
            Z11:=Z1;
         end RESULT_T1;

    Put_Line("T1 finished");
    end T1;


    task body T2 is
         MA2: MatrixN;
         X2: VectorN;
         Q2 : VectorH;
         q22: Integer := 0;
         q_2: Integer := 0;
         q2_1: Integer := 0;
         q2_3: Integer := 0;
         q2_4: Integer := 0;
         MF2: MatrixH;
         MS2: MatrixH;
         R2: VectorN;
         Z2: VectorH;
         Z1:VectorH;
         Z3:VectorH;
         Z4:VectorH;
         Z: VectorN;
    begin
         Put_Line("T2 started");
         Input(X2,1);

         accept DATA_MA (MA : in MatrixN) do
            MA2 := MA;
         end DATA_MA;

         T1.DATA_X(X2);
         T3.DATA_X(X2);
         T4.DATA_X(X2);

         accept DATA_R_MSH (R : in VectorN; MSH : in MatrixH) do
            R2 := R;
            MS2 := MSH;
         end DATA_R_MSH;

         accept DATA_QH_MFH (QH : in VectorH; MFH : in MatrixH) do
            Q2 := QH;
            MF2 := MFH;
         end DATA_QH_MFH;


         FindMinZ(Q2,q22);

         accept DATA_Q1 (q1 : in Integer) do
            q2_1 := q1;
         end DATA_Q1;

         q22 := Min(q22, q2_1);


         accept DATA_Q3 (q3 : in Integer) do
            q2_3 := q3;
         end DATA_Q3;

         q22 := Min(q22, q2_3);

         accept DATA_Q4 (q4 : in Integer) do
            q2_4 := q4;
         end DATA_Q4;

         q22 := Min(q22, q2_4);

         T1.DATA_Q(q22);
         T3.DATA_Q(q22);
         T4.DATA_Q(q22);

         Z2:=Calculation(X2,MA2,MS2,q22,R2,MF2);

         T1.RESULT_T1(Z1);

         T3.RESULT_T3(Z3);

         T4.RESULT_T4(Z4);

         for j in 1..H loop
            Z(j) := Z1(j);
            Z(H+j) := Z2(j);
            Z(2*H+j) := Z3(j);
            Z(3*H+j) := Z4(j);
         end loop;
         Output(Z);

    Put_Line("T2 finished");
    end T2;


    task body T3 is
         MA3: MatrixN;
         X3: VectorN;
         Q3 : VectorH;
         q33: Integer := 0;
         q_3: Integer := 0;
         MF3: MatrixH;
         MS3: MatrixN;
         R3: VectorN;
         Z3: VectorH;
         MT: MatrixH;
    begin
         Put_Line("T3 started");
         Input(MS3,1);
         Input(R3,1);

         accept DATA_MA (MA : in MatrixN) do
            MA3 := MA;
         end DATA_MA;

         accept DATA_X (X : in VectorN) do
            X3 := X;
         end DATA_X;

         T1.DATA_R_MSH(R3, MS3(1..H));
         T2.DATA_R_MSH(R3, MS3(H+1..2*H));
         T4.DATA_R_MSH(R3, MS3(3*H+1..4*H));

         accept DATA_QH_MFH (QH : in VectorH; MFH : in MatrixH) do
            Q3 := QH;
            MF3 := MFH;
         end DATA_QH_MFH;

         FindMinZ(Q3,q33);

         T2.DATA_Q3(q33);

         accept DATA_Q (q : in Integer) do
            q_3 := q;
         end DATA_Q;

         for j in 1..H loop
            for i in 1..N loop
            MT(j)(i) := MS3(2*H+j)(i);
         end loop;
         end loop;

         Z3:=Calculation(X3,MA3,MT,q_3,R3,MF3);

         accept RESULT_T3 (Z33 : out VectorH) do
            Z33:=Z3;
         end RESULT_T3;

    Put_Line("T3 finished");
    end T3;


    task body T4 is
         MA4: MatrixN;
         X4: VectorN;
         Q4 : VectorN;
         q44: Integer := 0;
         q_4: Integer := 0;
         MF4: MatrixN;
         MS4: MatrixH;
         R4: VectorN;
         Z4: VectorH;
         MK: MatrixH;
         K: VectorH;
    begin
         Put_Line("T4 started");
         Input(MF4,1);
         Input(Q4,1);

         accept DATA_MA (MA : in MatrixN) do
            MA4 := MA;
         end DATA_MA;

         accept DATA_X (X : in VectorN) do
            X4 := X;
         end DATA_X;

         accept DATA_R_MSH (R : in VectorN; MSH : in MatrixH) do
            R4 := R;
            MS4 := MSH;
         end DATA_R_MSH;

         T1.DATA_QH_MFH(Q4(1..H),MF4(1..H));
         T2.DATA_QH_MFH(Q4(H+1..2*H),MF4(H+1..2*H));
         T3.DATA_QH_MFH(Q4(2*H+1..3*H),MF4(2*H+1..3*H));

         for i in 1..H loop
            K(i) := Q4(3*H+i);
         end loop;


         FindMinZ(K,q44);

         T2.DATA_Q4(q44);

         accept DATA_Q (q : in Integer) do
            q_4 := q;
         end DATA_Q;

          for j in 1..H loop
            for i in 1..N loop
            MK(j)(i) := MF4(3*H+j)(i);
         end loop;
          end loop;

         Z4:=Calculation(X4,MA4,MS4,q_4,R4,MK);
         accept RESULT_T4 (Z44 : out VectorH) do
            Z44:=Z4;
         end RESULT_T4;

    Put_Line("T4 finished");
    end T4;

   begin
        null;
        end StartTasks;
   begin
       firstTime := Ada.Real_Time.Clock;
       Put_Line ("Lab4 started");
       StartTasks;
       Put_Line ("Lab4 finished");
       secondTime:=Calc_Time;

       measure:=Ada.Real_Time.To_Duration(secondTime);
       Put(Duration'Image(measure));
   end main;

