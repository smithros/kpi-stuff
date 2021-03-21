with Ada.Integer_Text_IO,Ada.Text_IO;
use Ada.Integer_Text_IO,Ada.Text_IO;

package body Data is

   function Matrix_Multiplication(A,B: in Matrix) return Matrix is
      P:Matrix;
      s:Integer;
   begin
      for K in 1..N loop
         for I in 1..N loop
            s:=0;
            for J in 1..N loop
               s:=s+A(K)(J)*B(J)(I);
               P(K)(I):=s;
            end loop;
         end loop;
      end loop;
      return P;
   end Matrix_Multiplication;

   function Max_of_Vector(A:in Vector) return Integer is
      max:Integer:=0;
   begin
      for I in 1..N loop
         if A(I)>max then
            max:=A(I);
         end if;
      end loop;
      return max;
   end Max_of_Vector;

   function Matrix_Vector_Multiplication(A: in Vector; MA: in Matrix) return Vector is
      P:Vector;
      s:Integer;
   begin
      for I in 1..N loop
         s:=0;
         for J in 1..N loop
            s:=s+A(I)*MA(J)(I);
         end loop;
         P(I):=s;
      end loop;
      return P;
   end Matrix_Vector_Multiplication;

   function Sum_Vectors(A,B: in Vector) return Vector is
      S:Vector;
   begin
      for I in 1..N loop
         S(I):=A(I)+B(I);
      end loop;
      return S;
   end Sum_Vectors;

   function Matrix_Integer_Multiplication(MA:in Matrix;s: in Integer ) return Matrix is
      MZ:Matrix;
   begin
      for K in 1..N loop
         for I in 1..N loop
            MZ(K)(I):=MA(K)(I)*s;
         end loop;
      end loop;
      return MZ;
   end Matrix_Integer_Multiplication;
   
   procedure Matrix_Filling_Ones(A: out Matrix) is
   begin
      for i in 1..n loop
         for j in 1..n loop
            A(i)(j) := 1;
         end loop;
      end loop;
   end Matrix_Filling_Ones;

   procedure Vector_Filling_Ones (A: out Vector) is

   begin
      for i in 1..n loop
         A(i) := 1;
      end loop;
   end Vector_Filling_Ones;

   procedure Vector_Input (A: out Vector) is
   begin
      for i in 1..n loop
         Get(A(i));
      end loop;
   end Vector_Input;

   procedure Vector_Output(A: in Vector) is
   begin
      for i in 1..n loop
         Put(A(i));
      end loop;
      New_Line;
   end Vector_Output;

   procedure Matrix_Input(A: out Matrix) is
   begin
      for i in 1..n loop
         for j in 1..n loop
            Get(A(i)(j));
         end loop;
      end loop;
   end Matrix_Input;

   procedure Matrix_Output (A: in Matrix) is
   begin
      for i in 1..n loop
         for j in 1..n loop
            Put(A(i)(j));
         end loop;
         New_Line;
      end loop;
      New_Line;
   end Matrix_Output;
   
   function Matrix_Transposition(MA: in Matrix) return Matrix is
      s: Integer;
      MW:Matrix;
   begin
      for i in 1..n loop
         for j in i..n loop
            s:=MA(j)(i);
            MW(j)(i):=MA(i)(j);
            MW(i)(j):=s;
         end loop;
      end loop;
      return MW;
   end Matrix_Transposition;

   function Func1(B: in Vector; MA,MD: in Matrix) return Matrix is
      MW:Matrix;
      ME:Matrix;
      max_B:Integer;
   begin
      max_B:=Max_of_Vector(B);
      MW:=Matrix_Multiplication(MA,MD);
      ME:=Matrix_Integer_Multiplication(MW,max_B);
      return ME;
   end Func1;

   function Func2(g: in Integer; MG,MK,ML: in Matrix) return Matrix is
      MW:Matrix;
      MQ:Matrix;
      MO:Matrix;
      MF:Matrix;
   begin
      MW:=Matrix_Multiplication(MK,ML);
      MQ:=Matrix_Transposition(MG);
      MO:=Matrix_Integer_Multiplication(MQ,g);
      MF:=Matrix_Multiplication(MO,MW);
      return MF;
   end Func2;

   function Func3(MP,MR: in Matrix; S,T: in Vector) return Vector is
      MX:Matrix;
      V:Vector;
      O:Vector;
   begin
      MX:=Matrix_Multiplication(MP,MR);
      V:=Matrix_Vector_Multiplication(S,MX);
      O:=Sum_Vectors(V,T);
   return O;
   end Func3;
   
end Data;
