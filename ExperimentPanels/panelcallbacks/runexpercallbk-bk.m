function runexperck(action)

h = get(gcbf,'UserData');

switch action
	case 'runscript',
		remPath = get(h.remotepath,'String');
		runScrp = get(h.runscript,'String');
		if ~isempty(runScrp),
			copyfile([remPath filesep runScrp], ...
				[remPath filesep 'runit.m']);
			eval(['! chmod 770 'remPath filesep 'runit.m']); 
		end;
	case 'showstim',
		datapath = get(h.datapath,'String');
		dp_lin = datapath; ind = find(datapath==':'); dp_lin(ind)='/';
		dp_lin = ['/home/' dp_lin];
		%dp_lin,
		if ~exist(dp_lin),
			eval(['! mkdir ' dp_lin ';']);
			eval(['! chmod 770 ' dp_lin ';']);
		end;
		
		datapath=[get(h.datapath,'String') ':' get(h.savedir,'String')];
		%datapath,
		dp_lin = datapath; ind = find(datapath==':'); dp_lin(ind)='/';
		dp_lin = ['/home/' dp_lin];
		%dp_lin,
		scriptName = get(h.showstim,'String');
		if isempty(scriptName), error('No script.'); end;
		saveWaves = get(h.savestims,'value');
		remPath = get(h.remotepath,'String');
		if saveWaves&exist(dp_lin),
			error('Directory already exists');
		elseif saveWaves,
			eval(['! mkdir ' dp_lin ';']);
			eval(['! chmod 770 ' dp_lin ';']);
		      %eval(['!cp 'remPath filesep 'acqParams_in ' dp_lin ';']);
		       write_pathfile('/home/dataman/data/acqReady',...
				datapath);
			aqDat=get(h.list_aq,'UserData');
			writeAcqStruct([remPath filesep 'acqParams_in'],aqDat);
			eval(['! chmod 770 ' remPath filesep 'acqParams_in;']);
		end;
		%disp('got here');
		write_gerbilrun(datapath,scriptName, saveWaves, ...
			[remPath filesep 'runit.m']);
		eval(['! chmod 770 'remPath filesep 'runit.m']); 
	case 'add_aq',
		aqdata = get(h.list_aq,'UserData');
		strDat = get(h.list_aq,'String');
		iscell(strDat),
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
end;

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str,dat] = input_aq (oldstr,inDat);
if isempty(inDat),
	inDat = struct('name','','type','','fname','','samp_dt', ...
	3.1807627469e-05,'reps',1,'ref',1,'ECGain',5000);
end;
prompt={'Name of record:', 'Type of recording:', 'file name', ...
	'sample interval', 'Number of reps (recalculated)', ...
	'reference', 'ECGain'};
def={inDat.name,inDat.type,inDat.fname,num2str(inDat.samp_dt,15),...
	int2str(inDat.reps),int2str(inDat.ref),int2str(inDat.ECGain)};
dialTitle = 'Record parameters...';
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
	str=[inDat.name ' : ' inDat.type ' : ' inDat.fname ' : ' ...
		num2str(inDat.samp_dt,15) ' : ' int2str(inDat.reps) ' : ' ...
		int2str(inDat.ref) ' : ' int2str(inDat.ECGain)];
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
	s=[inDat(i).name t inDat(i).type t inDat(i).fname t ...
		num2str(inDat(i).samp_dt,15) t int2str(inDat(i).reps) t ...
		int2str(inDat(i).ref) t int2str(inDat(i).ECGain)];
	fprintf(fid,'%s\n',s);
end;
fclose(fid);
