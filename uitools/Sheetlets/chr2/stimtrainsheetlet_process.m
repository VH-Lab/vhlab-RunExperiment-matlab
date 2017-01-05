function [varargout]=stimtrainsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 % paramstr,GoodCB,refsh

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [paramstr,GoodCB,refsh]=stimtrainsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'pulselistEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'pulselistEdit']),'userdata',varargin{3}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'pulselistEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'pulselistEdit']),'userdata'); end;
    case {'pulselistEdit','GoodCB'}
        if isempty(z),
            errordlg('No RunExperiment window, cannot set up stimtrains.');
        else,
            ecdlist = get(findobj(z,'tag','extdevlist'),'string');
            gotchr2 = 0;
            if ~isempty(ecdlist),
            	for i=1:length(ecdlist),
                    openpars = find(ecdlist{i}=='('); closepars = find(ecdlist{i}==')');
                    if strcmp(ecdlist{i}(1:openpars(1)-1),'chr2stim2'),
                        gotchr2 = 1; break;
                    end;
                end;
            end;
            if ~gotchr2, i = length(ecdlist)+1; end;
            ecdlist{i} = ['chr2stim2([0 900],' paramstr ');'];
            set(findobj(z,'tag','extdevlist'),'string',ecdlist,'value',1);
            set(findobj(z,'tag','extdevcb'),'value',GoodCB);
        end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['stimtrainsheet' typeName],'-mat'); g=getfield(g,['stimtrainsheet' typeName]);
        stimtrainsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['stimtrainsheet' typeName '={paramstr,GoodCB,refsh};']);
        eval(['save ' fname ' stimtrainsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        refsh='ref',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = []; %struct('type',[typeName ' test'],'owner','stimtrainsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        refsh='ref',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refsh,ds,[refsh 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        savedScript = getstimscript(ds,testName)
        islength = isempty(intersect(sswhatvaries(savedScript),'length'));
        if islength, paramstr = 'length'; else, paramstr = 'width'; end;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, paramstr, 1);
                assoc = struct('type',[typeName ' test'],'owner','stimtrainsheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','stimtrainsheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);        
end;
