function [varargout]=referencesheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: nameref, selectedcellnames, fnameextra
 %   
 % 

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [nameref,selectedcellnames,fnameextra]=referencesheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}),
                set(findobj(fig,'tag',[typeName 'namereftxt']),'userdata',varargin{1});
                set(findobj(fig,'tag',[typeName 'namereftxt']),'string',[varargin{1}.name ' | ' num2str(varargin{1}.ref) ]);
        end;
        if length(varargin)>1,
            selectedcells = varargin{2};
            vals = [];
            for i=1:length(selectedcells),
                str = get(findobj(fig,'tag',[typeName 'cellList']),'string');
                for j=1:length(str),
                    if strcmp(trimsymbol(str{j},'*'),selectedcells{i}),vals(end+1)=j;end;
                end;
            end;
            set(findobj(fig,'tag',[typeName 'cellList']),'value',vals);
        end;
        if length(varargin)>2, set(findobj(fig,'tag',[typeName 'filenameEdit']),'string',varargin{3}); end;
    case 'GetVars',
	if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'namereftxt']),'userdata'); end;
	if nargout>1, 
		vals = get(findobj(fig,'tag',[typeName 'cellList']),'value');
		str = get(findobj(fig,'tag',[typeName 'cellList']),'string');
		if ~isempty(str),
			varargout{2} = trimsymbol(str(vals),'*');
		else,
			varargout{2} = {};
		end;
	end;
	if nargout>2,
		varargout{3}=get(findobj(fig,'tag',[typeName 'filenameEdit']),'string');
	end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname),
		error(['Empty filename for ' typeName 'RestoreVarsBt']);
	end;
        g = load(fname,['referencesheet' typeName],'-mat');
	g=getfield(g,['referencesheet' typeName]);
        referencesheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata'),
        fnameextra,
        if isempty(fname),
		error(['Empty filename for ' typeName 'SaveVarsBt']);
	end;
        eval(['referencesheet' typeName '={nameref,selectedcellnames,fnameextra};']);
        eval(['save ' fname ' referencesheet' typeName ' -append -mat']);
    case 'ChooseNameRef',
        answ = questdlg('Use an existing record or one that is to be acquired?',...
                  'Existing or acquired',...
                  'Existing record','To be acquired','Cancel','To be acquired');
        if strcmp(answ,'Existing record'),
            nrs = getallnamerefs(ds);
            if length(nrs)==0,
                close(fig);
                error('No existing records.');
            end;
            str = {};
            for i=1:length(nrs),
               str = cat(2,str,{[ nrs(i).name ' | ' int2str(nrs(i).ref)]});
            end;
            [s,v] = listdlg('PromptString','Select a name | ref',...
                         'SelectionMode','single','ListString',str);
            if v==0, error('No record selected.');
            else, nameref = nrs(s);
            end;
        elseif strcmp(answ,'To be acquired'), % new record
            udre = get(geteditor('RunExperiment'),'userdata');
            udre2 = get(udre.list_aq,'userdata');
            if isempty(udre2),
                errordlg('Needs an aquisition record to run tests.'); return;
            else,
            str = {};
            for i=1:length(udre2),
                str = cat(2,str,{[ udre2(i).name ' | ' int2str(udre2(i).ref)]});
            end;
            [s,v] = listdlg('PromptString','Select a name | ref',...
                         'SelectionMode','single','ListString',str);
            if v==0,
		return;
            else,
		nameref = struct('name',udre2(s).name,'ref',udre2(s).ref); end;
            end;
        else,
		close(fig);
        end;
        referencesheetlet_process(fig, typeName, ds, [typeName 'SetVars'],nameref);
        referencesheetlet_process(fig, typeName, ds, [typeName 'UpdateBt']);
    case 'SaveBt',
        filename = [fixpath(getscratchdirectory(ds,1)) typeName '_' nameref.name '_' int2str(nameref.ref) '_' fnameextra '.mat'];
        save(filename,'fig','-mat');
        bts = findobj(fig,'style','push');
        btnstr = 'SaveVars';
        for i=1:length(bts),
            if findstr(get(bts(i),'tag'),btnstr),
                set(bts(i),'userdata',filename);
                str=get(bts(i),'callback');
                quotes = findstr(str,'''');
                funcname = str(quotes(1)+1:quotes(2)-1);
                typename = str(quotes(3):quotes(4));
                eval([funcname '(fig,' typename ', ds, ' typename(1:end-1) 'SaveVarsBt'');']);
            end;
        end;        
    case 'RestoreBt',
        filename = [fixpath(getscratchdirectory(ds,1)) typeName '_' nameref.name '_' int2str(nameref.ref) '_' fnameextra '.mat'];
        bts = findobj(fig,'style','push');
        btnstr = 'RestoreVars';
        for i=1:length(bts),
            if findstr(get(bts(i),'tag'),btnstr),
                set(bts(i),'userdata',filename);
                str=get(bts(i),'callback');
                quotes = findstr(str,'''');
                funcname = str(quotes(1)+1:quotes(2)-1);
                typename = str(quotes(3):quotes(4));
                eval([funcname '(fig,' typename ', ds, ' typename(1:end-1) 'RestoreVarsBt'');']);
            end;
        end;
    case 'UpdateBt',
	ds = dirstruct(getpathname(ds));
	ud = get(fig,'userdata');
	ud.ds = ds;
	set(fig,'userdata',ud);
	ds = ud.ds;
	% import cells from the various devices we know
	importspikedata(ds,nameref);
	% update the list
	referencesheetlet_process(fig,typeName,ds,[typeName 'UpdateList']);
    case 'UpdateList',
	cellname = nameref2cellname(ds,nameref.name,nameref.ref,999);
	myloc = findstr(cellname,'999');
	cellname = [cellname(1:myloc-1) '*' cellname(myloc+4:end)];
	try, 
		[cells,cellnames] = load2celllist(getexperimentfile(ds),cellname,'-mat');
		for i=1:length(cells),
			A=findassociate(cells{i},'valid','','');
			if ~isempty(A),
				if A.data,  % if it is non-zero
					cellnames{i} = ['*' cellnames{i}];
				end;
			end;
		end;
	catch,
		cells = {};
		cellnames = {};
	end;
	val = 2;
	if length(cellnames)==0,
		val = [];
	elseif length(cellnames)==1,
		val = 1;
	end;
	set(findobj(fig,'tag',[typeName 'cellList']),'string',cellnames,'value',val);
    case 'GetCells',
	ds = update(ds);
	ud = get(fig,'userdata');
	ud.ds = ds;
	set(fig,'userdata',ud);
	importspikedata(ds,nameref);
        str = get(findobj(fig,'tag',[typeName 'cellList']),'string');
        val = get(findobj(fig,'tag',[typeName 'cellList']), 'value');
        cells = {}; cellnames = {};
        for j=1:length(val),
            [cells(j),cellnames(j)] = load2celllist(getexperimentfile(ds),trimsymbol(str{val(j)},'*'),'-mat');
        end;
        if nargout>0, varargout{1} = cells; end;
        if nargout>1, varargout{2} = cellnames; end;
    case 'AddDBBt',
	varargout{1} = struct('type','valid','owner','RunExperiment','data',1,'desc','Is this a valid record for analysis? (0/1)');
    case 'DBBt',
        [mycell,mycellname] = referencesheetlet_process(fig,typeName,ds,[typeName 'GetCells']);
        bts = findobj(fig,'style','push');
        btnstr = 'AddDBBt';
        for i=1:length(bts),
		if findstr(get(bts(i),'tag'),btnstr),
			str=get(bts(i),'callback');
			quotes = findstr(str,'''');
			funcname = str(quotes(1)+1:quotes(2)-1);
			typename = str(quotes(3):quotes(4));
			eval(['assoc=' funcname '(fig,' typename ', ds, ' typename(1:end-1) 'AddDBBt'');']);
			if ~isempty(assoc),
				if iscell(assoc),
					for j=1:length(mycell),
						for k=1:length(assoc{j}),
							mycell{j}=associate(mycell{j},assoc{j}(k));
						end;
					end;
				elseif isstruct(assoc), % then assocs are not different for different cells
					for j=1:length(mycell),
						for k=1:length(assoc),
							mycell{j}=associate(mycell{j},assoc(k));
						end;
					end;
				end;
			end;
		end;
        end;
	if ~isempty(mycell),
		saveexpvar(ds,mycell,mycellname);
	end;
	referencesheetlet_process(fig,typeName,ds,[typeName 'UpdateList']);
end;

