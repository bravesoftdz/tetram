%PROJECT% %NAME%;
{
-----------------------------------------------------------------------------
     DO NOT EDIT THIS FILE, IT IS GENERATED BY THE PACKAGE GENERATOR
            ALWAYS EDIT THE RELATED XML FILE (%XMLNAME%)

     Last generated: %DATETIME%
-----------------------------------------------------------------------------
}
<%%% BEGIN PACKAGEONLY %%%>
<%%% DO NOT GENERATE %%%>
<%%% END PACKAGEONLY %%%>
<%%% BEGIN RUNONLY %%%>
<%%% DO NOT GENERATE %%%>
<%%% END RUNONLY %%%>
<%%% BEGIN DESIGNONLY %%%>
<%%% DO NOT GENERATE %%%>
<%%% END DESIGNONLY %%%>

{$R *.res}
{$ALIGN ON}
{$ASSERTIONS ON}
{$BOOLEVAL OFF}
{$DEBUGINFO OFF}
{$EXTENDEDSYNTAX ON}
{$IMPORTEDDATA ON}
{$IOCHECKS ON}
{$LOCALSYMBOLS OFF}
{$LONGSTRINGS ON}
{$OPENSTRINGS ON}
{$OPTIMIZATION ON}
{$OVERFLOWCHECKS OFF}
{$RANGECHECKS OFF}
{$REFERENCEINFO OFF}
{$SAFEDIVIDE OFF}
{$STACKFRAMES OFF}
{$TYPEDADDRESS OFF}
{$VARSTRINGCHECKS ON}
{$WRITEABLECONST OFF}
{$MINENUMSIZE 1}
{$IMAGEBASE $%IMAGE_BASE%}
{$DESCRIPTION '%DESCRIPTION%'}
{$IMPLICITBUILD OFF}

<%%% START COMPILER DEFINES %%%>
{$DEFINE %COMPILERDEFINE%}
<%%% END COMPILER DEFINES %%%>

uses
  ToolsAPI,
<%%% START FILES %%%>
  %UNITNAME% in '%FILENAME%' {%FORMNAMEANDTYPE%},
<%%% END FILES %%%>
  ;

<%%% BEGIN LIBRARYONLY %%%>
exports
  JCLWizardInit name WizardEntryPoint;
<%%% END LIBRARYONLY %%%>

end.