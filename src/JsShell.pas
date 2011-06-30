program JsShell;

uses JsLexer, JsCurrying, SysUtils, JsStringUtils;



type
        TExampleLexer = class(TJsTokenWorker)
                public
                
                        function Parse : TJsTokenNode; override;

end;

function FromToken( Input : String ): TJsToken;
var fToken : TJsToken; rResult,rInput : String;
    fCurry : TJsBaseRecordM2<String,String,String>;
begin
      //  fCurry := TJsCurryM2<String,String,String>.Curry(From,'abcd');

        rResult := From('abcd',Input);
        rInput := Drop(Input,Length(rResult));
        WriteLn(rResult);
        fToken := TJsToken.Create(rResult,0,TJsTokenUnknown);
        fToken.Input := rInput;
        
        result := fToken;
end;

function TExampleLexer.Parse : TJsTokenNode;
begin
        Once(FromToken);
end;



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
	
	fLexer : TExampleLexer; fTree : TJsTokenNode;
begin

	fCurriedFunction :=  (TJsCurryM2<Integer,Integer,Integer>.Curry(Add,12));
	WriteLn(IntToStr(fCurriedFunction.Force(12)));
	
	fCurry := TJsCurryM3<Integer,Integer,Integer,Integer>.Curry(Add2,250);
	WriteLn(IntToStr(fCurry.Force(100,100)));
	
	fLexer := TExampleLexer.Create('abadasdadadasdasdaasdasd12');
	fTree := fLexer.Work;
	
	WriteLn(fTree.Input);
	
end.
