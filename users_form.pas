unit users_form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls, StdCtrls, roles;

type

  { TUsersForm }

  TUser = record
    id: integer;
    login: string;
    pass: string;
    roles:TRoles;
    modified: boolean;
  end;

  TUsersForm = class(TForm)
    saveBtn: TButton;
    buttonsPnl: TPanel;
    SQLQuery: TSQLQuery;
    usersSG: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    procedure RedrawGrid();
  private
    users: array of TUser;
  public
    procedure RefreshGrid();
    { public declarations }
  end;

const GRID_COL_NUM = 6;
const GRID_COL_WIDTHS: array [0..GRID_COL_NUM - 1] of integer = (
      30, 100, 100, 30, 30, 30
);
const GRID_COL_CAPS: array [0..GRID_COL_NUM - 1] of string = (
      'id', 'Логин', 'Пароль', 'R', 'W', 'U'
);

var
  UsersForm: TUsersForm;


implementation

{$R *.lfm}

{ TUsersForm }



procedure TUsersForm.FormCreate(Sender: TObject);
begin
  //RefreshGrid;

end;

procedure TUsersForm.RefreshGrid;
var
   roles: integer;
begin
   SetLength(users, 0);
   with SQLQuery do
   begin
     SQL.Text := 'SELECT id, login, pass, roles FROM USERS ORDER BY roles asc';
     Open;
     while not EOF do
     begin
       setlength(users, length(users) + 1);
       with users[high(users)] do
       begin
         id := Fields[0].AsInteger;
         login := Fields[1].AsString;
         pass := Fields[2].AsString;
         roles := parseRoles(Fields[3].AsInteger);
         modified := false;
       end;
       Next;
     end;
     Close;
   end;
   RedrawGrid;
end;

function BoolToStr(bool: boolean): string;
begin
   if (bool) then
      result := 'OK'
   else
      result := 'NO';
end;

procedure TUsersForm.RedrawGrid;
var
   i: integer;
begin
   usersSG.RowCount := length(users) +1;
   usersSG.ColCount := GRID_COL_NUM;
   for i := 0 to GRID_COL_NUM - 1 do
   begin
     usersSG.ColWidths[i] := GRID_COL_WIDTHS[i];
     usersSG.Cells[i, 0] := GRID_COL_CAPS[i];
   end;
   for i := 0 to high(users) do
   begin
     usersSG.Cells[0, i + 1] := IntToStr(users[i].id);
     usersSG.Cells[1, i + 1] := users[i].login;
     usersSG.Cells[2, i + 1] := users[i].pass;
     usersSG.Cells[3, i + 1] := BoolToStr(users[i].roles.R);
     usersSG.Cells[4, i + 1] := BoolToStr(users[i].roles.W);
     usersSG.Cells[5, i + 1] := BoolToStr(users[i].roles.U);
   end;
end;

end.

