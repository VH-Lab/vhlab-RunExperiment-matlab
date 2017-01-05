function [varargout]=gratingsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: revstim1, test1, revstim2, test2, ctrloc,
 % onoffvalue, cb1, cb2, ctrcb


command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,tuneEdit,parameter,preference,gratCtrl,GoodCB,prefCB,refCtrl,bsiCtl]=gratingsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'TuneEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'prefEdit']),'string',num2str(varargin{4})); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'prefEdit']),'userdata',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'prefCB']),'value',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{8}); end;
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{9}); end;        
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata'); end;
        if nargout>3, varargout{4}=str2nume(get(findobj(fig,'tag',[typeName 'prefEdit']),'string')); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'prefEdit']),'userdata'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'prefCB']),'value'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank,blankisblack]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
p=getparameters(ps);
        p_master = p;
        %if strcmp(typeName,'CoarseDir'), p.imageType = 1;  end;
        mystimdur = duration(periodicstim(p));
        try
            eval(['p.' parameter '=' tuneEdit ';']);
        catch
            errordlg(['Syntax Error in ' typeName ': ' tuneEdit '.'], 'My Error Dialog');
        end
        p.dispprefs = {'BGposttime',isi,'BGpretime',0.5};
        p_master_dispprefs = p;
	if strcmp(parameter,'tFrequency'), p.tFrequency = abs(p.tFrequency); end;
        myps=periodicscript(p);
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'myps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        if strcmp(parameter,'tFrequency'),
		tuneEditValues = eval(tuneEdit);
		for i=1:numStims(myps),
			p = getparameters(get(myps,i));
			p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
			if tuneEditValues(i)<0, p.angle = mod(p.angle + 180,360); end;
			myps=set(myps,periodicstim(p),i);
		end;
	elseif strcmp(upper(parameter),'BRIGHTNESS'),
	        tunevalues = eval(tuneEdit),
		for i=1:length(tunevalues),
			tunevalues(i),
			p = p_master_dispprefs;
			p.chromlow = [0 0 0];
			p.chromhigh = 255*tunevalues(i)*p_master.chromhigh/max(p_master.chromhigh);
			p.brightness = tunevalues(i);
			myps = set(myps,periodicstim(p),i);
		end;
        elseif strcmp(parameter,'sPhaseShift'), % ask what we should do
            flickertype = questdlg('You have selected to vary phase. What flicker type?','Flicker type','Light->Dark->Light','Counterphase','Counterphase');
            switch(flickertype),
		case 'Light->Dark->Light',
			flickermode = 0;
		case 'Counterphase',
			flickermode = 2;
            end;
            animtype = questdlg('You have selected to vary phase. What animation type?','Animation type','Square','Sinusoidal','Drifting','Sinusoidal');
	    switch(animtype),
		case 'Square',
			animmode = 1;
		case 'Sinusoidal',
			animmode = 2;
		case 'Drifting',
			animmode = 4;
            end;
            for i=1:numStims(myps);
                p = getparameters(get(myps,i));
                p.flickerType = flickermode;
                p.animType = animmode;
		if p.sPhaseShift>=2*pi, p.angle = mod(p.angle + 90,360); end;
                myps=set(myps,periodicstim(p),i);
            end;
        end;
        mngray = (p_master.chromhigh+p_master.chromlow)/2;
	if blankisblack,
		blankcolor= [0 0 0];
	else,
		blankcolor = mngray;
	end;
        stimvalues = eval(tuneEdit);
        if blank, myps = addblankstim(myps,blankcolor); stimvalues(end+1) = NaN; end;
        myps=setDisplayMethod(myps, randomize, reps);
        test=RunScriptRemote(ds,myps,saveit,0,1,stimvalues);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['gratingsheet' typeName],'-mat');g=getfield(g,['gratingsheet' typeName]);
        gratingsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['gratingsheet' typeName '={testName,tuneEdit,parameter,preference,gratCtrl,GoodCB,prefCB,refCtrl,bsiCtl};']);
        eval(['save ' fname ' gratingsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','gratingsheetlet','data',testName,'desc',[typeName ' test']);
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
                gratingsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','',pref);
                assoc = struct('type',[typeName ' test'],'owner','gratingsheetlet','data',testName,'desc',[typeName ' test']);
                if isstruct(co),
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','gratingsheetlet','data',co,'desc',[typeName ' resp']);
                else,
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','gratingsheetlet','data',{co},'desc',[typeName ' resp']);
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
