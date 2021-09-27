function sgsscript = longhartley(sgsbase, reps, isi)

sgsscript = stimscript(0);

p = getparameters(sgsbase);
mystate = p.randState;

for i=1:reps,
	p.randState = mystate;
	p.dispprefs = {'BGpretime',isi};
	rand('state',mystate);
	rand(1,fix(1000*rem(now,1)));
	mystate = rand('state');
	if isa(sgsbase,'hartleystim'),
		sgsscript = append(sgsscript,hartleystim(p));
	elseif isa(sgsbase,'blinkingstim'),
		sgsscript = append(sgsscript,blinkingstim(p);
	else,
		error(['Do not know how to deal with stim class ' class(sgsbase).']);
	end;
end;


