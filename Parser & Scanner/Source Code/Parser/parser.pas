program parser;

uses CRT, scanner;

var is_any_error : boolean;

procedure error_reporting(id : byte);
begin
     is_any_error := true;
     case id of
               1 : writeln('#Ex001 : zu unterzeichnen ; nicht gefunden "Tanda ; tidak ditemukan"');
               2 : writeln('#Ex002 : ANFAGEN startet, aber am ende nicht gefunden "BEGIN dimulai, tetapi END tidak ditemukan"');
               3 : writeln('#Ex003 : anfangen nicht gefunden "BEGIN tidak ditemukan"');
               4 : writeln('#Ex004 : kennzeichnung oder ganze zahl nicht gefunden "Identifier atau Integer tidak ditemukan"');
               5 : writeln('#Ex005 : variable wert oder art nicht definiert "Nilai atau tipe Variable belum didefinisikan"');
               6 : writeln('#Ex006 : nichts := "Tidak ada :="');
               7 : writeln('#Ex007 : das ende des programms wurde nicht gefunden "Akhir program tidak ditemukan"');
               8 : writeln('#Ex008 : kein stichwort oder fehler auftritt "Tidak ada keyword atau terjadi kesalahan"');
               9 : writeln('#Ex009 : operator nicht gefunden "Operator tidak ditemukan"');
               10 : writeln('#Ex010 : zeichen marken nicht gefunden "Tanda Sign tidak ditemukan"');
     end;
     writeln('Linie (Baris) : ',LineNumber);
end;

//prosedur factor
procedure factor_proc;
begin
     if token = t_id then
     begin
          scan;
     end
     else  if token = t_int then
     begin
          scan;
     end
     else
         error_reporting(4);
end;

//prosedur operator
procedure operator_proc;
begin
     if token = t_greater then
     begin
          scan;
     end
     else
         error_reporting(9);
end;

//prosedur simple_exp while
procedure simple_while;
begin
     factor_proc;
     operator_proc;
     factor_proc;
end;

//prosedur variable
procedure variable_proc;
begin
     factor_proc;
     if token = t_ass then
     begin
          scan;
          factor_proc;
          if token = t_semicol then
          begin
               scan;
          end
          else
              error_reporting(1);
     end
     else
         error_reporting(5);
end;


//prosedur sign
procedure sign_proc;
begin
     if token = t_sub then
     begin
          scan;
     end
     else
     if token = t_add then
     begin
          scan;
     end
     else
         error_reporting(10);
end;

//Prosedur statement
procedure statement_proc;
begin
     if token = t_id then
     begin
          scan;
          if token = t_assign then
          begin
               scan;
               if token = t_id then
               begin
                    scan;
                    sign_proc;
                    if token = t_id then
                    begin
                         scan;
                    if token = t_semicol then
                    begin
                         scan;
                    end
                    else
                        error_reporting(1);
                    end
                    else
                    error_reporting(4);
               end
               else
                  error_reporting(4);
          end
          else
              error_reporting(6);
     end

     //Perulangan while
     else
     if token = t_while then
     begin
          scan;
          simple_while;
          if token = t_do then
          begin
               scan;
               //Biar ga error untuk block_proc
               if token = t_begin then
          begin
          scan;
          statement_proc;
          if token = t_end then
          begin
               scan;
          end
          else
              error_reporting(2);

       end
       else
         error_reporting(3);
         //end biar ga error
               if token = t_semicol then
               begin
                    scan;
               end
               else
                   error_reporting(1);
          end
          else
              error_reporting(8);
     end
end;

//prosedur block
procedure block_proc;
begin
     if token = t_begin then
     begin
          scan;
          statement_proc;
          if token = t_end then
          begin
               scan;
          end
          else
              error_reporting(2);

       end
       else
         error_reporting(3);
end;

//prosedur program
procedure program_proc;
begin
     if token = t_program then
     begin
          scan;
          if token = t_id then
          begin
               scan;
               if token = t_semicol then
               begin
                    scan;
                    if token = t_var then
                    begin
                         scan;
                         variable_proc;
                         variable_proc;
                         block_proc;
                         if token = t_dot then
                         begin
                              scan;
                         end
                         else
                             error_reporting(7);
                    end
                    else
                        error_reporting(8);
               end
               else
                   error_reporting(1);
          end
          else
              error_reporting(4);
     end
     else
         error_reporting(8);
end;

begin
     clrscr;
     initialize;
     is_any_error := false;
     scan;
     clrscr;
     program_proc;
     terminate;
     if is_any_error then
       writeln('"Parsing fehl" Parsing Fail')
     else
       writeln('"Parsen Erfolg" Parsing success');
     repeat until readkey =#13
end.

