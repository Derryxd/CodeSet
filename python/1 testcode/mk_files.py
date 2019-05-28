import os
 
for i in range(1, 21):
 
    dir_Name = r'E:\360data\重要数据\桌面\file\py\File'+str(i)+'/'
    os.makedirs(dir_Name)
    '''r表示不转义，使用真实字符 '''
    for j in range(1, 4):
        fileName = r'E:\360data\重要数据\桌面\file\py\File'+str(i)+'/'+'text'+str(j)+'.txt'
        f = open(fileName,'w')
        f.close()
 
    for j in range(1, 21):
        fileName = r'E:\360data\重要数据\桌面\file\py\File'+str(i)+'/'+str(j)+'text.txt'
        f = open(fileName,'w')
        f.close()
