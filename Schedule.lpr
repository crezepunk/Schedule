program Schedule;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms, lazcontrols, main, reference_form, data, metadata, 
search_frame, db_edit, search_filter_frame,
  record_edit_form, time_table_form, conflict_form, login, users_form, roles;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TDBData, DBData);
  Application.CreateForm(TTimeTable, TimeTable);
  Application.CreateForm(TConflictForm, ConflictForm);
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TUsersForm, UsersForm);
  Application.Run;
end.

