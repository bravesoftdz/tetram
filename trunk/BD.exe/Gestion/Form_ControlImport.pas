unit Form_ControlImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ComCtrls, ToolWin, UframBoutons, UframVTEdit, UbdtForms,
  ExtCtrls, CRFurtif;

type
    TFlowPanel = class(ExtCtrls.TFlowPanel)
    protected
      procedure Paint; override;
    end;


  TfrmControlImport = class(TbdtForm)
    framVTEdit1: TframVTEdit;
    framVTEdit2: TframVTEdit;
    framVTEdit3: TframVTEdit;
    framVTEdit4: TframVTEdit;
    Frame11: TframBoutons;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ImageList1: TImageList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    FlowPanel1: TFlowPanel;
    CRFurtifLight1: TCRFurtifLight;
    CRFurtifLight2: TCRFurtifLight;
    CRFurtifLight3: TCRFurtifLight;
    CRFurtifLight4: TCRFurtifLight;
    CRFurtifLight5: TCRFurtifLight;
    procedure FormCreate(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure Frame11btnAnnulerClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses
  VirtualTree, GraphUtil;

procedure TFlowPanel.Paint;
begin
  GradientFillCanvas(Self.Canvas, clWindow, clBtnFace, ClientRect, gdVertical);
end;

procedure TfrmControlImport.FormCreate(Sender: TObject);
begin
  framVTEdit2.Mode := vmAlbumsSerie;
  framVTEdit1.Mode := vmSeries;
  framVTEdit3.Mode := vmEditeurs;
  framVTEdit4.Mode := vmCollections;

  framVTEdit2.CanCreate := False;

  framVTEdit3.CanEdit := False;

  framVTEdit4.CanCreate := False;
  framVTEdit4.CanEdit := False;
end;

procedure TfrmControlImport.Frame11btnAnnulerClick(Sender: TObject);
begin
  Frame11.btnAnnulerClick(Sender);
  Release;
end;

procedure TfrmControlImport.Frame11btnOKClick(Sender: TObject);
begin
  Frame11.btnOKClick(Sender);
  Release;
end;

end.
