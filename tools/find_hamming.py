

lst =[1,2,4,8, 16, 32]
for data in lst:
    lst = []
    for i in range(39):
        if i & data:
            print(i-1, end=" ")
            lst.append(i) 
    print("\t",len(lst)) 

# print(len(lst1))