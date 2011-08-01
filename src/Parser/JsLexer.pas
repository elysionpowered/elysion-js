unit JsLexer;

interface

uses Classes, JsStringUtils, SysUtils;

type
	
	
	// TOKENS
	
	TJsTokenType = (TJsTokenId, TJsTokenNumber, TJsTokenString, TJsTokenOperator, TJsTokenUnknown );
	PJsToken = ^TJsToken;
	
	TJsToken = class
	    private
	    
	        mToken : String;
	        mInput : String;
	        mTokenId : Integer;
	        mTokenType : TJsTokenType;
	
	    public
	        
	        constructor Create( fString : String; fId : Integer; fType : TJsTokenType  );
	        
	        
	        procedure SetToken( fString : String; fId : Integer; fType : TJsTokenType );
	    
	        function Compare ( AOther : TJsToken ): Boolean;overload;
	        function Compare( AToken : String ): Boolean;overload;
	
	    published
	    
	    
	        property Input : String read mInput write mInput;
	        property Token : String read mToken write mToken;
	        property TokenId : Integer read mTokenId write mTokenId;
	        property TokenType : TJsTokenType read mTokenType;
		
	end;
	
	TJsTokenArray = Array of TJsToken;
	PJsTokenArray = Array of PJsToken;
	
	
	TJsTokenList = class
	    private
	        
	        mTokens : TJsTokenArray;
	        mCount : Integer;
	        
	    public
	    
	        constructor Create;
	    
	        procedure Add( fToken : TJsToken );
	        procedure Add( fString : String; fId : Integer; fType : TJsTokenType  );
	        
	        procedure Clear;
	        function GetArray : TJsTokenArray;
	        
	        function Contains( fToken : TJsToken ): Boolean;
	        function Contains( fString : String ) : Boolean;
	    
	    published
	    
	        property Count : Integer read mCount;
	    
	end;
	
	
	// Lexer
	TJsFuncStringWorker = function ( fInput : String ) : TJsToken;
    TJsFuncTokenWorker = function( fToken : TJsToken ): TJsToken;
    
    
    TJsTokenNode = class
        private
            
            mInput : String;
            mToken : TJsToken;
            mLeafs : TList;
            
        public
        
            Dummy : Boolean;
        
            constructor Create( fInput : String );
            
            procedure Add( fTokenNode : TJsTokenNode ); overload;
	        procedure Add( fToken : TJsToken );overload;
	        procedure Add( fString : String; fId : Integer; fType : TJsTokenType  );overload;
	        
	        procedure SetNode( fToken : TJsToken );
	    
	        function GetLeafs : TList;
	        function GetToken : TJsToken;
	        function GetInput : String;
	        
	        procedure PrintLeafs;
	        
	     published
	     
	        property Input : String read mInput write mInput;
            
    end;
    
    PJsTokenNode = ^TJsTokenNode;
    TJsTokenNodeArray = Array of TJsTokenNode;
    
    TJsTokenNodeList = class
	private
	        
	    mTokens : TJsTokenNodeArray;
	    mCount : Integer;
	        
	public
	    
	    constructor Create;
	    
	    procedure Add( fToken : TJsTokenNode );        
	    function GetArray : TJsTokenNodeArray;
	    procedure Clear;
	    
	end;    
	
	
	
    TJsFuncRuleNode = function( fInput : String ): Boolean;
    TJsFuncTokenNodeWorker = function( fInput : String ): TJsTokenNode;
    
    TJsConstantStringWorker = class
        public    
            CurrentConstant : String;
            function Parse( Input : String ): TJsTokenNode;
            
    end;
    
    TJsConstantCharWorker = class
        public    
            CurrentConstant : Char;
            function Parse( Input : String ): TJsTokenNode;  
    end;    
    
    TJsUntilConstantStringWorker = class
        public    
            CurrentConstant : String;
            function Parse( Input : String ): TJsTokenNode;
            
    end;
    
    TJsUntilConstantCharWorker = class
        public    
            CurrentConstant : Char;
            function Parse( Input : String ): TJsTokenNode;  
    end;   
    
    PJsConstantStringWorker = ^TJsConstantStringWorker;
    PJsConstantCharWorker = ^TJsConstantCharWorker;
    PJsUntilConstantStringWorker = ^TJsUntilConstantStringWorker;
    PJsUntilConstantCharWorker = ^TJsUntilConstantCharWorker;  
    
    TJsTokenWorker = class
        protected
            
            mToken : TJsTokenNode;
            mInput : String;         
            mCurrentInput : String;
            
            mLogicalStack : TJsTokenNodeList;
            mNodes : TJsTokenNodeList;
            
            ConstantCharWorker : TJsConstantCharWorker;
            ConstantStringWorker : TJsConstantStringWorker;
            UntilConstantStringWorker : TJsUntilConstantStringWorker;
            UntilConstantCharWorker : TJsUntilConstantCharWorker;
            
            function Constant( Input : String ): TJsConstantStringWorker; overload;
            function Constant( Input : Char ): TJsConstantCharWorker; overload;
            function UntilConstant( Input : String ): TJsUntilConstantStringWorker; overload;
            function UntilConstant( Input : Char ): TJsUntilConstantCharWorker; overload;
            
            //procedure ThrowError ( fNode : TJsTokenNode ); 
            //procedure ThrowWarning( fNode : TJsTokenNode ); virtual; abstract;
            //procedure ThrowInfo( fNode : TJsTokenNode ); virtual; abstract;
            
            //PARSING
            procedure Apply( fNode : TJsTokenNode ); overload;
            
            procedure Many( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure Many( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure Many( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure Many( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;
            
            procedure Many( fWorker : TJsConstantStringWorker ); overload;
            procedure Many( fWorker : TJsConstantCharWorker ); overload;
            procedure Many( fWorker : TJsUntilConstantCharWorker ); overload;
            procedure Many( fWorker : TJsUntilConstantStringWorker); overload;
            
            
            
            procedure Once( fWorker : TJsTokenWorker ); overload;
            procedure Many( fWorker : TJsTokenWorker ); overload;
            procedure Range( fRange : Integer; fWorker : TJsTokenWorker ); overload;
            procedure Twice( fWorker : TJsTokenWorker ); overload;
            procedure OnceOr( fWorker : TJsTokenWorker ); overload;
            procedure ManyOr( fWorker : TJsTokenWorker ); overload;
            procedure TwiceOr( fWorker : TJsTokenWorker ); overload;
            procedure RangeOr(fRange : Integer; fWorker : TJsTokenWorker ); overload;
            
            procedure Once( fWorker : TJsConstantStringWorker ); overload;
            procedure Once( fWorker : TJsConstantCharWorker ); overload;
            procedure Once( fWorker : TJsUntilConstantCharWorker ); overload;
            procedure Once( fWorker : TJsUntilConstantStringWorker); overload;
            
             
            procedure OnceOr( fWorker : TJsConstantStringWorker ); overload;
            procedure OnceOr( fWorker : TJsConstantCharWorker ); overload;
            procedure OnceOr( fWorker : TJsUntilConstantCharWorker ); overload;
            procedure OnceOr( fWorker : TJsUntilConstantStringWorker); overload;
                       
            
            procedure Once( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure Once( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure Once( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure Once( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;
            
            procedure Twice( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure Twice( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure Twice( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure Twice( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;            
            
            procedure Range( fRange : Integer; fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure Range( fRange : Integer; fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure Range( fRange : Integer;  fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure Range( fRange : Integer;  fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;     

            
            procedure ManyOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure ManyOr( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure ManyOr( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure ManyOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;
            
            procedure OnceOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure OnceOr( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure OnceOr( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure OnceOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;
            
            procedure TwiceOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure TwiceOr( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure TwiceOr( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure TwiceOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;            
            
            procedure RangeOr( fRange : Integer; fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure RangeOr( fRange : Integer; fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure RangeOr( fRange : Integer;  fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure RangeOr( fRange : Integer;  fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;   
            
            procedure Logic;  
        
            
        public
        
            constructor Create( fInput : String );overload;
            constructor Create();overload;
        
            function Work( fInput : String ) : TJsTokenNode;overload;
            function Work() : TJsTokenNode;overload;
            
            function GetInput : String;
            
            //USER DEFINED       
            function Parse : TJsTokenNode; virtual; abstract;       
                 
        
    end;



{*
    Parser Combinatürs
*}

function Numbers(Input : String): TJsToken;
function ConstantString( Str : String; Input : String): TJsTokenNode;
function ConstantChar( Ch : Char; Input : String ): TJsTokenNode;
function UntilConstantChar( Ch : Char; Input : String ): TJsTokenNode;
function UntilConstantString( Str : String; Input : String ): TJsTokenNode;
function FromLiterals( Input : String ): TJsToken;
function FromValidChars( Input : String ): TJsToken;
function EndOfLine( Input : String ): TJsTokenNode;
function LineTab( Input : String ): TJsTokenNode;
function LineSpace( Input : String): TJsTokenNode;


{* Languages *}

type


    
    TJsLanguageSemanticType = ( 
                                TJsLanguageSemanticType_VarDefinition,
                                TJsLanguageSemanticType_VarDeclaration,
                                TJsLanguageSemanticType_ArrayDefinition,
                                TJsLanguageSemanticType_ArrayDeclaration,
                                TJsLanguageSemanticType_ArrayUsage,
                                TJsLanguageSemanticType_FunctionDefinition,
                                TJsLanguageSemanticType_FunctionUsage,
                                TJsLanguageSemanticType_ClassDefinition,
                                TJsLanguageSemanticType_StructureDefinition,
                                TJsLanguageSemanticType_ClassUsage,
                                TJsLanguageSemanticType_ClassDeclaration,
                                TJsLanguageSemanticType_MethodDefinition,
                                TJsLanguageSemanticType_MethodUsage,
                                TJsLanguageSemanticType_Scope, //Scopes
                                TJsLanguageSemanticType_Program, // Delphi like program
                                TJsLanguageSemanticType_Modules, //Modules or Namespaces
                                TJsLanguageSemanticType_Loop,
                                TJsLanguageSemanticType_While,
                                TJsLanguageSemanticType_Lambda,
                                TJsLanguageSemanticType_Templates,
                                TJsLanguageSemanticType_Constants
                           );   
    
    TJsLanguageTokenType = (
                                TJsLanguageTokenType_Container,
                                TJsLanguageTokenType_Block,
                                TJsLanguageTokenType_Closed,
                                TJsLanguageTokenType_Constant
                           );
    
    TJsLanguageToken = record
        TokenType : TJsLanguageTokenType;
        
        BlockIdentifier : String;
        ContainerBegin : String;
        ContainerEnd : String;
        Constant : String;
        
        {* Closed Type *}        
        IdentifierBeginChars : String;
        IdentifierChars : String;
        
        {* Only Used In Semantic Blobs *}
        Level : Integer;
               
    end;
    
    TJsLanguageSemanticBlob = record
        TokenSeries : Array of TJsLanguageToken;
        MountPoint : TJsLanguageSemanticType;
        Mounted : Boolean;
    end;
    
    
    TJsLanguageLexer = class(TJsTokenWorker)
        protected
            
        public
    
end;



implementation

function TJsUntilConstantCharWorker.Parse(Input : String): TJsTokenNode;
begin
    result := UntilConstantChar( CurrentConstant, Input );
end;

function TJsUntilConstantStringWorker.Parse(Input : String): TJsTokenNode;
begin
    result := UntilConstantString( CurrentConstant, Input );
end;


function TJsConstantCharWorker.Parse(Input : String): TJsTokenNode;
begin
    result := ConstantChar( CurrentConstant, Input );
end;

function TJsConstantStringWorker.Parse(Input : String): TJsTokenNode;
begin
    result := ConstantString( CurrentConstant, Input );
end;

function ConstantString( Str : String; Input : String): TJsTokenNode;
var found : Boolean; work, tmp : String;
    I, J : Integer;
    fToken : TJsToken;
begin
    fToken := TJsToken.Create('',0,TJsTokenUnknown);
    Input := ShrinkSpaces(Input);
    
    for I := 1 to Length(Input) do begin
        if ( Input[I] = Str[1] ) and ( Length(Input) >= Length(Str) )then begin
            
            Found := true;
            
            tmp := Input;
                
            for J := 1 to Length(Str) do begin
                if Str[J] = tmp[J] then begin
                        Work := Work + Str[J];
                end else begin
                        Found := false;
                        break;
                end;
            end;
            
            
            if Found then begin
                fToken.Token := Work;
                break;
            end else begin
                fToken.Token := '';
                break;
            end;
            
        end;
        
        if ( Input[I] <> ' ' ) and ( Input[I] <> '') then begin
            break;
        end;
        
    end;
    
    result := TJsTokenNode.Create(fToken.Input);
    result.Input := Drop(Input, Length(Work));
    result.SetNode(fToken);
end;

function ConstantChar( Ch : Char; Input : String ): TJsTokenNode;
var I : Integer; fToken : TJsToken; Found : Boolean;
begin
    Input := ShrinkSpaces(Input);
    fToken := TJsToken.Create('',0,TJsTokenUnknown);
    for I := 1 to Length(Input) do begin
        
        if not (Ch = Input[I] ) and not( Input[I] = ' ') then 
            break;
        
        if Length(Input) = 1 then begin
            if Ch = Input[I] then begin
                fToken.Token := Ch;
            end;
        end;
        
        if (Input[I] = Ch) then begin
            fToken.Token := Input[I];
            break;            
        end; 
    end;
    result := TJsTokenNode.Create(fToken.Input);
    result.Input := Drop(Input,1);
    result.SetNode(fToken);  
end;

function UntilConstantChar( Ch : Char; Input : String ): TJsTokenNode;
var I : integer; fToken : TJsToken;
begin
    fToken := TJsToken.Create('',0,TJsTokenUnknown);
    for I := 1 to length(Input) do begin
        if Input[I] = Ch then begin
            fToken.Input := Drop(Input,I);
            fToken.Token := Input[I];
            break;
        end;
    end;
    result := TJsTokenNode.Create(fToken.Input);
    result.Input := fToken.Input;
    result.SetNode(fToken);  
end;

function UntilConstantString( Str : String; Input : String ): TJsTokenNode;
var I : integer; fToken : TJsTokenNode; Work : String;
begin
    fToken := TJsTokenNode.Create('');
    for I := 1 to Length(Input) do begin
        Work := Drop(Input,I);
        fToken := ConstantString(Str,Work);
        if ( fToken.GetToken.Token = Str ) then begin
                break;
        end;
    end;
    result := fToken;   
end;

function FromLiterals( Input : String ): TJsToken;
var fToken : TJsToken; rResult,rInput : String;
begin
        rResult := From('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVW',Input);
        rInput := Drop(Input,Length(rResult)-1);
        fToken := TJsToken.Create(rResult,0,TJsTokenUnknown);
        fToken.Input := rInput;
        fToken.Token := rResult;
        
        result := fToken;
end;

function FromValidChars( Input : String ): TJsToken;
var fToken : TJsToken; rResult,rInput : String;
begin
        rResult := From('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVW1234567890<>,;.:-_#+*´`=)(/&%$§"!°^}\¸][{¬½¼³²¹·…`~',Input);
        rInput := Drop(Input,Length(rResult)-1);
        fToken := TJsToken.Create(rResult,0,TJsTokenUnknown);
        fToken.Input := rInput;
        fToken.Token := rResult;
        
        result := fToken;
end;

function EndOfLine( Input : String ): TJsTokenNode;
begin
    result := ConstantString(#10#13,Input);//ConstantString(Chr(10) + Chr(13),Input);
end;


function LineTab( Input : String ): TJsTokenNode;
begin
    result := ConstantString(#11,Input);
end;


function LineSpace( Input : String): TJsTokenNode;
begin
    result := ConstantString(' ',Input);
end;

function Numbers( Input : String ) : TJsToken;
var fToken : TJsToken; rResult,rInput : String;
begin
        rResult := From('1234567890',Input);
        rInput := Drop(Input,Length(rResult)-1);
        fToken := TJsToken.Create(rResult,0,TJsTokenUnknown);
        fToken.Input := rInput;
        fToken.Token := rResult;
        
        result := fToken;
end;

{* TJsTokenWorker *}


procedure TJsTokenWorker.Many( fWorker : TJsUntilConstantStringWorker );
var fSave : TJsTokenNode;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    while True do begin
        fSave := self.mToken;
        Once( fWorker );
        if ( Length(mToken.mInput) >= Length(fSave.mInput) ) then begin
            mToken := fSave;
            break;
        end; 
        
        if ( Length(mToken.mInput) = 0 ) then
            break;
    end;
end;

procedure TJsTokenWorker.Many( fWorker : TJsUntilConstantCharWorker );
var fSave : TJsTokenNode;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    while True do begin
        fSave := self.mToken;
        Once( fWorker );
        if ( Length(mToken.mInput) >= Length(fSave.mInput) ) then begin
            mToken := fSave;
            break;
        end; 
        
        if ( Length(mToken.mInput) = 0 ) then
            break;
    end;
end;


procedure TJsTokenWorker.Many(fWorker: TJsConstantCharWorker);
var fSave : TJsTokenNode;
    OldInput : String;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    while True do begin
        fSave := self.mToken;
        OldInput := mCurrentInput;
        Once( fWorker );
        
        if Length(OldInput) <= Length(mCurrentInput) then begin
            mToken := fSave;
            mCurrentInput := OldInput;
            break;
        end; 
        
        if ( Length(mCurrentInput) = 0 ) then begin
            break;
        end;
    end;
end;


procedure TJsTokenWorker.Many( fWorker : TJsConstantStringWorker );
var fSave : TJsTokenNode;
    OldInput : String;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    while True do begin
        fSave := self.mToken;
        OldInput := mCurrentInput;
        Once( fWorker );
        
        if Length(OldInput) <= Length(mCurrentInput) then begin
            mToken := fSave;
            mCurrentInput := OldInput;
            break;
        end; 
        
        if ( Length(mCurrentInput) = 0 ) then begin
            break;
        end;
    end;
end;

procedure TJsTokenWorker.Once( fWorker : TJsConstantStringWorker );
var fToken : TJsTokenNode; sToken : TJsTokenNode; 
    J : Integer;
begin
    fToken := fWorker.Parse(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mCurrentInput := fToken.GetInput;
    mToken.Add(fToken);
    mToken.Input := mCurrentInput;
end;

procedure TJsTokenWorker.Once( fWorker : TJsConstantCharWorker );
var fToken : TJsTokenNode;  sToken : TJsTokenNode;
begin
    fToken := fWorker.Parse(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mCurrentInput := fToken.GetInput;
    mToken.Add(fToken);
    mToken.Input := mCurrentInput;
end;

procedure TJsTokenWorker.Once(fWorker : TJsUntilConstantCharWorker);
var fToken : TJsTokenNode;  sToken : TJsTokenNode;
begin
    fToken := fWorker.Parse(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mCurrentInput := fToken.GetInput;
        mToken.Add(fToken);
    mToken.Input := mCurrentInput;
end;

procedure TJsTokenWorker.Once( fWorker : TJsUntilConstantStringWorker );
var fToken : TJsTokenNode; 
begin
    fToken := fWorker.Parse(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mCurrentInput := fToken.GetInput;
    mToken := fToken;
    mToken.Input := mCurrentInput;
end;

////////
procedure TJsTokenWorker.OnceOr( fWorker : TJsConstantStringWorker );
var fToken : TJsTokenNode; sToken : TJsTokenNode; 
    J : Integer;
begin
    fToken := fWorker.Parse(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.OnceOr( fWorker : TJsConstantCharWorker );
var fToken : TJsTokenNode;  sToken : TJsTokenNode;
begin
    fToken := fWorker.Parse(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.OnceOr(fWorker : TJsUntilConstantCharWorker);
var fToken : TJsTokenNode;  sToken : TJsTokenNode;
begin
    fToken := fWorker.Parse(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.OnceOr( fWorker : TJsUntilConstantStringWorker );
var fToken : TJsTokenNode; 
begin
    fToken := fWorker.Parse(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mLogicalStack.Add(fToken);
end;

            
            
            

function TJsTokenWorker.Constant( Input : String ): TJsConstantStringWorker;
var Worker : TJsConstantStringWorker;
begin
    ConstantStringWorker.CurrentConstant := Input;
    result := ConstantStringWorker;
end;

function TJsTokenWorker.Constant( Input : Char ): TJsConstantCharWorker;
var Worker : TJsConstantCharWorker;
begin
    ConstantCharWorker.CurrentConstant := Input;
    result := ConstantCharWorker;
end;

function TJsTokenWorker.UntilConstant( Input : String ): TJsUntilConstantStringWorker;
begin
    UntilConstantStringWorker.CurrentConstant := Input;
    result := UntilConstantStringWorker;
end;

function TJsTokenWorker.UntilConstant( Input : Char ): TJsUntilConstantCharWorker;
begin
    UntilConstantCharWorker.CurrentConstant := Input;
    result := UntilConstantCharWorker;
end;

function TJsTokenWorker.GetInput : String;
begin
    result := mCurrentInput;
end;

procedure TJsTokenWorker.Range( fRange : Integer;   fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        Once(fTokenWorker,fRules);
    end;
end;

procedure TJsTokenWorker.Range( fRange : Integer;   fTokenWorker : TJsFuncTokenNodeWorker );
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        Once(fTokenWorker);
    end;
end;

procedure TJsTokenWorker.Range(fRange : Integer;   fTokenStringWorker : TJsFuncStringWorker);
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        Once(fTokenStringWorker);
    end;
end;

procedure TJsTokenWorker.Range( fRange : Integer;   fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        Once(fTokenStringWorker,fRules);
    end;

end;

procedure TJsTokenWorker.RangeOr( fRange : Integer;   fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        OnceOr(fTokenWorker,fRules);
    end;
end;

procedure TJsTokenWorker.RangeOr( fRange : Integer;   fTokenWorker : TJsFuncTokenNodeWorker );
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        OnceOr(fTokenWorker);
    end;
end;

procedure TJsTokenWorker.RangeOr(fRange : Integer;   fTokenStringWorker : TJsFuncStringWorker);
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        OnceOr(fTokenStringWorker);
    end;
end;

procedure TJsTokenWorker.RangeOr( fRange : Integer;   fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        OnceOr(fTokenStringWorker,fRules);
    end;
end;

procedure TJsTokenWorker.Twice( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fToken,sToken : TJsTokenNode; 
begin
	if ( fRules(mCurrentInput) = True ) then begin
	    fToken := fTokenWorker(mCurrentInput);
	    mCurrentInput := fToken.GetInput;
	    sToken := fTokenWorker(mCurrentInput);
	    mCurrentInput := sToken.GetInput;
	    fToken.Add(sToken);
	    
	    mToken.Input := mCurrentInput;
	    mToken.Add(fToken);
	end;
end;

procedure TJsTokenWorker.Twice( fTokenWorker : TJsFuncTokenNodeWorker );
var fToken, sToken : TJsTokenNode; 
begin
	 fToken := fTokenWorker(mCurrentInput);
	 mCurrentInput := fToken.GetInput;
	 sToken := fTokenWorker(mCurrentInput);
	 mCurrentInput := sToken.GetInput;
	 fToken.Add(sToken);
	 
	 mToken.Input := mCurrentInput;	 
	 mToken.Add(fToken);
end;

procedure TJsTokenWorker.Twice(fTokenStringWorker : TJsFuncStringWorker);
var fToken, sToken : TJsTokenNode;  _token01, _token02 : TJsToken;
begin
	 _token01 := fTokenStringWorker(mCurrentInput);
	 fToken := TJsTokenNode.Create(mCurrentInput);
	 mCurrentInput := fToken.GetInput;
	 sToken := TJsTokenNode.Create(mCurrentInput);
	 _token02 := fTokenStringWorker(mCurrentInput);
	 
	 fToken.SetNode(_token01);
	 sToken.SetNode(_token02);
	 
	 fToken.Add(sToken);
	 mToken.Add(fToken);
	 
	 mToken.Input := mCurrentInput;
end;

procedure TJsTokenWorker.Twice( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var fToken, sToken : TJsTokenNode;  _token01, _token02 : TJsToken;
begin
	if ( fRules(mCurrentInput) = True ) then begin
	     _token01 := fTokenStringWorker(mCurrentInput);
	     fToken := TJsTokenNode.Create(mCurrentInput);
	     mCurrentInput := fToken.GetInput;
	     sToken := TJsTokenNode.Create(mCurrentInput);
	     _token02 := fTokenStringWorker(mCurrentInput);
	     
	     fToken.SetNode(_token01);
	     sToken.SetNode(_token02);
	     
	     fToken.Add(sToken);
	     mToken.Add(fToken);
	     
	     mToken.Input := mCurrentInput;
	end; 

end;

procedure TJsTokenWorker.TwiceOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fToken,sToken : TJsTokenNode; 
begin
	if ( fRules(mCurrentInput) = True ) then begin
	    fToken := fTokenWorker(mCurrentInput);
	    mCurrentInput := fToken.GetInput;
	    sToken := fTokenWorker(mCurrentInput);
	    mCurrentInput := sToken.GetInput;
	    fToken.Add(sToken);
	    
	    mLogicalStack.Add(fToken);
	end;
end;

procedure TJsTokenWorker.TwiceOr( fTokenWorker : TJsFuncTokenNodeWorker );
var fToken, sToken : TJsTokenNode; 
begin
	 fToken := fTokenWorker(mCurrentInput);
	 mCurrentInput := fToken.GetInput;
	 sToken := fTokenWorker(mCurrentInput);
	 mCurrentInput := sToken.GetInput;
	 fToken.Add(sToken);
	 
	 mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.TwiceOr(fTokenStringWorker : TJsFuncStringWorker);
var fToken, sToken : TJsTokenNode;  _token01, _token02 : TJsToken;
begin
	 _token01 := fTokenStringWorker(mCurrentInput);
	 fToken := TJsTokenNode.Create(mCurrentInput);
	 mCurrentInput := fToken.GetInput;
	 sToken := TJsTokenNode.Create(mCurrentInput);
	 _token02 := fTokenStringWorker(mCurrentInput);
	 
	 fToken.SetNode(_token01);
	 sToken.SetNode(_token02);
	 
	 fToken.Add(sToken);
     mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.TwiceOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var fToken, sToken : TJsTokenNode;  _token01, _token02 : TJsToken;
begin
	if ( fRules(mCurrentInput) = True ) then begin
	     _token01 := fTokenStringWorker(mCurrentInput);
	     fToken := TJsTokenNode.Create(mCurrentInput);
	     mCurrentInput := fToken.GetInput;
	     sToken := TJsTokenNode.Create(mCurrentInput);
	     _token02 := fTokenStringWorker(mCurrentInput);
	     
	     fToken.SetNode(_token01);
	     sToken.SetNode(_token02);
	     
	     fToken.Add(sToken);
	     mLogicalStack.Add(fToken);
	end;
end;


////////////////////////////////////


procedure TJsTokenWorker.Once( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fToken : TJsTokenNode; 
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
	if ( fRules(mCurrentInput) = True ) then begin
	    fToken := fTokenWorker(mCurrentInput);
	    
	    if ( Length(fToken.GetToken.Token) = 0 ) then exit; 
 	 	    if ( (fToken.Input) = mCurrentInput ) then exit; 
	    
	    mCurrentInput := fToken.GetInput;
	    mToken.Add(fToken);
	    mToken.Input := mCurrentInput;
	end;
end;

procedure TJsTokenWorker.Once( fTokenWorker : TJsFuncTokenNodeWorker );
var fToken : TJsTokenNode; 
begin
    fToken := fTokenWorker(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;
 	if ( (fToken.Input) = mCurrentInput ) then exit;     

    mCurrentInput := fToken.GetInput;
    mToken.Add(fToken);
    mToken.Input := mCurrentInput;
end;

procedure TJsTokenWorker.Once(fTokenStringWorker : TJsFuncStringWorker);
var fToken : TJsToken; 
begin
    fToken := fTokenStringWorker(mCurrentInput);

    if ( Length(mCurrentInput) = 0 ) then exit;
    if ( Length(fToken.Token) = 0 ) then exit;
    if ( (fToken.Input) = mCurrentInput ) then exit;
    mCurrentInput := fToken.Input;
	mToken.Add(fToken);
	mToken.Input := mCurrentInput;
end;

procedure TJsTokenWorker.Once( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var fToken : TJsToken; 
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
	if ( fRules(mCurrentInput) = True ) then begin
	    fToken := fTokenStringWorker(mCurrentInput);
        if ( Length(fToken.Token) = 0 ) then exit;
        if ( (fToken.Input) = mCurrentInput ) then exit;
	    mToken.Add(fToken);
	    mToken.Input := mCurrentInput;
	end;

end;

procedure TJsTokenWorker.OnceOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fToken : TJsTokenNode; 
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
	if ( fRules(mCurrentInput) = True ) then begin
	    fToken := fTokenWorker(mCurrentInput);
        if ( Length(fToken.GetToken.Token) = 0 ) then exit;	  
        if ( (fToken.Input) = mCurrentInput ) then exit;  
	    mLogicalStack.Add(fToken);
	end;
end;

procedure TJsTokenWorker.OnceOr( fTokenWorker : TJsFuncTokenNodeWorker );
var fToken : TJsTokenNode; 
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    fToken := fTokenWorker(mCurrentInput);
    if ( Length(fToken.GetToken.Token) = 0 ) then exit;    
    if ( (fToken.Input) = mCurrentInput ) then exit;
	mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.OnceOr(fTokenStringWorker : TJsFuncStringWorker);
var fToken : TJsToken; fNode : TJsTokenNode;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    fToken := fTokenStringWorker(mCurrentInput);
    if ( Length(fToken.Token) = 0 ) then exit;     
    if ( (fToken.Input) = mCurrentInput ) then exit; 
    fNode := TJsTokenNode.Create(mCurrentInput);
    fNode.SetNode(fToken);
    mLogicalStack.Add(fNode);
end;

procedure TJsTokenWorker.OnceOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var fToken : TJsToken; fNode : TJsTokenNOde;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
	if ( fRules(mCurrentInput) = True ) then begin
        fToken := fTokenStringWorker(mCurrentInput); 
        if ( Length(fNode.GetToken.Token) = 0 ) then exit;  
        if ( (fToken.Input) = mCurrentInput ) then exit;             
        fNode := TJsTokenNode.Create(mCurrentInput);
        fNode.SetNode(fToken);
        mLogicalStack.Add(fNode);
	end;

end;


procedure TJsTokenWorker.Many( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fSave : TJsTokenNode;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    while True do begin
        fSave := self.mToken;
        Once( fTokenWorker, fRules );
        if ( Length(mToken.mInput) >= Length(fSave.mInput) ) then begin
            mToken := fSave;
            break;
        end; 
        
        if ( Length(mToken.mInput) = 0 ) then
            break;
    end;
end;

procedure TJsTokenWorker.Many( fTokenWorker : TJsFuncTokenNodeWorker );
var fSave : TJsTokenNode;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    while True do begin
        fSave := self.mToken;
        Once( fTokenWorker );
        if ( Length(mToken.mInput) >= Length(fSave.mInput) ) then begin
            mToken := fSave;
            break;
        end; 
        
        if ( Length(mToken.mInput) = 0 ) then
            break;
    end;
end;


procedure TJsTokenWorker.Many(fTokenStringWorker : TJsFuncStringWorker);
var fSave : TJsTokenNode;
begin
    while True do begin
        fSave := self.mToken;
        Once( fTokenStringWorker );
        if ( Length(mToken.mInput) >= Length(fSave.mInput) ) then begin
            mToken := fSave;
            break;
        end; 
        
        if ( Length(mToken.mInput) = 0 ) then
            break;
    end;
end;

procedure TJsTokenWorker.Many( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var fSave : TJsTokenNode;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    while True do begin
        fSave := self.mToken;
        Once( fTokenStringWorker,fRules );
        if ( Length(mToken.mInput) >= Length(fSave.mInput) ) then begin
            mToken := fSave;
            break;
        end; 
        
        if ( Length(mToken.mInput) = 0 ) then
            break;
    end;
end;

procedure TJsTokenWorker.ManyOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fSave, fCurr : TJsTokenNode; fLast : String;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    fSave := TJsTokenNode.Create(self.mCurrentInput);
    fCurr := TJsTokenNode.Create(self.mCurrentInput);
    fLast := self.mCurrentInput;
    while True do begin
        
        if fRules(fSave.Input) = False then
            break;
            
        fCurr := fTokenWorker(fSave.Input);
        if ( Length(fSave.mInput) >= Length(fCurr.Input) ) then begin
            break;
        end; 
        
        if ( Length(fSave.mInput) = 0 ) then
            break;
            
        fSave.Add(fCurr);
        fSave.Input := fCurr.Input;
            
    end;
    mLogicalStack.Add(fSave);
end;

procedure TJsTokenWorker.ManyOr( fTokenWorker : TJsFuncTokenNodeWorker );
var fSave, fCurr : TJsTokenNode; fLast : String;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    fSave := TJsTokenNode.Create(self.mCurrentInput);
    fCurr := TJsTokenNode.Create(self.mCurrentInput);
    fLast := self.mCurrentInput;
    while True do begin
        
        fCurr := fTokenWorker(fSave.Input);
        if ( Length(fSave.mInput) >= Length(fCurr.Input) ) then begin
            break;
        end; 
        
        if ( Length(fSave.mInput) = 0 ) then
            break;
            
        fSave.Add(fCurr);
        fSave.Input := fCurr.Input;
            
    end;
    mLogicalStack.Add(fSave);

end;

procedure TJsTokenWorker.ManyOr(fTokenStringWorker : TJsFuncStringWorker);
var fSave : TJsTokenNode; fLast : String; fCurr : TJsToken;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    fSave := TJsTokenNode.Create(self.mCurrentInput);
    fLast := self.mCurrentInput;
    while True do begin
        
        fCurr := fTokenStringWorker(fSave.Input);
        if ( Length(fSave.mInput) >= Length(fCurr.Input) ) then begin
            break;
        end; 
        
        if ( Length(fSave.mInput) = 0 ) then
            break;
            
        fSave.Add(fCurr);
        fSave.Input := fCurr.Input;
            
    end;
    mLogicalStack.Add(fSave);


end;

procedure TJsTokenWorker.ManyOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var fSave : TJsTokenNode; fLast : String; fCurr : TJsToken;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    fSave := TJsTokenNode.Create(self.mCurrentInput);
    fLast := self.mCurrentInput;
    while True do begin
       
        if fRules(fSave.Input) = False then
            break;         
        
        fCurr := fTokenStringWorker(fSave.Input);
             
        
        if ( Length(fSave.mInput) >= Length(fCurr.Input) ) then begin
            break;
        end; 
        
        if ( Length(fSave.mInput) = 0 ) then
            break;
            
        fSave.Add(fCurr);
        fSave.Input := fCurr.Input;
            
    end;
    mLogicalStack.Add(fSave);
end;


procedure TJsTokenWorker.Logic;
var tmp, wpm, gw : TJsTokenNode; 
    fSortedList : TList; I,J,K,l1,l2 : Integer; fNode : TJsTokenNode; fToken : TJsToken;
    fArray : TJsTokenNodeArray;
    
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    
    gw := TJsTokenNode.Create( '' ); 
    wpm := TJsTokenNode.Create('');
    
    fArray := mLogicalStack.GetArray;
    if ( Length(fArray) > 0 ) then begin
        fNode := fArray[0];
        
        
        
        for I := 0 to Length(fArray) - 1 do begin
            
            if ( fArray[I].GetLeafs.Count > 0 ) then
                wpm := TJsTokenNode(fArray[I].GetLeafs[0]);
            if ( fNode.GetLeafs.Count > 0 ) then
                gw := TJsTokenNode(fNode.GetLeafs[0]);
         
            l1 := Length(wpm.mInput);
           
            l2 := Length(fNode.mInput);
            
                  
            if l1 < l2 then begin
                fNode := fArray[I];
            end;
        end;
        
        

        tmp := TJsTokenNode.Create('');
        
        if ( fNode.GetLeafs.Count > 0 ) then begin
                tmp := TJsTokenNode(fNode.GetLeafs[0]);
                fNode.Input :=  Drop(fNode.Input,Length(tmp.GetToken.Token)-1);
        end else begin
                
                fNode.Input :=  Drop(fNode.Input,Length(fNode.GetToken.Token)-1);
        end;
        
        if ( fNode.GetToken.Token = '' ) then begin
            if fNode.GetLeafs.Count > 0 then begin
                for I := 0 to fNode.GetLeafs.Count - 1 do begin
                    tmp := TJsTokenNode(fNode.GetLeafs[i]);
                    mToken.Add(tmp);
                end;
            end;
            
            mToken.Input := fNode.Input;
            mCurrentInput := mToken.Input; 
            mLogicalStack.Clear;              
        end else begin
           
            mCurrentInput := fNode.Input;
            
            mToken.Add(fNode);
            
            mToken.Input := fNode.Input;
            mCurrentInput := fNode.Input; 
            mLogicalStack.Clear;
        end;
    
    end;
end;


procedure TJsTokenWorker.Apply( fNode : TJsTokenNode );
begin
    self.mToken.Add( fNode );
end;

constructor TJsTokenWorker.Create();
begin
    mInput := '';
    mLogicalStack := TJsTokenNodeList.Create;
    mCurrentInput := '';
    mToken := TJsTokenNode.Create('');
    mToken.SetNode( TJSToken.Create('',0,TJsTokenUnknown)); 
    mToken.Dummy := true;
            
   ConstantCharWorker := TJsConstantCharWorker.Create;
   ConstantStringWorker := TJsConstantStringWorker.Create;
   UntilConstantStringWorker := TJsUntilConstantStringWorker.Create;
   UntilConstantCharWorker := TJsUntilConstantCharWorker.Create; 
end;    
  

constructor TJsTokenWorker.Create( fInput : String );
begin
    mInput := fInput;
    mLogicalStack := TJsTokenNodeList.Create;
    mCurrentInput := fInput;
    mToken := TJsTokenNode.Create(fInput);
    mToken.SetNode( TJSToken.Create('',0,TJsTokenUnknown)); 
    mToken.Dummy := true;
    
   ConstantCharWorker := TJsConstantCharWorker.Create;
   ConstantStringWorker := TJsConstantStringWorker.Create;
   UntilConstantStringWorker := TJsUntilConstantStringWorker.Create;
   UntilConstantCharWorker := TJsUntilConstantCharWorker.Create; 
    
end;

function TJsTokenWorker.Work( fInput : String ): TJsTokenNode; 
begin
    mInput := fInput;
    mCurrentInput := fInput;
    Parse(); // Come to the dark side - We've cookies!
    mToken.Input := mCurrentInput;
    result := mToken;
end;

function TJsTokenWorker.Work : TJsTokenNode;
begin
    Parse;
    
    mToken.Input := mCurrentInput;
    result := mToken;
    
end;


procedure TJsTokenWorker.Once( fWorker : TJsTokenWorker );
var Node, tmp : TJsTokenNode; Token : TJsToken;
    I : Integer;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
        
    fWorker.mCurrentInput := mCurrentInput;
    Node := fWorker.Work(mCurrentInput);
    
    if Node.GetLeafs.Count > 0 then begin
        mCurrentInput := Node.Input;
        for I := 0 to Node.GetLeafs.Count - 1 do begin
            tmp := TJsTokenNode(Node.GetLeafs[i]);
            tmp.Input := fWorker.mCurrentInput;
            mToken.Add(tmp);
        end;
    end;
end;

procedure TJsTokenWorker.Many( fWorker : TJsTokenWorker );
var fSave : TJsTokenNode;
begin
    while True do begin
        fSave := self.mToken;
        Once( fWorker );
        if ( Length(mToken.mInput) >= Length(fSave.mInput) ) then begin
            mToken := fSave;
            break;
        end; 
        
        if ( Length(mToken.mInput) = 0 ) then
            break;
    end;

end;

procedure TJsTokenWorker.Range( fRange : Integer; fWorker : TJsTokenWorker );
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        Once(fWorker);
    end;

end;

procedure TJsTokenWorker.Twice( fWorker : TJsTokenWorker );
var fToken, sToken : TJsTokenNode; 
begin
	 fToken := fWorker.Work(mCurrentInput);
	 mCurrentInput := fWorker.mCurrentInput;
	 sToken := fWorker.Work(mCurrentInput);
	 mCurrentInput := fWorker.mCurrentInput;
	 fToken.Add(sToken);
	 
	 mToken.Input := mCurrentInput;	 
	 mToken.Add(fToken);
end;

procedure TJsTokenWorker.OnceOr( fWorker : TJsTokenWorker );
var fToken : TJsTokenNode; 
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    fToken := fWorker.Work(mCurrentInput);   
    if ( (fToken.Input) = mCurrentInput ) then exit;
	mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.ManyOr( fWorker : TJsTokenWorker );
var fSave, fCurr : TJsTokenNode; fLast : String;
begin
    if ( Length(mCurrentInput) = 0 ) then exit;
    fSave := TJsTokenNode.Create(self.mCurrentInput);
    fCurr := TJsTokenNode.Create(self.mCurrentInput);
    fLast := self.mCurrentInput;
    while True do begin
        
        fCurr := fWorker.Work(fSave.Input);
        if ( Length(fSave.mInput) >= Length(fCurr.Input) ) then begin
            break;
        end; 
        
        if ( Length(fSave.mInput) = 0 ) then
            break;
            
        fSave.Add(fCurr);
        fSave.Input := fCurr.Input;
            
    end;
    mLogicalStack.Add(fSave);
end;

procedure TJsTokenWorker.TwiceOr( fWorker : TJsTokenWorker );
var fToken, sToken : TJsTokenNode; 
begin
	 fToken := fWorker.Work(mCurrentInput);
	 mCurrentInput := fWorker.mCurrentInput;
	 sToken := fWorker.Work(mCurrentInput);
	 mCurrentInput := fWorker.mCurrentInput;
	 fToken.Add(sToken);
	 
	 mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.RangeOr( fRange : Integer; fWorker : TJsTokenWorker );
var I : Integer;
begin
    for I := 0 to fRange - 1 do begin
        OnceOr(fWorker);
    end;
end;

            

//Token Node


constructor TJsTokenNode.Create( fInput : String );
begin
    self.mInput := fInput;
    self.Dummy := false;
    self.mLeafs := TList.Create;
end;


function TJsTokennode.GetLeafs : TList;
begin
    result := mLeafs;
end;

function TJsTokenNode.GetToken : TJsToken;
begin
    result := mToken;
end;

function TJsTokenNode.GetInput : String;
begin
    result := mInput;
end;

procedure TJsTokenNode.Add( fTokenNode : TJsTokenNode );
begin
    self.mLeafs.Add(fTokenNode);
end;

procedure TJsTokenNode.Add( fToken : TJsToken );
var fTokenNode : TJsTokenNode;
begin

    fTokenNode := TJsTokenNode.Create(fToken.Input);
    fTokenNode.SetNode( fToken );
    self.Add( fTokenNode );
end;


procedure TJsTokenNode.PrintLeafs;
var I : Integer; Node : TJsTokenNode;
begin
        
        WriteLn('Tree-Length: ' + IntToStr(mLeafs.Count));
        
        for I := 0 to mLeafs.Count -1  do begin
                Node := TJsTokenNode(mLeafs[I]);
                WriteLn('Token-Value: ' + Node.GetToken.Token );
        end;
        
        for I := 0 to mLeafs.Count -1  do begin
                Node := TJsTokenNode(mLeafs[I]);
                WriteLn('Token-Input: ' + Node.Input );
        end;
        
end;

procedure TJsTokenNode.Add(  fString : String; fId : Integer; fType : TJsTokenType );
var fTokenNode : TJsTokenNode; fToken : TJsToken;
begin
    fToken := TJsToken.Create( fString, fId, fType );
    fTokenNode := TJsTokenNode.Create('');
    fTokenNode.SetNode( fToken );
    self.Add( fTokenNode );
end;

procedure TJsTokenNode.SetNode( fToken : TJsToken );
begin
    mToken := fToken;
end;


//TokenList

constructor TJsTokenNodeList.Create;
begin
    SetLength(mTokens,0);
end;



procedure TJsTokenNodeList.Add( fToken : TJsTokenNode );
begin
    SetLength(mTokens, Length(mTokens) + 1);
    mTokens[Length(mTokens)-1] := fToken;
end;



function TJsTokenNodeList.GetArray : TJsTokenNodeArray;
begin
    result := mTokens;
end;

procedure TJsTokenNodeList.Clear;
begin
    mTokens := niL;
end;


//TokenList

constructor TJsTokenList.Create;
begin
    SetLength(mTokens,0);
end;

procedure TJsTokenList.Add( fString : String; fId : Integer; fType : TJsTokenType  );
var fToken : TJsToken;
begin
    fToken := TJsToken.Create(fString,fId,fType);
    Add(fToken);
end;

procedure TJsTokenList.Add( fToken : TJsToken );
begin
    SetLength(mTokens, Length(mTokens) + 1);
    mTokens[Length(mTokens)-1] := fToken;
end;


function TJsTokenList.Contains( fString : String ): Boolean;
var I : Integer;
begin
    result := False;
    for I := 0 to Length(mTokens) - 1 do begin
        if ( mTokens[i].Compare(fString) ) then begin
            result := True;
            exit;
        end;
    end;

end;

function TJsTokenList.Contains( fToken : TJsToken ): Boolean;
var I : Integer;
begin
    result := False;
    for I := 0 to Length(mTokens) - 1 do begin
        if ( mTokens[i].Compare(fToken) ) then begin
            result := True;
            exit;
        end;
    end;
    
end;


procedure TJsTokenList.Clear;
begin
    SetLength(mTokens,0);
end;

function TJsTokenList.GetArray : TJsTokenArray;
begin
    result := mTokens;
end;


//TOKENS

constructor TJsToken.Create( fString : String; fId : Integer; fType : TJsTokenType  );
begin
    SetToken( fString, fId, fType );
end;

procedure TJsToken.SetToken( fString : String; fId : Integer; fType : TJsTokenType  );
begin
    mToken := fString;
    mTokenId := fId;
    mTokenType := fType;
end;

function TJsToken.Compare( AOther : TJsToken ): Boolean;
begin

    if ( AOther.mToken = self.mToken ) and (AOther.mTokenType = self.mTokenType ) and ( AOther.mTokenId = self.mTokenId ) 
        then result := True
        else result := false;
    
end;


function TJsToken.Compare( AToken : String ): Boolean;
begin
    if ( self.mToken = AToken )
        then result := True
        else result := false;
end;


end.


