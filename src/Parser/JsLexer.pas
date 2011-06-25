unit JsLexer;

interface

uses Classes, JsStringUtils;

type
	
	
	// TOKENS
	
	TJsTokenType = (TJsTokenId, TJsTokenNumber, TJsTokenString, TJsTokenOperator, TJsTokenUnknown );
	PJsToken = ^TJsToken;
	
	TJsToken = class
	    private
	    
	        mToken : String;
	        mTokenId : Integer;
	        mTokenType : TJsTokenType;
	
	    public
	        
	        constructor Create( fString : String; fId : Integer; fType : TJsTokenType  );
	        
	        
	        procedure SetToken( fString : String; fId : Integer; fType : TJsTokenType );
	    
	        function Compare ( AOther : TJsToken ): Boolean;overload;
	        function Compare( AToken : String ): Boolean;overload;
	
	    published
	    
	        property Token : String read mToken;
	        property TokenId : Integer read mTokenId;
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
        
            constructor Create( fInput : String );
            
            procedure Add( fTokenNode : TJsTokenNode ); overload;
	        procedure Add( fToken : TJsToken );overload;
	        procedure Add( fString : String; fId : Integer; fType : TJsTokenType  );overload;
	        
	        procedure SetNode( fToken : TJsToken );
            
    end;
    
    TJsTokenNodeArray = Array of TJsTokenNode;
    
	TJsTokenNodeList = class
	    private
	        
	        mTokens : TJsTokenNodeArray;
	        mCount : Integer;
	        
	    public
	    
	        constructor Create;
	    
	        procedure Add( fToken : TJsTokenNode );
	        
	        function GetArray : TJsTokenNodeArray;
	    
	end;    
	
	TJsFuncRuleNode = function( fInput : String ): Boolean;
	TJsFuncTokenNodeWorker = function( fInput : String ): TJsTokenNode;
    
    TJsTokenWorker = class
        private
            
            mToken : TJsTokenNode;
            mInput : String;         
            mCurrentInput : String;
            
            mLogicalStack : TJsTokenNodeList;
            
            //USER DEFINED       
            function Force : TJsTokenNode; virtual; abstract;
            
            //procedure ThrowError ( fNode : TJsTokenNode ); 
            //procedure ThrowWarning( fNode : TJsTokenNode ); virtual; abstract;
            //procedure ThrowInfo( fNode : TJsTokenNode ); virtual; abstract;
            
            //PARSIN
            procedure Apply( fNode : TJsTokenNode ); overload;
            
            procedure Many( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure Many( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure Many( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure Many( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;
            
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
        
            
            
            
        public
        
            constructor Create( fInput : String );
        
            function Work( fInput : String ) : TJsTokenNode;overload;
            function Work() : TJsTokenNode;overload;
            
            
        
    end;


implementation

{

            procedure Many( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure Many( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure Many( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure Many( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;
}

procedure TJsTokenWorker.Range( fRange : Integer;   fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
begin

end;

procedure TJsTokenWorker.Range( fRange : Integer;   fTokenWorker : TJsFuncTokenNodeWorker );
begin

end;

procedure TJsTokenWorker.Range(fRange : Integer;   fTokenStringWorker : TJsFuncStringWorker);
begin

end;

procedure TJsTokenWorker.Range( fRange : Integer;   fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
begin

end;

procedure TJsTokenWorker.RangeOr( fRange : Integer;   fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
begin

end;

procedure TJsTokenWorker.RangeOr( fRange : Integer;   fTokenWorker : TJsFuncTokenNodeWorker );
begin

end;

procedure TJsTokenWorker.RangeOr(fRange : Integer;   fTokenStringWorker : TJsFuncStringWorker);
begin

end;

procedure TJsTokenWorker.RangeOr( fRange : Integer;   fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
begin

end;

procedure TJsTokenWorker.Twice( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
begin

end;

procedure TJsTokenWorker.Twice( fTokenWorker : TJsFuncTokenNodeWorker );
begin

end;

procedure TJsTokenWorker.Twice(fTokenStringWorker : TJsFuncStringWorker);
begin

end;

procedure TJsTokenWorker.Twice( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
begin

end;

procedure TJsTokenWorker.TwiceOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
begin

end;

procedure TJsTokenWorker.TwiceOr( fTokenWorker : TJsFuncTokenNodeWorker );
begin

end;

procedure TJsTokenWorker.TwiceOr(fTokenStringWorker : TJsFuncStringWorker);
begin

end;

procedure TJsTokenWorker.TwiceOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
begin

end;


procedure TJsTokenWorker.Once( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fToken : TJsTokenNode;
begin
	fToken := fTokenWorker(self.mInput);
end;

procedure TJsTokenWorker.Once( fTokenWorker : TJsFuncTokenNodeWorker );
begin

end;

procedure TJsTokenWorker.Once(fTokenStringWorker : TJsFuncStringWorker);
begin

end;

procedure TJsTokenWorker.Once( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
begin

end;

procedure TJsTokenWorker.OnceOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
begin

end;

procedure TJsTokenWorker.OnceOr( fTokenWorker : TJsFuncTokenNodeWorker );
begin

end;

procedure TJsTokenWorker.OnceOr(fTokenStringWorker : TJsFuncStringWorker);
begin

end;

procedure TJsTokenWorker.OnceOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
begin

end;


procedure TJsTokenWorker.Many( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
begin

end;

procedure TJsTokenWorker.Many( fTokenWorker : TJsFuncTokenNodeWorker );
begin

end;

procedure TJsTokenWorker.Many(fTokenStringWorker : TJsFuncStringWorker);
begin

end;

procedure TJsTokenWorker.Many( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
begin

end;

procedure TJsTokenWorker.ManyOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
begin

end;

procedure TJsTokenWorker.ManyOr( fTokenWorker : TJsFuncTokenNodeWorker );
begin

end;

procedure TJsTokenWorker.ManyOr(fTokenStringWorker : TJsFuncStringWorker);
begin

end;

procedure TJsTokenWorker.ManyOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
begin

end;


procedure TJsTokenWorker.Apply( fNode : TJsTokenNode );
begin
    self.mToken.Add( fNode );
end;

constructor TJsTokenWorker.Create( fInput : String );
begin
    mInput := fInput;
    mLogicalStack := TJsTokenNodeList.Create;
    mCurrentInput := fInput;
    mToken := TJsTokenNode.Create(fInput);
end;

function TJsTokenWorker.Work( fInput : String ): TJsTokenNode;
begin
    mInput := fInput;
    Force(); // Come to the dark side - We've cookies!
    result := mToken;
end;

function TJsTokenWorker.Work : TJsTokenNode;
begin
    Force;
    result := mToken;
end;


//Token Node

constructor TJsTokenNode.Create( fInput : String );
begin
    self.mInput := fInput;
    self.mLeafs := TList.Create;
end;

procedure TJsTokenNode.Add( fTokenNode : TJsTokenNode );
begin
    self.mLeafs.Add(fTokenNode);
end;

procedure TJsTokenNode.Add( fToken : TJsToken );
var fTokenNode : TJsTokenNode;
begin

    fTokenNode := TJsTokenNode.Create('');
    fTokenNode.SetNode( fToken );
    self.Add( fTokenNode );
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
