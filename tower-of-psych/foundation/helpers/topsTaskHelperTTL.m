classdef topsTaskHelperTTL < topsTaskHelper
   % Class topsTaskHelperTTL
   %
   % Add topsTaskHelperTTL, a subclass of topsTaskHelper
   
   properties (SetObservable)
      
      % Maximum number of pulses
      maxPulses;
      
      % trialData fields
      trialDataFields;
   end
   
   methods
      
      % Constuct the helper
      %
      % Arguments:
      %  maxPulses         ... maximum number of pulses
      %  trialDataFields   ... used to store time stamps
      %  writableFcn       ... function handle of writable class
      function self = topsTaskHelperTTL(varargin)
            
          % Parse the arguments
         [parsedArgs, passedArgs] = parseHelperArgs('TTL', varargin, ...
            'maxPulses',         4, ...
            'trialDataFields',   {'TTLstart', 'TTLnum', 'TTLfinish'}, ...         
            'fevalable',         @dotsWritableDOut1208FS);
         
         % Create it, putting the fevalable back in the arg list
         self = self@topsTaskHelper(passedArgs{:}, 'fevalable', parsedArgs.fevalable);
         
         % Save the parsed args
         self.maxPulses = parsedArgs.maxPulses;
         self.trialDataFields = parsedArgs.trialDataFields;         
      end
      
      % Overloaded start method
      %
      %  Sets the prepare fevalable to call sendPulses method
      %  based on the current trial
      function start(self, treeNode)
         
         % Only bind to topsTreeNodeTask
         if isa(treeNode, 'topsTreeNodeTask')
            
            % Add the trialData field
            for ii = 1:length(self.trialDataFields)
               if ~isfield(treeNode.trialData, self.trialDataFields{ii})
                  [treeNode.trialData.(self.trialDataFields{ii})] = deal(nan);
               end
            end
         end
      end
      
      % Overloaded startTrial method, which sends the TTL pulse(s)
      %
      function startTrial(self, treeNode)
                
         % Num pulses is based on the trial number
         numPulses =  mod(max(0, treeNode.trialCount-1), self.maxPulses)+1;
         
         % send pulses
         [startTime, endTime] = self.theObject.sendTTLPulses(numPulses);
         
         % Set the values in the trialData struct
         treeNode.setTrialData([], self.trialDataFields{1}, startTime);
         treeNode.setTrialData([], self.trialDataFields{2}, numPulses);
         treeNode.setTrialData([], self.trialDataFields{3}, endTime);
      end
   end
end