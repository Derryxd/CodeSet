
import os
import sys

def DepthTraversal(nowDir, p):
    # 根据目录建立列表
    baseName = os.path.basename(nowDir)
    c = [baseName]
    p.append(c)

    ls = os.listdir(nowDir)
    for each in ls:
        nextPath = nowDir + os.sep + each
        nextPath_basename = os.path.basename(nextPath)
        if os.path.isdir(nextPath):
            DepthTraversal(nextPath, c)
        else:
            nextPath_basename = os.path.basename(nextPath)
            p.append(nextPath_basename)

def tree(lst):
    # 树状图输出列表
    l = len(lst)
    if l == 0:
        print('─' * 3)
    else:
        for i, j in enumerate(lst):
            if i != 0:
                #f.write(tabs[0])
                print(tabs[0], end='')
            if l == 1:
                s = '─' * 3
            elif i == 0:
                s = '┬' + '─' * 2
            elif i + 1 == l:
                s = '└' + '─' * 2
            else:
                s = '├' + '─' * 2
            #f.write(s)
            print(s, end='')
            if isinstance(j, list) or isinstance(j, tuple):
                if i + 1 == l:
                    tabs[0] += blank[0] * 3
                else:
                    tabs[0] += '│' + blank[0] * 2
                tree(j)
            else:
                print(j)
                #f.write(j + "\n")
    tabs[0] = tabs[0][:-3]


if __name__ == '__main__':
    try:
        path = os.path.abspath(sys.argv[1])
    except IndexError:
        print("请赋予绝对路径参数")
        exit()
    #f = open("out", 'w')
    TreeList = []
    DepthTraversal(path, TreeList)
    blank = [
        chr(183)]  ##此处为空格格式;Windows控制台下可改为chr(12288) ;linux系统中可改为chr(32)【chr(32)==' ' ;chr(183)=='·' ;chr(12288)=='　'】
    tabs = ['']
    tree(TreeList)
