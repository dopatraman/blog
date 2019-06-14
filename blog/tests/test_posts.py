"""
PostTest
"""
import json

from django.test import TestCase, RequestFactory
from blog.tests.factories.user import UserFactory
from blog.api.views import create_post, get_all_posts, get_post
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
        p = create_post(request)
        p_json = json.loads(p.content)
        posts = Post.objects.all()
        self.assertEqual(posts.count(), 1)
        self.assertEqual(p_json.get("post_id"), posts.get().id)

    def test_get_all_posts(self):
        request = self.factory.post("/api/create")
        request.user = self.user
        create_post(request)
        request = self.factory.get("/api/")
        response = get_all_posts(request)
        posts = json.loads(response.content)
        self.assertEquals(1, len(posts))
        self.assertEquals(posts.get("posts")[0].get("user").get("id"), self.user.id)

    def test_get_all_posts_none(self):
        request = self.factory.get("/api/")
        response = get_all_posts(request)
        posts = json.loads(response.content)
        self.assertEquals([], posts.get("posts"))

    def test_get_single_post(self):
        request = self.factory.post("/api/create")
        request.user = self.user
        response = create_post(request)
        created_post = json.loads(response.content)
        request = self.factory.get("/api/")
        response = get_post(request, created_post.get("post_id"))
        post = json.loads(response.content)
        self.assertEqual(
            post.get("post").get("content_url"), created_post.get("content_url")
        )
