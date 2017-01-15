function RunExperimentInitLocal;

 % inits local pathname variables for RunExperiment

 % Note: this file really belongs in the configuration folder, but nobody probably edits
 % this file, so we'll put it in the distribution for now.

NewStimGlobals;

remotecommglobals;
 
global sharedirNLT initdatapathNLT initanalysispathNLT initremotedirpathNLT;
global initextractpathNLT initacqreadyNLT;

sharedirNLT = Remote_Comm_dir;  %okay, if initialized after NewStim

initdatapathNLT = Remote_Comm_dir;
initanalysispathNLT = Remote_Comm_dir;
initremotedirpathNLT = Remote_Comm_dir;

initextractpathNLT = '/home/data/';
initacqreadyNLT= '/home/dataman/data/acqReady';

global lgn_databaseNLT;
lgn_databaseNLT = '/home/vanhoosr/nelson/lgn_characterize/single_unit/lgn_db';

global ghostmachine;

ghostmachine = 0;
