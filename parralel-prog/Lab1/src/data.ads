generic
   N: Integer;
package Data is

   type Vector is private;
   type Matrix is private;

   function Func1(B: in Vector; MA,MD: in Matrix) return Matrix;

   function Func2(g: in Integer; MG,MK,ML: in Matrix) return Matrix;

   function Func3(MP,MR: in Matrix; S,T: in Vector) return Vector;

   function Matrix_Transposition(MA: in Matrix) return Matrix;

   function Matrix_Multiplication(A,B: in Matrix) return Matrix;

   function Sum_Vectors(A,B: in Vector) return Vector;

   function Max_of_Vector(A:in Vector) return Integer;

   function Matrix_Vector_Multiplication(A: in Vector; MA: in Matrix) return Vector;

   function Matrix_Integer_Multiplication(MA:in Matrix;s: in Integer ) return Matrix;

   procedure Vector_Filling_Ones (A: out vector);

   procedure Matrix_Filling_Ones(A: out Matrix);

   procedure Vector_Input (A: out Vector);

   procedure Vector_Output(A: in Vector);

   procedure Matrix_Input(A: out Matrix);

   procedure Matrix_Output(A: in Matrix);

   private
   type Vector is array(1..N) of Integer;
   type Matrix is array(1..N) of Vector;

end Data;
