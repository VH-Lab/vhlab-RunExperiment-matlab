function [varargout]=traininggratingsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: testName, DirPrefEdit, ONOFFEdit, gratCtrl, GoodCB, acquireCB, refCtrl, bsiCtl, methodPopupValue]
 % onoffvalue, cb1, cb2, ctrcb


A{1} = [ 1     2     3     4     5     6     7     8];
A{2} = [8     7     6     5     4     3     2     1];
A{3} = [8     4     7     3     6     2     5     1];
A{4} = [5     1     4     8     3     7     2     6];
A{5} = [1     4     8     2     7     5     3     6];
A{6} = [7     2     6     1     5     3     8     4];
A{7} = [3     7     4     1     5     8     2     6];
A{8} = [4     6     2     5     8     3     1     7];

B_seq = getfield(load('B_sequences.mat','-mat'),'B_sequences');
B_seq_steps = 8*ones(1,size(B_seq,1));

B = [ 8 8 8 8 8 8 8 8];

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,DirPrefEdit,ONOFFEdit,gratCtrl,GoodCB,acquireCB,refCtrl,bsiCtl,methodPopupValue]=traininggratingsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value'); % this will be replaced by the acquireCB value below
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'DirPrefEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'ONOFFEdit']),'string',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'ONOFFEdit']),'userdata',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'acquireCB']),'value',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{8}); end;        
	if length(varargin)>8&~isempty(varargin{9}),set(findobj(fig,'tag',[typeName 'methodPopup']),'value',varargin{9}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'DirPrefEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'ONOFFEdit']),'string'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'ONOFFEdit']),'userdata'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'acquireCB']),'value'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'methodPopup']),'value'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank,blankisblack]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
	blank = 0; % we don't use blanks in training
        p=getparameters(ps);
	% we need total revision from here
        mystimdur = duration(periodicstim(p));
	
	try, angle = eval(DirPrefEdit);
	catch,
		errordlg(['Syntax error in ' typeName ': DirPrefEdit.']);
		error(['Syntax error in ' typeName ': DirPrefEdit.']);
	end;

	try, onoff=eval([ONOFFEdit]);
	catch,
		errordlg(['Syntax error in ' typeName ': ' ONOFFEdit.']);
		error(['Syntax error in ' typeName ': ONOFFEdit.']);
	end;

        p.dispprefs = {'BGposttime',isi};

	switch methodPopupValue,
		case 1, % Bidirectional motion training
			p.angle = [angle angle+180 angle angle+180];
			p.flickerType = 0;
			p.animType = 4;
			p.imageType = 2;	
			p.loops = 0;

		case 2, % Unidirectional motion training
			p.angle = [angle];
			p.flickerType = 0;
			p.animType = 4;
			p.imageType = 2;
			p.loops = 0;

		case 3, % Counter-phase at single spatial phase
			p.angle = angle;
			p.sPhaseShift = 0;
			p.flickerType = 2;
			p.imageType = 2;
			p.animType = 2;
			p.loops = 0;

		case 4, % Flash training with multiple spatial phases
			p.angle = angle;
			p.sPhaseShift = [0:pi/6:pi-pi/6];
			p.flickerType = 0;
			p.imageType = 2;
			p.animType = 2;
			p.loops = 0;

		case 5, % 4-directional
			p.angle = [angle angle+180 angle+90 angle-90];
			p.flickerType = 0;
			p.animType = 4;
			p.imageType = 2;	
			p.loops = 0;

		case 6, % 8-directional
			p.angle = [angle angle+180 angle+90 angle-90 angle+45 angle-45 angle+90+45 angle-90-45 ];
			p.flickerType = 0;
			p.animType = 4;
			p.imageType = 2;	
			p.loops = 0;

		case {7,8,9,10,11,12,13,14},
			seq = methodPopupValue - 6; % 7->1, 8->2, etc...
			p.angle = [angle];
			p.flickerType = 0;
			p.animType = 4;
			p.imageType = 2;
			p.loops = 0;
			p.phaseSteps = B(seq);
			p.phaseSequence = A{seq};

		case {15,16,17,18,19,20,21,22,23,24,25,26},
			seq = methodPopupValue - 14;
			p.angle = [angle];
			p.flickerType = 0;
			p.animType = 4;
			p.imageType = 2;
			p.loops = 0;
			p.phaseSteps = B_seq_steps(seq);
			p.phaseSequence = B_seq(seq,:);

		case {27},
			p.imageType = 0;
			p.animType = 5;
			p.loops = 0;

		case {28},
        		[newrect,dist,screenrect] = getscreentoolparams;
			myscript = makeorthogonaltrainingstim(ps, [0:30:360-30], screenrect);
		case {29},
        		[newrect,dist,screenrect] = getscreentoolparams;
			myscript = makeorthogonaltrainingstim(ps, [0:30:360-30], screenrect, 0);
	end;

        if methodPopupValue < 28,
		myps=periodicscript(p);
        	[newrect,dist,screenrect] = getscreentoolparams;
	        foreachstimdolocal({'myps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
	else,
		myps = myscript;
	end;
        %if strcmp(parameter,'tFrequency'),  % leaving the code here in case we ever train for spatial frequency; we'll have to decide
        %    for i=1:numStims(myps),
        %        p = getparameters(get(myps,i));
        %        p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
        %        myps=set(myps,periodicstim(p),i);
        %    end;
        %elseif strcmp(parameter,'sPhaseShift'), % default is counterphase
        %    for i=1:numStims(myps);
        %        p = getparameters(get(myps,i));
        %        p.flickerType = 2;
        %        p.animType = 2;
        %        myps=set(myps,periodicstim(p),i);
        %    end;
        %end;
        mngray = (p.chromhigh+p.chromlow)/2;
        if blankisblack,
            blankcolor= [0 0 0];
    	else,
        	blankcolor = mngray;
        end;
        stimvalues = p.angle;
        if blank, myps = addblankstim(myps,blankcolor); stimvalues(end+1) = NaN; end;
	single_rep_duration = duration(myps),
	rounded_number_of_reps = round(onoff(1)*60  / single_rep_duration),
	saveit = acquireCB;
        myps=setDisplayMethod(myps, randomize, rounded_number_of_reps);
		% we want to put the code below on a timer
        %test=RunScriptRemote(ds,myps,saveit,0,1,stimvalues);
        %set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);
	mystruct = struct('ds',ds,'myps',myps,'saveit',saveit,'stimvalues',stimvalues,'typeName',typeName,'fig',fig,'startTime',clock,'counter',0);
	t = timer('Period',60*sum(onoff),'Tag','GratingTrainingTimer','TimerFcn','traininggratingsheetlet_timerhelper;','userdata',mystruct,'ExecutionMode','fixedSpacing');
	t2 = timer('Period',5,'Tag','GratingTrainingElapsedTimer','TimerFcn','traininggratingsheetlet_elapsedtimerhelper;','userdata',mystruct,'ExecutionMode','fixedSpacing');
	start(t); start(t2);
    case 'StopBt',
	t = timerfindall('Tag','GratingTrainingTimer');
	if ~isempty(t),
		stop(t);
		delete(t);
		disp(['Found GratingTrainingTimer and it was stopped and deleted.']);
	else,
		warning('No GratingTrainingTimer found.');
	end;
	t2 = timerfindall('Tag','GratingTrainingElapsedTimer');
	if ~isempty(t2),
		stop(t2);
		delete(t2);
		disp(['Found GratingTrainingElapsedTimer and it was stopped and deleted.']);
	else,
		warning('No GratingTrainingElapsedTimer found.');
	end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['traininggratingsheet' typeName],'-mat');g=getfield(g,['traininggratingsheet' typeName]);
        traininggratingsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['traininggratingsheet' typeName '={testName,tuneEdit,parameter,preference,gratCtrl,GoodCB,prefCB,refCtrl,bsiCtl};']);
        eval(['save ' fname ' traininggratingsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','traininggratingsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        if ~isempty(bsiCtl),
            set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
            [subF,divF,SigF,Mult,DiffImg,MeanFilt,MedianFilt,LVIntrinsicON]=brainsurfaceanalysissheetlet_process(fig, bsiCtl, ds, [bsiCtl 'GetVars']),
            analyzeintrinsicstims([getpathname(ds) filesep testName],eval(subF),eval(SigF));
            createsingleconditions([getpathname(ds) filesep testName],eval(Mult),eval(MeanFilt),eval(MedianFilt));
            plotorientationmap([getpathname(ds) filesep testName],DiffImg,1,1);
            return;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,pref,dummy,dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, parameter, 1);
                %[dummy,dummy,pref,dummy,dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, parameter, 1,'stimnum');
                traininggratingsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','',pref);
                assoc = struct('type',[typeName ' test'],'owner','traininggratingsheetlet','data',testName,'desc',[typeName ' test']);
                if isstruct(co),
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','traininggratingsheetlet','data',co,'desc',[typeName ' resp']);
                else,
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','traininggratingsheetlet','data',{co},'desc',[typeName ' resp']);
                end;
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);
    case 'prefCB',
        [ps]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p = getparameters(ps);
        mystimdur = duration(periodicstim(p));
        p = setfield(p,parameter,preference);
        if strcmp(parameter,'tFrequency'),
            p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
        end;
        ps = periodicscript(p);
        gratingcontrolsheetlet_process(fig,gratCtrl,ds,[gratCtrl 'SetVars'],ps);
end;
