function [varargout]=modulatinggratingsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: testName,tuneEdit,parameter,preference,gratCtrl,TuneWithModulatingGratingCB,modGratCtrl,GoodCB,prefCB,refCtrl
  % need to add a modGratCtrl info, 
  % need to add a switch for whether we are varying parameters in the modulating grating or carrier

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,tuneEdit,parameter,preference,gratCtrl,TuneWithModulatingGratingCB,modGratCtrl,GoodCB,prefCB,refCtrl,bsiCtl]=modulatinggratingsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;  % testName
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'TuneEdit']),'string',varargin{2}); end;  % tuneEdit
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata',varargin{3}); end; % the parameter name
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'prefEdit']),'string',num2str(varargin{4})); end; % the preference value
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'prefEdit']),'userdata',varargin{5}); end; % gratCtrl - the grating control for the carrier grating (underlying grating)
	if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'TuneWithModulatingGratingCB']),'value',varargin{6}); end; %- are we tuning with the modulating grating or carrier?
	if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'TuneWithModulatingGratingCB']),'userdata',varargin{7}); end; % - modGratCtrl
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{8}); end; % is it a good trial?
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'prefCB']),'value',varargin{9}); end; % did we check the preference?
        if length(varargin)>9&~isempty(varargin{10}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{10}); end; % refCtl
        if length(varargin)>10&~isempty(varargin{11}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{11}); end;  % brain surface imaging ctl
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata'); end;
        if nargout>3, varargout{4}=str2nume(get(findobj(fig,'tag',[typeName 'prefEdit']),'string')); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'prefEdit']),'userdata'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'TuneWithModulatingGratingCB']),'value'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'TuneWithModulatingGratingCB']),'userdata'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'prefCB']),'value'); end;
        if nargout>9, varargout{10}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>10, varargout{11}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
	p = getparameters(ps);
        [psm,repsm,isim,randomizem,blankm]=gratingcontrolsheetlet_process(fig, modGratCtrl, ds, [modGratCtrl 'GetVars']);
	pm = getparameters(psm);
        mystimdur = duration(periodicstim(p));

	if TuneWithModulatingGratingCB,
        	try
			eval([' pmlist =' tuneEdit ';']);
	        catch
			errordlg(['Syntax Error in ' typeName ': ' tuneEdit '.'], 'My Error Dialog');
		end
		plist = getfield(p,parameter)*ones(size(pmlist));
	else,
        	try
			eval(['plist =' tuneEdit ';']);
	        catch
			errordlg(['Syntax Error in ' typeName ': ' tuneEdit '.'], 'My Error Dialog');
		end
		pmlist = getfield(pm,parameter)*ones(size(plist));
	end;
        p.dispprefs = {'BGposttime',isi,'BGpretime',0.5};
	myps = stimscript(0);
	for i=1:length(pmlist),
		pm = setfield(pm,parameter,pmlist(i));
		p =  setfield(p, parameter, plist(i));
		p.rect = pm.rect;
		thepsstimp = p;
		thepsstimp.ps_mask = periodicstim(pm);
		myps = append(myps,periodicstim(thepsstimp));
	end;
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'myps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        if strcmp(parameter,'tFrequency'),
            for i=1:numStims(myps),
                p = getparameters(get(myps,i));
                p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
                myps=set(myps,periodicstim(p),i);
            end;
        elseif strcmp(parameter,'sPhaseShift'), % default is counterphase
            for i=1:numStims(myps);
                p = getparameters(get(myps,i));
                p.flickerType = 2;
                p.animType = 2;
		if p.sPhaseShift>=2*pi, p.angle = mod(p.angle + 90,360); end;
                myps=set(myps,periodicstim(p),i);
            end;
        end;
        mngray = (p.chromhigh+p.chromlow)/2;
        stimvalues = eval(tuneEdit);
        if blank, myps = addblankstim(myps,mngray); stimvalues(end+1) = NaN; end;
        myps=setDisplayMethod(myps, randomize, reps);
        test=RunScriptRemote(ds,myps,saveit,0,1,stimvalues);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['gratingsheet' typeName],'-mat');g=getfield(g,['gratingsheet' typeName]);
        modulatinggratingsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['gratingsheet' typeName '={testName,tuneEdit,parameter,preference,gratCtrl,TuneWithModulatingGratingCB,modGratCtrl,GoodCB,prefCB,refCtrl,bsiCtl};']);
        eval(['save ' fname ' gratingsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','modulatinggratingsheetlet','data',testName,'desc',[typeName ' test']);
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
		if TuneWithModulatingGratingCB,
	                [dummy,dummy,pref,dummy,dummy,dummy,co]=singleunitgrating2mod(ds, mycell{j}, mycellname{j}, testName, parameter, 1);
		else,
	                [dummy,dummy,pref,dummy,dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, parameter, 1);
		end;
                %[dummy,dummy,pref,dummy,dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, parameter, 1,'stimnum');
                modulatinggratingsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','',pref);
                assoc = struct('type',[typeName ' test'],'owner','modulatinggratingsheetlet','data',testName,'desc',[typeName ' test']);
                if isstruct(co),
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','modulatinggratingsheetlet','data',co,'desc',[typeName ' resp']);
                else,
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','modulatinggratingsheetlet','data',{co},'desc',[typeName ' resp']);
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
