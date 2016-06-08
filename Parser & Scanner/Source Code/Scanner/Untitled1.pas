program scanner;
uses crt;

var
   source_code, output_result : text;
   karakter : Char;
   kata, nama_token : string;

procedure openFile; { prosedur membaca file sumber }
  begin
       read(source_code,karakter);
  end;

procedure result; {prosedur utk menulis result setiap token}
  begin
       append(output_result); {menambah result scan ke file result}
       writeln(output_result, kata : 15, ' : ', nama_token);
       writeln(kata : 15, ' : ', nama_token); {mencetak result scan ke layar}
  end;

function cekkeyword(s:string):string; {fungsi mengecek keyword atau bukan}
  var
     x : byte;
     panjang : integer;
     ftext : text;
     data : string;

  begin
       panjang:= length(s); {konversi kata ke huruf kecil}
       for x:=1 to panjang do
         begin
              if s[x] > upcase (s[x]) then
              s[x] := s[x]
         else
              s[x]:= chr(ord(s[x])+32);
       end;
       assign(ftext,'keyword.txt');
       reset(ftext);

       while not eof (ftext) do {mencocokkan dgn tabel keyword}
         begin
              readln(ftext,data);
              if s=data then nama_token:='Keyword';
         end;
         close(ftext);
       end;

procedure periksa; {prosedur memeriksa setiap karakter file sumber}
  begin
       while not eof(source_code) do {kerjakan sampai akhir file}
         begin
              openFile;
              if karakter = '{' then {mengabaikan/membuang komentar}
                begin
                  repeat
                       begin
                            openFile;
                       end;
                     until karakter = '}';
                     kata:='';
                end;

              if karakter = chr(39) then {mengecek tanda petik (')}
                begin
                  repeat
                    begin
                         kata := kata + karakter;
                         openFile;
                    end;
                  until karakter = chr(39) ;

                  kata := kata + karakter;
                  nama_token := 'Literals';
                  result;
                  kata :='';
               end;

               if (karakter in['A'..'Z','a'..'z','_']) then {mengecek karakter/kata}
                 begin
                   repeat
                     begin
                          kata := kata + karakter;
                          openFile;
                     end;
                   until (not(karakter in['A'..'Z','a'..'z','_']));

                   nama_token:='Identifier';
                   cekkeyword(kata);
                   result;
                   kata :='';
                end;

                if (karakter in['0'..'9']) then {mengecek angka}
                  begin
                    repeat
                      begin
                           kata := kata + karakter;
                           openFile;
                      end;
                    until (not(karakter in['0'..'9']));
                    nama_token := 'Identifier';
                    result;
                    kata :='';
                  end;

                if (karakter in['+','-','*','/','^']) then
                  begin
                    repeat
                      begin
                           kata := kata+karakter;
                           openFile;
                      end;
                    until (not(karakter in['+','-','*','/','^']));
                    nama_token :='Operator';
                    result;
                    kata:='';
                  end;

                if (karakter in['(',')','[',']','^',':', '=',';',',','.']) then
                  begin
                       kata:=karakter;
                       nama_token :='Punctuation';
                       result;
                       kata:='';
                  end;
         end;
  end;

begin {=program utama=}
      clrscr;
      assign(source_code,'program.txt'); {menetapkan file sumber}
      reset(source_code); {membaca file sumber}
      assign(output_result,'result.txt'); {menetapkan file result}
      rewrite(output_result); {menghapus isi file result}
      periksa; {menjalankan prosedur scan}
      close(source_code); {menutup file}
      close(output_result);
      readln;
end.
