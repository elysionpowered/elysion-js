unit JsStringUtils;

interface

function tail( Str : String ): String;
function head( Str : String ): Char;

function drop( Str : String; Len : Integer ): String;
function take( Str : STring; Len : Integer ): String;

function from( List : String; Input : String ): String;overload;
function from( fChar : Char; Input : String ): String;overload;

function ShrinkSpaces( Str : String ): String;

implementation



function from( List : String; Input : String ): String;
var Work, Inp : String; I,J : Integer; Found : Boolean;
begin
        Work := '';
        Input := ShrinkSpaces(Input);
        
        for I := 0 to Length(Input) do begin
                if ( Input[I] = ' ' ) then begin
                        
                        if ( Length(Work) > 0 ) then begin
                                WriteLn(Work);
                                break;
                        end;
                
                end else begin    
                        Found := false;
                        for J := 0 to Length(List) do begin
                                if ( List[J] = Input[I] ) then begin
                                        Found := true;
                                        break;
                                end;
                        end;
                        
                        if Found = True then begin
                                Work := Work + Input[I];
                        end else begin
                                break;
                        end;                        
                end;
        end;
     
        result := Work;

end;

function from( fChar : Char; Input : String ): String;
	function _fromLoop( fInp : String; fWork : String ): String;
	begin
		if (head(fInp) = fChar) then
		begin
			result := _fromLoop( tail(fInp), fWork + head(fInp) );
		end else begin
		        if ( head(fInp) = ' ') and ( Length(fWork) = 0) then
		                result := _fromLoop( tail(fInp), fWork )
		        else
			        result := fWork;
		end;
	end;
	
begin
	result := _fromLoop( Input, '' ); 
end;


function ShrinkSpaces( str : String ): String;
var I : Integer; Work : String;
begin
        Work := '';
        for I := 1 to Length(Str) do begin
                if (Str[I] <> ' ') then begin
                        Work := Work + Str[I];
                end else begin
                        if Length(Work) > 1 then begin
                                break;
                        end;
                end;
        end;
        
        if  I > 1 then
         Result := Work + Drop(str,I)
        else
         Result := Work;
end;

function tail( Str : String ): String;
	function getString : String;
	var I : Integer;
	begin
		for I := 2 to Length(Str)  do begin
			result := result + Str[i];
		end;
	end;
begin
	result := getString;
end;	

function head( Str : String ): Char;
begin
	result := Str[1];
end;

function drop( Str : String; Len : Integer ): String;
var I : Integer; Work : String;
begin
        Work := '';
        for I := 0 to Length(Str) do  begin
                if ( I > Len ) then begin
                        Work := Work + Str[I];
                end;
        end;
        
        result := Work;
end;

function take( Str : STring; Len : Integer ): String;
	function _subTake( _str : String; _len : Integer; _work : String ): String;
	begin
		if (_len = 0) then begin
			result := _work;
			exit;
		end;

		_subTake( tail(_str), _len - 1, _work + _str[1] );
	end;
begin
	result := _subTake( Str, Len, '' );
end;

end.
