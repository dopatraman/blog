import factory
from blog.api.models import User

class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = User

    username = factory.Faker('word')
    email = factory.Faker('email')
