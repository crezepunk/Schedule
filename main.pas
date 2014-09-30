unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  DbCtrls, EditBtn, StdCtrls, reference_form, metadata, time_table_form,
  conflict_form, users_form, roles;

type

  { TMainForm }

  TMainForm = class(TForm)
    TimeTableBtn: TButton;
    MainMenu: TMainMenu;
    MTables: TMenuItem;
    MExit: TMenuItem;
    MFile: TMenuItem;
    MHelp: TMenuItem;
    MAbout: TMenuItem;
    procedure MExitClick(Sender: TObject);
    procedure usersBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TimeTableBtnClick(Sender: TObject);
  private
    procedure MRefClick(Sender: TObject);
  private
    FReferences: array of TRefForm;
  //public
    //procedure SyncWithRoles;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}


{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  MenuItem: TMenuItem;
  i: integer;
begin
  if (not currentRoles.R) then
  begin
    TimeTableBtn.Enabled := false;
    exit;
  end;
  SetLength(FReferences, Length(MData.Tables));
  for i := 0 to high(MData.Tables) do begin
    //ShowMessage(MData.Tables[i].Name);
    MenuItem := TMenuItem.Create(MainMenu);
    with MenuItem do begin
      Caption := MData.Tables[i].Caption;
      Name := 'M' + MData.Tables[i].Name;
      OnClick := @MRefClick;
      Tag := i;
    end;
    MTables.Insert(i, MenuItem);
    if (not currentRoles.U) and (MData.Tables[i].Name = 'Users') then
       MTables.Items[i].Enabled := false;

  end;
end;

procedure TMainForm.TimeTableBtnClick(Sender: TObject);
begin
  TimeTable.Free;
  TimeTable := TTimeTable.Create(self);
  TimeTable.Show;
  ConflictForm.Show;
end;

procedure TMainForm.MRefClick(Sender: TObject);
begin
  if FReferences[(Sender as TMenuItem).Tag] = nil then
    FReferences[(Sender as TMenuItem).Tag] :=
      TRefForm.Create(self, MData.Tables[(Sender as TMenuItem).Tag]);
  FReferences[(Sender as TMenuItem).Tag].Show;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TMainForm.usersBtnClick(Sender: TObject);
begin
  UsersForm.RefreshGrid;
  UsersForm.Show();
end;

procedure TMainForm.MExitClick(Sender: TObject);
begin

end;

end.
