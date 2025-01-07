inherited ManagerEditorFilter: TManagerEditorFilter
  Caption = 'Edit Filter'
  ClientHeight = 618
  ClientWidth = 631
  Constraints.MinHeight = 500
  ExplicitWidth = 647
  ExplicitHeight = 656
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 577
    Width = 631
    ExplicitTop = 577
    ExplicitWidth = 631
    inherited bnOK: TcxButton
      Left = 463
      ExplicitLeft = 463
    end
    inherited bnCancel: TcxButton
      Left = 544
      ExplicitLeft = 544
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 631
    Height = 577
    ExplicitWidth = 631
    ExplicitHeight = 577
    object Label1: TLabel [0]
      Left = 61
      Top = 43
      Width = 404
      Height = 52
      Caption = 'Filter properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Image1: TImage [1]
      Left = 23
      Top = 43
      Width = 32
      Height = 32
    end
    object Image2: TImage [2]
      Left = 10000
      Top = 10000
      Width = 32
      Height = 32
      Visible = False
    end
    object edAppCmdId: TcxDBTextEdit [3]
      Left = 487
      Top = 43
      DataBinding.DataField = 'AppCmdId'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 0
      Width = 121
    end
    object memoDescr: TcxDBMemo [4]
      Left = 38
      Top = 377
      DataBinding.DataField = 'Description'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 8
      Height = 162
      Width = 555
    end
    object edName: TcxDBTextEdit [5]
      Left = 38
      Top = 152
      DataBinding.DataField = 'Name'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 2
      Width = 555
    end
    object edLocation: TcxDBTextEdit [6]
      Left = 38
      Top = 287
      DataBinding.DataField = 'Location'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 5
      Width = 555
    end
    object edHint: TcxDBTextEdit [7]
      Left = 38
      Top = 242
      DataBinding.DataField = 'Hint'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 4
      Width = 555
    end
    object pgFilterType: TcxPageControl [8]
      Left = 10000
      Top = 10000
      Width = 585
      Height = 461
      TabOrder = 11
      Visible = False
      Properties.ActivePage = ATab0
      Properties.CustomButtons.Buttons = <>
      OnPageChanging = pgFilterTypePageChanging
      ClientRectBottom = 457
      ClientRectLeft = 4
      ClientRectRight = 581
      ClientRectTop = 24
      object ATab0: TcxTabSheet
        Caption = 'CheckBox'
        ImageIndex = 0
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label3: TLabel
            Left = 211
            Top = 30
            Width = 70
            Height = 13
            Caption = 'Checked value'
          end
          object Label4: TLabel
            Left = 211
            Top = 56
            Width = 54
            Height = 13
            Caption = 'Clear value'
          end
          object Label5: TLabel
            Left = 8
            Top = 30
            Width = 57
            Height = 13
            Caption = 'ParamName'
          end
          object Label8: TLabel
            Left = 8
            Top = 61
            Width = 24
            Height = 13
            Caption = 'Style'
          end
          object cxDBTextEdit1: TcxDBTextEdit
            Left = 76
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
          object cxDBTextEdit3: TcxDBTextEdit
            Left = 288
            Top = 28
            DataBinding.DataField = 'SPValue'
            DataBinding.DataSource = MainSource
            TabOrder = 1
            Width = 121
          end
          object cxDBTextEdit4: TcxDBTextEdit
            Left = 288
            Top = 55
            DataBinding.DataField = 'SPValue1'
            DataBinding.DataSource = MainSource
            TabOrder = 2
            Width = 121
          end
          object ddCheckBoxStyle: TcxImageComboBox
            Left = 76
            Top = 57
            EditValue = 0
            Properties.Images = ImageContainer.Images16
            Properties.Items = <
              item
                Description = 'Large Button'
                ImageIndex = 94
                Value = 0
              end
              item
                Description = 'Button'
                ImageIndex = 146
                Value = 1
              end
              item
                Description = 'Checkbox'
                ImageIndex = 124
                Value = '2'
              end>
            TabOrder = 3
            Width = 121
          end
        end
      end
      object ATab1: TcxTabSheet
        Caption = 'Edit'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label6: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label9: TLabel
            Left = 8
            Top = 30
            Width = 57
            Height = 13
            Hint = 'Param name for text. Example: @Description'
            Caption = 'ParamName'
          end
          object Label18: TLabel
            Left = 240
            Top = 35
            Width = 72
            Height = 13
            Caption = 'Min text length'
          end
          object cxDBTextEdit5: TcxDBTextEdit
            Left = 76
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
          object seMinTextLength: TcxSpinEdit
            Left = 332
            Top = 32
            Hint = 'Minimum text length to trigger refresh event'
            BeepOnEnter = False
            Properties.AssignedValues.MinValue = True
            Properties.MaxValue = 32.000000000000000000
            TabOrder = 1
            Width = 121
          end
        end
      end
      object ATab2: TcxTabSheet
        Caption = 'DropDown'
        ImageIndex = 2
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 65
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label7: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label11: TLabel
            Left = 8
            Top = 30
            Width = 57
            Height = 13
            Caption = 'ParamName'
          end
          object cxDBTextEdit6: TcxDBTextEdit
            Left = 71
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
        end
        inline ddEdit: TDropDownEditorFrame
          Left = 0
          Top = 65
          Width = 577
          Height = 368
          Align = alClient
          TabOrder = 1
          ExplicitTop = 65
          ExplicitWidth = 577
          ExplicitHeight = 368
          inherited ddLayout: TdxLayoutControl
            Width = 577
            Height = 368
            ExplicitWidth = 577
            ExplicitHeight = 368
            inherited gridItems: TcxTreeList
              Left = 3
              Top = 3
              Width = 565
              Height = 239
              ExplicitLeft = 3
              ExplicitTop = 3
              ExplicitWidth = 565
              ExplicitHeight = 239
            end
            inherited edDDProviderName: TcxButtonEdit
              Left = 90
              Top = 326
              ExplicitLeft = 90
              ExplicitTop = 326
              ExplicitWidth = 288
              Width = 288
            end
            inherited cbDBName: TcxComboBox
              Left = 435
              Top = 326
              ExplicitLeft = 435
              ExplicitTop = 326
            end
            inherited cbAddAll: TcxCheckBox
              Left = 15
              Top = 272
              ExplicitLeft = 15
              ExplicitTop = 272
            end
            inherited cbAddNone: TcxCheckBox
              Left = 15
              Top = 299
              ExplicitLeft = 15
              ExplicitTop = 299
            end
            inherited edAllValue: TcxTextEdit
              Left = 435
              Top = 272
              ExplicitLeft = 435
              ExplicitTop = 272
            end
            inherited edNoneValue: TcxTextEdit
              Left = 435
              Top = 299
              ExplicitLeft = 435
              ExplicitTop = 299
            end
          end
        end
      end
      object ATab3: TcxTabSheet
        Caption = 'OptionBox'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label12: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label13: TLabel
            Left = 211
            Top = 30
            Width = 56
            Height = 13
            Caption = '<All> value'
          end
          object Label14: TLabel
            Left = 211
            Top = 56
            Width = 70
            Height = 13
            Caption = '<None> value'
          end
          object Label15: TLabel
            Left = 8
            Top = 30
            Width = 57
            Height = 13
            Caption = 'ParamName'
          end
          object Label16: TLabel
            Left = 8
            Top = 56
            Width = 26
            Height = 13
            Caption = 'Value'
          end
          object cxDBTextEdit10: TcxDBTextEdit
            Left = 76
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
          object cxDBTextEdit11: TcxDBTextEdit
            Left = 288
            Top = 28
            DataBinding.DataField = 'SPValue'
            DataBinding.DataSource = MainSource
            TabOrder = 1
            Width = 121
          end
          object cxDBTextEdit12: TcxDBTextEdit
            Left = 288
            Top = 55
            DataBinding.DataField = 'SPValue1'
            DataBinding.DataSource = MainSource
            TabOrder = 2
            Width = 121
          end
          object cxDBTextEdit13: TcxDBTextEdit
            Left = 76
            Top = 57
            DataBinding.DataField = 'ParamName2'
            DataBinding.DataSource = MainSource
            TabOrder = 3
            Width = 121
          end
        end
      end
      object ATab4: TcxTabSheet
        Caption = 'Date'
        ImageIndex = 4
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label17: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label20: TLabel
            Left = 10
            Top = 33
            Width = 56
            Height = 13
            Hint = 'Example @ADate'
            Caption = 'Date Param'
          end
          object cxDBTextEdit14: TcxDBTextEdit
            Left = 142
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
        end
      end
      object ATab5: TcxTabSheet
        Caption = 'DateRange'
        ImageIndex = 5
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label21: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label24: TLabel
            Left = 8
            Top = 30
            Width = 83
            Height = 13
            Hint = 'Example: @StartDate'
            Caption = 'Start Date Param'
          end
          object Label25: TLabel
            Left = 8
            Top = 56
            Width = 77
            Height = 13
            Hint = 'Example: @EndDate'
            Caption = 'End Date Param'
          end
          object cxDBTextEdit18: TcxDBTextEdit
            Left = 108
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
          object cxDBTextEdit21: TcxDBTextEdit
            Left = 108
            Top = 57
            DataBinding.DataField = 'ParamName2'
            DataBinding.DataSource = MainSource
            TabOrder = 1
            Width = 121
          end
        end
      end
      object ATab6: TcxTabSheet
        Caption = 'StaticText'
        ImageIndex = 6
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label26: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label27: TLabel
            Left = 8
            Top = 30
            Width = 57
            Height = 13
            Caption = 'ParamName'
          end
          object cxDBTextEdit22: TcxDBTextEdit
            Left = 76
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
        end
      end
      object ATab7: TcxTabSheet
        Caption = 'TreeView'
        ImageIndex = 7
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel8: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label28: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label29: TLabel
            Left = 8
            Top = 30
            Width = 57
            Height = 13
            Caption = 'ParamName'
          end
          object cxDBTextEdit23: TcxDBTextEdit
            Left = 76
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
        end
      end
      object ATab8: TcxTabSheet
        Caption = 'File'
        ImageIndex = 8
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel9: TPanel
          Left = 0
          Top = 0
          Width = 577
          Height = 65
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label10: TLabel
            Left = 8
            Top = 8
            Width = 152
            Height = 16
            Caption = 'Using stored procedure'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label22: TLabel
            Left = 8
            Top = 30
            Width = 57
            Height = 13
            Caption = 'ParamName'
          end
          object cxDBTextEdit2: TcxDBTextEdit
            Left = 76
            Top = 30
            DataBinding.DataField = 'ParamName'
            DataBinding.DataSource = MainSource
            TabOrder = 0
            Width = 121
          end
        end
      end
    end
    object chboxAlwaysEnabled: TcxDBCheckBox [9]
      Left = 10000
      Top = 10000
      Caption = 'Always enabled'
      DataBinding.DataField = 'AlwaysEnabled'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 15
      Visible = False
      OnClick = chboxAlwaysEnabledClick
    end
    object cbEnabledWhenNoRecords: TcxDBCheckBox [10]
      Left = 10000
      Top = 10000
      Caption = 'Enabled when no records'
      DataBinding.DataField = 'EnabledNoRecords'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 16
      Visible = False
    end
    object edEnabledFieldName: TcxDBTextEdit [11]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'EnabledFieldName'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 17
      Visible = False
      Width = 68
    end
    object edEnabledSign: TcxDBImageComboBox [12]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'EnabledSign'
      DataBinding.DataSource = MainSource
      Enabled = False
      Properties.Items = <
        item
          Description = '='
          ImageIndex = 0
          Value = 0
        end
        item
          Description = '<>'
          Value = 1
        end
        item
          Description = '>'
          Value = 2
        end
        item
          Description = '>='
          Value = 3
        end
        item
          Description = '<'
          Value = 4
        end
        item
          Description = '<='
          Value = 5
        end
        item
          Description = 'IS NULL'
          Value = 6
        end
        item
          Description = 'NOT IS NULL'
          Value = 7
        end
        item
          Description = 'IN CASE'
          Value = 8
        end
        item
          Description = 'NOT IN CASE'
          Value = 9
        end>
      Properties.OnChange = edEnabledSignPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 18
      Visible = False
      Width = 100
    end
    object edEnabledValue: TcxDBTextEdit [13]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'EnabledValue'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 19
      Visible = False
      Width = 121
    end
    object ddFilterType: TcxDBImageComboBox [14]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'CommandType'
      DataBinding.DataSource = MainSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Check'
          ImageIndex = 124
          Value = 0
        end
        item
          Description = 'Edit'
          ImageIndex = 191
          Value = 1
        end
        item
          Description = 'DropDown'
          ImageIndex = 285
          Value = 2
        end
        item
          Description = 'Option Box'
          ImageIndex = 233
          Value = 3
        end
        item
          Description = 'DateEdit'
          ImageIndex = 102
          Value = 4
        end
        item
          Description = 'DaterangeEdit'
          ImageIndex = 101
          Value = 5
        end
        item
          Description = 'Static Text'
          ImageIndex = 188
          Value = 6
        end
        item
          Description = 'TreeView'
          ImageIndex = 653
          Value = 7
        end
        item
          Description = 'File'
          ImageIndex = 656
          Value = 8
        end>
      Properties.OnChange = ddExecuteActionPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 9
      Visible = False
      Width = 175
    end
    object edCaption: TcxDBTextEdit [15]
      Left = 38
      Top = 197
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 3
      Width = 555
    end
    object edCreateOrder: TcxDBTextEdit [16]
      Left = 38
      Top = 332
      DataBinding.DataField = 'CreateOrder'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
      Width = 275
    end
    object edWidth: TcxDBTextEdit [17]
      Left = 319
      Top = 332
      AutoSize = False
      DataBinding.DataField = 'Width'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 7
      Height = 21
      Width = 274
    end
    object bnImageIndex: TcxButton [18]
      Left = 538
      Top = 70
      Width = 70
      Height = 25
      Caption = 'Image'
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 1
      OnClick = bnImageIndexClick
    end
    object cbAutoRefresh: TcxDBCheckBox [19]
      Left = 10000
      Top = 10000
      Hint = 'AutoRefresh current plugin on control change'
      Caption = 'AutoRefresh'
      DataBinding.DataField = 'AutoRefresh'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 10
      Visible = False
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    object Tab0: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Common'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      Index = 0
    end
    object edAppCmdId_item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'ID'
      Control = edAppCmdId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Command properties'
      CaptionOptions.Visible = False
      Control = Label1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 52
      ControlOptions.OriginalWidth = 104
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object Image1_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignVert = avTop
      Control = Image1
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = Tab0
      AlignVert = avClient
      CaptionOptions.Text = 'General'
      ButtonOptions.Buttons = <>
      ItemIndex = 4
      Index = 2
    end
    object memoDescr_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Description'
      CaptionOptions.Layout = clTop
      Control = memoDescr
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object edName_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Name'
      CaptionOptions.Layout = clTop
      Control = edName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object edLocation_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Location'
      CaptionOptions.Layout = clTop
      Control = edLocation
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object edHint_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Hint'
      CaptionOptions.Layout = clTop
      Control = edHint
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object Tab2: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Permissions'
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object Tab1: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Filter'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = Tab1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avTop
      Control = Image2
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = Tab1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object pgActionType_Item: TdxLayoutItem
      Parent = Tab1
      AlignVert = avClient
      CaptionOptions.Text = 'cxPageControl1'
      CaptionOptions.Visible = False
      Control = pgFilterType
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 315
      ControlOptions.OriginalWidth = 436
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup2: TdxLayoutGroup
      AlignVert = avClient
      CaptionOptions.Text = 'Activity condition'
      ButtonOptions.Buttons = <>
      Index = -1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup2
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahClient
      Index = 0
    end
    object chboxAlwaysEnabled_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Always enabled'
      CaptionOptions.Visible = False
      Control = chboxAlwaysEnabled
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'cxDBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbEnabledWhenNoRecords
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object edEnabledFieldName_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      CaptionOptions.Text = 'Field Name'
      Control = edEnabledFieldName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 68
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 2
    end
    object edEnabledSign_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignVert = avBottom
      Control = edEnabledSign
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object edEnabledValue_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      AlignVert = avBottom
      CaptionOptions.Text = 'Value'
      Control = edEnabledValue
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 2
    end
    object ddFilterType_Item: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Filter type'
      Control = ddFilterType
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 175
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object edCaption_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Caption'
      CaptionOptions.Layout = clTop
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object edCreateOrder_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      CaptionOptions.Text = 'Create Order'
      CaptionOptions.Layout = clTop
      Control = edCreateOrder
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_Width: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Width'
      CaptionOptions.Layout = clTop
      Control = edWidth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = bnImageIndex
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 70
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahRight
      Index = 2
    end
    object item_AutoRefresh: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'AutoRefresh'
      CaptionOptions.Visible = False
      Control = cbAutoRefresh
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      LayoutDirection = ldHorizontal
      Index = 4
    end
  end
  inherited MainSource: TDataSource
    Left = 32
    Top = 449
  end
end
