program TVGUID05;

uses Objects, Drivers, Views, Menus, App, SysUtils, DateUtils , CURSACH1, Dialogs;

const
  WinCount: Integer =   0;
  cmNewWin          = 101;
  cmFileOpen        = 100;
  cmNewAlarm = 102;


type
  DialogData = record
    InputLineData: string[128];
  end;



type
  TMyApp = object(TApplication)
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure NewDialog;
	procedure NewAlarmWindow;
	procedure NewWindow;
    //Function WordToString: Word; virtual;
  end;

 
PDemoDialog = ^TDemoDialog;
  TDemoDialog = object(TDialog)
  end;


  PDemoWindow = ^TDemoWindow;
  TDemoWindow = object(TWindow)
    constructor Init(Bounds: TRect; WinTitle: String; WindowNo: Word);
  end;

  PInterior = ^TInterior;
  TInterior = object(TView)
    constructor Init(var Bounds: TRect);
    procedure Draw; virtual;
  end;

var
  DemoDialogData: DialogData;
  
  
{ TInterior }
constructor TInterior.Init(var Bounds: TRect);
begin
  TView.Init(Bounds);
  GrowMode := gfGrowHiX + gfGrowHiY;
  Options := Options or ofFramed;
end;

procedure TInterior.Draw;
const Days : array[0 .. 6] of String[11] =
   ('Sunday', 'Monday', 'Tuesday',
   'Wednesday', 'Thursday', 'Friday', 'Saturday');
var
  Hour, Min, Sec, HSec  : Word;
  Greeting, OneMoreGreeting: string;
  OneSec : TDateTime;
  Helper : PTimerHelper;
  R : TRect;
begin
  //GetTime(Hour,Min,Sec,HSec);
  //Greeting := 'Today : ' + Days[Dow] + ', ' + D  + '.'+ M + '.'+ Y ;
  Greeting := TimeToStr(Time);
  OneMoreGreeting := TimeToStr(Time - StrToTime ('0:0:1'));
  TView.Draw;
  WriteStr(4, 2, Greeting, $01);
  WriteStr(4, 3, OneMoreGreeting, $01);
  OneSec := Time;
  Helper := new (PTimerHelper, Init(OneSec));
  {
	Helper = Helper.Init(StrToTime(//тут строка с вывода))
	while (Helper.remainingTime != 0) do
	begin
		//изменяем строки с оставшимся временем и прошедшем временем
		Helper.ChangeDates();
		delay(1000);
	end;
	Helper.Done('Timer Done!');
	// выводим сообщение с помрщью поля goodbye string
  }


end;

{ TDemoWindow }
constructor TDemoWindow.Init(Bounds: TRect; WinTitle: String; WindowNo: Word);
var
  S: string[3];
  Interior: PInterior;
begin
  Str(WindowNo, S);
  TWindow.Init(Bounds, WinTitle + ' ' + S, wnNoNumber);
  GetClipRect(Bounds);
  Bounds.Grow(-1,-1);
  Interior := New(PInterior, Init(Bounds));
  Insert(Interior);
end;

{ TMyApp }
procedure TMyApp.HandleEvent(var Event: TEvent);
begin
  TApplication.HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmNewWin:
		begin
	  NewDialog;
	  NewAlarmWindow;
	  //NewWindow;
	  end;
	  cmNewAlarm : NewAlarmWindow;
    else
      Exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure TMyApp.InitMenuBar;
var R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~F~ile', hcNoContext, NewMenu(
      NewItem('~O~pen', 'F3', kbF3, cmFileOpen, hcNoContext,
      NewItem('~N~ew alarm dialog', 'F4', kbF4, cmNewWin, hcNoContext,
      NewLine(
      NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil))))),
    NewSubMenu('~W~indow', hcNoContext, NewMenu(
      NewItem('~N~ext', 'F6', kbF6, cmNext, hcNoContext,
      NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcNoContext,
      nil))),
    nil))
  )));
end;

procedure TMyApp.InitStatusLine;
var R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F4~ New', kbF4, cmNewWin,
      NewStatusKey('~Alt-F3~ Close', kbAltF3, cmClose,
      nil)))),
    nil)
  ));
end;

procedure TMyApp.NewDialog;
var
  Bruce: PView;
  Dialog: PDemoDialog;
  R: TRect;
  C: Word;
begin
  R.Assign(20, 6, 60, 19);
  Dialog := New(PDemoDialog, Init(R, 'Demo Dialog'));
  with Dialog^ do
  begin
    R.Assign(3, 8, 37, 9);
    Bruce := New(PInputLine, Init(R, 128));
    Insert(Bruce);
    R.Assign(2, 7, 24, 8);
    Insert(New(PLabel, Init(R, 'Type ur time', Bruce)));
    {R.Assign(2, 10, 12, 12);
	Insert(New(PButton, Init(R, '~N~ew Window', cmOK && cmNewWindow, bfNormal)));}
	R.Assign(15, 10, 25, 12);
    Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));
    R.Assign(28, 10, 38, 12);
    Insert(New(PButton, Init(R, 'Cancel', cmCancel, bfNormal)));
	R.Assign(2, 10, 12, 12);
	//Insert(New(PButton, Init(R, 'SetAlarm', cmNewAlarm, bfNormal)));
  end;
  Dialog^.SetData(DemoDialogData);
  C := DeskTop^.ExecView(Dialog);
  if C <> cmCancel then Dialog^.GetData(DemoDialogData);
  Dispose(Dialog, Done);
end;

procedure TMyApp.NewAlarmWindow;
var
	Bruce: PView;
	Alarm: PDemoDialog;
	R: TRect;
	C: Word;  
	Text : PStaticText;
	Helper : PTimerHelper;
	DinStr : PAnsiString;
	S : AnsiString;
	S2: PString;
	suka : ShortString;
begin
R.Assign(10, 3, 60, 19);
C:= 1;
Alarm := New(PDemoDialog, Init(R, 'Demo Dialog'));
with Alarm^ do 	
begin
R.Assign(15, 6, 25, 10);
S:= 'Text';
S2 := newStr(S);
suka := 'Suka blyat';
Text := new(PStaticText, Init(R, suka));
Insert(Text);
Text^.Draw;
sleep(1000);
Text^. Text:=newStr ('Da blyat!');
Text^.Draw;
{R.Assign(25, 35, 37, 40);

Text := new(PStaticText, Init(R, 'Dick'));
Text.Draw();
Insert(Text);}

R.Assign(15, 10, 25, 12);
Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));
end;
Desktop^.Insert(Alarm);
C := DeskTop^.ExecView(Alarm);
Dispose(Alarm, Done);
end;




procedure TMyApp.NewWindow;
var
  Window: PDemoWindow;
  R: TRect;
begin
  Inc(WinCount);
  R.Assign(0, 0, 45, 13);
  R.Move(Random(34), Random(11));
  Window := New(PDemoWindow, Init(R, 'Demo Window', WinCount));
  DeskTop^.Insert(Window);
end;


{constructor TMyDialog.Init(var R : TRect; Title2 :  string);
var Wind : PDialog;
Baton : PButton;
begin

inherited Init (R, Title2);
  
  //Dispose(Baton, Done);

end;

destructor TMyDialog.Done;
begin

end;}

{procedure TMyDialog.HandleEvent (var Event: TEvent);
begin

end;}




var
  MyApp: TMyApp;

begin
  with DemoDialogData do
  begin
    InputLineData := '19:00';
  end;
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
end.
