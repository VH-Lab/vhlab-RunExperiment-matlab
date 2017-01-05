function TrainingSheet(command, fig)

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
        TrainingSheet ('default', fig);
    case 'default'
        z = geteditor('RunExperiment');
        ud = get(z,'userdata');
        if ~isa(ud.ds,'dirstruct'),
            errordlg('No data in RunExperiment window -- hit return after data directory.');
            error('No data in RunExperiment window -- hit return after data directory.');
        else, usstruct.ds = dirstruct(getpathname(ud.ds));
        end;
        set(fig,'userdata',usstruct);

        ps=periodicscript('default');
        p=getparameters(ps);
        p.angle=0;
        p.sFrequency=0.08;
        p.nCycles=20;
        p.tFrequency = 4;
        p.rect=[0 0 1000 1000];
        p.contrast = 0.7;
        p.flickerType = 0; p.animType = 4; p.imageType = 2;
        p.loops = 0;
        ps=periodicscript(p);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,20,5,1,1);
	%  traininggratingsheetlet_process SetVar variable input argument order list: testName, DirPrefEdit, ONOFFEdit, gratCtrl, GoodCB, acquireCB, refCtrl, bsiCtl, methodPopupValue]
        traininggratingsheetlet_process(fig,'GratingTraining',usstruct.ds,'GratingTrainingSetVars','','0','[20 10]','GratCtrl',0,0,' ',' ',1);

    otherwise
        disp(['unknown command ' command])
end
    

function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    93   829   405]);
set(gcf, 'tag', 'TrainingSheet');
top=880;
top=405;
newpos=top - 15;

uicontrol('style','text','fontsize',16,'fontweight','bold','string','Training Control Sheet','position',[5 newpos-40 400 40],'backgroundcolor',0.8*[1 1 1],'horizontalalignment','left');

newpos = top - 40 - 15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);

newpos = newpos-lengthwidth(2)-20;

[hlist,lengthwidth] = traininggratingsheetlet('GratingTraining', 'GratingTraining', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;
