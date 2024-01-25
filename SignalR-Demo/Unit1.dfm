object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 510
  ClientWidth = 659
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    659
    510)
  TextHeight = 15
  object mmo1: TMemo
    Left = 8
    Top = 80
    Width = 643
    Height = 422
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'mmo1')
    TabOrder = 0
    ExplicitWidth = 639
    ExplicitHeight = 421
  end
  object con1: TScHubConnection
    HttpConnectionOptions.SSLOptions.Protocols = [spTls11, spTls12, spTls13]
    HttpConnectionOptions.Transports = [ttLongPolling]
    HttpConnectionOptions.HeadersText = 'Accept-Encoding=utf-8'#13#10
    Left = 24
    Top = 16
  end
end
