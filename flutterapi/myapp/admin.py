from django.contrib import admin
from .models import Todolist

#models.py -> admin.py
# เป็นการลงทะเบียน model ไว้ในส่วน Admin , เมื่อมีการเปลียนแปลงต้องทำ Migrate python manage.py makemigrations
# และพิมพ์ python manage.py migrate

#admin.site.register(Todolist)  เป็นการไม่แสดงในหน้า admin
admin.site.register(Todolist) 


