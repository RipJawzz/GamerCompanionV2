from django.urls import path
from django.urls.resolvers import URLPattern
from . import views

urlpatterns = [
    path("recommend",views.recommend),
    path("game_desc",views.gameDesc),
    path("addUser",views.userCreate),
    path("toggle_game_pref/<str:op>",views.toggleGamePref),
    path("similar_users",views.similarUsers)
]
