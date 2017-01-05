function MarjenaSheet(command, fig)

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
	set(fig,'name','Length Summing');
        MarjenaSheet ('default', fig);
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

	% default grating
        ps=periodicscript('default');
        p=getparameters(ps);
        p.angle=0;
        p.sFrequency=0.1;
        p.tFrequency = 4;
        p.nCycles=p.tFrequency*2;
        p.rect=[0 0 400 400];
        p.contrast = 1;
        p.flickerType = 0;
	p.animType = 4;
	p.imageType = 2;
	p.windowShape = 3;
        ps=periodicscript(p);

        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,5,3,1,1);
        gratingsheetlet_process(fig,'CoarseDir',usstruct.ds,'CoarseDirSetVars','','[0:22.5:360-22.5]','angle','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'SpatFreq',usstruct.ds,'SpatFreqSetVars','','[0.05 0.1 0.15 0.2 0.3 0.5 0.8]','sFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'TempFreq',usstruct.ds,'TempFreqSetVars','','[0.5 1 2 4 8 16 32]','tFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'Contrast',usstruct.ds,'ContrastSetVars','','[0.02 0.04 0.08 0.16 0.32 0.64 1]','contrast','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'FineDir',usstruct.ds,'FineDirSetVars','','[0:22.5:360-22.5]','angle','','GratCtrl',0,0,'ref');
        contrastplaidsheetlet_process(fig,'ContrastPlaid',usstruct.ds,'ContrastPlaidSetVars','','[0.16 0.32 0.64 1]','contrast','','GratCtrl',0,0,'ref');
        %lengthwidthcontrastsheetlet_process(fig,'LengthWidthC',usstruct.ds,'LengthWidthCSetVars','','[20 40 80 140 220 320 440 560]','[-1]','[1]','GratCtrl',0,'ref');
        lengthwidthcontrastaperturesheetlet_process(fig,'LengthWidthCA',usstruct.ds,'LengthWidthCASetVars','','[20 40 80 140 220 320 440 560]','[-1]','[1]','GratCtrl',0,'ref');
        flanktuningsheetlet_process(fig,'FlankTuningIsoOri',usstruct.ds,'FlankTuningIsoOriSetVars','',1,'[0:22.5:180-22.5]','120','1','[1]','230','GratCtrl',0,'ref');
        flanktuningsheetlet_process(fig,'FlankTuningOppOri',usstruct.ds,'FlankTuningIsoOppSetVars','',0,'[0:22.5:180-22.5]','120','1','[1]','230','GratCtrl',0,'ref');
        surroundtuningsheetlet_process(fig,'SurroundTune',usstruct.ds,'SurroundTuneSetVars','','[0:22.5:180-22.5]','300','GratCtrl',0,'ref');

    otherwise
        disp(['unknown command ' command])
end
 




function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    40   829   955]);
set(gcf, 'tag', 'MarjenaSheet');
top=900;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Direction', 'CoarseDir', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Spatial Frequency', 'SpatFreq', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Temporal Frequency', 'TempFreq', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Contrast', 'Contrast', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Fine Direction', 'FineDir', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist, lengthwidth] = contrastplaidsheetlet('ContrastPlaid','ContrastPlaid', [ 5 newpos]);
newpos = newpos-lengthwidth(2)-15;

%[hlist,lengthwidth] = lengthwidthcontrastsheetlet('LengthWidthC', 'LengthWidthC', [5 newpos]);
%newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = lengthwidthcontrastaperturesheetlet('LengthWidthCA', 'LengthWidthCA', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = flanktuningsheetlet('FlankTuningIsoOri', 'FlankTuningIsoOri', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = flanktuningsheetlet('FlankTuningOppOri', 'FlankTuningOppOri', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = surroundtuningsheetlet('SurroundTune', 'SurroundTune', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);
newpos = newpos-lengthwidth(2)-5;


