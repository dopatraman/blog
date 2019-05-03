"""
PostTest
"""
from django.test import TestCase, RequestFactory
from blog.tests.factories.user import UserFactory
from blog.api.views import create_post
from blog.api.models import Post


class PostTest(TestCase):
    """
    Tests for post controller
    """

    def setUp(self):
        self.user = UserFactory.create()
        self.factory = RequestFactory()

    def test_create_post(self):
        request = self.factory.post("/api/create")
        request.user = self.user
        create_post(request)
        posts = Post.objects.all()
        self.assertEqual(posts.count(), 1)
