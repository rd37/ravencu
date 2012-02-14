classdef Merc863 < Driver
    
    properties
        posError=0.0001;
        framerate;
        refPosition;
        maxVelocity;
        velocity;
        name;
        orientation;
    end
    
    events
       AXISREACHEDPOSITION;
       AXISCHANGED;
    end
    
    methods
        function controller=Merc863(connection,address)
            controller=controller@Driver(address,connection);
            controller.connection.send([num2str(controller.address) ' SVO 1 1']);
            controller.checkError();
            controller.findRef();
        end
        
        function move(controller,pos,interval)
            if interval ~= 0
               controller.setTimer( interval ); 
            end
            controller.connection.send([num2str(controller.address) ' MOV 1 ' num2str(pos)]); 
            controller.checkError();
            activateTimer( controller );
        end
        
        function findRef( driver )
            driver.connection.send([num2str(driver.address) ' FRF']);
            driver.checkError();
        end
        
        function currentPosition = getCurrentPosition(driver)
            result = driver.connection.query([num2str(driver.address) ' POS?']);
            currentPosition = Merc863.stripPrefix(result);
            driver.checkError();
        end
        
        function targetPosition = getTargetPosition(driver)
            result = driver.connection.query([num2str(driver.address) ' MOV?']);
            targetPosition = Merc863.stripPrefix(result);
            driver.checkError();
        end
        
        function delete(driver)
             driver.connection.send([num2str(driver.address) ' SVO 1 0']);
             driver.checkError();
        end
        
        %called by timer periodically checks for all event types 
        %and notifies listeners
        function timerEvent(subscriber, publisher, evtData)
           %disp('1.first');
           currentPos=getCurrentPosition(subscriber);
           targetPos=getTargetPosition(subscriber);
           evt=Merc863Event('AXISCHANGED');
           evt.targetPosition=targetPos;
           evt.currentPosition=currentPos;
           notify(subscriber,'AXISCHANGED',evt);
           
           %disp('2.recieved timer event curr pos ');
           %disp(currentPos);disp(targetPos);
           
           
           if strcmp(num2str(currentPos),num2str(targetPos))
              %disp('3. target reached');
              deactivateTimer(subscriber.timer);
              evt3=Merc863Event('AXISREACHEDPOSITION');
              evt3.targetPosition=targetPos;
              evt3.currentPosition=currentPos;
              notify(subscriber,'AXISREACHEDPOSITION',evt3);
           else
               %disp('4. target not acheived');
           end
           
        end
    end
    
    methods (Access=private)
        function checkError(driver)
            error = driver.connection.query([num2str(driver.address) ' ERR?']);
            [~, error] = strtok(error);
            [~, err] = strtok(error);
            
            if err ~= '0'
                disp (err);
                %throw('ExceptThisBitch');
            end
        end
    
    end
    
    methods (Static)
        function output = stripPrefix(input)
            [~, postfix] = strtok(input, '=');
            output = postfix(2:end);
        end
    end
end

