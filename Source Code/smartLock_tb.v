`timescale 1ns / 10ps;
module smartLock_tb;
    reg [9:0] buttons;
    reg reset, clk, enter, delete, lock;

    wire doorLocked, error;
    
    //instantiation
    smartLock smartLock_inst (
        .buttons    (buttons),
        .enter      (enter),
        .delete     (delete),
        .reset      (reset),
        .clk        (clk),
        .lock       (lock),
        
        .error      (error),
        .doorLocked (doorLocked)
    );
    
    always
    begin
    clk = 1;
    #10;
    clk = 0;
    #10;
    end
    
    initial
    begin
        reset = 1;
        buttons = 10'h000;
        enter = 0;
        delete = 0;
        lock = 0;
        #20;
        reset = 0;
        #20;
        
        //1234 + enter, should save successfully
        buttons[1] = 1;
        #10;
        buttons[1] = 0;
        #10;
        buttons[2] = 1;
        #10;
        buttons[2] = 0;
        #10;
        buttons[3] = 1;
        #10;
        buttons[3] = 0;
        #10;
        buttons[4] = 1;
        #10;
        buttons[4] = 0;
        #10;
        enter = 1;
        #20;
        enter = 0;
        #160;
        
        /*
        //5678 + enter, should save successfully
        buttons[5] = 1;
        #10;
        buttons[5] = 0;
        #10;
        buttons[6] = 1;
        #10;
        buttons[6] = 0;
        #10;
        buttons[7] = 1;
        #10;
        buttons[7] = 0;
        #10;
        buttons[8] = 1;
        #10;
        buttons[8] = 0;
        #10;
        enter = 1;
        #20;
        enter = 0;
        #180;*/
        /*
        //9012 + enter, should save successfully
        buttons[9] = 1;
        #10;
        buttons[9] = 0;
        #10;
        buttons[0] = 1;
        #10;
        buttons[0] = 0;
        #10;
        buttons[1] = 1;
        #10;
        buttons[1] = 0;
        #10;
        buttons[2] = 1;
        #10;
        buttons[2] = 0;
        #10;
        enter = 1;
        #20;
        enter = 0;
        #60;
        
        //3456 + enter, cannot save, should have error
        buttons[3] = 1;
        #10;
        buttons[3] = 0;
        #10;
        buttons[4] = 1;
        #10;
        buttons[4] = 0;
        #10;
        buttons[5] = 1;
        #10;
        buttons[5] = 0;
        #10;
        buttons[6] = 1;
        #10;
        buttons[6] = 0;
        #10;
        enter = 1;
        #20;
        enter = 0;
        #60;
        
        //3456 + delete, cannot delete, should have error
        buttons[3] = 1;
        #10;
        buttons[3] = 0;
        #10;
        buttons[4] = 1;
        #10;
        buttons[4] = 0;
        #10;
        buttons[5] = 1;
        #10;
        buttons[5] = 0;
        #10;
        buttons[6] = 1;
        #10;
        buttons[6] = 0;
        #10;
        delete = 1;
        #20;
        delete = 0;
        #280;
        
        //5678 + delete, should delete successfully
        buttons[5] = 1;
        #10;
        buttons[5] = 0;
        #10;
        buttons[6] = 1;
        #10;
        buttons[6] = 0;
        #10;
        buttons[7] = 1;
        #10;
        buttons[7] = 0;
        #10;
        buttons[8] = 1;
        #10;
        buttons[8] = 0;
        #10;
        delete = 1;
        #20;
        delete = 0;
        #280;*/
        
        //lock, should lock the door
        lock = 1;
        #20;
        lock = 0;
        #20;
        
        //1234, should unlock the door
        buttons[1] = 1;
        #10;
        buttons[1] = 0;
        #10;
        buttons[2] = 1;
        #10;
        buttons[2] = 0;
        #10;
        buttons[3] = 1;
        #10;
        buttons[3] = 0;
        #10;
        buttons[4] = 1;
        #10;
        buttons[4] = 0;
        #270;
        /*
        //lock, should lock the door
        lock = 1;
        #20;
        lock = 0;
        #20;
        
        //1357, cannot unlock the door, should have error
        buttons[1] = 1;
        #10;
        buttons[1] = 0;
        #10;
        buttons[3] = 1;
        #10;
        buttons[3] = 0;
        #10;
        buttons[5] = 1;
        #10;
        buttons[5] = 0;
        #10;
        buttons[7] = 1;
        #10;
        buttons[7] = 0;
        #70;
        
        //5678, should unlock the door
        buttons[5] = 1;
        #10;
        buttons[5] = 0;
        #10;
        buttons[6] = 1;
        #10;
        buttons[6] = 0;
        #10;
        buttons[7] = 1;
        #10;
        buttons[7] = 0;
        #10;
        buttons[8] = 1;
        #10;
        buttons[8] = 0;
        #70;*/
        
    $finish;
    end

endmodule