inherited dfActionsExecuteStoredProcedureDialog: TdfActionsExecuteStoredProcedureDialog
  Caption = 'Execute Stored Procedure'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DialogLayout: TdxLayoutControl
    inherited cbRequiresTransaction: TDBCheckBox
      TabOrder = 12
    end
    inherited cbRunSynchro: TDBCheckBox
      TabOrder = 16
    end
    inherited cbUseExpression: TDBCheckBox
      Width = 154
      ExplicitWidth = 154
    end
    inherited cbVisibleToUser: TDBCheckBox
      TabOrder = 9
    end
    inherited memoUserInformation: TcxDBMemo
      TabOrder = 11
    end
    inherited bnImageIndex: TcxButton
      TabOrder = 10
    end
    object cbDBName: TcxDBComboBox [14]
      Left = 110
      Top = 369
      DataBinding.DataField = 'DBName'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 8
      Width = 121
    end
    object edbProviderName: TcxDBButtonEdit [15]
      Left = 110
      Top = 342
      DataBinding.DataField = 'ProviderName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edbProviderNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 7
      Width = 547
    end
    inherited Group_Common: TdxLayoutGroup
      ItemIndex = 3
    end
    inherited Group_Properties: TdxLayoutGroup
      ItemIndex = 2
    end
    inherited item_cbUseExpression: TdxLayoutItem
      ControlOptions.OriginalWidth = 154
    end
    object Item_cbDBName: TdxLayoutItem
      Parent = Group_Properties
      AlignHorz = ahLeft
      CaptionOptions.Text = 'DBName'
      Control = cbDBName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_edbProviderName: TdxLayoutItem
      Parent = Group_Properties
      CaptionOptions.Text = 'ProviderName'
      Control = edbProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutLabeledItem1: TdxLayoutLabeledItem
      Parent = Group_Properties
      AlignHorz = ahLeft
      CaptionOptions.Text = 
        'Note:  If stored procedure returns field "UserMessage", it will ' +
        'be added to resulting DataSet'
      Index = 2
    end
  end
end
