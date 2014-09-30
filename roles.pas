unit roles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type
    TRoles = record
       R: boolean;
       W: boolean;
       U: boolean;
    end;

function parseRoles(roles: integer): TRoles;

var
   currentRoles: TRoles;

implementation

function parseRoles(roles: integer): TRoles;
begin
   with result do
   begin
      R := roles mod 10 > 0;
      W := roles mod 100 div 10 > 0;
      U := roles div 100 > 0;
   end;
end;


end.

