function [varargout]=flanktuningsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 % testName,IsoOri,FlankLocationAngleStr,StimSizeStr,NumFlanksStr,contraststr,FlankDistStr,pgratCtrl,GoodCB,refsh

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,IsoOri,FlankLocationAngleStr,StimSizeStr,NumFlanksStr,contraststr,FlankDistStr,gratCtrl,GoodCB,refsh]=flanktuningsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'IsoOriCB']),'value',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'FlankLocationAngleEdit']),'string',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'StimSizeEdit']),'string',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'NumFlanksEdit']),'string',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'ContrastEdit']),'string',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'FlankDistEdit']),'string',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'ContrastEdit']),'userdata',varargin{8}); end;        
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{9}); end;
        if length(varargin)>9&~isempty(varargin{10}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{10}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'IsoOriCB']),'value'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'FlankLocationAngleEdit']),'string'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'StimSizeEdit']),'string'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'NumFlanksEdit']),'string'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'ContrastEdit']),'string'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'FlankDistEdit']),'string'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'ContrastEdit']),'userdata'); end;        
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>9, varargout{10}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        try, FlankLocationAngle= str2num(FlankLocationAngleStr); catch, errordlg(['Syntax error in Flank Location Angle string: ' FlankLocationAngleStr '.']); return; end;
	try, StimSize = str2num(StimSizeStr); catch, errordlg(['Syntax erorr in Stim Size string:' StimSizeStr '.']); end;
	try, NumFlanks = str2num(NumFlanksStr); catch, errordlg(['Syntax erorr in Num Flanks string:' NumFlanksStr '.']); end;
	try, FlankDist = str2num(FlankDistStr); catch, errordlg(['Syntax erorr in Flanks Distance string:' FlankDistStr '.']); end;
        p = getparameters(ps);
        p.rect = [ 0 0 StimSize StimSize];
        p.dispprefs = {'BGposttime',isi};
        try, mycontrast = str2num(contraststr); catch, errordlg(['Syntax error in contrast: ' contrast '.']); return; end;
	p.contrast = mycontrast(1);
        base = periodicstim(p);
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'base'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
	if IsoOri, flankOri = p.angle; else, flankOri = 90 + p.angle; end;
        flankscript = makeflanktuning(base,flankOri,FlankLocationAngle,FlankDist,NumFlanks,mycontrast(1),mycontrast,screenrect,0);
        mngray = (p.chromhigh+p.chromlow)/2;
        if blank, flankscript = addblankstim(flankscript,mngray); end;
        lwscript = setDisplayMethod(flankscript,randomize,reps);
        test=RunScriptRemote(ds,flankscript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['flanktuningsheet' typeName],'-mat'); g=getfield(g,['flanktuningsheet' typeName]);
        flanktuningsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['flanktuningsheet' typeName '={testName,IsoOri,FlankLocationAngleStr,StimSizeStr,NumFlanksStr,contraststr,FlankDistStr,gratCtrl,GoodCB,refsh};']);
        eval(['save ' fname ' flanktuningsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        refsh='ref',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','flanktuningsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        refsh='ref',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refsh,ds,[refsh 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        savedScript = getstimscript(ds,testName)
	%islength = isempty(intersect(sswhatvaries(savedScript),'length'));
	%if islength, paramstr = 'length'; else, paramstr = 'width'; end;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, 'stimnumber', 1);
		myfig = gcf;
		%myud = get(myfig,'userdata');
		%mypc = myud{1};
		%convert_periodiccurve_2d(mypc,'length','contrast');
                assoc = struct('type',[typeName ' test'],'owner','flanktuningsheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','flanktuningsheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);        
end;

