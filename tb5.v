module tb5();
    reg rst;
    memory mem(rst);
    initial begin
        #20
        rst = 1;
    end
endmodule