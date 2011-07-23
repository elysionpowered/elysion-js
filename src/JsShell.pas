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

        WriteLn('Begin');
        rResult := From('abcd',Input);
        rInput := Drop(Input,Length(rResult));
        WriteLn(rResult);
        WriteLn('In here');
        WriteLn(rInput);
        fToken := TJsToken.Create(rResult,0,TJsTokenUnknown);
        fToken.Input := rInput;
        fToken.Token := rResult;
        
        result := fToken;
end;

function TExampleLexer.Parse : TJsTokenNode;
begin
        Once(FromToken);
end;

var	
	fLexer : TExampleLexer; fTree : TJsTokenNode; fString : String;
begin

	fLexer := TExampleLexer.Create('ab3bbbb');
	fTree := fLexer.Work;
	fString := from('abcde','abbbbbbbb');
	WriteLn(fString);	
end.
