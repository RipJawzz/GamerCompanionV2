from django.contrib.auth.models import AbstractUser
from django.db import models
from django.contrib.postgres.fields import ArrayField

# Create your models here.
class User(models.Model):
    firebaseID = models.TextField(primary_key=True)
    liked = models.TextField()
    featureArray = ArrayField(
        models.IntegerField(),
        max_length=8
    )
    