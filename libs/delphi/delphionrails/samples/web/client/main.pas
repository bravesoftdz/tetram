unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm45 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

  TBlogListItem = record
    id: Integer;
    title: string;
    post_date: TDateTime;
  end;

  TBlogList = array of TBlogListItem;

var
  Form45: TForm45;

implementation
uses msxml, superobject;

{$R *.dfm}

procedure TForm45.Button1Click(Sender: TObject);
var
  req: IXMLHTTPRequest;
  ctx: TSuperRttiContext;
  list: TBlogList;
  i: Integer;
begin
  req := CoXMLHTTP.Create;
  req.open('GET', 'http://localhost:81/blog.json', False, EmptyParam, EmptyParam);
  req.send(EmptyParam);
  ctx := TSuperRttiContext.Create;
  try
    list := ctx.AsType<TBlogList>(SO(req.responseText)['data']);
    Memo1.Clear;
    for i := 0 to length(list) - 1 do
      with list[i] do
        Memo1.Lines.Add(Format('%s | %d | %s', [DateTimeToStr(post_date), id, title]));
  finally
    ctx.Free;
  end;
end;

end.
