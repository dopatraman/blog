import os

from django.conf import settings
from django.http import HttpResponse, JsonResponse
from blog.api.models import Post


def get_all_posts(request):
    return JsonResponse({"posts": list(Post.objects.all())})


def get_post(request, post_id):
    return JsonResponse({"post": Post.objects.filter(pk=post_id).first()})


def create_post(request):
    post_content = request.body

    post_content_url = save_post(post_content)

    post = Post.objects.create(user=request.user, content_url=post_content_url)
    post.save()

    return JsonResponse({"post_id": post.id, "content_url": post.content_url})


def save_post(post_content):
    post_title = get_post_title()
    if not os.path.exists(settings.POST_CONTENT_PATH):
        os.makedirs(settings.POST_CONTENT_PATH)
    file_path = f"{settings.POST_CONTENT_PATH}/{post_title}.md"
    with open(file_path, "wb") as f:
        f.write(post_content)
    return file_path


def get_post_title():
    pass
