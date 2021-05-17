module doorLock_tb;

    reg lock;
    reg unlock;
    
    wire doorLocked;
    
    doorLock doorLock (
        .lock(lock),
        .unlock(unlock),
        
        .doorLocked(doorLocked)
    );
    
    initial
    begin
        lock = 1;
        #20;
        
        lock = 0;
        #20;
        
        unlock = 1;
        #20;
        
        unlock = 0;
        #20;
        
        lock = 1;
        #20;
        lock = 0;
        #20;    
    

    $finish;
    end


endmodule