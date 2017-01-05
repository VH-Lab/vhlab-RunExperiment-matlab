function sgsscript = longsgs(sgsbase, framedur, N, isi)

sgsscript = stimscript(0);

p = getparameters(sgsbase);
mystate = p.randState;
[x,y] = getgrid(sgsbase);

for i=1:N,
	p.N = framedur;
	p.randState = mystate;
	p.dispprefs = {'BGpretime',isi};
	rand('state',mystate);
	rand(x*y,p.N);
	mystate = rand('state');
	if isa(sgsbase,'stochasticgridstim'),
		sgsscript = append(sgsscript,stochasticgridstim(p));
	elseif isa(sgsbase,'glidergridstim'),
		sgsscript = append(sgsscript,glidergridstim(p));
	else,
		error(['Do not know how to deal with stim class ' class(sgsbase).']);
	end;
end;
