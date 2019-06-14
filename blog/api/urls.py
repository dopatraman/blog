from django.urls import path
from . import views
from .controllers import ApiController

# NOTE: A Controller class  (or something) can export all of these paths. Will
# give the chance for dependency injection (re: storage service)
# urlpatterns = [
#     path("", views.get_all_posts, name="get_all_posts"),
#     path("<int:post_id>", views.get_post, name="get_post"),
#     path("create", views.create_post, name="create_post"),
# ]
urlpatterns = ApiController.export(
    storage_service=(lambda x: x), formatter_service=(lambda x: x)
)
