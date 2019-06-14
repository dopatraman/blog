import os
from uuid import uuid4
from django.conf import settings


class PostStorageService(object):
    def __init__(self):
        pass

    def store_post(self, post_dir: str, post_content: str) -> str:
        self._create_post_dir(post_dir)
        return self._save_post(post_content, post_dir)

    def _save_post(self, post_dir: str, post_content: str):
        post_path: str = f"{post_dir}/{self._get_post_title(post_content)}.md"
        with open(post_path, "wb") as f:
            f.write(post_content.encode())
        return post_path

    def _create_post_dir(self, post_dir: str):
        if not os.path.exists(post_dir):
            os.makedirs(post_dir)

    def _get_post_title(self, post_content: str) -> str:
        return uuid4().__str__()

class PostFormatterService(object):
    pass