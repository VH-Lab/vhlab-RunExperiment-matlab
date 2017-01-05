function runexperck(action, fig)
h=[];
if nargin==1, fig = gcbf; end;
h = get(fig,'UserData');
switch action
	case 'datapath',
		dp = get(h.datapath,'String'); % in local computer format
		if exist(dp)~=7, % if datapath directory does not exist, make it
			try,
			   [p,f,e]=fileparts(dp);
                           mkdir(p,[f e]);
			end;
		end;
		try, 
			h.ds=dirstruct(dp);
			set(fig,'userdata',h);
		catch,
			errordlg('Datapath not valid');
			p = getpathname(h.ds);
			if p(end)==filesep,
				p = p(1:end-1);
			end;
			set(h.datapath,'String',p);
		end;
	case 'choosedatapath',
		dirname = uigetdir;
		set(h.datapath,'String',dirname);
		runexpercallbk('datapath',fig);
	case 'runscript',
		remPath = get(h.remotepath,'String');
		runScrp = get(h.runscript,'String');
		if ~isempty(runScrp),
			copyfile([remPath filesep runScrp], ...
				[remPath filesep 'runit.m']);
			eval(['! chmod 770 ' remPath filesep 'runit.m']); 
		end;
	case 'EnDis',
		strs = lb_getselected(h.rslb);
		if length(strs)==1,
			g=char(strs);
			if g(end)=='*',
				set(h.rssb,'enable','on');
			else,
				set(h.rssb,'enable','off');
			end;
		else,
			set(h.rssb,'enable','off');
		end;
	case 'showstim',   % show a stimscript
		saveWaves = get(h.savestims,'value');  % are we acquiring here or just displaying?
		if saveWaves,  % make a new test directory if necessary
			runexpercallbk('datapath',fig);
			ntd = newtestdir(h.ds);
			if ~isempty(ntd), set(h.savedir,'String',ntd); end;
		end;
		datapath = get(h.datapath,'String');
		if ~exist(datapath),  % make a new data directory if necessary
			[dPath,dFile]=fileparts(datapath);
			mkdir(dPath,dFile);
			if isunix_sv, eval(['! chmod 770 ' datapath ';']); end;
		end;
		datapath=[get(h.datapath,'String') filesep get(h.savedir,'String')];
		scriptName = char(lb_getselected(h.rslb));
		if scriptName(end)~='*',
			errordlg('Script not loaded','Error');
			error('no loaded script');
		end;
		scriptName = scriptName(1:end-1);
		if isempty(scriptName), error('No script.'); end;
		remPath = get(h.remotepath,'String');
		if saveWaves&exist(datapath),  % if the directory already exists there is an error
			errordlg('Directory already exists.');
			error('Directory already exists');
		elseif saveWaves,  % otherwise, if we are saving, write the acquisition commands
			[dPath,dFile]=fileparts(datapath);
			mkdir(dPath,dFile);
			if isunix_sv,eval(['! chmod 770 ' datapath ';']); end;
			global initacqreadyNLT;
			write_pathfile(initacqreadyNLT,localpath2remote(linpath2mac(datapath)));
			aqDat=get(h.list_aq,'UserData');
			writeAcqStruct([remPath filesep 'acqParams_in'],aqDat);
			if isunix_sv, eval(['! chmod 770 ' remPath filesep 'acqParams_in;']); end;
		end;
		bbb=evalin('base',['exist(''' scriptName ''')']);
		if bbb, % if script also exists locally, show the duration time in RunExperiment window
			[ty,tm,td,th,tm,ts]=datevec(now);
			durr=evalin('base',['duration(' scriptName ')']);
			durrh=fix(durr/3600); durr=durr-3600*durrh;
			durrm=fix(durr/60);durr=durr-60*durrm; durrs=fix(durr);
			set(h.ctdwn,'String',['Script duration: ' sprintf('%.2d',durrh) ':' ...
			sprintf('%.2d',durrm) ':' sprintf('%.2d',durrs) '; Started at '  datestr(now,13) '.']);
		end;
		% get any extra command strings that are necessary
		cmdstrs = {};
		if get(findobj(fig,'Tag','extdevcb'),'value'),  % use cb's
			listofcmds = get(findobj(fig,'Tag','extdevlist'),'string');
			highlightedcmds = get(findobj(fig,'Tag','extdevlist'),'value');
			for i=1:length(highlightedcmds); % only run selected commands
				try, 
					cmdstr = listofcmds{highlightedcmds(i)};
					endp = find(cmdstr==')');
					if isempty(endp),  % no (), so just add it
						cmdstr = [cmdstr '(datapath,scriptName,saveWaves,remPath)'];
					elseif cmdstr(endp-1)=='(', % we have (), remove and add
						cmdstr=[cmdstr(1:end-2) '(datapath,scriptName,saveWaves,remPath)'];
					else, % we have (a,b,...,c), add the extra arguments
						cmdstr = [cmdstr(1:endp-1) ',datapath,scriptName,saveWaves,remPath)'];
					end;
					newcmd = eval(cmdstr);
				catch, 
					errordlg(['Error running extra device/command ' listofcmds{i} ': ' lasterr]);
					error(['Error running extra device/command ' listofcmds{i} ': ' lasterr]);
				end;
				if ~isempty(newcmd),
					if size(newcmd,2)>size(newcmd,1),newcmd = newcmd'; end;
					cmdstrs = cat(1,cmdstrs,newcmd);
				end;
			end;
		end;
		write_runscript_remote(datapath,scriptName, saveWaves,[remPath filesep 'runit.m'],cmdstrs);
		if isunix_sv,eval(['! chmod 770 ' remPath filesep 'runit.m']); end;
	case 'aq_menu',
		v = get(findobj(fig,'Tag','AcqListMenu'),'value');
		callbacklist = {'','','add_aq','increment_aq','decrement_aq','edit_aq','delete_aq','','open_aq','save_aq','',...
			'add_default_aq','add_default_aq','add_default_aq','add_default_aq','','add_default_aq'};
		if ~isempty(callbacklist{v}),
			runexpercallbk(callbacklist{v},fig);
		end;
		set(findobj(fig,'Tag','AcqListMenu'),'value',1);
	case 'increment_aq',
                aqdata = get(h.list_aq,'UserData');
                strData = get(h.list_aq,'String');
		for i=1:length(aqdata),
			aqdata(i).ref = aqdata(i).ref + 1;
			strData{i} = record2str(aqdata(i));
		end;
                set(h.list_aq,'UserData',aqdata,'String',strData);
	case 'decrement_aq',
                aqdata = get(h.list_aq,'UserData');
                strData = get(h.list_aq,'String');
		for i=1:length(aqdata),
			aqdata(i).ref = max(aqdata(i).ref - 1,1);
			strData{i} = record2str(aqdata(i));
		end;
                set(h.list_aq,'UserData',aqdata,'String',strData);
	case 'add_default_aq',
		v = get(findobj(fig,'Tag','AcqListMenu'),'value');
		v = v - 11;
		filelist = {'acqIn_singlechannel.txt','acqIn_8channel.txt','acqIn_16channel.txt','acqIn_32channel.txt','','acqIn_prairietwophoton.txt'};
		vhlv_channelgroupingfilelist = {'vhlv_channelgrouping_1channel.txt',...
			'vhlv_channelgrouping_8channel.txt',...
			'vhlv_channelgrouping_16channel.txt',...
			'vhlv_channelgrouping_32channel.txt',...
			'vhlv_channelgrouping_1channel.txt',...
			'vhlv_channelgrouping_1channel.txt',...
		};
		vhlv_filtermapfilelist = {'vhlv_filtermap_1channel.txt',...
			'vhlv_filtermap_8channel.txt',...
			'vhlv_filtermap_16channel.txt',...
			'vhlv_filtermap_32channel.txt',...
			'vhlv_filtermap_1channel.txt',...
			'vhlv_filtermap_1channel.txt',...
		};
		if isempty(filelist{v}), return; end;
		newAqDat = loadStructArray(filelist{v});
		StrDat = {};
		for i=1:length(newAqDat),
			StrDat{i} = record2str(newAqDat(i));
		end;
		set(h.list_aq,'UserData',newAqDat,'String',StrDat, 'value',1);
		newchgrp = loadStructArray(vhlv_channelgroupingfilelist{v});
		set(findobj(fig,'tag','vhlv_channelgroupingList'),'UserData',newchgrp,'String',struct2str(newchgrp),'value',1);
		newfiltmap = loadStructArray(vhlv_filtermapfilelist{v});
		set(findobj(fig,'tag','vhlv_filtermapList'),'UserData',newfiltmap,'String',struct2str(newfiltmap),'value',1);
	case 'add_init_aq',
		inDat = struct('name','extra','ref',1,'type','singleEC');
		str = {record2str(inDat)};
		set(h.list_aq,'UserData',inDat,'string',str,'value',1);
	case 'add_aq',
		aqdata = get(h.list_aq,'UserData');
		strDat = get(h.list_aq,'String');
		if isempty(aqdata), clear aqdata; end;
		l = length(strDat);
		[strDat{l+1},aqdata(l+1)]=input_aq([],[]);
		if ~isempty(strDat{l+1}),
			set(h.list_aq,'UserData',aqdata, ...
			'String',strDat,'value',l+1);
		end;
	case 'edit_aq',
		aqdata = get(h.list_aq,'UserData');
		strDat = get(h.list_aq,'String');
		val = get(h.list_aq,'value');
		if val>0,
		    [strDat{val},aqdata(val)]=input_aq(strDat{val},aqdata(val));
		end;
		set(h.list_aq,'UserData',aqdata,'String',strDat);
	case 'delete_aq',
		aqdata = get(h.list_aq,'UserData');
		strDat = get(h.list_aq,'String');
		l = length(strDat);
		val = get(h.list_aq,'value');
		if val>0,
			newStrDat={};
			if l~=1,
				[newStrDat{1:length(strDat)-1}]= ...
				deal(strDat{[1:val-1 val+1:l]});
				newAqDat=aqdata([1:val-1 val+1:l]);
				if val~=1, val = val-1; else, val=1; end;
			else, val = 0;
			end;
			set(h.list_aq,'UserData',newAqDat, ...
				'String',newStrDat,'value',val);
		end;
	case 'open_aq',
		[fname, pname] = uigetfile('*','Open file ...');
		if fname(1)~=0,  % if user doesn't cancel
			newAqDat = loadStructArray([pname fname]);
			StrDat = {};
			for i=1:length(newAqDat),
				StrDat{i} = record2str(newAqDat(i));
			end;
			set(h.list_aq,'UserData',newAqDat,'String',StrDat, ...
				'value',1);
		end;
	case 'save_aq',
		[fname, pname] = uiputfile('*', 'Save As ...');
		if fname(1)~=0,
			aqDat=get(h.list_aq,'UserData');
			writeAcqStruct([pname fname],aqDat);
		end;
	case 'extdevaddbt', % add a command
		str = get(findobj(fig,'Tag','extdevlist'),'string');
		prompt={'Enter the new command'};
		def = {''};
		answer = inputdlg(prompt,'Extra stimulus command',1,def);
		if ~isempty(answer),
			str(end+1) = answer;
			set(findobj(fig,'Tag','extdevlist'),'string',str);
			set(findobj(fig,'Tag','extdevlist'),'max',2);
		end;
	case 'extdevdelbt', % del a command
		str = get(findobj(fig,'Tag','extdevlist'),'string');
		v = get(findobj(fig,'Tag','extdevlist'),'value');
		if ~isempty(v),
			str=str(setxor(1:length(str),v));
			v = 1:length(str);
			set(findobj(fig,'Tag','extdevlist'),'string',str,'value',v);
		end;
	case 'extdevaboutbt',
		str =   {'Extra devices/commands help'
				 ''
				 'This features allows one to add extra commands to the script that displays'
				 'stimscripts.  This can be useful for communicating with other external'
				 'devices that need to be coordinated with the visual stimulus.'
				 ''
				 'To add an extra command, type in a function to be evaluated.  The prototype of'
				 'the function should be as follows:'
				 ''
				 '  MYCELLSTRINGLIST = MYCMDFUNC(MYARG1,MYARG2,...,DATAPATH,SCRIPTNAME,...'
				 '                               SAVING,REMOTEPATH)'
				 'where MYARG* are your arguments to the function, DATAPATH is the path'
				 'of the directory where visual stimulus data will be saved,SCRIPTNAME'
				 'is the name of the stimscript to be run,SAVING is 0/1, 1 if stimulus'
				 'data will actually be saved (as opposed to just displaying), and '
				 'REMOTEPATH is the directory where the script will eventually be written.'
				 'MYCELLSTRINGLIST is a cell list of strings containing the script commands'
				 'to be run. It will be run a few seconds before visual stimulation.'
				 ''
				 'To add a command, type in the function to be evaluated.  The last four'
				 'arguments will be added for you.  So, you might type:'
				 'mycmdfunc(myarg1,myarg2)   or'
				 'mycmdfunc() or mycmdfunc if your function has no extra arguments.'
				 ''
				 'Only commands which are highlighted will be run, and the commands will only'
				 'be used in general if Enable EC/Ds is checked.'};
		textbox('Help for extra devices/commands',str);
end;

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create window that prompts user for recording parameters
function [str,dat] = input_aq (oldstr,inDat);

if isempty(inDat),
	% specify default parameter values
	inDat = struct('name','extra','ref',1,'type','singleEC');
end;

% specify prompts for user
prompt={'Name of record:', 'Reference number of record:', 'Type of recording:'};
def={inDat.name,int2str(inDat.ref),inDat.type};
dialTitle = 'Record parameters...';

% acquire user-entered recording parameters from promted window
answer = inputdlg(prompt,dialTitle,1,def);
if ~isempty(answer),
	fldn = fieldnames(inDat);
	str = '';
	for i=1:length(fldn),
		if isnumeric(getfield(inDat,fldn{i})),
			inDat = setfield(inDat,fldn{i},str2num(answer{i}));
		else,
			inDat = setfield(inDat,fldn{i},answer{i});
		end;
		str = [ str ' : ' answer{i}];
	end;
	str = str(4:end);
else, str = oldstr;
end;
dat = inDat;

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function str = record2str(inDat);
if ~isempty(inDat),
	str=[inDat.name ' : ' int2str(inDat.ref) ' : ' inDat.type ];
else,
	str = '';
end;

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function writeAcqStruct(fname, inDat)
[fid,msg] = fopen(fname,'wt');
if fid==-1,
	disp(msg);
	return;
end;

fn = fieldnames(inDat(1));
s = '';
for i=1:length(fn),
	s = [ s char(9) fn{i}];
end;
s = s(2:end);
fprintf(fid,'%s\n',s);

for i=1:length(inDat),
	t = char(9);
	s=[inDat(i).name t int2str(inDat(i).ref) t inDat(i).type];
	fprintf(fid,'%s\n',s);
end;
fclose(fid);

