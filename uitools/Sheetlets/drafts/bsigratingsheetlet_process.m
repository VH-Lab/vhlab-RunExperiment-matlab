function [varargout]=bsigratingsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: revstim1, test1, revstim2, test2, ctrloc,
 % onoffvalue, cb1, cb2, ctrcb


command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,tuneEdit,parameter,preference,gratCtrl,GoodCB,prefCB,refCtrl,bsiCtl]=bsigratingsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
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
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'prefEdit']),'string',num2str(varargin{4})); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'prefEdit']),'userdata',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'prefCB']),'value',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{8}); end;
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{9}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata'); end;
        if nargout>3, varargout{4}=str2nume(get(findobj(fig,'tag',[typeName 'prefEdit']),'string')); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'prefEdit']),'userdata'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'prefCB']),'value'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank,blankisblack]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p=getparameters(ps);
        p_master = p;

        %if strcmp(typeName,'CoarseDir'), p.imageType = 1;  end;
        mystimdur = duration(periodicstim(p));
        try
            eval(['p.' parameter '=' tuneEdit ';']);
        catch
            errordlg(['Syntax Error in ' typeName ': ' tuneEdit '.'], 'My Error Dialog');
        end
        p.dispprefs = {'BGposttime',isi};
        myps=periodicscript(p);
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'myps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
%         for i=2:numStims(myps),  % this was just for testing
%             p = getparameters(get(myps,i));
%             p.chromhigh = [ 1 1 1]; 
%             p.chromlow = [ 0 0 0];
%             myps = set(myps,periodicstim(p),i);
%         end;
        if strcmp(parameter,'tFrequency'),
            for i=1:numStims(myps),
                p = getparameters(get(myps,i));
                p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
                myps=set(myps,periodicstim(p),i);
            end;
        elseif strcmp(parameter,'sPhaseShift'), % default is counterphase
            for i=1:numStims(myps);
                p = getparameters(get(myps,i));
                p.flickerType = 2;
                p.animType = 2;
                myps=set(myps,periodicstim(p),i);
            end;
        end;        
        mngray = (p.chromhigh+p.chromlow)/2;
        stimvalues = eval(tuneEdit);
        mngray = (p_master.chromhigh+p_master.chromlow)/2;
    	if blankisblack,
    		blankcolor= [0 0 0];
    	else,
    		blankcolor = mngray;
        end;    
        if blank,
            myps = addblankstim(myps,blankcolor);
            stimvalues(end+1) = NaN;
        end;
        myps=setDisplayMethod(myps, randomize, reps);
        test=RunScriptRemote(ds,myps,saveit,0,1, stimvalues);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['bsigratingsheet' typeName],'-mat');g=getfield(g,['gratingsheet' typeName]);
        bsigratingsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['bsigratingsheet' typeName '={testName,tuneEdit,parameter,preference,gratCtrl,GoodCB,prefCB,refCtrl,bsiCtl};']);
        eval(['save ' fname ' bsigratingsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','gratingsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [subF,divF,SigF,Mult,DiffImg,MeanFilt,MedianFilt,LVIntrinsicON]=brainsurfaceanalysissheetlet_process(fig, bsiCtl, ds, [bsiCtl 'GetVars']),
        analyzeintrinsicstims([getpathname(ds) filesep testName],eval(subF),eval(SigF));
        createsingleconditions([getpathname(ds) filesep testName],eval(Mult),eval(MeanFilt),eval(MedianFilt),eval(subF),eval(SigF));
        plotorientationmap([getpathname(ds) filesep testName],DiffImg,1,1);
    case 'prefCB',
        [ps]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p = getparameters(ps);
        mystimdur = duration(periodicstim(p));
        p = setfield(p,parameter,preference);
        if strcmp(parameter,'tFrequency'),
            p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
        end;
        ps = periodicscript(p);
        gratingcontrolsheetlet_process(fig,gratCtrl,ds,[gratCtrl 'SetVars'],ps);
end;
