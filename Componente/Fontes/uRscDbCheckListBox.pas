{=======================================}
{             RSC SISTEMAS              }
{        SOLU��ES TECNOL�GICAS          }
{         rscsistemas.com.br            }
{          +55 92 4141-2737             }
{      contato@rscsistemas.com.br       }
{                                       }
{ Desenvolvidor por:                    }
{   Roniery Santos Cardoso              }
{     ronierys2@hotmail.com             }
{     +55 92 984391279                  }
{                                       }
{                                       }
{ Vers�o Original RSC SISTEMAS          }
{ Vers�o: 1.0.0 - 12/02/2022            }
{                                       }
{                                       }
{=======================================}


unit uRscDbCheckListBox;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Threading,

  Winapi.Windows,

  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.DBCtrls,
  Vcl.Dialogs,
  Vcl.Buttons,
  Vcl.CheckLst,
  Vcl.Forms,

  Data.DB;

type
  TRscDbCheckListBox = class(TCustomEdit)
  private
    { Private declarations }
    FFieldDataLink      : TFieldDataLink;
    FSbtnPesq           : TSpeedButton;
    FCheckListBox       : TCheckListBox;


    FDataFieldSeparador: char;
    FOnClickCheck: TNotifyEvent;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataFieldSeparador(const Value: char);
    procedure SetDataSource(const Value: TDataSource);



    { A��es Bot�o Pesquisa no Edit }
    procedure SbtnPesqClick(Sender: TObject);

    {}
    function ParentForm(Sender: TWinControl): TWinControl;

    {List}
    procedure ExitList(Sender: TObject);


    function GetCount: Integer;
    function GetSelected(Index: Integer): Boolean;
    procedure SetCount(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetSelected(Index: Integer; const Value: Boolean);
    function GetChecked(Index: Integer): Boolean;
    procedure SetChecked(Index: Integer; const Value: Boolean);
    procedure ClickCheck(Sender: TObject);
    function GetItems: TStrings;

    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure ActiveChange(Sender: TObject);

  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Count: Integer read GetCount write SetCount;
    property Items: TStrings read GetItems write SetItems;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
  published
    { Published declarations }
    property DataField: string read GetDataField write SetDataField;
    property DataSource : TDataSource read GetDataSource write SetDataSource;
    property DataFieldSeparador: char read FDataFieldSeparador write SetDataFieldSeparador;

    property OnClickCheck: TNotifyEvent read FOnClickCheck write FOnClickCheck;

    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property NumbersOnly;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
//    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property TextHint;
    property Touch;
    property Visible;
    property StyleElements;
//    property OnChange;
//    property OnClick;
//    property OnContextPopup;
//    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
//    property OnEnter;
//    property OnExit;
    property OnGesture;
//    property OnKeyDown;
//    property OnKeyPress;
//    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Rsc', [TRscDbCheckListBox]);
end;

{ TRscDbSearchCheckListBox }

procedure TRscDbCheckListBox.ActiveChange(Sender: TObject);
var
  I:  integer;
  AForm: TWinControl;
begin

  AForm :=  ParentForm(FindControl(Self.Handle));

  with  FCheckListBox do
    begin
      Parent  :=  AForm;
      Left          :=  -50;
      Top           :=  -50;
      Width         :=  10;
      Height        :=  10;
      Visible :=  False;
      Clear;
      if Assigned(FFieldDataLink.DataSource) then
        begin
          if Count < 1 then
            begin
              if FFieldDataLink.Field <>  nil then
                begin
                  FFieldDataLink.Field.DataSet.DisableControls;
                  FFieldDataLink.Field.DataSet.First;

                  while not FFieldDataLink.Field.DataSet.Eof do
                    begin
                      I :=  Items.Add(FFieldDataLink.Field.DisplayText);
                      FFieldDataLink.Field.DataSet.Next;
                      Checked[I]  :=  False;
                    end;
                  FFieldDataLink.Field.DataSet.First;
                  FFieldDataLink.Field.DataSet.EnableControls;
                end;
            end
          else;
        end;
    end;
end;

procedure TRscDbCheckListBox.ClickCheck(Sender: TObject);
var
  I: Integer;
begin
  Self.Text :=  '';
  for I := 0 to Self.Count - 1 do
    begin
      if Self.Checked[I] then
        begin
          Self.Text :=  Self.Text + Self.DataFieldSeparador + Self.Items[I];
          Self.Hint :=  Self.Text;
        end;
    end;

  if Assigned(FOnClickCheck) then FOnClickCheck(Self);
end;

constructor TRscDbCheckListBox.Create(AOwner: TComponent);
begin
  inherited;

  ReadOnly  :=  True;
  DataFieldSeparador :=  ',';

  Self.ShowHint :=  True;
  Self.Hint :=  Self.Text;


  FFieldDataLink := TFieldDataLink.Create;
  FFieldDataLink.Control := Self;
  FFieldDataLink.OnDataChange :=  DataChange;
  FFieldDataLink.OnEditingChange :=  EditingChange;
  FFieldDataLink.OnUpdateData :=  UpdateData;
  FFieldDataLink.OnActiveChange :=  ActiveChange;

  try
    FSbtnPesq :=  TSpeedButton.Create(Self);
    with  FSbtnPesq do
    begin
      Font    :=  Self.Font;
      OnClick :=  SbtnPesqClick;
      Caption :=  '...';
      Parent  :=  Self;
      Align   :=  alRight;
    end;
  Except on E: Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;

  FCheckListBox :=  TCheckListBox.Create(Self);
  with  FCheckListBox do
    begin
      Visible       :=  False;
      Left          :=  -50;
      Top           :=  -50;
      Width         :=  10;
      Height        :=  10;
      OnClickCheck  :=  ClickCheck;
      OnExit        :=  ExitList;
    end;

end;

procedure TRscDbCheckListBox.DataChange(Sender: TObject);
//var
//  AForm: TWinControl;
begin

//  AForm :=  ParentForm(FindControl(Self.Handle));

  with  FCheckListBox do
    begin
//      Parent  :=  AForm;
      Visible :=  False;
    end;
end;

destructor TRscDbCheckListBox.Destroy;
begin

  FFieldDataLink.Free;
  FFieldDataLink := nil;
  FSbtnPesq.Free;
  inherited;
end;

procedure TRscDbCheckListBox.EditingChange(Sender: TObject);
//var
//  AForm: TWinControl;
begin

//  AForm :=  ParentForm(FindControl(Self.Handle));

  with  FCheckListBox do
    begin
//      Parent  :=  AForm;
      Visible :=  False;
    end;
end;

procedure TRscDbCheckListBox.ExitList(Sender: TObject);
begin
  TTask.Run(procedure
  begin
    TThread.Queue(nil,
    procedure
    begin
      FCheckListBox.Visible :=  False;
    end);
  end);
end;

function TRscDbCheckListBox.GetChecked(Index: Integer): Boolean;
begin
  Result  :=  FCheckListBox.Checked[Index];
end;

function TRscDbCheckListBox.GetCount: Integer;
begin
  Result  :=  FCheckListBox.Count;
end;

function TRscDbCheckListBox.GetDataField: string;
begin
  Result := FFieldDataLink.FieldName;
end;

function TRscDbCheckListBox.GetDataSource: TDataSource;
begin
  Result := FFieldDataLink.DataSource;
end;

function TRscDbCheckListBox.GetItems: TStrings;
begin
  Result  :=  FCheckListBox.Items;
end;

function TRscDbCheckListBox.GetSelected(Index: Integer): Boolean;
begin
  Result  :=  FCheckListBox.Selected[Index];
end;

function TRscDbCheckListBox.ParentForm(Sender: TWinControl): TWinControl;
begin
  if Sender.Parent is TForm then
    Result  :=  Sender.Parent
  else
    begin
      if Sender.Parent is TWinControl then
        Result  :=  ParentForm(Sender.Parent)
      else
        Result  :=  nil;
    end;
end;

procedure TRscDbCheckListBox.SbtnPesqClick(Sender: TObject);
const MargTam = 80;
var
  I, Altura:  integer;
  Largura:  integer;
  AForm: TWinControl;
  FHeitCheckListField, heitTxt, HeitList : integer;
  pRect:  TRect;
begin
  if FCheckListBox.Visible =  False then
    begin
      GetWindowRect(TWinControl(Self).Handle, pRect);
      FCheckListBox.Height  :=  0;

        AForm :=  ParentForm(FindControl(Self.Handle));

          with  FCheckListBox do
            begin
              Parent  :=  AForm;
              if Count < 1 then
                Exit;
              BorderStyle :=  Self.BorderStyle;
              CharCase  :=  Self.CharCase;
              Font    :=  Self.Font;

              FHeitCheckListField :=  0;
              heitTxt :=  0;
              Largura :=  200;

              for I := 0 to Count - 1 do
                begin
                  heitTxt :=  ItemHeight;
                  Inc(FHeitCheckListField, ItemHeight);
                  if FFieldDataLink.Field.Size  > 200 then
                    Largura :=  200
                  else
                    begin
                      if Largura > FFieldDataLink.Field.Size then
                        begin
                          Largura :=  FFieldDataLink.Field.Size + MargTam;
                        end;
                    end;
                end;

              if Largura < Self.Width then
                Largura :=  Self.Width;

                Width :=  Largura;

              case heitTxt of
                8..15:
                  begin
                    HeitList  :=  100;
                  end;
                16..25:
                  begin
                    HeitList  :=  200;
                  end;
                26..35:
                  begin
                    HeitList  :=  300;
                  end;
              else
                HeitList  :=  400;
              end;

              if FHeitCheckListField >= HeitList then
                Altura :=  HeitList
              else
                begin
                  if FHeitCheckListField <= 50 then
                    Altura :=  50
                  else
                    Altura :=  FHeitCheckListField;
                end;

              Height  :=  Altura;

              if (pRect.Left  - AForm.Left + Width) > (AForm.Left  + AForm.Width) then
                begin
                  Left  :=  (pRect.Left - AForm.Left - Width);
                end
              else
                begin
                  Left  :=  pRect.Left - AForm.Left - 8;
                end;

              if (pRect.Top - AForm.Top + Altura  + Self.Height) > (AForm.Top  + AForm.Height) then
                begin
                  Top  :=  (pRect.Top - AForm.Top - Altura - Self.Height);
                end
              else
                begin
                  Top  :=  pRect.Top  - AForm.Top - Self.Height  +  10;
                end;
            end;

          FCheckListBox.Visible :=  True;
          FCheckListBox.SetFocus;
    end
  else
    begin
      TTask.Run(procedure
      begin
        TThread.Queue(nil,
        procedure
        begin
          FCheckListBox.Visible :=  False;
        end);
      end);
    end;
end;

procedure TRscDbCheckListBox.SetChecked(Index: Integer;
  const Value: Boolean);
begin
  FCheckListBox.Checked[Index]  :=  Value;
end;

procedure TRscDbCheckListBox.SetCount(const Value: Integer);
begin
  FCheckListBox.Count :=  Value;
end;

procedure TRscDbCheckListBox.SetDataField(const Value: string);
begin
  FFieldDataLink.FieldName := Value;
end;

procedure TRscDbCheckListBox.SetDataFieldSeparador(const Value: char);
begin
  FDataFieldSeparador := Value;
end;

procedure TRscDbCheckListBox.SetDataSource(const Value: TDataSource);
begin
  if not (FFieldDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    begin
      FFieldDataLink.DataSource :=  Value;
    end;

  if Value <> nil then
    begin
      Value.FreeNotification(Self);
    end;
end;

procedure TRscDbCheckListBox.SetItems(const Value: TStrings);
begin
  FCheckListBox.Items := Value;
end;

procedure TRscDbCheckListBox.SetSelected(Index: Integer;
  const Value: Boolean);
begin
  FCheckListBox.Selected[Index] :=  Value;
end;

procedure TRscDbCheckListBox.UpdateData(Sender: TObject);
//var
//  AForm: TWinControl;
begin

//  AForm :=  ParentForm(FindControl(Self.Handle));

  with  FCheckListBox do
    begin
//      Parent  :=  AForm;
      Visible :=  False;
    end;
end;

end.
