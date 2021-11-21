from django.db import models

#เพิ่ม class models เสร็จต้องไปเพิ่มที่หน้า admin.py ด้วย
class Todolist(models.Model):
    #ชื่อ Field = ประกาศชนิดข้อมูล
    title = models.CharField(max_length=100)
    detail = models.TextField(null=True, blank=True)

    def __str__(self):
        return self.title