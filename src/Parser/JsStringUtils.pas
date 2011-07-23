unit JsStringUtils;

interface

function tail( Str : String ): String;
function head( Str : String ): Char;

function drop( Str : String; Len : Integer ): String;
function take( Str : STring; Len : Integer ): String;

function from( List : String; Input : String ): String;overload;
function from( fChar : Char; Input : String ): String;overload;

implementation



function from( List : String; Input : String ): String;
var Work : String; I,J : Integer; Found : Boolean;
begin

        for I := 0 to Length(Input) do begin
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
                        result := Work;
                        break;
                end;
        end;
        
        result := Work;

end;

function from( fChar : Char; Input : String ): String;
	function _fromLoop( fInp : String; fWork : String ): String;
	begin
		if head(fInp) = fChar then
		begin
			result := _fromLoop( tail(fInp), fWork + head(fInp) );
		end else begin
			result := fWork;
		end;
	end;
	
begin
	result := _fromLoop( Input, '' ); 
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
        for I := 0 to Length(Str) do  begin
                if ( I >= Len ) then begin
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
