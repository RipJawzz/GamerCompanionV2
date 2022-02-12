import numpy as np
l = 2
r = 64
def recommender(user):    
    global l,r
    file=open("./MLengine/gamedata.npy","rb")
    mat=np.load(file,allow_pickle=True)
    user = np.array(user)
    scores = np.sum(((mat[:, 1:] - user) ** 2), axis=1).reshape(mat.shape[0], 1)
    scores = np.column_stack(( mat[:,0].reshape(mat.shape[0], 1),scores))
    scores = scores[scores[:, 1].argsort()]
    return scores

def collabFiltering(userData):
    for i in userData:
        print(i.firebaseID)

def updateFeatureArray(arr,factor,id,op):
    global l,r
    file=open("./MLengine/gamedata.npy","rb")
    mat=np.load(file,allow_pickle=True)
    arr = np.array(arr)
    if op=='+':
        arr=arr*((100-factor)/100)+mat[id-1,1:]*factor/100
    #elif op=='-':
    #    factor=factor/3
    #    arr=(arr-mat[id-1,1:]*factor/100)/((100-factor)/100)
    return arr

def toggleGame(arr,id,op):
    if op=='-' and id in arr:
        arr.remove(id)
    elif op=='+' and id not in arr:
        arr.append(id)
    return arr

def gameDesc():
    file=open("./MLengine/gamedesc.npy","rb")
    mat=np.load(file,allow_pickle=True)
    return mat