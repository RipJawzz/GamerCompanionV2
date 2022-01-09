from django.contrib.auth.models import AbstractUser
from django.db import models
from django.contrib.postgres.fields import ArrayField
from numpy import empty

# Create your models here.
class User(models.Model):
    firebaseID = models.TextField(primary_key=True)
    likedGames = ArrayField(
        models.IntegerField(),
        blank=True,
        null=False,
    )
    featureArray = ArrayField(
        models.FloatField(),
        null=False
    )
    