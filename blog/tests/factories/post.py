import factory
from blog.api.models import Post
from .user import UserFactory

class PostFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Post

    user = factory.SubFactory(UserFactory)
    content_url = factory.Faker('url')
