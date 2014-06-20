package org.tetram.bdtheque.data.services;

import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.tetram.bdtheque.data.bean.Edition;

import java.util.Collection;

/**
 * Created by Thierry on 20/06/2014.
 */
@Service
@Lazy
@Scope
public class FusionServiceImpl implements FusionService {

    @Override
    public void fusionneInto(Collection<Edition> source, Collection<Edition> dest) {
/*
type
  OptionFusion = record
    ImporterImages: Boolean;
    RemplacerImages: Boolean;
  end;
var
  FusionsEditions: array of TEditionFull;
  OptionsFusion: array of OptionFusion;
  Edition: TEditionFull;
  i: Integer;
  frm: TfrmFusionEditions;
begin
  if Source.Count = 0 then
    Exit;

  SetLength(FusionsEditions, Source.Count);
  ZeroMemory(FusionsEditions, Length(FusionsEditions) * SizeOf(TEditionFull));
  SetLength(OptionsFusion, Source.Count);
  ZeroMemory(OptionsFusion, Length(OptionsFusion) * SizeOf(OptionFusion));
  // même si la destination n'a aucune données, on peut choisir de ne rien y importer
  // if Dest.Editions.Count > 0 then
  for i := 0 to Pred(Source.Count) do
  begin
    frm := TfrmFusionEditions.Create(nil);
    try
      frm.SetEditionSrc(Source[i]);
      // SetEditions doit être fait après SetEditionSrc
      frm.SetEditions(Dest, FusionsEditions);

      case frm.ShowModal of
        mrCancel:
          FusionsEditions[i] := nil;
        mrOk:
          if frm.CheckBox1.Checked then
          begin
            FusionsEditions[i] := TFactoryEditionFull.getInstance;
            Dest.Add(FusionsEditions[i]);
          end
          else
            FusionsEditions[i] := TEditionFull(frm.lbEditions.Items.Objects[frm.lbEditions.ItemIndex]);
      end;
      OptionsFusion[i].ImporterImages := frm.CheckBox2.Checked and (Source[i].Couvertures.Count > 0);
      OptionsFusion[i].RemplacerImages := frm.CheckBox3.Checked and OptionsFusion[i].ImporterImages;
    finally
      frm.Free;
    end;
  end;

  for i := 0 to Pred(Source.Count) do
  begin
    Edition := FusionsEditions[i];
    if Assigned(Edition) then
    begin
      if not OptionsFusion[i].ImporterImages then
        Source[i].Couvertures.Clear
      else if OptionsFusion[i].RemplacerImages then
        Edition.Couvertures.Clear;

      FusionneInto(Source[i], Edition);
    end;
  end;
end;
 */
    }
}
