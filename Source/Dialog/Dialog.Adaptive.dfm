inherited AdaptiveDialog: TAdaptiveDialog
  Caption = 'AdaptiveDialog'
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    inherited bnOK: TcxButton
      ModalResult = 0
      OnClick = bnOKClick
    end
  end
  inherited MainSource: TDataSource
    OnDataChange = MainSourceDataChange
  end
  inherited BalloonHint: TBalloonHint
    HideAfter = 5000
  end
end
