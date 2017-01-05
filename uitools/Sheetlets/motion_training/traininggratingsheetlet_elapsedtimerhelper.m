function traininggratingsheetlet_elapsedtimerhelper

% TRAININGGRATINGSHEETLET_TIMERHELPER
%
%  Executes training stimulus from TRAININGGRATINGSHEETLET
%
%   See TRAININGGRATINGSHEETLET_PROCESS

ud = get(timerfind('Tag','GratingTrainingTimer'),'userdata');
try,
	elapsedtime_in_seconds = etime(clock,ud.startTime);
	hrs = fix(elapsedtime_in_seconds / (60*60));
	elapsedtime_in_seconds = elapsedtime_in_seconds - hrs * (60*60);
	mns = fix(elapsedtime_in_seconds / 60);
	elapsedtime_in_seconds = fix(elapsedtime_in_seconds - mns * 60);
	timestr = ['Elapsed time ' sprintf('%d:%0.2d:%0.2d',hrs,mns,elapsedtime_in_seconds) ];
	set(findobj(ud.fig,'Tag',[ud.typeName 'ElapsedTxt']),'string',timestr);
catch, 
	error(['Grating training elapsed time error at ' datestr(now) '.']);
end;






