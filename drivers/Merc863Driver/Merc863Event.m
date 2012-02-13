classdef Merc863Event < event.EventData
    %MERC863EVENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        desired_pi_pos=0;
        desired_io_pos=0;
        last_pi_pos=0;
        last_io_pos=0;
        io_pin1=0;
        io_pin2=0;
        io_pin3=0;
        io_pin4=0;
        Evt;
    end
    
    methods
        function evt=Merc863Event(EVT)
           evt.Evt=EVT;
        end
    end
    
end

