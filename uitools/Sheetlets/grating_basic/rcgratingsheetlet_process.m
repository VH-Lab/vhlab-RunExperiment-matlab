function [varargout]=rcgratingsheetlet_process(fig, typeName, ds, command, varargin)
% var input argument order testName,tuneEdit,parameter,tune2Edit,parameter2,tune3Edit,parameter3,isirepsbisiEdit,gratCtrl,GoodCB,refCtrl
command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
	[testName,tuneEdit,parameter,tune2Edit,parameter2,tune3Edit,parameter3,isirepsbisiEdit,gratCtrl,GoodCB,refCtrl]=...
			rcgratingsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end; % testname
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'TuneEdit']),'string',varargin{2}); end; % tuneEdit string
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'TitleText']),'userdata',varargin{3});end; % parameter1
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'Tune2Edit']),'string',varargin{4}); end; % tune2Edit string
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'Title2Text']),'userdata',varargin{5});end; % parameter2
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'Tune3Edit']),'string',varargin{6}); end; % tune3Edit string
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'Title3Text']),'userdata',varargin{7});end; % parameter3
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'ISIRepsBISIEdit']),'string',varargin{8}); end; % ISIRepsBISIEdit string
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata',varargin{9}); end; % gratCtrl
        if length(varargin)>9&~isempty(varargin{10}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{10}); end;  % goodCB
        if length(varargin)>10&~isempty(varargin{11}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{11}); end; % refCtl
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end; % testname
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'string'); end; % first tuneEdit string
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'TitleText']),'userdata'); end; % parameter 1
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'Tune2Edit']),'string'); end; % second tuneedit string
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'Title2Text']),'userdata'); end; % parameter 2
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'Tune3Edit']),'string'); end; % third tuneedit string
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'Title3Text']),'userdata'); end; % parameter 3
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'ISIRepsBISIEdit']),'string'); end; % ISIRepsBISIEdit
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata'); end; % gratCtrl sheetlet
        if nargout>9, varargout{10}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end; % goodCB
        if nargout>10, varargout{11}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end; % refCtrl
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p=getparameters(ps);
	p.animType = 1;
	try, p1list = eval(tuneEdit); catch, errordlg(['Syntax error in ' typeName ': ' tuneEdit '.'],'My Error Dialog'); end;
	try, p2list = eval(tune2Edit);catch, errordlg(['Syntax error in ' typeName ': ' tune2Edit '.'],'My Error Dialog'); end;
	try, p3list = eval(tune3Edit);catch, errordlg(['Syntax error in ' typeName ': ' tune3Edit '.'],'My Error Dialog'); end;
	try, pars = eval(isirepsbisiEdit); catch, errordlg(['Syntax error in ' typeName ': ' isirepsbisiEdit '.'],'My Error Dialog'); end;
	myps = append(stimscript(0),periodicstim(p));
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'myps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
	ps = get(myps,1);
	rcg = rcgratingstim('default');
	p = getparameters(rcg);
	p.baseps = ps;
	p.orientations = p1list;
	p.spatialfrequencies = p2list;
	p.spatialphases = p3list;
	p.reps = pars(2);
	p.dur = pars(1);
	p.pausebetweenreps = pars(3);
	rcg = rcgratingstim(p);
	myrc = append(stimscript(0),rcg);
        test=RunScriptRemote(ds,myrc,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['rcgratingsheet' typeName],'-mat');g=getfield(g,['rcgratingsheet' typeName]);
        rcgratingsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['rcgratingsheet' typeName '={testName,tuneEdit,parameter,tune2Edit,parameter2,tune3Edit,parameter3,isirepsbisiEdit,gratCtrl,GoodCB,refCtrl};']);
        eval(['save ' fname ' rcgratingsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','rcgratingsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,pref,dummy,dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, 'stimnum', 1,'stimnum');
                assoc = struct('type',[typeName ' test'],'owner','rcgratingsheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','rcgratingsheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);
end;
