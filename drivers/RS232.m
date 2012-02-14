classdef RS232 < handle
    properties
        connection;
    end
    
    methods
        function comm = RS232(port, baudrate)
            disp('Connecting..');
            try
                comm.connection = serial(port,'BaudRate',baudrate);
                fopen(comm.connection);
                disp('Connection Success!');
            catch ME1
                throw(ME1);
            end
        end
        
        function delete(comm)
            fclose(comm.connection);
            delete(comm.connection);
        end
        
        function send(comm, msg)
            fprintf(comm.connection, msg);
        end
        
        function response = query(comm, msg)
            comm.send(msg);
            response = fscanf(comm.connection);
        end
    end
end

