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
@api_view(["GET"])
def trial(request):
    if request.method == "GET":
        problems = User.objects.all()
        problems = UserSerializer(problems, many=True).data
        return Response(problems)

@api_view(["POST"])
def recommend(request):
    if request.method == "POST":
        res={}
        res["recommendations"] = ext.recommender(request.data["attr"])

        #print(res)
        return Response(res)
