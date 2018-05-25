function RTDconfigureSaccadeTask(task, datatub, trialsPerDirection)
% RTDconfigureSaccadeTask(task, datatub, trialsPerDirection)
%
% RTD = Response-Time Dots
%
% Fills in information in a topsTreeNode representing a task 
%  "child" of the maintask. Uses the name of the task to determine
%  behavior:
%     'VGS' ... Visually guided saccade
%     'MGS' ... Memory guided saccade
%
% Inputs:
%  task        ... the topsTreeNode
%  datatub     ... tub o' data
%  trialsPerDirection ... number of trials
%
% 5/11/18 written by jig

%% ---- Check arg
if isempty(trialsPerDirection)
   trialsPerDirection = datatub{'Input'}{'trialsPerDirection'};
end

%% ---- Instruction strings. 
%
% Define them here so they can be consistent across task types
topStrings = { ...
   'When the fixation spot disappears'};
bottomStrings = { ...
   'Look at the visual target'; ...
   'Look at the remebered location of the visual target'};

%% ---- Make the array of directions
% 
% Automatically randomized... could control this with a flag
directions = repmat( ...
   datatub{'Input'}{'saccadeDirections'}, ...
   trialsPerDirection, 1);
numTrials = numel(directions);
indices = randperm(numTrials);
directions = directions(indices)';

%% ---- Make the trialData field of the task's nodeData
%
% Add structure array to the task's nodeData
task.nodeData.trialData = struct( ...
   'trialIndex', num2cell((1:numTrials)'), ...
   'direction', num2cell(directions), ...
   'RT', nan, ...
   'correct', nan, ...
   'time_screen_roundTrip', 0, ...
   'time_local_trialStart', nan, ...
   'time_ui_trialStart', nan, ...
   'time_screen_trialStart', nan, ...
   'time_TTLFinish', nan, ...
   'time_fixOn', nan, ...
   'time_targOn', nan, ...
   'time_targOff', nan, ...
   'time_fixOff', nan, ...
   'time_fdbkOn', nan, ...
   'time_local_trialFinish', nan, ...
   'time_ui_trialFinish', nan, ...
   'time_screen_trialFinish', nan);

%% ---- Add the start task fevalable with task-specific instructions
switch task.name

   case 'VGS'
      instructions = {topStrings{1}, bottomStrings{1}};

   case 'MGS'
      instructions = {topStrings{1}, bottomStrings{2}};
end
task.startFevalable = {@RTDstartTask, datatub, task, instructions};
