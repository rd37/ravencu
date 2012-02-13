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
        function driver_event_occured(sub,pub,evt_obj)
           disp('recieved event'); 
        end
    end
    
end

