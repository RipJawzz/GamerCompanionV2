from warnings import catch_warnings
from django.db.models import manager
from django.http.response import JsonResponse
from django.shortcuts import render

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate, login, logout
from MLengine import ext

from .models import *
from .serializers import *

# Create your views here.

@api_view(["PUT"])
def recommend(request):
    if request.method == "PUT":
        res={}
        try:
            id=request.data["firebaseID"]
            res["recommendations"] = ext.recommender(User.objects.get(firebaseID = id).featureArray)
            res["message"]="Success"
            return Response(res,status.HTTP_200_OK)
        except User.DoesNotExist:
            res["message"]="User Not found"
            return Response(res,status.HTTP_404_NOT_FOUND)
        except:
            res["message"]="There was an Error"
            return Response(res,status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(["PUT"])     
def similarUsers(request):
    if request.method == "PUT":
        res={}
        try:
            id=request.data["firebaseID"]
            userData=User.objects.all()
            print(userData)
            ext.collabFiltering(userData)
            res["recommendations"] = []
            res["message"]="Success"
            return Response(res,status.HTTP_200_OK)
        except User.DoesNotExist:
            res["message"]="User Not found"
            return Response(res,status.HTTP_404_NOT_FOUND)
        except Exception as e:
            print(e)
            res["message"]="There was an Error"
            return Response(res,status.HTTP_500_INTERNAL_SERVER_ERROR)
        
@api_view(["PUT"])
def userCreate(request):
    if request.method=="PUT":
        res={}
        res["firebaseID"]=request.data["firebaseID"]
        res["likedGames"]=[]
        res["featureArray"]=[10 for x in range(ext.r-ext.l)]
        serializer = UserSerializer(data=res)
        if serializer.is_valid():
            serializer.save()
            res = serializer.data
            return Response({"message" : "User created"},status.HTTP_200_OK)
        res = serializer.errors
        res["message"] = "Problem Creating user"
        return Response({"message" : "Problem Creating user"}, status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(["PUT"])
def userDelete(request):
    if request.method=="PUT":
        fid = request.data["firebaseID"]
        try:
            rec = User.objects.get(fid)
            print(rec)
            rec.delete()
            return Response({"message" : "Success"},status.HTTP_200_OK)
        except:
            print("Tough Luck")
        return Response({"message" : "LOL"}, status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(["PUT"])
def toggleGamePref(request,op):
    
    if request.method=="PUT":
        try:
            id=request.data["firebaseID"]
            gameId=request.data["gameID"]
            factor=request.data["factor"]
            updUser= User.objects.get(firebaseID = id)
        except User.DoesNotExist:
            return Response(status.HTTP_404_NOT_FOUND)
        res={}
        request.data["firebaseID"]=id  
        request.data["likedGames"]=ext.toggleGame(updUser.likedGames,gameId,op)
        request.data["featureArray"]=ext.updateFeatureArray(updUser.featureArray,factor,gameId,op)
        serializer=UserSerializer(updUser,data=request.data)
        if serializer.is_valid():
            serializer.save()
            res["message"]="User pref updated"
            return Response(res,status.HTTP_200_OK)
        
        res=serializer.errors
        res["message"]="There was an error updating user pref"
        return Response(res, status.HTTP_400_BAD_REQUEST)

@api_view(["GET"])
def gameDesc(request):
    if request.method=="GET":
        res={}
        res["data"]=ext.gameDesc()
        return Response(res,status.HTTP_200_OK)