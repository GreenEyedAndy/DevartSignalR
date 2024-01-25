unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ScSignalRHubConnection, Vcl.StdCtrls, System.JSON;

type
  TForm1 = class(TForm)
    con1: TScHubConnection;
    mmo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DoReceive(Sender: TObject; const Values: array of Variant);
    procedure MessageReceiptCollection(AJsonCollection: TJsonObject);
  end;

var
  Form1: TForm1;

implementation



{$R *.dfm}

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if con1.State = hcsConnected then begin
    con1.Stop;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  con1.Url := 'http://localhost:5100/messageHub';
  con1.HttpConnectionOptions.Url := 'http://localhost:5100/messageHub';
  con1.Register('ChangedEntities', DoReceive, [varString]);
  con1.Start;
end;

procedure TForm1.DoReceive(Sender: TObject; const Values: array of Variant);
var
  JsonArray: TJsonArray;
  JsonValueCollections: TJsonValue;
  JsonValueCollection: TJsonValue;
  JsonText: string;
  wstring: WideString;
  i: Integer;
begin
  wstring := VarToWideStr(Values[0]);
  mmo1.Lines.Add(wString);

  exit;

  for i := 0 to Length(Values) - 1 do begin
    JsonText := Values[i];
    JsonValueCollections := TJsonObject.ParseJSONValue(JSonText);
    if JsonValueCollections is TJsonArray then begin
      for JsonValueCollection in TJsonArray(JsonValueCollections) do begin
        if JsonValueCollection is TJsonObject then begin
          MessageReceiptCollection(TJsonObject(JsonValueCollection));
        end;
      end;
    end;
    JsonValueCollections.Free;
  end;
end;

procedure TForm1.MessageReceiptCollection(AJsonCollection: TJsonObject);
var
  JsonEntity: TJsonValue;
  EntityCollection: string;
  EntityNotifyReason: Integer;
  EntityId: string;
  EntityJson: string;
begin
  EntityCollection := AJsonCollection.GetValue<string>('name');
  EntityNotifyReason := AJsonCollection.GetValue<Integer>('notifyReason');
  EntityJson := '';
  EntityId := '';

  JsonEntity := AJsonCollection.GetValue('entity');
  if JsonEntity is TJsonObject then begin
    EntityJson := JsonEntity.ToJSON;
  end else if JsonEntity is TJsonString then begin
    EntityId := TJsonString(JsonEntity).Value;
  end;


  mmo1.Lines.Add(EntityJson);
end;



end.
