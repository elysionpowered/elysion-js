program JsShell;

uses JsLexer, JsCurrying, SysUtils;


function Add( A : Integer; B : Integer ) : Integer;
begin
	result := A + B;
end;

function Add2( A,B,C : Integer ): Integer;
begin
	result := A + B + C;
end;

type TFunc = function( A : Integer ) : Integer;//( A: Integer ) : Integer;

var fCurriedFunction : TJsBaseRecordM2<Integer,Integer,Integer>; fFunc : TJsCurryOutputM2<Integer,Integer,Integer>;
	fCurry : TJsBaseRecordM3<Integer,Integer,Integer,Integer>;
begin

	fCurriedFunction :=  (TJsCurryM2<Integer,Integer,Integer>.Curry(Add,12));
	WriteLn(IntToStr(fCurriedFunction.Force(12)));
	
	fCurry := TJsCurryM3<Integer,Integer,Integer,Integer>.Curry(Add2,250);
	WriteLn(IntToStr(fCurry.Force(100,100)));
	
end.
