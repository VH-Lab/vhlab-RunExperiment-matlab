function ss=makebardisparity(disparities,bar1col,bar2col,o,backforth,ctrx,ctry);

ss=stimscript(0);

DUR = 40;
rinc=1;
sms = shapemoviestim('default');   

p = getparameters(sms);
p.rect = [ 0 0 800 600];
p.fps = 1; 
p.N = DUR*backforth;
p.isi=0.01;
p.BG = [0 0 0];
p.disparity = 1;
V = 57;
NewStimGlobals; % for pixels_per_cm
E = 8;  % cm
H = 100;
sms = shapemoviestim(p);

pos = struct('x',ctrx-200*sin(o*pi/180),'y',ctry+200*cos(o*pi/180));
speed = struct('x',(1000/100)*sin(o*pi/180),'y',(-1000/100)*cos(o*pi/180));

me = struct('type',4,'position',pos,'onset',1,'duration',DUR,...
            'size',H,'color',struct('r',bar1col(1),'g',bar1col(2),'b',bar1col(3)),'contrast',1,...
            'speed',speed,'orientation',o,'eccentricity',14);

me = me([]);
    
for d=disparities,

	
	bf = backforth;

	

	sgn = 1;
	R=[-300 -200 -100 0 100 200 300];

	for i=1:bf,
        [lo,ro]=stereopoint(V,E,0,d),
        lo = (pixels_per_cm*lo); ro = (pixels_per_cm*ro);

        pos = struct('x',0*R(rinc)+lo+ctrx-sgn*(0*200)*sin(o*pi/180),'y',R(rinc)+ctry+0*sgn*(0*200)*cos(o*pi/180));
		speed = struct('x',0*(sgn*1000/100)*sin(o*pi/180),'y',0*(-sgn*1000/100)*cos(o*pi/180));
		pos2 = struct('x',0*R(rinc)+ro+ctrx-sgn*(0*200)*sin(o*pi/180),'y',R(rinc)+ctry+0*sgn*(0*200)*cos(o*pi/180));
        posd = struct('x',0*R(rinc)+ctrx+mean([lo ro])-sgn*(0*200)*sin(o*pi/180),'y',R(rinc)+ctry+0*sgn*(0*200)*cos(o*pi/180));
		
        pos,
        pos2,
        posd,
        rinc=rinc+1;
		me(end+1) = struct('type',4,'position',pos,'onset',1+DUR*(i-1),'duration',DUR,...
		            'size',H,'color',struct('r',bar1col(1),'g',bar1col(2),'b',bar1col(3)),'contrast',1,...
					'speed',speed,'orientation',o,'eccentricity',14);
                
        me(end+1) = struct('type',4,'position',pos2,'onset',1+DUR*(i-1),'duration',DUR,...
                    'size',H,'color',struct('r',bar2col(1),'g',bar2col(2),'b',bar2col(3)),'contrast',1,...
                    'speed',speed,'orientation',o,'eccentricity',14);

        if abs(lo-ro)<=14,
            me(end+1) = struct('type',4,'position',posd,'onset',1+DUR*(i-1),'duration',DUR,...
                        'size',H,'color',struct('r',bar2col(1)+bar1col(1),'g',bar2col(2)+bar1col(2),'b',bar2col(3)+bar1col(3)),'contrast',1,...
                        'speed',speed,'orientation',o,'eccentricity',1+14-abs(lo-ro));
        end;

		sgn = sgn * -1;
	end;
				

	
end;

	sms = setshapemovies(sms,{me});
	ss = append(ss,sms);
