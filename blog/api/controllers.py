import os

from django.urls import path
from django.conf import settings
from django.http import HttpResponse, JsonResponse

from blog.api.models import Post

class ApiController(object):

    @staticmethod
    def export(**deps):
        ctrl = ApiController(**deps)
        return [
            path("", ctrl.get_all_posts, name="get_all_posts"),
            path("<int:post_id>", ctrl.get_post, name="get_post"),
            path("create", ctrl.create_post, name="create_post"),
        ]

    def __init__(self, **deps):
        self.deps = deps

    def get_all_posts(request):
        posts = Post.objects.all()
        posts = map(lambda post: post.json(), posts)
        return JsonResponse({"posts": list(posts)})


    def get_post(request, post_id):
        return JsonResponse({"post": Post.objects.filter(pk=post_id).first().json()})


    def create_post(request):
        post_content_url = save_post(request.body)
        post = Post.objects.create(user=request.user, content_url=post_content_url)
        post.save()

        return JsonResponse({"post_id": post.id, "content_url": post.content_url})


    def save_post(post_content):
        post_title = get_post_title(post_content)
        if not os.path.exists(settings.POST_CONTENT_PATH):
            os.makedirs(settings.POST_CONTENT_PATH)
        file_path = f"{settings.POST_CONTENT_PATH}/{post_title}.md"
        with open(file_path, "wb") as f:
            f.write(post_content)
        return file_path


    def get_post_title(post_content):
        pass
