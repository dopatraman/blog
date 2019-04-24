from django.test import TestCase, Client
from blog.tests.factories.user import UserFactory
from blog.tests.factories.post import PostFactory

class PostTest(TestCase):
    def setUp(self):
        self.user = UserFactory.create()
        self.post = PostFactory.create(user=self.user)
        self.client = Client()

    def test_get_all_posts(self):
        response = self.client.get("/api/")
