function [newscript,iontParams]=makeiontophoresisscript2(thescript,currents,pulsewidth,pulseinterval,numpulses,channels,doparam,reps)

% MAKEIONTOPHORESISSCRIPT - Modifies script for iontophoresis
%
%  [NEWSCRIPT,IONTPARAMS]=MAKEIONTOPHORESISSCRIPT(STIMSCRIPT,CURRENTS,...
%      PULSEWIDTH,PULSEINTERVAL,NUMPULSES,CHANNELS,DOPARAM,REPS)
%
%  STIMSCRIPT - the original script to modify
%  CURRENTS - the current steps, in A
%  PULSEWIDTH -duration of each pulse
%  PULSEINTERVAL - Interval between pulses
%  NUMPULSES - Number of pulses per stim
%  CHANNELS - channel numbers to use; channel 1 will use negative
%       current values in CURRENTS
%  DOPARAM - Display order parameter; if 0, then sequential ordering,
%       if 1, then random ordering; if 2, then the original ordering is
%       preserved and current steps/channel values will be on
%       sequential repetitions of the original display order;
%       if 3, it inserts a zero-current trial after every nonzero-
%       current trial (if there is no nonzero-current trial, nothing
%       is done, ordering will be random).
%       NOTE: if DOPARAM is 3 and if there is more than one
%       current level being used, the number of zero-current trials is
%       increased to match the number of nonzero current trials.
%  REPS - number of repetitions (ignored if DOPARAM is 2)
%
%  NEWSCRIPT is the new script, and IONTPARAMS is a table of stimid,
%    channel, current value, and duration for each stimulus


newscript = stimscript(0);
do = getDisplayOrder(thescript);
N = numStims(thescript);
strs = {};

iontParams = [];	
	
do_orig = do;
if size(do_orig,1)>size(do_orig,2), do_orig = do_orig'; end;
mydo = [];
ctr = 0;
current_order = [];

for i=1:length(currents),
	for j=1:length(channels),
		for k=1:N,
			thestim = get(thescript,k);
			%if isempty(time), durr = duration(thestim); else, durr = time; end;
			if channels(j)==1, curr = -1*currents(i); else, curr = currents(i); end;
			ps = getparameters(thestim);
			ps.iontophor_curr = curr;
			ps.iontophor_pulsewidth = pulsewidth;
            ps.iontophor_pulseinterval = pulseinterval;
            ps.iontophor_numpulses = numpulses;
            ps.iontophor_chan = channels(j);
			str = class(thestim);
			eval(['newstim=' str '(ps);']);
			newscript = append(newscript,newstim);
			stimid = numStims(newscript);
			iontParams = [iontParams ; stimid channels(j) curr pulsewidth pulseinterval numpulses];

		end;
		ctr = ctr + 1;
		mydo = [mydo do_orig+(ctr-1)*N];
        curr_thesetrials = curr*ones(size(do_orig));
        current_order = [current_order curr_thesetrials];
        
    end;
end;

mydo_orig = mydo;
if(doparam==3)
    % User wants to alternate on- and off-current trials
    current_vals = unique(current_order);
    if(~any(current_vals==0))
        % There are no zero-current trials, so this option makes no sense.
        % Abort.
        warning('Invalid setting for doparam - need 0 current trials.  Setting doparam to 1.')
		doparam = 1;
        mydo = mydo_orig;
    else
        zeroind = find(current_order==0);
        nonzeroind = find(current_order~=0);
        
        numzero = length(zeroind);
        numnonzero = length(nonzeroind);
        nz_z_rat = numnonzero/numzero;
        
        % Duplicate zeroind if need be
        zeroind = repmat(zeroind,1,nz_z_rat);

        % Make random selectors for the two trial types (zero and nonzero
        % current) 
        n0 = length(zeroind);
        zerosel = zeroind(randperm(n0));
        nonzerosel = nonzeroind(randperm(n0));
        
        on_first = rand>0.5;  %Randomize whether we start with an on or off trial
        
        zeroconds = mydo_orig(zerosel);
        nonzeroconds = mydo_orig(nonzerosel);
        if(on_first==1)
            q = [nonzeroconds;zeroconds];
        else
            q = [zeroconds;nonzeroconds];
        end

        % This little trick will interleave the two types of trials.
        % Clever!
        mydo = q(:)';
    end    
end  % if(doparam==3)


numStims(newscript);
mydo;

if (doparam==2 | doparam==3),
	newscript = setDisplayMethod(newscript,2,mydo);
else,
	newscript = setDisplayMethod(newscript,doparam,reps);
end;
