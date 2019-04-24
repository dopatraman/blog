from django.conf import settings
from django.http import HttpResponse, JsonResponse
from blog.api.models import Post

def get_all_posts(request):
    return JsonResponse({"posts": list(Post.objects.all())})

def get_post(request, post_id):
    return JsonResponse({"post": Post.objects.filter(pk=post_id).first()})

def create_post(request):
    print("CREATE POST", request.POST)
    return HttpResponse()