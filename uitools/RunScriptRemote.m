function myname = RunScriptRemote(ds, thescript, saveit, priority, abortable, stimvalues, varargin)
% RUNSCRIPTREMOTE - Run stimulus scripts on a remote (or even local) machine
%
%  TESTDIRNAME = RUNSCRIPTREMOTE(DS, THESCRIPT, SAVEIT, PRIORITY, ABORTABLE, STIMVALUES, ...)
%     
% Inputs:
%   DS - A DIRSTRUCT object for the experiment directory
%   THESCRIPT - the stimulus script
%   SAVEIT - Should we save the result? 
%   PRIORITY - The priority level for the call to the Rush function (see HELP RUSH)
%   ABORTABLE - Should the script be abortable? (runs the slightest bit slower if it is)
%   STIMVALUES - The values for the stimuli (can be NaN to ignore)
%
% Additional arguments can be provided as name/value pairs 
%  for displaying an alternate stimulus on a second computer:
% Variable (default value):  |  Description
% ----------------------------------------------------------------------------------------
% alt_display (0)            |  Should we display on an alternative display?
% alt_script ([])            |  The stimscript to display on the alternate display
% alt_trigger (1)            |  Should the alternate display computer wait for a trigger for each stim?
%


global FitzScriptmodifier_dirname FitzExperFileName FitzInstructionFileName;

NewStimGlobals;

if numStims(thescript)>NSMaxStimsPerStimScript,
    error(['The script to be run has more stimuli ' int2str(numStims(thescript)) ' than the maximum allowed by the configuration NSMaxStimsPerStimScript (' int2str(NSMaxStimsPerStimScript) ').']);
end;

if nargin<6, sv = [NaN]; stimvalues = sv; else, sv = stimvalues; end;

alt_display = 0;
alt_script = [];
alt_trigger = 1;

assign(varargin{:});

mypath = []; myname = []; myremotepath = [];
if saveit,
    mynewdirname = [getpathname(ds) filesep newtestdir(ds)],
    [mypath,myname] = fileparts(mynewdirname),
    myremotepath = (localpath2remote(mypath)),
end;

z=geteditor('RunExperiment');
if ~isempty(z),
    vdaqintrinsic = get(findobj(z,'tag','vdaqintrinsic'),'value');
    lvintrinsic = get(findobj(z,'tag','lvintrinsic'),'value');
else,
    vdaqintrinsic = 0;
    lvintrinsic = 0;
end;

thescript = unloadStimScript(thescript);

if saveit,
	try,
	mkdir(mypath,myname);
	end;
	lastind = length(mypath); if mypath(lastind)==filesep, lastind = lastind - 1; end;
	[mypathpath,mypathfilename] = fileparts(mypath(1:lastind));
	fid = fopen(FitzExperFileName,'wt'); fprintf(fid,'%s',mypathfilename); fclose(fid);
	fid = fopen(FitzInstructionFileName,'wt'); fprintf(fid,'%s',myname); fclose(fid);
	%nameref = referencesheetlet_process(gcf, 'ref', ds, ['ref' 'GetVars']);
	%nameref.type = 'singleEC';
	[nameref,vh_channelgroupinginfo,vh_filtermapinfo] = getrunexperimentacquisitionlist;
	saveStructArray([mypath filesep myname filesep 'reference.txt'],nameref);
	if ~isempty(vh_channelgroupinginfo),
		saveStructArray([mypath filesep myname filesep 'vhintan_channelgrouping.txt'],vh_channelgroupinginfo);
	end;
	if ~isempty(vh_filtermapinfo),
		saveStructArray([mypath filesep myname filesep 'vhintan_filtermap.txt'],vh_filtermapinfo);
	end;
	addtag(ds,myname,'stimcommandtime',now);
end;

thescript = RunScriptModifiers('EditScript',thescript);


if vdaqintrinsic|lvintrinsic, thescript = vdaqintrinsicmodifier(thescript); end;

if vdaqintrinsic, 
    thescript = setDisplayMethod(thescript,0,1);
end;

str = {     'save gotit abortable -mat;'
            'thescript = loadStimScript(thescript);'
            'mti=DisplayTiming(thescript);'
            'stimorder = getDisplayOrder(thescript);'
            'if saveit, try, mkdir(myremotepath,myname); end; save([fixpath(myremotepath) myname filesep ''stimorder.mat''],''stimorder'',''-mat'');end;'
            'if saveit, save([fixpath(myremotepath) myname filesep ''stimvalues.mat''],''stimvalues'',''-mat''); end;'
            '[MTI2,start]=DisplayStimScript(thescript,mti,priority,abortable);'
            'saveScript = strip(unloadStimScript(thescript));'
            'MTI2 = stripMTI(MTI2);'
            'try, snd(''play'',''glass'');snd(''play'',''glass'');snd(''play'',''glass''); catch, beep; pause(0.5); beep; pause(0.5); beep; end;'
            'if saveit, disp([''saving now, to '' fixpath(myremotepath) myname filesep ''stims.mat'']); end;'
            'if saveit, try, mkdir(myremotepath,myname); end; save([fixpath(myremotepath) myname filesep ''stims.mat''],''saveScript'',''start'',''MTI2'',''-mat''); end;'
      };

if alt_display,
	str = cat(1,str(1),{'pause(10);'},str(2:end)); % add a pause to allow the alternate computer to catch up
