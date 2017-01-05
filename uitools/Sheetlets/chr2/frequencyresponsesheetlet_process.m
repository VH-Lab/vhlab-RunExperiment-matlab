function [varargout]=frequencyresponsesheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 % testName,freqliststr,durationstr,GoodCB,refsh

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,freqliststr,durationstr,GoodCB,refsh]=frequencyresponsesheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'freqlistEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'DurationEdit']),'string',varargin{3}); end;
        if length(varargin)>4&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{4}); end;
        if length(varargin)>5&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{5}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'freqlistEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'DurationEdit']),'string'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
    case 'RunBt',
        % create dummy script, and iont table
        freqs = eval(freqliststr);
        arg = eval(durationstr);
        pw=arg(1); dur=arg(2); isi=arg(3); reps=arg(4); 
        pulsewidth = []; pulseinterval = []; numpulses = [];
        current = 900; channel = 0;
        for i=1:length(freqs),
            if freqs(i)>0, 
                pulsewidth(i) = max(0,arg(1)-0.1e-3);
                pulseinterval(i) = max(0,round( (-pulsewidth(i) -0.4e-3 + 1/freqs(i))*10000 )/10000),
                numpulses(i) = dur / (pulsewidth(i)+pulseinterval(i));
            else,
                pulsewidth(i) = dur;
                pulseinterval(i) = 1e-3;
                numpulses(i) = 1;
            end;
        end;

        thescript = addblankstim(stimscript(0), [128 128 128], dur,{'BGposttime',isi});
        global FitzScriptmodifier_dirname;
        [myscript,ionttable] = makeiontophoresisfreqscript(thescript,current,pulsewidth,pulseinterval,numpulses,channel,1,reps);
        writeiontophoresistable2(FitzScriptmodifier_dirname,ionttable);
        if ~isempty(z),
            ecd = get(findobj(z,'tag','extdevcb'),'value');
            set(findobj(z,'tag','extdevcb'),'value',0);
        end;
        ans = questdlg('You must now RESET the acquisition program and start it','','OK','Cancel','OK');
        if strcmp(ans,'Cancel'),
            newscript = [];
        end;
        test=RunScriptRemote(ds,myscript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);
        try, delete([FitzScriptmodifier_dirname 'iontophoresis_instruction.txt']); end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['frequencyresponsesheet' typeName],'-mat'); g=getfield(g,['frequencyresponsesheet' typeName]);
        frequencyresponsesheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['frequencyresponsesheet' typeName '={testName,freqliststr,durationstr,GoodCB,refsh};']);
        eval(['save ' fname ' frequencyresponsesheet' typeName ' -append -mat']);
    case 'AddDBBt',
        refsh='ref',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','frequencyresponsesheetlet','data',testName,'desc',[typeName ' test']);
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
                assoc = struct('type',[typeName ' test'],'owner','frequencyresponsesheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','frequencyresponsesheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);        
end;
