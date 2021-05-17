module doorLock(
    input lock,
    input unlock,
    
    output reg doorLocked
);

    always @(posedge lock | unlock) begin
        if (lock)
            doorLocked = 1;
        else
            doorLocked = 0;
    end

endmodule