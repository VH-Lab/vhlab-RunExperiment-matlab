function [varargout]=lengthwidthcontrastsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 % testName,lengthsstr,widthsstr,contraststr,pgratCtrl,GoodCB,refsh

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,lengthsstr,widthsstr,contraststr,gratCtrl,GoodCB,refsh]=lengthwidthcontrastsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'LengthsEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'WidthsEdit']),'string',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'ContrastEdit']),'string',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'WidthsEdit']),'userdata',varargin{5}); end;        
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{7}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'LengthsEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'WidthsEdit']),'string'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'ContrastEdit']),'string'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'WidthsEdit']),'userdata'); end;        
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        try, lengths = str2num(lengthsstr); catch, errordlg(['Syntax error in lengths: ' lengthsstr '.']); return; end;
        try, widths = str2num(widthsstr); catch, errordlg(['Syntax error in widths: ' widthsstr '.']); return; end;
        p = getparameters(ps);
        p.dispprefs = {'BGposttime',isi};
        try, mycontrast = str2num(contraststr); catch, errordlg(['Syntax error in contrast: ' contrast '.']); return; end;
	p.contrast = mycontrast(1);
        base = periodicstim(p);
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'base'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        lwscript = makelengthwidthtuning(base,lengths,widths);
	N = numStims(lwscript);
        for i=1:N,
		mystimp = getparameters(get(lwscript,i));
		mystimp.stimnumber = i;
		mystimp.length = diff(mystimp.rect([1 3]));
		mystimp.width= diff(mystimp.rect([2 4]));
		lwscript = set(lwscript,periodicstim(mystimp),i);
		for j=2:length(mycontrast),
			mystimp = getparameters(get(lwscript,i));
			mystimp.contrast = mycontrast(j);
			mystimp.stimnumber = 1+numStims(lwscript);
			mystimp.length = diff(mystimp.rect([1 3]));
			mystimp.width= diff(mystimp.rect([2 4]));
			lwscript = append(lwscript,periodicstim(mystimp));
		end;
	end;
        mngray = (p.chromhigh+p.chromlow)/2;
        if blank, lwscript = addblankstim(lwscript,mngray); end;
        lwscript = setDisplayMethod(lwscript,randomize,reps);
        test=RunScriptRemote(ds,lwscript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['lengthwidthcontrastsheet' typeName],'-mat'); g=getfield(g,['lengthwidthcontrastsheet' typeName]);
        lengthwidthcontrastsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['lengthwidthcontrastsheet' typeName '={testName,lengthsstr,widthsstr,contraststr,gratCtrl,GoodCB,refsh};']);
        eval(['save ' fname ' lengthwidthcontrastsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        refsh='ref',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','lengthwidthcontrastsheetlet','data',testName,'desc',[typeName ' test']);
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
                [dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, 'stimnumber', 1);
		myfig = gcf;
		myud = get(myfig,'userdata');
		mypc = myud{1};
		convert_periodiccurve_2d(mypc,'length','contrast');
                assoc = struct('type',[typeName ' test'],'owner','lengthwidthcontrastsheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','lengthwidthcontrastsheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);        
end;
