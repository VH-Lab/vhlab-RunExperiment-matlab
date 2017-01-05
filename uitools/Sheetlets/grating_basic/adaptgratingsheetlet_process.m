function [varargout]=adaptgratingsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: revstim1, test1, revstim2, test2, ctrloc,
 % onoffvalue, cb1, cb2, ctrcb


command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,tuneEdit,parameter,adaptparams,gratCtrl,GoodCB,refCtrl,bsiCtl]=adaptgratingsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
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
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'adaptEdit']),'string',num2str(varargin{4})); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'adaptEdit']),'userdata',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{8}); end;        
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata'); end;
        if nargout>3, varargout{4}=str2nume(get(findobj(fig,'tag',[typeName 'adaptEdit']),'string')); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'adaptEdit']),'userdata'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
    case 'RunBt',
	AddExternalCommand(['adapttopoff(' int2str(adaptparams(5)) ')'],1,'adapttopoff');
	ToggleExternalCommand(1);
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p=getparameters(ps);
        %if strcmp(typeName,'CoarseDir'), p.imageType = 1;  end;
        mystimdur = duration(periodicstim(p));
        try
            eval(['p.' parameter '=' tuneEdit ';']);
        catch
            errordlg(['Syntax Error in ' typeName ': ' tuneEdit '.'], 'My Error Dialog');
        end
        p.dispprefs = {'BGposttime',isi,'BGpretime',adaptparams(4)};
        myps=periodicscript(p);
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
                myps=set(myps,periodicstim(p),i);
            end;
        end;

        % here we add initial adaptation and top off stim
	p = getparameters(get(myps,1));
	initialp = p;
	eval(['initialp.' parameter '= adaptparams(1);']);
	initialp.nCycles = max([1 round(adaptparams(2)*initialp.tFrequency/(initialp.loops+1))]);
	initialp.initialadapt = 1;
        initialp.dispprefs = {'BGposttime',0,'BGpretime',0};
	if adaptparams(5)==1, initialp.contrast = 0; end;
	myps = append(myps,periodicstim(initialp,1));
	topoffp = initialp;
	topoffp.nCycles = max([1 round(adaptparams(3)*topoffp.tFrequency/(topoffp.loops+1))]);
	topoffp.adapttopoff = 1;
	myps = append(myps,periodicstim(topoffp,1));

        mngray = (p.chromhigh+p.chromlow)/2;
        stimvalues = eval(tuneEdit);
        if blank, myps = addblankstim(myps,mngray); stimvalues(end+1) = NaN; end;
        myps=setDisplayMethod(myps, randomize, reps);
        test=RunScriptRemote(ds,myps,saveit,0,1,stimvalues);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['adaptgratingsheet' typeName],'-mat');g=getfield(g,['gratingsheet' typeName]);
        adaptgratingsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['adaptgratingsheet' typeName '={testName,tuneEdit,parameter,adaptparams,gratCtrl,GoodCB,refCtrl,bsiCtl};']);
        eval(['save ' fname ' gratingsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','adaptgratingsheetlet','data',testName,'desc',[typeName ' test']);
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
                assoc = struct('type',[typeName ' test'],'owner','adaptgratingsheetlet','data',testName,'desc',[typeName ' test']);
                if isstruct(co),
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','adaptgratingsheetlet','data',co,'desc',[typeName ' resp']);
                else,
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','adaptgratingsheetlet','data',{co},'desc',[typeName ' resp']);
                end;
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);
end;
