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
   
   
    procedure Output (V : in VectorN) is
    begin
    New_Line;
    for I in 1..N loop
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
   
   function Min (A, B: Integer) return Integer is
    begin
    if A <= B then
        return A;
    else
        return B;
    end if;
   end Min;
   
   function Calculation (X : in VectorN;
                         MA : in MatrixN;
                         MS : in MatrixH;
                         q : in Integer;
                         R : in VectorN;
                         MF: in MatrixH) return VectorH is

      MQ: MatrixH;
      MB: MatrixH;
      M: VectorH;
      F: VectorH;
      Z: VectorH;
      
    begin
      for j in 1 .. H loop
            for i in 1 .. N loop
               MQ (j) (i) := 0;
               for k in 1 .. N loop
                  MQ (j) (i) := MQ (j) (i) + MA (k) (i) * MS (j) (k);
               end loop;
            end loop;
      end loop;
      
      
      for j in 1 ..H loop
         M(j):=0;
         F(j):=0;
         for i in 1 .. N loop
            M (j):= M(j) + MQ (j) (i) * X (j);
            F (j):= F(j) + MF (j) (i) * R (j);
               end loop;
            end loop;
      
      
      for j in 1 .. H loop
            F (j) := F (j) * q;
      end loop;
      
      for i in 1..H loop
         Z(i) := M(i) + F(i);
      end loop;
      
   
      return Z;
    end Calculation;

  end Data;
