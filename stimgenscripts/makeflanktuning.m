function tunescript = makeflanktuning(base, flankori, flanklocori, flankoffset, numflanks, centercontrast, flankcontrast, screenrect, makeoneflank)

% MAKEFLANKTUNING - Make flanking grating stimuli
%
%   TUNESCRIPT = MAKEFLANKTUNING(BASE, FLANKORI, FLANKLOCORI, ...
%       FLANKOFFSET, NUMFLANKS, CENTERCONTRAST, FLANKCONTRAST,
%       SCREENRECT,MAKETWOFLANKS)
%
%  Creates stimuli that include a center grating and possibly
%  several flanking gratings.
%
%  The gratings are in the PERIODICSTIM class and are based on the
%  PERIODICSTIM BASE.  Stimuli are created such that every combination
%  of the parameters specified are represented.  Those parameters are
%  as follows:
%
%  FLANKORI - The orientation of the flanking gratings (degrees)
%  FLANKLOCORI - The direction of the offset of the flanking gratings
%                relative to the main grating.  For example, if
%                FLANKLOCORI is 0, then flanks are to the top and bottom.
%                (Units are degrees.)  0 is up.
%  FLANKOFFSET - The distance, in pixels, between center and flanks and
%                between Nth tier flanks and N+1th tier flanks.  The
%                direction of the offset is determined by FLANKLOCORI.
%  NUMFLANKS -   How many flanks?  1 means one flank on each side, 2 is 
%                2 flanks on each side, etc. (See MAKETWOFLANKS)
%  CENTERCONTRAST - Contrast of the center grating
%  FLANKCONTRAST - Contrast of the flanks
%  SCREENRECT - The rect of the screen [0 0 width height]
%  MAKEONEFLANK - 0/1  Should we only make one flank?


p = getparameters(base);
ctr = [ mean(p.rect([1 3])) mean(p.rect([2 4])) ];

tunescript = stimscript(0);

for fo=1:length(flankori),
  for flo = 1:length(flanklocori),
    for fof = 1:length(flankoffset),
      for nf = 1:length(numflanks),
        for cc = 1:length(centercontrast)
          for fc = 1:length(flankcontrast),
		p_ = p; % flank parameters
		p_.angle = flankori(fo);
		p_.contrast = flankcontrast(fc);
		p.contrast = centercontrast(cc);
		msp.rect = screenrect;
		msp.flanklocori = flanklocori(flo);
		msp.dispprefs = {};
		ms = multistim(msp);
		ms = append(ms,periodicstim(p));
		for n=1:numflanks(nf),
			[x,y] = pol2cart((90-flanklocori(flo))*pi/180,n*flankoffset(fof));
			p_.rect = p.rect + [x -y x -y];
			ms = append(ms,periodicstim(p_));
			if ~makeoneflank,
				[x,y] = pol2cart((90-flanklocori(flo))*pi/180,-n*flankoffset(fof));
				p_.rect = p.rect + [x -y x -y];
				ms = append(ms,periodicstim(p_));
			end;
		end;
		tunescript = append(tunescript,ms);
          end;
        end;
      end;
    end;
  end;
end;

