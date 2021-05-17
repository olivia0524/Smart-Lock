module smartLock (
    input [9:0] buttons,
    input enter,
    input delete,
    input reset,
    input clk,
    input lock,
    
    output error,
    output doorLocked
);

wire enter_sig, delete_sig;
wire [15:0] password_sig;
wire [2:0] counter_sig;
wire saver_done_sig, deleter_done_sig, comparator_done_sig;
wire saver_start_sig, deleter_start_sig, comparator_start_sig;
wire [1:0] op_mode_sig;
wire error_controller_sig, error_saver_sig, match_sig;
wire [16:0] RF_data_out_sig;
wire RF_save_sig, RF_delete_sig;
wire [1:0] saver_read_addr_sig, deleter_read_addr_sig, comparator_read_addr_sig;
reg [1:0] read_addr_sig;
wire [1:0] save_addr_sig, delete_addr_sig;
wire deleter_pwChecker_start_sig, comparator_pwChecker_start_sig;
reg pwChecker_start_sig;
wire pwChecker_done_sig, pwChecker_match_sig;
wire unlock_sig;


// instantiation
keypad keypad (
    .buttons        (buttons),
    .enter          (enter),
    .delete         (delete),
    .reset          (reset),
    
    .password       (password_sig),
    .enter_out      (enter_sig),
    .delete_out     (delete_sig),
    .counter        (counter_sig)
);

controller controller (
    .clk            (clk),
    .reset          (reset),
    .enter          (enter_sig),
    .delete         (delete_sig),
    .lock           (lock),
    .counter        (counter_sig),
    .saver_done     (saver_done_sig),
    .deleter_done   (deleter_done_sig),
    .error_open     (error_sig),
    .comparator_done(comparator_done_sig),
    .match          (match_sig),
    
    .save_start     (saver_start_sig),
    .delete_start   (deleter_start_sig),
    .compare_start  (comparator_start_sig),
    .op_mode        (op_mode_sig),
    .unlock         (unlock_sig),
    .error          (error_controller_sig)
);

regFile regFile (
    .reset          (reset),
    .save           (RF_save_sig),
    .delete         (RF_delete_sig),
    .data_in        (password_sig),
    .save_addr      (save_addr_sig),
    .del_addr       (delete_addr_sig),
    .read_addr      (read_addr_sig),
    
    .data_out       (RF_data_out_sig)
);

comparator deleter (
    .clk            (clk),
    .start          (deleter_start_sig),
    .reset          (reset),
    .data_in        (RF_data_out_sig),
    .compare_done   (pwChecker_done_sig),
    .compare_match  (pwChecker_match_sig),
                   
    .read_addr      (deleter_read_addr_sig),
    .del_addr       (delete_addr_sig),
    .compare_start  (deleter_pwChecker_start_sig),
    .finish         (deleter_done_sig),
    .match          (RF_delete_sig)                    //tell RF to delete target password
);

comparator comparator (
    .clk            (clk),
    .start          (comparator_start_sig),
    .reset          (reset),
    .data_in        (RF_data_out_sig),
    .compare_done   (pwChecker_done_sig),
    .compare_match  (pwChecker_match_sig),
                   
    .read_addr      (comparator_read_addr_sig),
    .del_addr       (),
    .compare_start  (comparator_pwChecker_start_sig),
    .finish         (comparator_done_sig),
    .match          (match_sig)
);

saver saver (
    .clk            (clk),
    .start          (saver_start_sig),
    .reset          (reset),
    .data_in        (RF_data_out_sig),
   
    .read_addr      (saver_read_addr_sig),
    .save_addr      (save_addr_sig),
    .finish         (saver_done_sig),
    .save_start     (RF_save_sig),
    .error          (error_saver_sig)
);

pwChecker pwChecker (
    .clk            (clk),
    .start          (pwChecker_start_sig),
    .data1          (password_sig),
    .data2          (RF_data_out_sig[15:0]),
    
    .finish         (pwChecker_done_sig),
    .match          (pwChecker_match_sig)
);

doorLock doorLock (
    .lock           (lock),
    .unlock         (unlock_sig),
    .doorLocked     (doorLocked)
);

always @(*) begin
    case(op_mode_sig)
        2'd1: begin
                read_addr_sig = saver_read_addr_sig;
            end
        2'd2: begin
                read_addr_sig = deleter_read_addr_sig;
                pwChecker_start_sig = deleter_pwChecker_start_sig;
            end
        2'd3: begin
                read_addr_sig = comparator_read_addr_sig;
                pwChecker_start_sig = comparator_pwChecker_start_sig;
            end
    endcase
end

assign error_sig = error_saver_sig || ~RF_delete_sig;
assign error = error_controller_sig || error_saver_sig;

endmodule