inherited ManagerEditorCSharpScript: TManagerEditorCSharpScript
  Caption = 'DataScript (C#)'
  PixelsPerInch = 96
  TextHeight = 13
  object memoTemplate: TMemo [3]
    Left = 436
    Top = 366
    Width = 417
    Height = 159
    Lines.Strings = (
      'using System;'
      'using System.Data;'
      'using DAC.XDataSet;'
      'using DAC.ObjectModels;'
      ''
      'public class %s : TBasicDataClass'
      '{'
      
        '  public override TxDataSet Run(TMiceDataRequest miceRequest, TM' +
        'iceUser miceUser)'
      '   {'
      '        var DataSet = new TxDataSet();'
      
        '        DataSet.LoadFromExecutionContext(miceRequest.ExecutionCo' +
        'ntext);'
      '        DataSet.Open();'
      '        //DataSet.AddMessage("Processed by DataScript: %s");'
      '        return DataSet;'
      '   }'
      '}')
    ScrollBars = ssBoth
    TabOrder = 7
    Visible = False
    WantReturns = False
  end
  inherited MainBar: TdxBarManager
    PixelsPerInch = 96
    inherited MainMenuBar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnRun'
        end
        item
          Visible = True
          ItemName = 'bnSave'
        end
        item
          Visible = True
          ItemName = 'bnSaveAsFile'
        end
        item
          Visible = True
          ItemName = 'bnFormat'
        end
        item
          Visible = True
          ItemName = 'bnCloseCurrentPage'
        end
        item
          Visible = True
          ItemName = 'bnParams'
        end
        item
          Visible = True
          ItemName = 'bnPublish'
        end>
    end
    object bnPublish: TdxBarButton [4]
      Caption = 'Publish'
      Category = 0
      Hint = 'Save and publish script to work'
      Visible = ivAlways
      ImageIndex = 18
      PaintStyle = psCaptionGlyph
      OnClick = bnPublishClick
    end
    object bnParams: TdxBarButton [5]
      Caption = 'Parameters'
      Category = 0
      Hint = 'Accepted parameters t'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 9
      PaintStyle = psCaptionGlyph
      OnClick = bnParamsClick
    end
  end
end
