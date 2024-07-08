import random

random.seed(10)

for i in range(10):
    da = random.randint(0,15)
    prior = random.randint(0,7)
    len = random.randint(64,1024)
    wait_cnt = random.randint(0, 1024) 
    print( f"mem[{i}]" + "= {{(DATA_WIDTH-'d27){1'b0}},"+ f" 10'd{wait_cnt}, 10'd{len}, 3'd{prior}, 4'd{da} " + "};" )