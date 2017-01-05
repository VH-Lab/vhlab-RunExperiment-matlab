function ss=makebarorientation(orientations,backforth,ctrx,ctry);


ss=stimscript(0);

for o=orientations,
	sms = shapemoviestim('default');
	
	bf = backforth;
	
	p = getparameters(sms);
	p.rect = [ 0 0 800 600];
	p.fps = 100; 
	p.N = 40*bf;
	p.isi=0.01;
	p.BG = [0 0 0];
	p.angle = o;
	
	sms = shapemoviestim(p);
	
	pos = struct('x',ctrx-200*sin(o*pi/180),'y',ctry+200*cos(o*pi/180));
	speed = struct('x',(1000/100)*sin(o*pi/180),'y',(-1000/100)*cos(o*pi/180));
	
	me = struct('type',4,'position',pos,'onset',1,'duration',40,...
	            'size',800,'color',struct('r',255,'g',255,'b',255),'contrast',1,...
				'speed',speed,'orientation',o,'eccentricity',14);

	me = me([]);
	sgn = 1;
	
	for i=1:bf,
		pos = struct('x',ctrx-sgn*200*sin(o*pi/180),'y',ctry+sgn*200*cos(o*pi/180));
		speed = struct('x',(sgn*1000/100)*sin(o*pi/180),'y',(-sgn*1000/100)*cos(o*pi/180));
		
		me(end+1) = struct('type',4,'position',pos,'onset',1+40*(i-1),'duration',40,...
		            'size',800,'color',struct('r',255,'g',255,'b',255),'contrast',1,...
					'speed',speed,'orientation',o,'eccentricity',14);
		sgn = sgn * -1;
	end;
				
	sms = setshapemovies(sms,{me});
	
	ss = append(ss,sms);
end;