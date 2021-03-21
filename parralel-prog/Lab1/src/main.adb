with Data;
with Ada.Integer_Text_IO,Ada.Text_IO;
use Ada.Integer_Text_IO,Ada.Text_IO;
with System.Multiprocessors; use System.Multiprocessors;

--F1 ME = MAX(B) *(MA*MD)
--F2 MF = g*TRANS(MG)*(MK*ML)
--F3 O = (MP *MR)*S + T

procedure Main is
   N:Integer:=2;
   package Data1 is new Data (N);
   use Data1;
   Res1:Matrix;
   Res2:Matrix;
   Res3:Vector;

   CPU_0: CPU_Range := 1;
   CPU_1: CPU_Range := 2;
   CPU_2: CPU_Range := 3;

   procedure Tasks is
   task T1 is
      pragma Task_Name("T1");
      pragma Priority (9);
      pragma Storage_Size(10000000);
      pragma CPU(CPU_0);
   end T1;

   task T2 is
      pragma Task_Name("T2");
      pragma Priority (8);
      pragma Storage_Size(10000000);
      pragma CPU(CPU_1);
   end T2;

   task T3 is
      pragma Task_Name("T3");
      pragma Priority (3);
      pragma Storage_Size(10000000);
      pragma CPU(CPU_2);
   end T3;


   task body T1 is
      B:Vector;
      MA:Matrix;
      MD:Matrix;
      --ME:Matrix;
   begin
      Put_Line("Task T1 started");
      Vector_Filling_Ones(B);
      Matrix_Filling_Ones(MA);
      Matrix_Filling_Ones(MD);
      delay 1.0;
      Res1 := Func1(B=>B,MA=>MA,MD=>MD);
      delay 1.0;
   --
      Put_Line("Task T1 finished");
   end T1;

   task body T2 is
      g:Integer := N;
      MG:Matrix;
      MK:Matrix;
      ML:Matrix;
      --MF:Matrix;
   begin
      Put_Line("Task T2 started");
      Matrix_Filling_Ones(MG);
      Matrix_Filling_Ones(MK);
      Matrix_Filling_Ones(ML);
      delay 1.0;
      Res2 := Func2(g => g, MG => MG, MK => MK, ML => ML );
      delay 1.0;

      Put_Line("Task T2 finished");
   end T2;

   task body T3 is
      MP,MR:Matrix;
      S,T:Vector;
   begin
      Put_Line("Task T3 started");
      Matrix_Filling_Ones(MP);
      Matrix_Filling_Ones(MR);
      Vector_Filling_Ones(S);
      Vector_Filling_Ones(T);
      delay 1.0;
      Res3 := Func3(MP,MR,S,T);
      delay 1.0;

      Put_Line("Task T3 finished");
      end T3;
   begin
      null;
   end Tasks;

begin
   Tasks;
      Put("T1: ME = ");
      New_Line;
      Matrix_Output(Res1);

      Put("T2: ME = ");
      New_Line;
      Matrix_Output(Res2);

      New_Line;
      Put("T3: O = ");
      New_Line;
      Vector_Output(Res3);
end Main;
