with Ada.Text_IO;
   use Ada.Text_IO;
   
   generic
   
   N, H : in Natural;
   
   package Data is
   
   type Vector is array(Integer range <>) of Integer;
        Subtype VectorN is Vector(1..N);
        Subtype Vector4H is Vector(1..4 * H);
        Subtype Vector3H is Vector(1..3 * H);
        Subtype Vector2H is Vector(1..2 * H);
        Subtype VectorH is Vector(1..H);
   
   type Matrix is array(Integer range <>) of VectorN;
        Subtype MatrixN is Matrix(1..N);
        Subtype Matrix4H is Matrix(1..4 * H);
        Subtype Matrix3H is Matrix(1..3 * H);
        Subtype Matrix2H is Matrix(1..2 * H);
        Subtype MatrixH is Matrix(1..H);

   procedure Input ( V : out Vector; Value : in Integer);
   
   procedure Input ( MA : out Matrix; Value : in Integer);
   
   procedure Output (V : in VectorN);
   
   procedure Output (MA : in Matrix);
   
      
   procedure FindMinZ (V : in VectorH; minZi : out Integer);
   
   
   function Min (A, B: Integer) return Integer;
   
   function Calculation (X : in VectorN;
                         MA : in MatrixN;
                         MS : in MatrixH;
                         q : in Integer;
                         R : in VectorN;
                         MF: in MatrixH) return VectorH;
   
   end Data;
