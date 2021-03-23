function [varargout]=triplegratingsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: testName condition1editString, condition1ParameterString condition2editString,
 %   condition2ParameterString, condition3editString,
 %   condition3ParameterString, gratingControlSheet, GoodCB,
 %   ControlCallback


command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,tuneEdit,parameter,tune2Edit,parameter2,tune3Edit,parameter3, gratCtrl,GoodCB,refCtrl]=triplegratingsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
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
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'Tune2Edit']),'string',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'Tune2Edit']),'userdata',varargin{5});end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'Tune3Edit']),'string',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'Tune3Edit']),'userdata',varargin{7});end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{8}); end;        
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{9}); end;
        if length(varargin)>9&~isempty(varargin{10}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{10}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'Tune2Edit']),'string'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'Tune2Edit']),'userdata'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'Tune3Edit']),'string'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'Tune3Edit']),'userdata'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;        
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>9, varargout{10}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p=getparameters(ps);
        if strcmp(typeName,'CoarseDir'), p.imageType = 1;  end;
        mystimdur = duration(periodicstim(p));
        try
            eval(['p.' parameter '=' tuneEdit ';']);
        catch
            errordlg(['Syntax Error in ' typeName ': ' tuneEdit '.'], 'My Error Dialog');
        end
        try
            eval(['p.' parameter2 '=' tune2Edit ';']);
        catch
            errordlg(['Syntax Error in ' typeName ': ' tune2Edit '.'], 'My Error Dialog');
        end
        try
            eval(['p.' parameter3 '=' tune3Edit ';']);
        catch
            errordlg(['Syntax Error in ' typeName ': ' tune3Edit '.'], 'My Error Dialog');
        end        
        p.dispprefs = {'BGposttime',isi};
        myps=periodicscript(p); 
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'myps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        if strcmp(parameter,'tFrequency')|strcmp(parameter2,'tFrequency'),
            for i=1:numStims(myps),
                p = getparameters(get(myps,i));
                p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
                myps=set(myps,periodicstim(p),i);
            end;
        elseif strcmp(parameter,'sPhaseShift')|strcmp(parameter2,'sPhaseShift'), % default is counterphase
            for i=1:numStims(myps);
                p = getparameters(get(myps,i));
                p.flickerType = 2;
                p.animType = 2;
                myps=set(myps,periodicstim(p),i);
            end;
        end;
        mngray = (p.chromhigh+p.chromlow)/2;
        if blank, myps = addblankstim(myps,mngray); end;
        myps=setDisplayMethod(myps, randomize, reps);
        test=RunScriptRemote(ds,myps,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['triplegratingsheet' typeName],'-mat');g=getfield(g,['triplegratingsheet' typeName]);
        triplegratingsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        tune2Edit,
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['triplegratingsheet' typeName '={testName,tuneEdit,parameter,tune2Edit,parameter2,gratCtrl,GoodCB,refCtrl};']);
        eval(['save ' fname ' doublegratingsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','triplegratingsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,pref,dummy,dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, 'stimnum', 1,'stimnum');
                assoc = struct('type',[typeName ' test'],'owner','triplegratingsheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','triplegratingsheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);
end;
