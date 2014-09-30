unit login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, maskedit,
  ExtCtrls, StdCtrls, sqldb, main, users_form, roles;

type

  { TLoginForm }

  TLoginForm = class(TForm)
    enterBtn: TButton;
    registerBtn: TButton;
    loginEdit: TLabeledEdit;
    passEdit: TLabeledEdit;
    SQLQuery: TSQLQuery;
    procedure enterBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure registerBtnClick(Sender: TObject);
  private
    function GetUserRoles(ALogin: string; APass: string; var Msg: string):integer;
    function RegisterUser(ALogin: string; APass: string; var Msg: string): boolean;
    { private declarations }
  public
    { public declarations }
  end;

  const ERR_SQL = -2;
  const ERR_NOUSER = -1;


var
  LoginForm: TLoginForm;

implementation

{$R *.lfm}

{ TLoginForm }

procedure TLoginForm.enterBtnClick(Sender: TObject);
var
   roles: integer;
   msg: string;
begin
   roles := GetUserRoles(loginEdit.Text, passEdit.Text, msg);
   if (roles < 0) then
   begin
      ShowMessage('Произошла ошибка:' + msg);
      exit;
   end;
   if (roles = 0) then
   begin
      ShowMessage('Ваш пользователь ещё не утвержден администратором');
      exit;
   end;
   currentRoles := parseRoles(roles);
   MainForm := TMainForm.Create(nil);
   MainForm.Visible := true;
   Visible := false;
end;

procedure TLoginForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   Application.Terminate;
end;

procedure TLoginForm.registerBtnClick(Sender: TObject);
var
   msg: string;
begin
  if RegisterUser(loginEdit.Text, passEdit.Text, msg) then
  begin
     ShowMessage('Вы успешно зарегистрированы, дождитесь подтверждения ' +
                 'администратора для начала работы.');
  end
  else
  begin
     ShowMessage('Произошла ошибка: ' + msg);
     exit;
  end;
end;

function TLoginForm.GetUserRoles(ALogin: string; APass: string; var Msg: string
  ): integer;
begin
  with SQLQuery do
  begin
    SQL.Text := 'SELECT roles FROM USERS WHERE login = :login AND pass = :pass';
    Params.ParamByName('login').AsString := ALogin;
    Params.ParamByName('pass').AsString := APass;
    try
       Open;
    except on E:Exception do
       begin
          Msg := E.Message;
          result := ERR_SQL;
          exit;
       end;
    end ;
    if (RecordCount = 0) then
    begin
       Msg := 'Пользователь с такими данными не зарегистрирован';
       result := ERR_NOUSER;
       Close;
       exit;
    end;
    result := Fields[0].AsInteger;
  end;
end;

function TLoginForm.RegisterUser(ALogin: string; APass: string; var Msg: string
  ): boolean;
begin
  result := false;
  with SQLQuery do
  begin
    SQL.Text := 'SELECT * FROM USERS where login = :login';
    Params.ParamByName('login').AsString := ALogin;
    try
       Open;
    except
       on E:Exception do
       begin
          Msg := E.Message;
          exit;
       end;
    end;
    if (RecordCount <> 0) then
    begin
       Msg := 'Пользователь с таким логином уже существует!';
       Close;
       Exit;
    end;
    Close;
    SQL.Text := 'INSERT INTO USERS (login, pass, roles) ' +
                'VALUES (:login, :pass, :roles)';
    Params.ParamByName('login').AsString := ALogin;
    Params.ParamByName('pass').AsString := APass;
    Params.ParamByName('roles').AsInteger := 0;
    try
       ExecSQL;
    except
       on E:Exception do
       begin
         Msg := E.Message;
         exit;
       end;
    end;
    //Transaction.Commit;
    result := true;
  end;
end;

end.

