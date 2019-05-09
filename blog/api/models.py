from django.contrib.auth.models import AbstractUser
from django.db import models

# Create your models here
class JsonableModel(object):
    def __json__(self):
        fields = self._meta.fields
        json = {}
        for field in fields:
            key = field.name
            value = self.__getattribute__(key)
            json[key] = value.json() if isinstance(value, JsonableModel) else value
        return json

    def json(self):
        return self.__json__()


class BaseModel(models.Model, JsonableModel):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class User(AbstractUser, BaseModel):
    username = models.CharField(max_length=255, unique=True)
    email = models.EmailField(unique=True, null=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class Post(BaseModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    content_url = models.URLField(null=False)
