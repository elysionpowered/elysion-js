program JsShell;

uses JsLexer, JsCurrying, SysUtils, JsStringUtils;



type

        TDefinitionLexer = class;
        TExampleLexer = class(TJsTokenWorker)
                public
                        
                        DefinitionLexer : TDefinitionLexer;
                           
                        function ExampleDef( Input : String ): TJsToken;
                        function Parse : TJsTokenNode; override;
        end;
        
        
        
        {* Simple Property Definitions *}
        
        TSizeDefinition = class(TJsTokenWorker)
                public
                        function Parse : TJsTokenNode; override;
        end;
        
        TConstantDefinition = class(TJsTokenWorker)
                public
                        function Parse : TJsTokenNode; override;
        end;
        
        TDefinitionLexer = class(TJsTokenWorker)
                public
                        function Parse : TJsTokenNode; override;    

end;

function TConstantDefinition.Parse : TJsTokenNode;
begin
        OnceOr(Constant('left'));
        OnceOr(Constant('right'));
        OnceOr(Constant('bottom'));
        OnceOr(Constant('top'));
        OnceOr(Constant('none'));
        OnceOr(Constant('block'));
        OnceOr(Constant('static'));
        OnceOr(Constant('relative'));
        OnceOr(Constant('absolute'));
        OnceOr(Constant('bold'));
        OnceOr(Constant('italic'));
        Logic;
end;

function TSizeDefinition.Parse : TJsTokenNode;
begin
        Once(Numbers);
        OnceOr( Constant('px'));
        OnceOr( Constant('pt'));
        OnceOr( Constant('inch'));
        Logic;
end;

function TDefinitionLexer.Parse : TJsTokenNode;
begin
        Once(FromLiterals);
        Once(Constant(':'));
        OnceOr(TSizeDefinition.Create);
        OnceOr(TConstantDefinition.Create);
        Logic;        
end;


function TExampleLexer.ExampleDef ( Input : String ): TJsToken;
begin
       
end;


function TExampleLexer.Parse : TJsTokenNode;
var worker : TJsFuncStringWorker;
begin   
        Once(TDefinitionLexer.Create);
end;

var	
	fLexer : TExampleLexer; fTree : TJsTokenNode; fString : String;
begin
	fLexer := TExampleLexer.Create('size:25pt');
	fTree := fLexer.Work;
        fTree.PrintLeafs;
end.
