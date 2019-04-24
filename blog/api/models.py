from django.contrib.auth.models import AbstractUser
from django.db import models

# Create your models here
class BaseModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class User(AbstractUser):
    username = models.CharField(max_length=255, unique=True)
    email = models.EmailField(unique=True, null=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class Post(BaseModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    content_url = models.URLField(null=False)
