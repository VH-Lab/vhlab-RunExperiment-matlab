function FerretScrambleSheet(command, fig)

if nargin==0
    command='init';
end

if ishandle(command)
    fig=gcbf;
    command=get(command, 'tag');
    userdata = get(fig,'userdata');
end

switch command
    case 'init'
        fig=drawsheet; 
        FerretScrambleSheet ('default', fig);
    case 'default'
        z = geteditor('RunExperiment');
        ud = get(z,'userdata');
        if ~isa(ud.ds,'dirstruct'),
            errordlg('No data in RunExperiment window -- hit return after data directory.');
            error('No data in RunExperiment window -- hit return after data directory.');
        else, usstruct.ds = dirstruct(getpathname(ud.ds));
        end;
        set(fig,'userdata',usstruct);

        referencesheetlet_process(fig, 'ref', usstruct.ds, ['ref' 'ChooseNameRef']);
        
        eyemonitorpossheetlet_process(fig, 'eye', usstruct.ds, 'eyeGrabFromScreentool');
        
        ps=periodicscript('default');
        p=getparameters(ps);
        p.angle=0;
        p.sFrequency=0.08;
        p.nCycles=8;
        p.tFrequency = 4;
        p.rect=[0 0 1000 1000];
        p.contrast = 0.7;
        p.flickerType = 0; p.animType = 4; p.imageType = 2;
        ps=periodicscript(p);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,5,3,1,1);
        gratingsheetlet_process(fig,'CoarseDir',usstruct.ds,'CoarseDirSetVars','','[0:30:360-30]','angle','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'SpatFreq',usstruct.ds,'SpatFreqSetVars','','[0.05 0.1 0.2 0.5 0.8 1 1.3 ]','sFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'TempFreq',usstruct.ds,'TempFreqSetVars','','[0.5 1 2 4 6 8 12 16 20 25 30]','tFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'Contrast',usstruct.ds,'ContrastSetVars','','[0:0.1:1]','contrast','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'SpatPhase',usstruct.ds,'SpatPhaseSetVars','','[[0:pi/6:pi-pi/6] 2*pi+[0:pi/6:pi-pi/6]]','sPhaseShift','','GratCtrl',0,0,'ref');
        bs1 = blinkingstim('default');
        p=getparameters(bs1);
        p.BG = 128+[0 0 0]; p.random = 1; p.bgpause = 0; p.fps = 10; p.pixSize = [40 40]; p.rect = [0 0 400 400]; p.repeat = 30;
        bs1 = blinkingstim(p);
        p.value = [0 0 0];
        bs2 = blinkingstim(p);
        
        sgs1 = stochasticgridstim('default');
        sgs2 = stochasticgridstim('default');

        ggs1 = glidergridstim('default');
	p = getparameters(ggs1);
	p.pixSize = [ 20 600 ];
	p.rect = [ 0 0 800 600 ];
	p.fps = 10;
	ggs1 = glidergridstim(p);
        ggs2 = glidergridstim(p);

        reversecorrelationsheetlet_process(fig, 'ReverseCorr', usstruct.ds, 'ReverseCorrSetVars',sgs1,[],bs2,[],[100 20 15],[],[],[],1,'ref');
        glidersheetlet_process(fig, 'Glider', usstruct.ds, 'GliderSetVars',ggs1,[],ggs2,[],[10 32 3],[],[],[],1,'ref');
	
	phasesequencesheetlet_process(fig,'PhaseSeq',usstruct.ds,'PhaseSeqSetVars','','GratCtrl',0,'ref','[A1 A2 A3 A4 A5 A6 A7 A8]');
	phasesequenceplayersheetlet_process(fig,'PhasePlayer',usstruct.ds,'PhasePlayerSetVars','','GratCtrl',0,'ref','100');

    otherwise
        disp(['unknown command ' command])
end
 

   
function fig=drawsheet
fig=figure;

sheet_height = 800;
set(gcf, 'position', [96    93   829   sheet_height]);
set(gcf, 'tag', 'FerretScrambleSheet','name','Ferret Scramble');
top=sheet_height - 12;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Coarse Direction', 'CoarseDir', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Spatial Frequency', 'SpatFreq', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Temporal Frequency', 'TempFreq', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Contrast', 'Contrast', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Spatial Phase', 'SpatPhase', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = reversecorrelationsheetlet('Reverse Correlation', 'ReverseCorr', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = glidersheetlet('Glider stims', 'Glider', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = phasesequencesheetlet('PhaseSeq',[5 newpos]);
newpos = newpos - lengthwidth(2)-15;

[hlist,lengthwidth] = phasesequenceplayersheetlet('PhasePlayer',[5 newpos]);
newpos = newpos - lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);

newpos = newpos-lengthwidth(2)-5;
