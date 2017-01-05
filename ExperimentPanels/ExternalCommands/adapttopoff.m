function newscript = adapttopoff(firstorlast, commandstr,origscript,outputpath)

if nargin==0, 
	newscript = 'scriptmodifier';
	return;
end;
newscript = origscript;

switch commandstr,
    case 'EditScript',
        do = getDisplayOrder(origscript),
        N = numStims(origscript),
        indsOfInitialAdapt = [];
        indsOfTopOffAdapt = [];
	myindstoexclude = [];

        for i=1:N,
            p = getparameters(get(origscript,i));
            if isfield(p,'initialadapt')&~isfield(p,'adapttopoff'),
                indsOfInitialAdapt(end+1) = i;
		myindstoexclude = cat(2,myindstoexclude,find(do==i));
            end;
            if isfield(p,'adapttopoff'),
                indsOfTopOffAdapt(end+1) = i;
		myindstoexclude = cat(2,myindstoexclude,find(do==i));
            end;
        end;
        if isempty(indsOfTopOffAdapt) & isempty(indsOfInitialAdapt), 
            disp(['Nothing to work on here, adapttopoff making no changes']);
            return;
        end;

        % remove any initial or topoff stim displays
        do = do(setdiff(1:length(do),myindstoexclude));

	if firstorlast==0,
		theinitialind=1; thetopoffind=1;
	else,
		theinitialind = length(indsOfInitialAdapt);
		thetopoffind = length(indsOfTopOffAdapt);
	end;

        newdo = [indsOfInitialAdapt(theinitialind)];
        for i=1:length(do),
            newdo(end+1) = indsOfTopOffAdapt(thetopoffind);
            newdo(end+1) = do(i);
        end;

        newscript = setDisplayMethod(origscript,2,newdo);
    case 'CleanUp',
end;

