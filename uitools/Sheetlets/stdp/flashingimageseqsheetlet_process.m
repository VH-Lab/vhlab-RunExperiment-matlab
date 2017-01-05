function [varargout]=flashingimageseqsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: revstim1, test1, revstim2, test2, ctrloc,
 % onoffvalue, cb1, cb2, ctrcb

 % if number of input arguments is 3
 %   then process a command
 % if number of arguments is 7, then set variables
 %   revstim1, test1, revstim2, test2, ctrloc, cb1, cb2

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [rev1s,t1s,rev2s,t2s,ctredit,onoff,cb1,cb2,cb3,refCtrl]=flashingimageseqsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'CoarseEditBt']),'userdata',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'CoarseTestEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'FineEditBt']),'userdata',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'FineTestEdit']),'string',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'CenterEdit']),'string',mat2str(varargin{5})); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'OnOffPopup']),'value',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'CoarseCB']),'value',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'FineCB']),'value',varargin{8}); end;
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'CenterLocCB']),'value',varargin{9}); end;
        if length(varargin)>9&~isempty(varargin{10}), set(findobj(fig,'tag',[typeName 'AnalyzeCoarseBt']),'userdata',varargin{10}); end;        
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'CoarseEditBt']),'userdata'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'CoarseTestEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'FineEditBt']),'userdata'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'FineTestEdit']),'string'); end;
        if nargout>4, varargout{5}=str2num(get(findobj(fig,'tag',[typeName 'CenterEdit']),'string')); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'OnOffPopup']),'value'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'CoarseCB']),'value'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'FineCB']),'value'); end;
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'CenterLocCB']),'value'); end; 
        if nargout>9, varargout{10}=get(findobj(fig,'tag',[typeName 'AnalyzeCoarseBt']),'userdata'); end;
    case 'CoarseRunBt',
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'rev1s'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
	p = getparameters(rev1s);
	if cb3,
		p.dispprefs = {'BGpretime',ctredit(2)};
		cl = class(rev1s);
		eval(['rev1s=' cl '(p);']);
	end;
	thescript = append(stimscript(0),rev1s);
	if cb3,
        	thescript = setDisplayMethod(thescript,0,ctredit(1));
	end;
        if nargout>0, varargout{1}=thescript; end;
        test=RunScriptRemote(ds,thescript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'CoarseTestEdit']),'string',test);
    case 'FineRunBt',
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'rev2s'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
	p = getparameters(rev2s);
	if cb3,
		p.dispprefs = {'BGpretime',ctredit(2)};
		cl = class(rev2s);
		eval(['rev2s=' cl '(p);']);
	end;
        thescript=append(stimscript(0),rev2s);
	if cb3,
        	thescript = setDisplayMethod(thescript,0,ctredit(1));
	end;
        if nargout>0, varargout{1}=thescript; end;        
        test=RunScriptRemote(ds,thescript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'FineTestEdit']),'string',test);
    case 'CoarseEditBt',
        cl = class(rev1s);
        if ~isempty(cl)&~strcmp(cl,'double'), 
            eval(['rev1s = ' cl '(''graphical'',rev1s);']);
        end;
        if ~isempty(rev1s),
            flashingimageseqsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],rev1s,[],[],[],[],[],[],[],[]);
        end;
    case 'FineEditBt',
        cl = class(rev2s);
        if ~isempty(cl)&~strcmp(cl,'double'), 
            eval(['rev2s = ' cl '(''graphical'',rev2s);']);
        end;
        if ~isempty(rev2s),
            flashingimageseqsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],[],[],rev2s,[],[],[],[],[],[]);
        end;
    case 'CoarseCB',
    case 'FineCB',
    case 'CenterLocCB',
    case 'AnalyzeCoarseBt',
        set(findobj(fig,'tag',[typeName 'CoarseCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,rc] = singleunitrevcorr(ds, mycell{j}, mycellname{j}, t1s, 1);
            end;
        end;
    case 'AnalyzeFineBt',
        set(findobj(fig,'tag',[typeName 'CoarseCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,rc] = singleunitrevcorr(ds, mycell{j}, mycellname{j}, t2s, 1);
            end;
        end;        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['reversecorrsheet' typeName],'-mat'); g=getfield(g,['reversecorrsheet' typeName]);
        flashingimageseqsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['reversecorrsheet' typeName '={rev1s,t1s,rev2s,t2s,ctredit,onoff,cb1,cb2,cb3};']);
        eval(['save ' fname ' reversecorrsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if cb3,
            if nargout>0, varargout{1} = []; end;
        else,
            warning('Warning: reversecorrelation sheetlet was not checked.');
            if nargout>0, varargout{1} = []; end;
        end;
end;
