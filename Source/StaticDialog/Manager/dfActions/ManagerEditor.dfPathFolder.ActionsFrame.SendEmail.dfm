inherited DfActionsEmailDialog: TDfActionsEmailDialog
  Caption = 'Send EMail'
  ClientHeight = 759
  ClientWidth = 700
  ExplicitWidth = 716
  ExplicitHeight = 797
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 718
    Width = 700
    ExplicitTop = 718
    ExplicitWidth = 700
    inherited bnOK: TcxButton
      Left = 532
      ExplicitLeft = 532
    end
    inherited bnCancel: TcxButton
      Left = 613
      ExplicitLeft = 613
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 700
    Height = 718
    ExplicitWidth = 700
    ExplicitHeight = 718
    inherited cbActive: TDBCheckBox
      Width = 688
      ExplicitWidth = 688
    end
    inherited edCaption: TcxDBTextEdit
      ExplicitWidth = 581
      Width = 581
    end
    inherited cbRequiresTransaction: TDBCheckBox
      TabOrder = 14
    end
    inherited cbRunSynchro: TDBCheckBox
      TabOrder = 17
    end
    inherited cbUseExpression: TDBCheckBox
      Width = 654
      ExplicitWidth = 654
    end
    inherited memoExpression: TDBMemo
      Width = 650
      ExplicitWidth = 650
    end
    inherited cbVisibleToUser: TDBCheckBox
      TabOrder = 11
    end
    inherited memoUserInformation: TcxDBMemo
      TabOrder = 13
    end
    inherited bnImageIndex: TcxButton
      TabOrder = 12
    end
    inherited Label1: TLabel
      Width = 176
      Caption = 'Standart Action Properties'
      ExplicitWidth = 176
    end
    object edMailTo: TcxDBTextEdit [14]
      Left = 112
      Top = 369
      DataBinding.DataField = 'MessageTo'
      DataBinding.DataSource = DetailSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 8
      Width = 550
    end
    object edSubject: TcxDBTextEdit [15]
      Left = 112
      Top = 396
      DataBinding.DataField = 'MessageSubject'
      DataBinding.DataSource = DetailSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 9
      Width = 550
    end
    object memoBody: TcxDBMemo [16]
      Left = 38
      Top = 441
      DataBinding.DataField = 'MessageBody'
      DataBinding.DataSource = DetailSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 10
      Height = 239
      Width = 624
    end
    object ddMessageType: TcxDBImageComboBox [17]
      Left = 112
      Top = 342
      DataBinding.DataField = 'MessageType'
      DataBinding.DataSource = DetailSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'EMail'
          ImageIndex = 215
          Value = 0
        end
        item
          Description = 'SMS'
          ImageIndex = 460
          Value = 1
        end
        item
          Description = 'Online'
          ImageIndex = 415
          Value = 2
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 7
      Width = 121
    end
    inherited item_cbUseExpression: TdxLayoutItem
      ControlOptions.OriginalWidth = 654
    end
    inherited dxLayoutItem1: TdxLayoutItem
      ControlOptions.OriginalWidth = 176
    end
    object item_MailTo: TdxLayoutItem
      Parent = Group_Properties
      CaptionOptions.Text = 'To'
      Control = edMailTo
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_Subject: TdxLayoutItem
      Parent = Group_Properties
      CaptionOptions.Text = 'Subject'
      Control = edSubject
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object item_Body: TdxLayoutItem
      Parent = Group_Properties
      AlignVert = avClient
      CaptionOptions.Text = 'Body'
      CaptionOptions.Layout = clTop
      Control = memoBody
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object item_MessageType: TdxLayoutItem
      Parent = Group_Properties
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Message Type'
      Control = ddMessageType
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
end
