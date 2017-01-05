function newcell = checkmdrecord(md, cksds, nameref, assocname, assocowner, whatshouldvary)

% CHECKMDRECORD - Checks MD record for associate or stimulus record
%
%  NEWCELL = CHECKMDRECORD(THEMD, DS, NAMEREF, ASSOCNAME,
%        ASSOCOWNER, WHATSHOULDVARY)
%
%  Checks the with the CKSDIRSTRUCT CKSDS to see if it has
%  an associate named ASSOCNAME with owner ASSOCOWNER.  If it does not,
%  it looks into the CKSDIRSTRUCT to see if it can find a test directory
%  with a stimscript where parameter WHATSHOULDVARY is the only
%  parameter varied.  It then asks the user if the cell should be updated.
% 

newcell = cell;

theassoc = findassociate(newcell,assocname,assocowner,[]);

if isempty(theassoc),
	possibletests = {};

	testlist = gettests(cksds,nameref.name,nameref.ref);
	for t=1:length(testlist),
		go = 1;
		try,
			stims = load([fixpath(md) filesep testlist{t} filesep 'stims.mat'],'-mat');
			script = stims.saveScript;
			script = getstimscript(cksds,testlist{t});
		catch, go=0; warning(['Could not read script from ' testlist{t} '.']);
		end;
		if go,
			descr = sswhatvaries(script);
			if iscell(descr)&length(descr)==1,
				if strcmp(descr{1},whatshouldvary),
					possibletests = cat(2,possibletests,{testlist{t}});
				end;
			end;
		end;
	end;
	if length(possibletests)>0,
		disp(['No associate ' assocname ' for cell ' cellname '.']);
		if length(possibletests)==1,
			r=input(['Directory ' possibletests{1} ...
				' looks appropriate. Use it? Y/N '],'s');
				if r=='Y'|r=='y',
					newcell=associate(newcell,assocname,assocowner,possibletests{1},'');
				end;
		else, % more than one possible tests
			done = 0;
			while ~done,
				str = 'Multiple directories possible: ';
				for j=1:length(possibletests),
					str=[str possibletests{j} ' '];
				end;
				disp(str);
				r=input('Which test to use, or return to skip: ','s');
				if ~isempty(r),
					for j=1:length(possibletests),
						if strcmp(r,possibletests{j}),
							newcell=associate(newcell,assocname,assocowner,...
								possibletests{j},'');
							done = 1; break;
						end;
					end;
				end;
			end;
		end;
	else, disp(['No associate ' assocname ' but no dir appropriate for cell ' cellname '.']);
	end;
else, disp(['Found associate 'assocname ' already in ' cellname '.']);
end;
