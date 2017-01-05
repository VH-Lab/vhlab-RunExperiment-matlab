function [varargout]=quicktimesheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: testName,basestim,GoodCB,refCtrl

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,basestim,GoodCB,refCtrl]=quicktimesheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}),
		set(findobj(fig,'tag',[typeName 'EditBt']),'userdata',varargin{2});
		p = getparameters(varargin{2});
		[mypath,myfilename] = fileparts(p.filename);
		set(findobj(fig,'tag',[typeName 'FileNameTxt'],'string',myfilename));
	end;
        if length(varargin)>3&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{3}); end;
        if length(varargin)>4&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{4}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'EditBt']),'userdata'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
    case 'EditBt',
        f = warndlg('Note that this script will be run on the remote computer; be sure you select a file that is accessible on the remote computer','Quicktime warning');
        newstim = quicktimestim('graphical',basestim);
        if ~isempty(newstim),
            set(findobj(fig,'tag',[typeName 'EditBt']),'userdata',newstim);
        else, newstim = basestim;
        end;
        p = getparameters(newstim);
        [mypath,myfilename] = fileparts(p.filename);
        set(findobj(fig,'tag',[typeName 'FileNameTxt']),'string',myfilename);
    case 'RunBt',
        p = getparameters(basestim);
        [mypath,myfilename,myext] = fileparts(p.filename);
        remotepath = localpath2remote(mypath),
        mypath = mypath(find(mypath~=''''));
        myext = myext(find(myext~=''''));
        p.filename = [remotepath remotefilesep myfilename myext],
        mystimscript = append(stimscript(0),quicktimestim(p));
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'mystimscript'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        p = getparameters(get(mystimscript,1)),
        test=RunScriptRemote(ds,mystimscript,saveit,0,1,[NaN]);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['quicktimesheet' typeName],'-mat');g=getfield(g,['quicktimesheet' typeName]);
        quicktimesheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['quicktimesheet' typeName '={testName,basestim,GoodCB,refCtrl};']);
        eval(['save ' fname ' quicktimesheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','quicktimesheetlet','data',testName,'desc',[typeName ' test']);
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
                quicktimesheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','',pref);
                assoc = struct('type',[typeName ' test'],'owner','quicktimesheetlet','data',testName,'desc',[typeName ' test']);
                if isstruct(co),
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','quicktimesheetlet','data',co,'desc',[typeName ' resp']);
                else,
                    assoc(end+1) = struct('type',[typeName ' resp'],'owner','quicktimesheetlet','data',{co},'desc',[typeName ' resp']);
                end;
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);
end;
