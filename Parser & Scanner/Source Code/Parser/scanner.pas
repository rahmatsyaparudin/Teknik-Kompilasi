unit scanner;
interface
uses crt;

const
     ALNG        = 30;  {number of significant chars in identifiers}
     eof         = #26;
     tab         = #009;
     LineFeed    = #010;
     space       = #032;
     car_return  = #013;

type
    Alfa = string[ALNG];

    {recognized symbol tokens. }
    tokens = (
           t_int, t_sub, t_add, t_assign {':='},
           t_id, t_while, t_do, t_greater, t_semicol,
           t_program, t_var, t_begin, t_end, t_dot, t_ass
    );

const
     num_reserved_word = 7; {number of reserved word}

     {recognized reserved word of strings}
     keystr : array [1..num_reserved_word] of Alfa = (
            'wahrend', 'tun', 'programm', 'var', 'anfangen', 'ende', ':='
     );

     {recognized reserved word tokens}
     keysym : array [1..num_reserved_word] of tokens = (
            t_while, t_do, t_program, t_var, t_begin, t_end, t_assign
     );

var
   fin      : string[12]; {input file name}
   finput   : text;       {input file pointer}

   LookAhead  : boolean;
   enum       : boolean;
   ch         : char;
   token      : tokens;
   id         : alfa;
   inum       : longint;
   linenumber : integer;

   procedure initialize;
   procedure scan;
   procedure terminate;

implementation

procedure initialize;
begin
     if (paramcount < 1) then
        repeat
              write('file sumber (.pas): ');
              readln(fin);
        until (length(fin) <> 0)
     else fin := paramstr(1);

     if (Pos('.', fin)=0) then
        fin := fin + '.pas';

     assign (finput, fin);
     reset (finput);

     if (IOResult <> 0) then
     begin
          writeln ('tidak bisa mengakses file: ''',fin,'''');
          halt;
     end;

     fin := COPY (fin, 1, pos('.', fin)-1) + '.out';

     lookahead   := false;
     enum        := false;
     ch          := ' ';
     linenumber  := 1;
end;


procedure terminate;
begin
     close(finput);
end;

procedure getch;
begin
     read(finput, ch);
end;

procedure error_report(id : byte);
begin
     case id of
          1: writeln ('Error --> unknown character ''', ch, ''' Line: ', linenumber);
          2: writeln ('Error --> comment not limited ''', ch, ''' Line: ', linenumber);
          3: writeln ('Error --> Integer overflow ''', ch, ''' Line: ', linenumber);
end;
end;

procedure scan;
var
   idx    : integer;


begin
     if (not lookahead) then
        getch;
        lookahead := false;
        repeat
              case ch of
                   tab, linefeed, space :
                        getch;

                   car_return :
                   begin
                        getch;
                        inc (linenumber);
                   end;

                   eof :
                       exit;

                   'A'..'Z', 'a'..'z' :
                   begin
                        id := '';
                        repeat
                              id := id + Ch;
                              getch;
                        until (not (ch in['0'..'9', 'A'..'Z', 'a'..'z']));
                        lookahead := true;
                        idx := 0;
                        repeat
                              idx := idx + 1;
                        until ((idx = num_reserved_word) or (id = keystr[idx]));
                        if (id = keystr[idx]) then
                           token := keysym[idx]
                        else
                            token := t_id;
                        exit;
                    end;

                    '0'..'9' :
                    begin
                         inum := 0;
                         token := t_int;
                         repeat
                               inum := inum * 10 + (ord(ch) - ord('0'));
                               getch;
                         until (not (ch in['0'..'9']));
                         lookahead:=true;
                         exit;
                    end;

                    ':' :
                    begin
                         getch;
                         if (ch = '=') then
                         begin
                              token := t_assign;
                         end
                         else
                         begin
                              writeln ('Error -->unknown character '':'' Line: ', linenumber);
                              lookahead := true;
                         end;
                         exit;
                    end;

                    '-' :
                    begin
                         token     := t_sub;
                         exit;
                    end;

                    '=' :
                    begin
                         token     := t_ass;
                         exit;
                    end;

                    '+' :
                    begin
                         token     := t_add;
                         exit;
                    end;

                    '.' :
                    begin
                         token     := t_dot;
                         exit;
                    end;

                    ';' :
                    begin
                         token     := t_semicol;
                         exit;
                    end;

                     '>' :
                    begin
                         token     := t_greater;
                         exit;
                    end;

                  else
                  begin
                       error_report(1);
                       getch;
                  end;
               end;
          Until false;
      end;
end.

