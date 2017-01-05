function s = addblankstim(thescript, color, duration_, dispprefs)

%  ADDBLANKSTIM - Adds a "blank" stimulus to a script
%
%  NEWSCRIPT=ADDBLANKSTIM(THESCRIPT,COLOR, [DURATION],...
%      [DISPPREFS])
%
%  Adds a blank stim of a particular color to a stimcript THESCRIPT.
%  Returns the new script in NEWSCRIPT.
%
%  The stimulus that is added is a stochasticgrid stim with one
%  grid point; the background and foreground are colored in
%  COLOR.
%
%  If DURATION is specified and is not empty, the blank
%  stimulus will have that duration; otherwise, the duration
%  will be set to the median duration of the other stimuli
%  in the script, or, if there are no stimuli in the script,
%  then a duration of 1 second is used.
%
%  If DISPPREFS is specified, then the display preferences will
%  be passed along to the blank stimulus (e.g., 'BGpretime',2).
%  See help STOCHASTICGRIDSTIM for information about passing
%  display preference parameters.  If DISPPREFS is not specified,
%  then the stimuli are examined to see if any have BGpretime or
%  BGposttime specified, and, if so, the largest value of each
%  is used.

calcdefaultdur = (nargin<3);
if ~calcdefaultdur, calcdefaultdur = isempty(duration_); end;
calcdp = (nargin<4);
if ~calcdp, calcdp = isempty(dispprefs); end;

if calcdefaultdur,
	mydurs = [];
	for i=1:numStims(thescript), mydurs(i)=duration(get(thescript,i)); end;
	if isempty(mydurs), dur = 1; else, dur = median(mydurs); end;
else, dur = duration_;
end;

dur,

if calcdp,
	BGpre = []; BGpost = [];
	for i=1:numStims(thescript),
		dps = struct(getdisplayprefs(get(thescript,i)));
		BGpre(end+1) = dps.BGpretime;
		BGpost(end+1) = dps.BGposttime;
	end;
	if ~isempty(BGpre), BGpre = max(BGpre); BGpost = max(BGpost);
	else, BGpre = 0; BGpost = 0;
	end;
	thedp = {'BGpretime',BGpre,'BGposttime',BGpost};
else, thedp = dispprefs; BGpre = 0; BGpost = 0;
end;

dur = dur - BGpre - BGpost;

sgs = stochasticgridstim('default');
sgsp = getparameters(sgs);
sgsp.N = 1; sgsp.fps = 1/dur; 
sgsp.pixSize = [1 1]; sgsp.rect = [0 0 1 1];
sgsp.dist = [ 1 ]; sgsp.BG = color; sgsp.values = color;
sgsp.dispprefs = thedp;
sgsp.isblank = 1;
s = append(thescript,stochasticgridstim(sgsp));
