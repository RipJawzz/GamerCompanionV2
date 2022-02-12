import numpy as np
import pandas as pd
import pickle
import ext

l = ext.l
r = ext.r
user = np.zeros(shape=(1, r - l),dtype=float)

data="./gamedata.npy"
desc="./gamedesc.npy"
source="./gameData.csv"

def exploreRaw():
    df = pd.read_csv(source, header=0)
    print(df)
    mat = df.to_numpy()
    print(mat)

def convert():
    df = pd.read_csv(source, header=0)
    mat = df.to_numpy() 
    file=open(desc,"wb")
    np.save(file,mat[1:,:l+1])
    print(mat[1:,:l+1])
    file=open(data,"wb")
    np.save(file,mat[1:,l:].astype(float))
    print(mat[1:,l:])

def saveTags():
    df = pd.read_csv(source)
    mat = df.to_numpy() 
    print(mat)
    for i in range(1,mat.shape[0]):
        tag=""
        for itr in range(l+1,mat.shape[1]):
                if mat[i][itr]=='10':
                    tag+='|'+mat[0][itr]
        #df.loc[:,("Tags",i)]=tag[1:]
        df["Tags"][i]=tag[1:]
    df.to_csv(source,index=False)

def select():
    global user
    file=open(desc,"rb")
    mat=np.load(file,allow_pickle=True)
    print(mat[:, :])
    file=open(data,"rb")
    mat=np.load(file,allow_pickle=True)
    selection = int(input())-1
    user = user * 0.9 + mat[selection, 1:] * 0.1


def iniUser():
    global user
    file=open(desc,"rb")
    mat=np.load(file,allow_pickle=True)
    print(mat[:, :])
    print("select several games to begin with")
    ips = input().strip().split(" ")
    file=open(data,"rb")
    mat=np.load(file,allow_pickle=True)
    for i in ips:
        user = user + mat[int(i)-1, 1:]
    user /= len(ips)

def recommend():
    file=open(data,"rb")
    mat=np.load(file,allow_pickle=True)
    scores = np.sum(((mat[:, 1:] - user) ** 2), axis=1).reshape(mat.shape[0], 1)
    scores = np.column_stack(( mat[:,0].reshape(mat.shape[0], 1),scores))
    scores = scores[scores[:, 1].argsort()]
    print(scores)



while True:
    ip = input("Enter operation: 1,end : 2,recommend : 3,select : 4,Convert : 5,iniUser : 6,exploreRaw show stats : 7,save Tags\n")
    if ip == "1":
        break
    elif ip == "2":
        recommend()
    elif ip == "3":
        select()
    elif ip == "4":
        convert()
    elif ip=="5":
        iniUser()
    elif ip=='6':
        exploreRaw()
    elif ip=='7':
        saveTags()
    else:
        print(user)
