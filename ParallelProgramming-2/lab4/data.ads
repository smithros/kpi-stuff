
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
   
   procedure Output (V : in Vector);
   
   procedure Output (MA : in Matrix);
   
   procedure FindMaxZ (V : in VectorH; maxZi : out Integer);
      
   procedure FindMinZ (V : in VectorH; minZi : out Integer);
   
   function Max (A, B: Integer) return Integer;
   
   function Min (A, B: Integer) return Integer;
   
   function Calculation (x : in Integer;
                           a : in Integer;
                           MZ : in MatrixH;
                           MX : in MatrixN;
                           MC : in MatrixH) return MatrixH;
   
   function CalcSumX(A, B: Integer) return Integer;
   
   function CalcX(A, B: Vector) return Integer;
   
   end Data;
