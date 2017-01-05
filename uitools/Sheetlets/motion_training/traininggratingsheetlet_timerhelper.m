function traininggratingsheetlet_timerhelper

% TRAININGGRATINGSHEETLET_TIMERHELPER
%
%  Executes training stimulus from TRAININGGRATINGSHEETLET
%
%   See TRAININGGRATINGSHEETLET_PROCESS

ud = get(timerfind('Tag','GratingTrainingTimer'),'userdata');
try,
	test = RunScriptRemote(ud.ds,ud.myps,ud.saveit,0,1,ud.stimvalues);
	%disp(['I am training now.']); % this is for debugging
	%test = 't0001';  % this is for debugging
	set(findobj(ud.fig,'Tag',[ud.typeName 'TestEdit']),'string',test);
	trainingstr = ['Running new training stim epoch at ' datestr(now) '.'];
	currenttime = now;
	disp(trainingstr);
	trainingscript = ud.myps;
	fname = ['grating_training_run' int2str(ud.counter+1) '.mat'];
	pname = getpathname(ud.ds);
	while exist([fixpath(pname) fname])==2,
		ud.counter = ud.counter + 1;
		fname = ['grating_training_run' int2str(ud.counter+1) '.mat'];
		pname = getpathname(ud.ds);
	end;
	save([fixpath(pname) fname],'currenttime','trainingscript','trainingstr','-mat');
	ud.counter = ud.counter + 1;
	set(timerfind('Tag','GratingTrainingTimer'),'userdata',ud);
catch, 
	disp(['oops, I goofed.']);
	t = timerfind('Tag','GratingTrainingElapsedTimer');
	if ~isempty(t), stop(t); delete(t); end;
	t = timerfind('Tag','GratingTrainingTimer');
	if ~isempty(t), stop(t); delete(t); end;
	error(['Grating training error at ' datestr(now) '.']);
end;


