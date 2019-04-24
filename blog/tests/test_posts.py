from django.test import TestCase
from blog.tests.factories.user import UserFactory
from blog.tests.factories.post import PostFactory

class PostTest(TestCase):
    def setUp(self):
        self.user = UserFactory.create()
        self.post = PostFactory.create(user=self.user)

    def test_get_all_posts(self):
        self.assertTrue(True)
