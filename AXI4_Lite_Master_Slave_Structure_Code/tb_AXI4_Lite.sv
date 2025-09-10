`timescale 1ns / 1ps


module tb_AXI4_Lite();
    // Global Signals
    logic        ACLK;
    logic        ARESETn;
    // Write Transcation, AW Channel
    logic [ 3:0] AWADDR;
    logic        AWVALID;
    logic        AWREADY;
    // Write Transcation, W Channel
    logic [31:0] WDATA;
    logic        WVALID;
    logic        WREADY;
    // Write Transcation, B Channel
    logic [ 1:0] BRESP;
    logic        BVALID;
    logic        BREADY;
    // Read Transcation, AR Channel
    logic [ 3:0] ARADDR;
    logic        ARVALID;
    logic        ARREADY;
    // Read Transcation, R Channel
    logic [31:0] RDATA;
    logic        RVALID;
    logic        RREADY;
    logic [ 1:0] RRESP;
    // Internal Signals
    logic [ 3:0] addr;
    logic        write;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic        transfer;
    logic        ready;

AXI4_Lite_Master dut_master(.*
);

AXI4_Lite_Slave dut_slave(.*);

always #5 ACLK = ~ACLK;

initial begin
    ACLK = 1'b1;
    ARESETn = 1'b0;
    #10;
    ARESETn = 1'b1;
end

task  axi_write(input logic [3:0] axi_addr, input logic [31:0] axi_wdata);
    @(posedge ACLK);
    addr = axi_addr;
    write = 1'b1;
    wdata = axi_wdata;
    transfer = 1'b1;
    @(posedge ACLK);
    transfer = 0;
    wait(ready);
endtask 

task  axi_read(input logic [3:0] axi_addr);
    @(posedge ACLK);
    addr = axi_addr;
    write = 1'b0;
    wdata = 0;
    transfer = 1'b1;
    @(posedge ACLK);
    transfer = 0;
    wait(ready);
endtask 

initial begin
    repeat(3) @(posedge ACLK);
    axi_write(4'h0, 1);
    axi_write(4'h4, 2);
    axi_write(4'h8, 3);
    axi_write(4'hc, 4);
    axi_read(4'h0);
    axi_read(4'h4);
    axi_read(4'h8);
    axi_read(4'hc);
    #20 $finish;
end
endmodule
