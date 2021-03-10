module memory(rst);
    input rst;
    reg[31:0] main_memory[0:32000];
    reg[131:0] cache[0:1024];//size of every line in cache is 132 (4*32(4words) + 3(tag) + 1(valid))
    reg[14:0] adr;//10 bits index + 2 bits wordoffset + 3 bits tag
    real hit;
    real miss;
    reg [1:0] word_offset;//4 words
    reg[9:0] index;//1k lines in cache
    reg[2:0] tag;// (32/4)
    reg valid;
    always@(posedge rst)begin
        if (rst) $readmemb("main_memory.txt",main_memory);//enter main memory file name
        if (rst) $readmemb("cache.txt",cache);//enter cache file name
        hit = 0;
        miss = 0;
        for (adr = 1024 ;adr < 9216; adr = adr + 1)begin
            word_offset = adr[1:0];
            index = adr[11:2];
            tag = adr[14:12] ;
            valid = cache[index][131];
            if (valid == 1'b0)begin
                cache[index][131] = 1'b1;
                cache[index][130:128] = tag;
                cache[index][127:96] = main_memory[adr - word_offset];
                cache[index][95:64] = main_memory[adr - word_offset + 1];
                cache[index][63:32] = main_memory[adr - word_offset + 2];
                cache[index][31:0] = main_memory[adr - word_offset + 3];
                miss = miss + 1;
            end 
            
            else begin
              if (cache[index][130:128] == tag) hit = hit + 1;
              else begin
                cache[index][130:128] = tag;
                cache[index][127:96] = main_memory[adr - word_offset];
                cache[index][95:64] = main_memory[adr - word_offset + 1];
                cache[index][63:32] = main_memory[adr - word_offset + 2];
                cache[index][31:0] = main_memory[adr - word_offset + 3];
                miss = miss + 1;
              end

            end

        end
        $display("number of hits   %d",hit );
        $display("hit rate percent  %f",hit * 100/(hit+miss));
    end


endmodule
