unit UScriptEngineIntf;

interface

uses
  System.Classes, UScriptList, UScriptEditor, Entities.Full, VirtualTrees, System.Generics.Collections;

type
  TDebugMode = (dmRun, dmStepOver, dmStepInto, dmPaused);
  TLineNumbers = array of Integer;

  TCategoryMessage = (cmInfo, cmCompileError, cmRuntimeError);
  TTypeMessage = (tmUnknown, tmError, tmHint, tmWarning);

  IDebugItem = interface
    ['{57BE193A-510D-49B0-973E-B2CACF4AB66A}']
  end;

  IDebugList<I: IDebugItem> = interface
    ['{65233529-6ADC-409F-BCBF-FCB9C3DBDFB2}']
    function GetEnumerator: TList<I>.TEnumerator;

    procedure SetView(const Value: TVirtualStringTree);
    function GetView: TVirtualStringTree;
    property View: TVirtualStringTree read GetView write SetView;

    procedure UpdateView;

    procedure Delete(Index: Integer);
    procedure Clear;
    function ItemCount: Integer;
    procedure DeleteCurrent;
    function Current: I;
    function Last: I;
    function GetItemInterface(Index: Integer): I;
    property Items[Index: Integer]: I read GetItemInterface; default;
  end;

  IPositionnedDebugItem = interface(IDebugItem)
    ['{DC390CC0-087B-4431-86BA-796173D77B16}']
    function GetLine: Cardinal;
    procedure SetLine(const Value: Cardinal);
    property Line: Cardinal read GetLine write SetLine;

    function GetScript: TScript;
    procedure SetScript(const Value: TScript);
    property Script: TScript read GetScript write SetScript;
  end;

  IBreakpointInfo = interface(IPositionnedDebugItem)
    ['{D5B86D7D-44D5-41B6-85E1-A90EBC791064}']
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    property Active: Boolean read GetActive write SetActive;
  end;

  IBreakpointList = interface(IDebugList<IBreakpointInfo>)
    ['{68550247-E68A-497A-9172-9AC07D79AA30}']
    function IndexOf(Script: TScript; const ALine: Cardinal): Integer;
    function Exists(Script: TScript; const ALine: Cardinal): Boolean;
    procedure AddBreakpoint(Script: TScript; const ALine: Cardinal);
    function Toggle(Script: TScript; const ALine: Cardinal): Boolean;
  end;

  IWatchInfo = interface(IDebugItem)
    ['{B7BD4C11-D64C-43A2-BE15-B769939FE586}']
    function GetName: string;
    procedure SetName(const Value: string);
    property Name: string read GetName write SetName;

    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    property Active: Boolean read GetActive write SetActive;
  end;

  IWatchList = interface(IDebugList<IWatchInfo>)
    ['{B4CB1C4E-C38D-41EB-8E95-00861067D308}']
    function IndexOfName(const VarName: string): Integer;
    function CountActive: Integer;
    procedure AddWatch(const VarName: string);
  end;

  IMessageInfo = interface(IPositionnedDebugItem)
    ['{23E9F59B-7711-435B-9302-19F0218F2069}']
    function GetTypeMessage: string;
    procedure SetTypeMessage(const Value: string);
    property TypeMessage: string read GetTypeMessage write SetTypeMessage;

    function GetText: string;
    procedure SetText(const Value: string);
    property Text: string read GetText write SetText;

    function GetChar: Cardinal;
    procedure SetChar(const Value: Cardinal);
    property Char: Cardinal read GetChar write SetChar;

    function GetCategory: TCategoryMessage;
    procedure SetCategory(const Value: TCategoryMessage);
    property Category: TCategoryMessage read GetCategory write SetCategory;
  end;

  IMessageList = interface(IDebugList<IMessageInfo>)
    ['{2BD651C1-BB8E-49AB-949B-20E94075383D}']
    function AddCompileErrorMessage(const Fichier, Text: string; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
    function AddRuntimeErrorMessage(const Fichier, Text: string; Line, Char: Cardinal): Integer;
    function AddInfoMessage(const Fichier, Text: string; Line: Cardinal = 0; Char: Cardinal = 0): Integer;
  end;

  // TGetScriptEditorCallback = function(const ScriptUnitName: string): TScriptEditor of object;
  TGetScriptEditorCallback = function(Script: TScript): TScriptEditor of object;

  IEngineInterface = interface
    ['{640DAE0F-93CC-40A1-922C-E884D5F0F19C}']
    procedure AssignScript(Script: TStrings);

    procedure ResetBreakpoints;

    function Compile(Script: TScript; out Msg: IMessageInfo): Boolean;
    function Run: Boolean;

    function GetRunning: Boolean;
    property Running: Boolean read GetRunning;

    function GetSpecialMainUnitName: string;

    function GetDebugMode: TDebugMode;
    property DebugMode: TDebugMode read GetDebugMode;

    function GetActiveLine: Cardinal;
    procedure SetActiveLine(const Value: Cardinal);
    property ActiveLine: Cardinal read GetActiveLine write SetActiveLine;

    function GetActiveUnitName: string;
    procedure SetActiveUnitName(const Value: string);
    property ActiveUnitName: string read GetActiveUnitName write SetActiveUnitName;

    function GetErrorLine: Cardinal;
    procedure SetErrorLine(const Value: Cardinal);
    property ErrorLine: Cardinal read GetErrorLine write SetErrorLine;

    function GetErrorUnitName: string;
    procedure SetErrorUnitName(const Value: string);
    property ErrorUnitName: string read GetErrorUnitName write SetErrorUnitName;

    function GetUseDebugInfo: Boolean;
    procedure SetUseDebugInfo(Value: Boolean);
    property UseDebugInfo: Boolean read GetUseDebugInfo write SetUseDebugInfo;

    function GetExecutableLines(const AUnitName: string): TLineNumbers;
    function TranslatePosition(out Proc, Position: Cardinal; Row: Cardinal; const Fn: string): Boolean;
    function GetVariableValue(const VarName: string): string;
    function GetWatchValue(const VarName: string): string;

    procedure Pause;
    procedure StepInto;
    procedure StepOver;
    procedure Resume;
    procedure Stop;

    procedure GetUncompiledCode(Lines: TStrings);
    procedure SetRunTo(Position: Integer; const Filename: string);

    function isTokenIdentifier(TokenType: Integer): Boolean;

    function GetNewEditor(AOwner: TComponent): TScriptEditor;

    function GetCompletionProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor): Boolean;
    function GetParametersProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor; out BestProposal: Integer): Boolean;
  end;

  IMasterEngine = interface;

  IDebugInfos = interface
    ['{6A5AB23B-4462-438B-8F65-B12C2DA3F52C}']
    function GetMasterEngine: IMasterEngine;
    property MasterEngine: IMasterEngine read GetMasterEngine;

    procedure SetCurrentLine(const Value: Integer);
    function GetCurrentLine: Integer;
    property CurrentLine: Integer read GetCurrentLine write SetCurrentLine;
    procedure SetCursorLine(const Value: Integer);
    function GetCursorLine: Integer;
    property CursorLine: Integer read GetCursorLine write SetCursorLine;
    procedure SetErrorLine(const Value: Integer);
    function GetErrorLine: Integer;
    property ErrorLine: Integer read GetErrorLine write SetErrorLine;

    function GetBreakpointsList: IBreakpointList;
    property Breakpoints: IBreakpointList read GetBreakpointsList;
    function GetWatchesList: IWatchList;
    property Watches: IWatchList read GetWatchesList;
    function GetMessagesList: IMessageList;
    property Messages: IMessageList read GetMessagesList;

    function GetOnGetScriptEditor: TGetScriptEditorCallback;
    procedure SetOnGetScriptEditor(const Value: TGetScriptEditorCallback);
    property OnGetScriptEditor: TGetScriptEditorCallback read GetOnGetScriptEditor write SetOnGetScriptEditor;
  end;

  TAfterExecuteEvent = procedure of object;
  TBreakPointEvent = procedure of object;

  IMasterEngine = interface
    ['{C093B526-5485-4059-8516-5CBF1A3808AE}']
    function GetTypeEngine: TScriptEngine;
    procedure SetTypeEngine(const Value: TScriptEngine);
    property TypeEngine: TScriptEngine read GetTypeEngine write SetTypeEngine;

    function GetEngine: IEngineInterface;
    property Engine: IEngineInterface read GetEngine;

    function GetAlbumToUpdate: Boolean;
    property AlbumToUpdate: Boolean read GetAlbumToUpdate;

    function GetAlbumToImport: TAlbumFull;
    procedure SetAlbumToImport(const Value: TAlbumFull);
    property AlbumToImport: TAlbumFull read GetAlbumToImport write SetAlbumToImport;

    function GetDebugPlugin: IDebugInfos;
    property DebugPlugin: IDebugInfos read GetDebugPlugin;

    function GetScriptList: TScriptList;
    property ScriptList: TScriptList read GetScriptList;

    procedure SelectProjectScript(ProjectScript: TScript);
    function GetProjectScript: TScript;
    property ProjectScript: TScript read GetProjectScript;

    procedure SetCompiled(const Value: Boolean);
    function GetCompiled: Boolean;
    property Compiled: Boolean read GetCompiled write SetCompiled;

    function GetConsole: TStrings;
    procedure SetConsole(const Value: TStrings);
    property Console: TStrings read GetConsole write SetConsole;

    function GetOnAfterExecute: TAfterExecuteEvent;
    procedure SetOnAfterExecute(const Value: TAfterExecuteEvent);
    property OnAfterExecute: TAfterExecuteEvent read GetOnAfterExecute write SetOnAfterExecute;
    procedure AfterExecute;

    procedure ToggleBreakPoint(Script: TScript; Line: Cardinal; Keep: Boolean);

    function GetOnBreakPoint: TBreakPointEvent;
    procedure SetOnBreakPoint(const Value: TBreakPointEvent);
    property OnBreakPoint: TBreakPointEvent read GetOnBreakPoint write SetOnBreakPoint;

    function GetInternalUnitName(Script: TScript): string; overload;
    function GetInternalUnitName(const ScriptUnitName: string): string; overload;
    function GetScriptUnitName(const InternalUnitName: string): string;
    function GetScriptLines(const UnitName: string; Output: TStrings; ScriptKinds: TScriptKinds = [skUnit]): Boolean; overload;
    function GetScriptLines(Script: TScript; Lines: TStrings): Boolean; overload;

    procedure WriteToConsole(const Chaine: string);
  end;

implementation

end.
