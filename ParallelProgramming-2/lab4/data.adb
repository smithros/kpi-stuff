  with Ada.Text_IO, Ada.Integer_Text_IO;
  use Ada.Text_IO, Ada.Integer_Text_IO;
  

package body Data is
   
    procedure Input (V : out Vector; Value : Integer) is
    begin
        for I in 1..N loop
             V(I):= Value;
        end loop;
    end Input;
   
   	
    procedure Input (MA : out Matrix; Value : Integer) is
    begin
    for I in 1..N loop
        for J in 1..N loop
            MA(I)(J):= Value;
        end loop;
    end loop;
    end Input;
   
   
    procedure Output (V : in Vector) is
    begin
    New_Line;
    for I in 1..V'Last loop
        Put(Item => V(I), Width => 6);
    end loop;
    New_Line;
    end Output;
   
   
    procedure Output (MA : in Matrix) is
    begin
    New_Line;
    for I in 1..MA'Last loop
        for J in 1..N loop
            Put(Item => MA(i)(j), Width => 6);
        end loop;
        New_line;
    end loop;
    New_Line;
    end Output;
   
    procedure FindMaxZ (V : in VectorH; maxZi : out Integer) is
    maxBuf : Integer;
    begin
    maxBuf :=-99999;
    for i in 1..H loop
        if(maxBuf < V(i)) then
            maxBuf := V(i);
        end if;
    end loop;
    maxZi:=maxBuf;
    end FindMaxZ;
   
   procedure FindMinZ (V : in VectorH; minZi : out Integer) is
    minBuf : Integer;
    begin
    minBuf := 99999;
    for i in 1..H loop
        if(minBuf > V(i)) then
            minBuf := V(i);
        end if;
    end loop;
    minZi:=minBuf;
    end FindMinZ;
   
    function Max (A, B: Integer) return Integer is
    begin
        if A >= B then
            return A;
        else
            return B;
        end if;
    end Max;
   
   
   
   function Min (A, B: Integer) return Integer is
    begin
    if A <= B then
        return A;
    else
        return B;
    end if;
   end Min;
   
   function CalcSumX(A, B: Integer) return Integer is
   begin
      return A+B;
   end CalcSumX;
     
   function CalcX(A, B: Vector) return Integer is
   sum1: Integer := 0;
   begin
      for I in 1..H loop
         sum1 := sum1 + A(I)*B(I);
      end loop;
      return sum1;
      end CalcX;
      
   
    function Calculation (x : in Integer;
                           a : in Integer;
                           MZ : in MatrixH;
                           MX : in MatrixN;
                           MC : in MatrixH) return MatrixH is

    MQ: MatrixH;
    MB: MatrixH;
    MA: MatrixH;
    begin
      for j in 1 .. H loop
            for i in 1 .. N loop
               MQ (j) (i) := 0;
               for k in 1 .. N loop
                  MQ (j) (i) := MQ (j) (i) + MX (k) (i) * MC (j) (k);
               end loop;
            end loop;
      end loop;
      
      
      for j in 1 .. H loop
            for i in 1 .. N loop
            MQ (j) (i) := MQ (j) (i) * a;
            MB (j) (i) := MZ (j) (i) * x;
            end loop;
      end loop;
      
      for j in 1 ..H loop
         for i in 1 .. N loop
                  MA (j) (i) := MB (j) (i) + MQ (j) (i);
               end loop;
            end loop;
    return MA;
    end Calculation;

  end Data;
