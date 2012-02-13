classdef Merc863 < Driver
    %MERC863 Summary of this class goes here
    %Detailed explanation goes here
    
    properties
        id;
        pi_error=0.0001;
        io_error=0.0001;
        desired_pi_pos=0.0;
        desired_io_pos=0.0;
        last_pi_pos=0.0;
        last_io_pos=0.0;
        io_pin1=0;
        io_pin2=0;
        io_pin3=0;
        io_pin4=0;
        
        %rs232 commands
        ACTSVO='SVO 1 1 ';
        DEACTSVO='SVO 1 0 ';
        REFSVO='FRF'
        MVSVO='MOV 1 ';
        SVOPOS='POS?';
    end
    
    events
       AXISREACHEDPOSITION;
       AXISUPDATE;
       IOREACHEDPOSITION;
       IOUPDATE;
    end
    
    methods
        function MERC8=Merc863(address,baud_rate,comport,id)
            MERC8=MERC8@Driver(address,comport,baud_rate);
            MERC8.id=id;
            %create serial object
            MERC8.serial_obj=serial(MERC8.comport,'BaudRate',MERC8.baud_rate,'DataBits',MERC8.data_bits,'Parity',MERC8.parity,'StopBits',MERC8.stop_bits,'FlowControl',MERC8.flow_control); 
            fopen(MERC8.serial_obj);
            fprintf(MERC8.serial_obj,MERC8.ACTSVO);
            fprintf(MERC8.serial_obj,MERC8.REFSVO);
        end
        
        function set_pi_position(MERC8,pos,interval)
            MERC8.desired_pi_pos=pos;
            if interval ~= 0
               set_timer( MERC8, interval ); 
            end
            posstr=num2str( pos );
            cmd=[MERC8.MVSVO posstr];
            fprintf( MERC8.serial_obj, cmd );
            activate_timer( MERC8 );
        end
        
        function ret=get_pi_position( MERC8 )
            fprintf( MERC8.serial_obj,MERC8.SVOPOS );
            res=fscanf( MERC8.serial_obj );
            [f,y]=strtok(res,'=');
            [f,y]=strtok(y,'=');
            ret=str2double(f);
        end
        
        function set_io_position(MERC8,pos)
            MERC8.desired_io_pos=pos;
        end
        
        function ret=get_io_position(MERC8)
            ret=MERC8.last_io_pos;
        end
        
        %called by timer periodically checks for all event types 
        %and notifies listeners
        function timer_event_occured(evt_sub, evt_pub, evt_data)
           disp('recieved timer event curr pos ');
           
           evt_sub.last_pi_pos=get_pi_position(evt_sub);
           %disp(evt_sub.last_pi_pos);
           evt=Merc863Event('AXISUPDATE');
           evt.last_pi_pos=evt_sub.last_pi_pos;
           notify(evt_sub,'AXISUPDATE',evt);
           %disp(evt_sub.last_pi_pos);
           evt_sub.last_io_pos=get_io_position(evt_sub);
           evt2=Merc863Event('IOUPDATE');
           evt2.last_io_pos=evt_sub.last_io_pos;
           notify(evt_sub,'IOUPDATE',evt2);
           
           %check for pi position changes and 
           %disp(evt_sub.last_pi_pos);
           resadderr=evt_sub.desired_pi_pos+evt_sub.pi_error;
           ressuberr=evt_sub.desired_pi_pos-evt_sub.pi_error;
           %disp(resadderr);
           %disp(ressuberr);
           %disp(evt_sub.last_pi_pos);
           if (resadderr>=evt_sub.last_pi_pos) && (ressuberr<=evt_sub.last_pi_pos)
              deactivate_timer(evt_sub.timer);
              evt3=Merc863Event('AXISREACHEDPOSITION');
              evt3.last_pi_pos=evt_sub.last_pi_pos;
              notify(evt_sub,'AXISREACHEDPOSITION',evt3);
           end
           
           %check for pi position changes and 
           %ioresadderr=evt_sub.desired_io_position+evt_sub.io_error;
           %ioressuberr=evt_sub.desired_io_position-evt_sub.io_error;
           %if (ioresadderr>=evt_sub.last_io_pos) && (ioressuberr<=evt_sub.last_io_pos)
           %   deactivate_timer(evt_sub.timer);
           %   evt3=Merc863Event('IOREACHEDPOSITION');
           %   evt3.last_io_position=evt_sub.last_io_pos;
           %  notify(evt_sub,'IOREACHEDPOSITION',evt3);
           %end
        end
    end
    
end

