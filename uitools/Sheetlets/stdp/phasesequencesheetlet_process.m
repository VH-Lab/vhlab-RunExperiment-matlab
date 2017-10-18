function [varargout]=phasesequencesheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: testName,gratCtrl,GoodCB,refCtrl

 % the known phase sequences
A{1} = [ 1     2     3     4     5     6     7     8];
A{2} = [8     7     6     5     4     3     2     1];
A{3} = [8     4     7     3     6     2     5     1];
A{4} = [5     1     4     8     3     7     2     6];
A{5} = [1     4     8     2     7     5     3     6];
A{6} = [7     2     6     1     5     3     8     4];
A{7} = [3     7     4     1     5     8     2     6];
A{8} = [4     6     2     5     8     3     1     7];

B = [ 8 8 8 8 8 8 8 8];

B_seq = getfield(load('B_sequences.mat','-mat'),'B_sequences');
B_seq_steps = 8*ones(1,size(B_seq,1));

S_seq = getfield(load('S_sequences.mat','-mat'),'S_sequences');
S_seq_steps = 8*ones(1,size(S_seq,1));

command = command(length(typeName)+1:end);

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,gratCtrl,GoodCB,refCtrl,phaseSeqText]=phasesequencesheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'PhaseSeqEdit']),'string',varargin{5}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'PhaseSeqEdit']),'string'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p=getparameters(ps);
	p.dispprefs = {'BGposttime', isi};
        ps = periodicstim(p);
        mystimdur = duration(ps);
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'ps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        p=getparameters(ps);

	phaseSeqText = strtrim(phaseSeqText);
	if (phaseSeqText(1)=='[') & (phaseSeqText(end)==']'),
		phaseSeqText = strtrim(phaseSeqText(2:end-1));
	end;

	spaces = [0 1+find( (phaseSeqText(1:end-1)~=double(' ')) & (phaseSeqText(2:end)==double(' '))) length(phaseSeqText)+1];

	dscript = stimscript(0);
	for i=1:length(spaces)-1,
		mycode = strtrim(phaseSeqText(spaces(i)+1:spaces(i+1)-1));
		mynum = str2nume(mycode(2:end));
		if mycode(1)=='A', % isa
			p.phaseSequence = A{mynum};
			p.phaseSteps = B(mynum);
		elseif mycode(1)=='B',
			p.phaseSequence = B_seq(mynum,:);
			p.phaseSteps = B_seq_steps(mynum);
		elseif mycode(1)=='S',
			p.phaseSequence = S_seq(mynum,:);
			p.phaseSteps = S_seq_steps(mynum);		end;
		dscript = append(dscript,periodicstim(p));
	end;
        mngray = (p.chromhigh+p.chromlow)/2;
        if blank, dscript = addblankstim(dscript,mngray); end;
        dscript=setDisplayMethod(dscript, randomize, reps);
        test=RunScriptRemote(ds,dscript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test); 
    case 'PhaseSeqChooseBt',
	options = {};
	for i=1:length(A),
		options{end+1} = ['A' int2str(i)];
	end;
	for i=1:size(B_seq,1),
		options{end+1} = ['B' int2str(i)];
	end;
	for i=1:size(S_seq,1),
		options{end+1} = ['S' int2str(i)];
	end;
    [selection,ok] = listdlg('PromptString','Select sequences','SelectionMode','multiple','ListSize',[160 300],...
		'InitialValue',1:numel(options),'ListString',options);
	if ok & numel(selection)>1,
		superstring = '[';
		for i=1:length(selection),
			superstring = cat(2,superstring,options{selection(i)},' ');
		end;
		superstring(end) = ']'; % replace the last string with a space
		phasesequencesheetlet_process(fig,typeName,ds,[typeName 'SetVars'],'','','','',superstring);
	end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['phasesequencesheetlet' typeName],'-mat');
        if isfield(g,['phasesequencesheetlet' typeName]),
            g=getfield(g,['phasesequencesheetlet' typeName]);
            phasesequencesheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
        end;
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['phasesequencesheetlet' typeName '={testName,gratCtrl,GoodCB,refCtrl,phaseSeqText};']);
        eval(['save ' fname ' phasesequencesheetlet' typeName ' -append -mat']);
    case 'AnalyzeBt',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, 'stimnum', 1,'stimnum');
                %lineweightsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','',pref);
                assoc = struct('type',[typeName ' test'],'owner','phasesequencesheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','phasesequencesheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db); 
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
            if nargout>0, varargout{1} = []; end;
        else,
            assoc = struct('type',[typeName ' test'],'owner','phasesequencesheetlet','data',testName,'desc',[typeName ' test']);            
        end;
        if nargout>0, varargout{1} = assoc; end;        
end;
