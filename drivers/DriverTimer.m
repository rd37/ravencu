classdef DriverTimer < handle
    %TIMER Summary of this class goes here
    %Detailed explanation goes here
    
    properties
        delay=2;
        state='off';
        tmr;
    end
    events
        TimerPulsed;
    end
    methods
        function TMR=DriverTimer(delay)
            disp('created timer');
            TMR.delay=delay;
        end
        function set_delay(TMR,delay)
            disp('set delay');
            TMR.delay=delay;
        end
        function activate_timer(TMR)
           if strcmp(TMR.state,'off')
               TMR.tmr=timer('TimerFcn',@(x,y)TMR.callback(),'Period',TMR.delay,'ExecutionMode','fixeddelay');
               start(TMR.tmr);
               TMR.state='on';
           end
        end
        function deactivate_timer(TMR)
            if strcmp(TMR.state,'on')
               stop(TMR.tmr);
               delete(TMR.tmr);
               TMR.state='off';
            end
        end
        function add_timer_listener(DRV_pub,LST_sub,tmr_evt)
            disp('add timer listener');
            addlistener(DRV_pub, tmr_evt, @(evt_src,evt_data)timer_event_occured(LST_sub,evt_src,evt_data)); 
        end
        function callback(TMR)
            notify(TMR,'TimerPulsed');
        end
        
    end
    
end


