function [varargout]=phasesequenceplayersheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: testName,gratCtrl,GoodCB,refCtrl,PhaseSeqEdit,PhaseSeqBlanksEdit

 % the known phase sequences

command = command(length(typeName)+1:end);

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,gratCtrl,GoodCB,refCtrl,phaseSeqText,phaseSeqBlanksText]=phasesequenceplayersheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
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
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'PhaseSeqBlanksEdit']),'string',varargin{6}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'PhaseSeqEdit']),'string'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'PhaseSeqBlanksEdit']),'string'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p=getparameters(ps);
	p.dispprefs = {'BGposttime', isi};
        ps = periodicstim(p);
        mystimdur = duration(ps);
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'ps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        p=getparameters(ps);
	reps = 1;
	phaseSeqBlanks = eval([phaseSeqBlanksText]);

	C_seq = getfield(load('C_sequences.mat','-mat'),'C_sequences');
	C_seq_steps = 8*ones(1,size(C_seq,1));

	N = str2nume(phaseSeqText);

	r = randi(size(C_seq,1),[1 N]);

    dscript = stimscript(0);
	for i=1:length(r),
		p.phaseSequence = C_seq(r(i),:);
		p.phaseSteps = C_seq_steps(r(i));
		dscript = append(dscript,periodicstim(p));
	end;
        mngray = (p.chromhigh+p.chromlow)/2;
        if blank, dscript = addblankstim(dscript,mngray); end;
	displayorder = [1:length(r) repmat(length(r)+1,1,phaseSeqBlanks)];
	if randomize,
		displayorder = displayorder(randperm(length(displayorder)));
	end;
        dscript=setDisplayMethod(dscript, 2, displayorder);
        test=RunScriptRemote(ds,dscript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test); 
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['phasesequenceplayersheetlet' typeName],'-mat');
        if isfield(g,['phasesequenceplayersheetlet' typeName]),
            g=getfield(g,['phasesequenceplayersheetlet' typeName]);
            phasesequenceplayersheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
        end;
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['phasesequenceplayersheetlet' typeName '={testName,gratCtrl,GoodCB,refCtrl,phaseSeqText,phaseSeqBlanksText};']);
        eval(['save ' fname ' phasesequenceplayersheetlet' typeName ' -append -mat']);
    case 'AnalyzeBt',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, 'stimnum', 1,'stimnum');
                %lineweightsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','',pref);
                assoc = struct('type',[typeName ' test'],'owner','phasesequenceplayersheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','phasesequenceplayersheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db); 
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
            if nargout>0, varargout{1} = []; end;
        else,
            assoc = struct('type',[typeName ' test'],'owner','phasesequenceplayersheetlet','data',testName,'desc',[typeName ' test']);            
        end;
        if nargout>0, varargout{1} = assoc; end;        
end;