end;

  % this is now OUT OF DATE
str_intrinsic = {     'save gotit abortable -mat;'
            'thescript = loadstimscript(thescript);'
            'mti=DisplayTiming(thescript);'
            '[MTI2,start]=DisplayStimScriptIntrinsic(thescript,mti,priority,[]);'
            'saveScript = strip(unloadStimScript(thescript));'
            'MTI2 = stripMTI(MTI2);'
            'snd(''play'',''glass'');snd(''play'',''glass'');snd(''play'',''glass'');'
            'disp([''saving now, to '' fixpath(myremotepath) myname filesep ''stims.mat'']);'
            'if saveit, try, mkdir(myremotepath,myname); end; save([fixpath(myremotepath) myname filesep ''stims.mat''],''saveScript'',''start'',''MTI2'',''-mat''); end;'
      };  
  
str_lvintrinsic = {   'save gotit abortable -mat;'
            'stimorder = getDisplayOrder(thescript);'
            'if saveit, try, mkdir(myremotepath,myname); end; save([fixpath(myremotepath) myname filesep ''stimorder.mat''],''stimorder'',''-mat'');end;'
            'save([fixpath(myremotepath) myname filesep ''stimvalues.mat''],''stimvalues'',''-mat'');'
            'thescript = loadStimScript(thescript);'
            'mti=DisplayTiming(thescript);'
            'StimTriggerClear;'
            'fitzTrigParams.triggerStimOnset = 0;StimTriggerAdd(''FitzTrig'',fitzTrigParams);'
            'disp([''Just added new stim trigger mode.'']);'
            '[MTI2,start]=DisplayStimScript(thescript,mti,priority,1);'
            'saveScript = strip(unloadStimScript(thescript));'
            'StimTriggerClear;';
            'fitzTrigParams.triggerStimOnset = 1;StimTriggerAdd(''FitzTrig'',fitzTrigParams);'
            'MTI2 = stripMTI(MTI2);'
            'snd(''play'',''glass'');snd(''play'',''glass'');snd(''play'',''glass'');'
            'disp([''saving now, to '' fixpath(myremotepath) myname filesep ''stims.mat'']);'
            'if saveit, try, mkdir(myremotepath,myname); end; save([fixpath(myremotepath) myname filesep ''stims.mat''],''saveScript'',''start'',''MTI2'',''-mat''); end;'
	};  

str_alt = {     'save gotit_1 abortable -mat;'
            'thescript_alt = loadStimScript(thescript_alt);'
            'mti=DisplayTiming(thescript_alt);'
            'stimorder_alt = getDisplayOrder(thescript_alt);'
            '[MTI2,start]=DisplayStimScript(thescript_alt,mti,priority,abortable);'
            'saveScript = strip(unloadStimScript(thescript_alt));'
            'MTI2 = stripMTI(MTI2);'
            'try, snd(''play'',''glass'');snd(''play'',''glass'');snd(''play'',''glass''); catch, beep; pause(0.5); beep; pause(0.5); beep; end;'
            'if saveit, disp([''saving now, to '' fixpath(myremotepath) myname filesep ''stims_alt.mat'']); end;'
            'if saveit, try, mkdir(myremotepath,myname); end; save([fixpath(myremotepath) myname filesep ''stims_alt.mat''],''saveScript'',''start'',''MTI2'',''-mat''); end;'
	};

if alt_trigger,
	str_alt = cat(1,str_alt(1),{'NewStimGlobals; NewStimTriggeredStimPresentation=1;'},str_alt(2:end));
end;



if ~saveit, extrastring = '(acquiring stim info is OFF)'; else, extrastring = '(aquiring stim info is ON)'; end;

if saveit, ans = questdlg(['Please confirm acquisition program is running ' extrastring '.  LabView and Spike2 should not yet be running or errors may occur. If the Spike2 script has not already been restarted after a prior recording, then cancel, restart the Spike2 script, and re-run the stimulus.'],'','OK','Cancel','OK');
else, ans = 'OK';
end;

if strcmp(ans,'OK'),
	drawnow;
	if vdaqintrinsic, str = str_intrinsic; end;
	%if lvintrinsic, str = str_lvintrinsic; end;
	RunExperimentGlobals;
	if VH_RunStimsLocally==1, % do a local test,
		MTI2 = NSLoadAndRunTest(thescript);
	elseif VH_RunStimsLocally==2,
		ShowStimScreen; % make sure stim screen is in front
		HideCursor;
		for i=1:length(str),
			str{i},
			eval(str{i});
		end;
		ShowCursor;
	else,
		[b] =sendremotecommandvar(str,...
			{'thescript','priority','abortable','saveit','mypath','myname','myremotepath','stimvalues'}, ...
			{thescript,priority,abortable,saveit,mypath,myname,myremotepath,sv});
		if alt_display,
			[b] =sendremotecommandvar(str_alt,...
				{'thescript_alt','priority','abortable','saveit','mypath','myname','myremotepath'}, ...
				{alt_script,priority,abortable,saveit,mypath,myname,myremotepath},1);
		end;
	end;
end;

thescript = RunScriptModifiers('CleanUp',thescript);
if ~isempty(alt_script),
	alt_script = RunScriptModifiers('CleanUp',alt_script);
end;
