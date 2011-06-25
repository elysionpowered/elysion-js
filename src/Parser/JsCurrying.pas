unit JsCurrying;

interface

uses SysUtils, Classes;

type	

	TJsCurryInputM2<T1,T2,T3> = function( A : T1; B : T2 ): T3;
	TJsCurryOutputM2<T1,T2,T3> = function( A : T2 ) : T3; 
		

	PJsCurryInputM2 = ^TJsCurryInputM2;
	PJsCurryOutputM2 = ^TJsCurryOutputM2;

	TJsBaseRecordM2<T1,T2,T3> = record	
		Input : T1;
		Method : function( A : T1; B : T2 ) : T3;
		
		function Force ( A : T2 ) : T3;
		
	end;
			
					
	TJsCurryM2<T1,T2,T3> = class		
	 	public type 					
	 		TJsBaseRecordM2Sp = TJsBaseRecordM2<T1,T2,T3>;
			TJsCurryInputM2Sp = TJsCurryInputM2<T1,T2,T3>;
			TJsCurryOutputM2Sp = TJsCurryOutputM2<T1,T2,T3>;
		
		var private
				
			class var mFunction : TJsCurryInputM2Sp;
			class var mInput : T1;
			
			
		
		var public
		
			class function Curry( fFunc : TJsCurryInputM2Sp; aInput : T1 ): TJsBaseRecordM2Sp;	
	end;
	
	
	TJsCurryInputM3<T1,T2,T3,T4> = function( A : T1; B : T2 ; C : T3 ): T4;
	TJsCurryOutputM3<T1,T2,T3,T4> = function( A : T2; B : T3 ) : T4; 
		

	PJsCurryInputM3 = ^TJsCurryInputM3;
	PJsCurryOutputM3 = ^TJsCurryOutputM3;

	TJsBaseRecordM3<T1,T2,T3,T4> = record	
		Input : T1;
		Method :  function( A : T2; B : T3; C : T4 ) : T4; 
		
		function Force( A : T2; B : T3 ) : T4; 
		
	end;
			
					
	TJsCurryM3<T1,T2,T3,T4>= class		
	 	public type 					
	 		TJsBaseRecordM3Sp = TJsBaseRecordM3<T1,T2,T3,T4>;
			TJsCurryInputM3Sp = TJsCurryInputM3<T1,T2,T3,T4>;
			TJsCurryOutputM3Sp = TJsCurryOutputM3<T1,T2,T3,T4>;
		
		var private
				
			class var mFunction : TJsCurryInputM3Sp;
			class var mInput : T1;
			
			
		
		var public
		
			class function Curry( fFunc : TJsCurryInputM3Sp; aInput : T1 ): TJsBaseRecordM3Sp;	
	end;	
	
	
implementation

function TJsBaseRecordM3<T1,T2,T3,T4>.Force( A : T2; B : T3 ) : T3;
begin
	
	result := Method(Input,A,B);
end;


class function TJsCurryM3<T1,T2,T3,T4>.Curry(  fFunc : TJsCurryInputM3Sp; aInput : T1 ): TJsbaseRecordM3Sp;
var Sub : TJsBaseRecordM3Sp;
begin
	Sub.Method := fFunc;
	Sub.Input := aInput;
	

	result := Sub;
end;

function TJsBaseRecordM2<T1,T2,T3>.Force( A : T1 ) : T3;
begin
	result := Method(Input,A);
end;


class function TJsCurryM2<T1,T2,T3>.Curry(  fFunc : TJsCurryInputM2Sp; aInput : T1 ): TJsbaseRecordM2Sp;
var Sub : TJsBaseRecordM2Sp;
begin
	Sub.Method := fFunc;
	Sub.Input := aInput;
	

	result := Sub;
end;


 

end.
