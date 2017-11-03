object Acceuil: TAcceuil
  OldCreateOrder = False
  OnCreate = WebPageModuleCreate
  PageProducer = PageProducer
  OnBeforeDispatchPage = WebPageModuleBeforeDispatchPage
  Left = 254
  Top = 107
  Height = 150
  Width = 215
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer\Acceuil.html'
    ScriptEngine = 'JScript'
    Left = 48
    Top = 8
  end
end
