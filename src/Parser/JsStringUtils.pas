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
	function _included( ch : Char; _str : String ): Boolean;
	var I : integer;
	begin
	
		result := false;
	
		for I := 0 to Length( _str ) - 1 do 
		begin
			if (ch = _str[i]) then
			begin
				result := true;
				break;
			end;
		end;
		
		
	end;
	
	function _fromLoop( fInp : String; fWork : String ): String;
	begin
		if _included(head(fInp),List) then
		begin
			_fromLoop( tail(fInp), fWork + head(fInp) );
		end else begin
			result := fWork;
		end;
	end;
	
begin

	result := _fromLoop( Input, '' ); 

end;

function from( fChar : Char; Input : String ): String;
	function _fromLoop( fInp : String; fWork : String ): String;
	begin
		if head(fInp) = fChar then
		begin
			_fromLoop( tail(fInp), fWork + head(fInp) );
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
		for I := 1 to Length(Str) - 1 do begin
			result := Str[i];
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
	function _subDrop( _str : String; _len : Integer; _work : String ): String;
	begin
	        if (_str = '') then begin
	                result := _work;
                        exit;
	        end;
		if (_len = 0) and (_str = '' ) then begin
			result := _work;
			exit;
		end;
		if (_len = 0 ) then begin
		        result := _work;
		        exit;
		end;
		if (_len > 0 ) then
			_subDrop( tail(_str), _len - 1, _work );
		
		_subDrop( tail(_str), _len - 1, _work + _str[1] );
	end;
begin
	result := _subDrop( Str, Len, '' );
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
