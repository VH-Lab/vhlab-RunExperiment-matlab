function ss=makebarvelocity(orientations,velocities,ctrx,ctry,onoff,monitordistance,eccentricity);

ss=stimscript(0);

 % velocity in deg / sec

backforth = 1; % just go forward

travel = 20; % arbitrarily choose 20 deg of travel
NewStimGlobals;
cm_per_deg = monitordistance * tan(deg2rad(1));
pixels_per_deg = pixels_per_cm * cm_per_deg;
fps = 100; % assume 100Hz
 % eccentricity = 14; % arbitrary choice

warning('At the present time this function assumes a 100Hz monitor');

for O = onoff,

	if O==1,
		BG = [ 0 0 0 ]+128;
		FG = [ 1 1 1 ] * 255;
		FG = struct('r',FG(1),'g',FG(2),'b',FG(3));
	else,
		BG = [ 0 0 0 ]+128;
		FG = [ 0 0 0 ];
		FG = struct('r',FG(1),'g',FG(2),'b',FG(3));
	end;

	for o=orientations,
		for v = velocities,
			sms = shapemoviestim('default');
			
			bf = backforth;
			
			p = getparameters(sms);
			p.rect = [ 0 0 800 600];
			p.fps = fps; 
			p.N = max([1 round( pixels_per_deg*travel * fps / (v*pixels_per_deg) ) ]); % 40*bf; % 40 frames
			p.isi=1/fps;
			p.BG = BG;
			p.angle = o;
			p.velocity = v;
			
			sms = shapemoviestim(p);
			
			pos = struct('x',ctrx-200*sin(o*pi/180),'y',ctry+200*cos(o*pi/180)); % doesn't matter, going to be cleared
			speed = struct('x',(1000/100)*sin(o*pi/180),'y',(-1000/100)*cos(o*pi/180)); % doesn't matter, going to be cleared
			
			me = struct('type',4,'position',pos,'onset',1,'duration',40,...
				'size',800,'color',FG,'contrast',1,'speed',speed,'orientation',o,'eccentricity',14);

			me = me([]);
			sgn = sign(v);
			
			for i=1:bf,
				pos = struct('x',ctrx-sgn*travel/2*sin(o*pi/180),'y',ctry+sgn*travel/2*cos(o*pi/180));
				speed = struct('x',(pixels_per_deg*v/fps)*(sgn)*sin(o*pi/180),...
						'y',(pixels_per_deg*v/fps)*(-sgn)*cos(o*pi/180));
				
				me(end+1) = struct('type',4,'position',pos,'onset',1,'duration',p.N,...
					    'size',800,'color',FG,'contrast',1,...
							'speed',speed,'orientation',o,'eccentricity',eccentricity);
				sgn = sgn * -1;
			end;
						
			sms = setshapemovies(sms,{me});
			
			ss = append(ss,sms);
		end;
	end;
end;

