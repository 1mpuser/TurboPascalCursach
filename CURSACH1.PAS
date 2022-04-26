unit CURSACH1;

interface
uses objects, sysutils, DateUtils;


type
	PTimerHelper = ^TimerHelper;
    TimerHelper = object
		FutureTime, PrevTime : TDateTime;
		remHours, remMins, remSecs, pastHours, pastMins, pastSecs : Word;
		secondsRemaining : Word;
		GoodbyeString : String;
		constructor Init (var FutTime : TDateTime);
		Procedure ChangeDates;
		Procedure Over (gdByeStr : String);
end;


implementation


constructor TimerHelper.Init(var FutTime : TDateTime);
	var secondsBetweenDates : Word;
	hour, min, sec, ms : Word;
	tmpDate : TDateTime;
	begin
		PrevTime := Now;
		FutureTime := FutTime;
		tmpDate := FutTime - Now;
		DecodeTime(tmpDate, hour, min, sec, ms);
		secondsBetweenDates := 3600 * (hour) + 60 * (min) + (sec);
	end;


procedure TimerHelper.ChangeDates;
	var current, remainingTime, pastTime : TDateTime;
    var ms : Word;
	begin
		current := Now;
		pastTime := PrevTime - current;
		remainingTime := FutureTime - current;
		DecodeTime(remainingTime, remHours,remMins, remSecs, ms);
		DecodeTime(pastTime, pastHours, pastMins, pastSecs, ms);
		secondsRemaining :=  secondsRemaining - 1;
	end;


procedure TimerHelper.Over (gdByeStr : String);
	begin
		GoodbyeString := gdByeStr;
	end;


begin
end.
