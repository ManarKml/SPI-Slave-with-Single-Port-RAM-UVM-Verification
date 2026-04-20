module slave_gm (tx_data,tx_valid,SS_n,MOSI,MISO,rx_data,rx_valid,clk,rst_n);
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b100;

input [7:0] tx_data;
input tx_valid,SS_n,MOSI,clk,rst_n;
output reg MISO,rx_valid;
output reg [9:0] rx_data;

reg [4:0] counter;
reg flag;
reg[2:0] cs,ns;       
////////////////////counter////////////////////////
always @ (posedge clk ) begin
    if (~rst_n)
    counter<=0;
    else begin 
    if (cs==READ_ADD || cs==WRITE)
     counter <= (counter == 10) ? 0 : counter + 1;
    else if (cs==READ_DATA)
     counter <= (counter == 20) ? 0 : counter + 1;
    else counter<=0; 
    end
end
/////////////////////////FSM/////////////////////////
always @ (posedge clk) begin
    if(~rst_n)
    cs<=IDLE;
    else 
    cs<=ns;
end
/////
always@(posedge clk) begin
     if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        flag <= 0;
        MISO <= 0;
    end
    else begin
    case(cs)
    IDLE: 
    begin 
      {rx_valid}<=0; 
    end
    CHK_CMD: 
    begin
      {rx_valid}<=0;
    end 
    READ_DATA: begin
        if (counter<10) rx_data[9 - counter] <= MOSI;
        if (counter == 10) begin
            rx_valid <=1; end 
        if (tx_valid && counter !=20) begin
            rx_valid <=0;
            MISO <= tx_data[19 - counter]; 
        end
        if (counter == 20) begin flag <=0;
        
        end
    end
    READ_ADD: begin
          if (counter<10) rx_data[9-counter] <= MOSI;
        if (counter == 10) begin
             rx_valid <= 1;
             flag <=1;
            end
        else rx_valid <=0;
    end
    WRITE:begin  
          if (counter<10) rx_data[9-counter] <= MOSI;
        if (counter == 10) begin
             rx_valid <= 1;
            end
        else rx_valid <=0;
    end
    default : {MISO,rx_valid,rx_data}<=0; 
    endcase
    end
end
////
always@(*) begin
    case(cs)
    IDLE: 
    begin 
     if(~SS_n) ns=CHK_CMD;  else ns=IDLE;
     end
    CHK_CMD: 
    begin
        if(SS_n) ns=IDLE;
        else begin 
        if(MOSI) begin
         if (flag) begin ns = READ_DATA; end 
         else begin ns = READ_ADD; end
        end
        else ns=WRITE;
        end
    end 
    READ_DATA: begin
        if(SS_n) ns=IDLE; 
        else ns=READ_DATA; 
    end
    READ_ADD: begin
    if(SS_n) ns=IDLE; 
    else ns=READ_ADD;
    end
    WRITE:begin 
    if(SS_n) ns=IDLE; 
    else ns=WRITE;
    end
    default : ns=IDLE; 
    endcase
end
endmodule
