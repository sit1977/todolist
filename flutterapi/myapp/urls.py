from django.urls import path
from .views import *
#from .views import Home, all_todolist

urlpatterns = [
    path('',Home),
    path('api/all-todolist/',all_todolist),
    path('api/create-todolist',post_todolist),
    path('api/delete-todolist/<int:tid>',delete_todolist),
    path('api/update-todolist/<int:tid>',update_todolist),
]
