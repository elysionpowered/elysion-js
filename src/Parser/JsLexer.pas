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
	    
	        function GetLeafs : TList;
	        function GetToken : TJsToken;
	        function GetInput : String;
	        
	     published
	     
	        property Input : String read mInput write mInput;
            
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
	    procedure Clear;
	    
	end;    
	
	
    TJsFuncRuleNode = function( fInput : String ): Boolean;
    TJsFuncTokenNodeWorker = function( fInput : String ): TJsTokenNode;
    
    TJsTokenWorker = class
        protected
            
            mToken : TJsTokenNode;
            mInput : String;         
            mCurrentInput : String;
            
            mLogicalStack : TJsTokenNodeList;
            mNodes : TJsTokenNodeList;
            
            //procedure ThrowError ( fNode : TJsTokenNode ); 
            //procedure ThrowWarning( fNode : TJsTokenNode ); virtual; abstract;
            //procedure ThrowInfo( fNode : TJsTokenNode ); virtual; abstract;
            
            //PARSING
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
            
            procedure Logic;  
        
            
            
            
        public
        
            constructor Create( fInput : String );
        
            function Work( fInput : String ) : TJsTokenNode;overload;
            function Work() : TJsTokenNode;overload;
            
            //USER DEFINED       
            function Parse : TJsTokenNode; virtual; abstract;            
        
    end;


implementation

{

            procedure Many( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode );overload;
            procedure Many( fTokenWorker : TJsFuncTokenNodeWorker ); overload;
            procedure Many( fTokenStringWorker : TJsFuncStringWorker ); overload;
            procedure Many( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode ); overload;
}

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
	if ( fRules(mCurrentInput) = True ) then begin
	    fToken := fTokenWorker(mCurrentInput);
	    mCurrentInput := fToken.GetInput;
	    mToken.Add(fToken);
	    mToken.Input := mCurrentInput;
	end;
end;

procedure TJsTokenWorker.Once( fTokenWorker : TJsFuncTokenNodeWorker );
var fToken : TJsTokenNode; 
begin
    fToken := fTokenWorker(mCurrentInput);
    mCurrentInput := fToken.GetInput;
	mToken.Add(fToken);
	mToken.Input := mCurrentInput;
end;

procedure TJsTokenWorker.Once(fTokenStringWorker : TJsFuncStringWorker);
var fToken : TJsToken; 
begin
    fToken := fTokenStringWorker(mCurrentInput);
    mCurrentInput := fToken.Input;
	mToken.Add(fToken);
	mToken.Input := mCurrentInput;
end;

procedure TJsTokenWorker.Once( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var fToken : TJsToken; 
begin
	if ( fRules(mCurrentInput) = True ) then begin
	    fToken := fTokenStringWorker(mCurrentInput);
	    mToken.Add(fToken);
	    mToken.Input := mCurrentInput;
	end;

end;

procedure TJsTokenWorker.OnceOr( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fToken : TJsTokenNode; 
begin
	if ( fRules(mCurrentInput) = True ) then begin
	    fToken := fTokenWorker(mCurrentInput);
	    mLogicalStack.Add(fToken);
	end;
end;

procedure TJsTokenWorker.OnceOr( fTokenWorker : TJsFuncTokenNodeWorker );
var fToken : TJsTokenNode; 
begin
    fToken := fTokenWorker(mCurrentInput);
	mLogicalStack.Add(fToken);
end;

procedure TJsTokenWorker.OnceOr(fTokenStringWorker : TJsFuncStringWorker);
var fToken : TJsToken; fNode : TJsTokenNode;
begin
    fToken := fTokenStringWorker(mCurrentInput);  
    fNode := TJsTokenNode.Create(mCurrentInput);
    fNode.SetNode(fToken);
    mLogicalStack.Add(fNode);
end;

procedure TJsTokenWorker.OnceOr( fTokenStringWorker : TJsFuncStringWorker; fRules : TJsFuncRuleNode  );
var fToken : TJsToken; fNode : TJsTokenNOde;
begin
	if ( fRules(mCurrentInput) = True ) then begin
        fToken := fTokenStringWorker(mCurrentInput);  
        fNode := TJsTokenNode.Create(mCurrentInput);
        fNode.SetNode(fToken);
        mLogicalStack.Add(fNode);
	end;

end;


procedure TJsTokenWorker.Many( fTokenWorker : TJsFuncTokenNodeWorker; fRules : TJsFuncRuleNode);
var fSave : TJsTokenNode;
begin
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

    function SortByInput ( A,B : Pointer ): Integer;
    var t1,t2 : TJsTokenNode;
    begin
        t1 := TJsTokenNode(A);
        t2 := TJsTokenNode(B);
        result := Length(t1.Input) - Length(t2.Input);  
    end;

procedure TJsTokenWorker.Logic;
var fSortedList : TList; I,J,K : Integer; fNode : TJsTokenNode; fToken : TJsToken;
    fArray : TJsTokenNodeArray;
begin
    fArray := mLogicalStack.GetArray;
    for I := 0 to Length(fArray) - 1 do begin
        fSortedList.Add(fArray[I]);
    end;
    fSortedList.Sort(SortByInput);
    
    fNode := TJsTokenNode(fSortedList[0]);
    mToken.Add(fNode);
    mToken.Input := fNode.Input;
    
    
    mLogicalStack.Clear;
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
    Parse(); // Come to the dark side - We've cookies!
    result := mToken;
end;

function TJsTokenWorker.Work : TJsTokenNode;
begin
    Parse;
    result := mToken;
end;


//Token Node


constructor TJsTokenNode.Create( fInput : String );
begin
    self.mInput := fInput;
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
