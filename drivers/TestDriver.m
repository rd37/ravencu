classdef TestDriver < handle
    %TESTDRIVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
    end
    
    methods
        function TD=TestDriver(id)
            TD.id=id;
        end
        function driverEventOccured(sub,pub,evt_obj)
           disp('recieved event'); 
        end
    end
    
end

