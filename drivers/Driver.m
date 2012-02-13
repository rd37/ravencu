classdef Driver < handle
    %DRIVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        address=0;
        timer;
        serial_obj;
        
        comport='Com5';
        baud_rate=115200;
        data_bits=8;
        parity='none';
        stop_bits=1;
        flow_control='none';
    end
    
    methods
        %driver constructor called by sub class
        function DRV=Driver(address,comport,baud_rate)
            DRV.address=address;
            DRV.comport=comport;
            DRV.baud_rate=baud_rate;
        end
        
        function set_timer(DRV, interval)
            %same in java if timer!=null 
            if ~isempty(DRV.timer)
                disp('update timer');
                DRV.timer.set_delay(interval);
            else
                disp('create new timer');
                DRV.timer=DriverTimer(interval);
                add_timer_listener(DRV.timer,DRV,'TimerPulsed');
            end
        end
        
        function activate_timer(DRV)
            if ~isempty(DRV.timer)
               disp('activate timer');
               activate_timer(DRV.timer);
            end
        end
        
        function deactivate_timer(DRV)
            if ~isempty(DRV.timer)
                disp('deactivate timer');
               deactivate_timer(DRV.timer);
            end
        end
        
        function add_driver_listener(DRV_pub,LST_sub,drv_evt)
            disp('add driver listener');
            addlistener(DRV_pub, drv_evt, @(evt_src,evt_data)driver_event_occured(LST_sub,evt_src,evt_data)); 
        end
        
        function destroy(DRV)
            disp('destroy this driver');
             if ~isempty(DRV.timer)
                 deactivate_timer(DRV.timer);
                 %clear(DRV.timer);
             end
             fclose(DRV.serial_obj);
             clear DRV;
        end
    end
    
    methods (Abstract)
        result=timer_event_occured(evt_sub, evt_pub, evt_data);
    end
    
end

