object dmScripts: TdmScripts
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 460
  Width = 761
  object PSImport_DateUtils1: TPSImport_DateUtils
    Left = 208
    Top = 8
  end
  object PSImport_Classes1: TPSImport_Classes
    EnableStreams = True
    EnableClasses = True
    Left = 208
    Top = 56
  end
  object PSImport_ComObj1: TPSImport_ComObj
    Left = 208
    Top = 104
  end
  object PSDllPlugin1: TPSDllPlugin
    Left = 208
    Top = 152
  end
  object PSScriptDebugger1: TPSScriptDebugger
    CompilerOptions = [icAllowUnit, icBooleanShortCircuit]
    OnCompile = PSScriptDebugger1Compile
    OnExecute = PSScriptDebugger1Execute
    OnAfterExecute = PSScriptDebugger1AfterExecute
    Plugins = <
      item
        Plugin = PSImport_DateUtils1
      end
      item
        Plugin = PSImport_Classes1
      end
      item
        Plugin = PSDllPlugin1
      end
      item
        Plugin = PSImport_ComObj1
      end>
    MainFileName = 'Main'
    UsePreProcessor = True
    OnNeedFile = PSScriptDebugger1NeedFile
    OnFindUnknownFile = PSScriptDebugger1NeedFile
    OnIdle = PSScriptDebugger1Idle
    OnLineInfo = PSScriptDebugger1LineInfo
    OnBreakpoint = PSScriptDebugger1Breakpoint
    Left = 64
    Top = 8
  end
end
