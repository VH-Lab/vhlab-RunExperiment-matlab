function [newscript,iontParams] = makeiontophoresisfreqscript(thescript,current,pulsewidth,pulseinterval,numpulses,channel,doparam,reps)


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

for i=1:length(pulsewidth)+1, %include a blank
		for k=1:N,
			thestim = get(thescript,k);
			if channel==1, curr = -1*current; else, curr = current; end;
            if i==length(pulsewidth)+1, curr = 0; i=i-1; end;
			ps = getparameters(thestim);
			ps.iontophor_curr = curr;
			ps.iontophor_pulsewidth = pulsewidth(i);
            ps.iontophor_pulseinterval = pulseinterval(i);
            ps.iontophor_numpulses = numpulses(i);
            ps.iontophor_chan = channel;
			str = class(thestim);
			eval(['newstim=' str '(ps);']);
			newscript = append(newscript,newstim);
			stimid = numStims(newscript);
			iontParams = [iontParams ; stimid channel curr pulsewidth(i) pulseinterval(i) numpulses(i)];
		end;
		ctr = ctr + 1;
		mydo = [mydo do_orig+(ctr-1)*N];
        curr_thesetrials = curr*ones(size(do_orig));
        current_order = [current_order curr_thesetrials];
end;

mydo_orig = mydo;

if (doparam==2 | doparam==3),
	newscript = setDisplayMethod(newscript,2,mydo);
else,
	newscript = setDisplayMethod(newscript,doparam,reps);
end;
