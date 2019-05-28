file = open("11.txt", "r")  
all_lines = file.readlines()  
  
for line in all_lines:  
    print(eval(line)) 
  
file.close()  
