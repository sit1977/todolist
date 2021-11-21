from django.shortcuts import render
from django.http import JsonResponse, response
from rest_framework.response import Response
from rest_framework.decorators import api_view  
from rest_framework import serializers, status
from .serializers import TodolistSerializer
from .models import Todolist

#GET DATA
@api_view(['GET','POST'])
def all_todolist(request):
    alltodolist = Todolist.objects.all() #ดึงข้อมูลทั้งหมดจาก model todolist
    serializer = TodolistSerializer(alltodolist,many=True)
    response = Response(serializer.data,status=status.HTTP_200_OK)
    response['Content-Type']='application/json; charset=UTF-8'
    #response['Access-Control-Allow-Origin']='*'
    #response['Access-Control-Allow-Credentials']='true'
    #response['Access-Control-Allow-Headers']='Access-Control-Allow-Origin, Accept'
    #response['Access-Control-Allow-Methods']='GET, POST, OPTIONS'
    return response

#POST DATA (save to database)
@api_view(['POST'])
def post_todolist(request):

    if request.method == 'POST':
        serializer = TodolistSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_201_CREATED )
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

#DELETE
@api_view(['DELETE'])
def delete_todolist(request,tid):
    if request.method == 'DELETE': 
        todo = Todolist.objects.get(id=tid)
        if todo :
            #serializer = TodolistSerializer(data)
            delete = todo.delete()
            if delete:
                OK={
                    'status' : 'Deleted',
                }
                STATUS=status.HTTP_200_OK
            else:
                OK={
                    'status' : 'Fail',
                 }
                STATUS=status.HTTP_400_BAD_REQUEST
            return Response(OK,status=STATUS)    


#GET DELETE
@api_view(['GET'])
def delete_todolist_query(request):
    _id = request.query_params.get('id')
    try:
     data = Todolist.objects.get(id=_id)
    except:
        return Response("Not Data",status=status.HTTP_404_NOT_FOUND)   
    if data :
        serializer = TodolistSerializer(data)
        old = serializer.data
        data.delete()
        OK={
            'status' : 'Deleted', 
             'data' : old
        }
        return Response(OK,status=status.HTTP_200_OK)    

#PUT UPDATE
@api_view(['PUT'])
def update_todolist(request,tid):
    if request.method == 'PUT': #PUT
        todo = Todolist.objects.get(id=tid)
        if todo:
            ##กำหนดการเปลี่ยนเอง
            #todo.title = request.data['title']
            #todo.detail =  request.data['detail']
            #todo.save()

            ##กำหนดการเปลีย่นแปลง
            serializer = TodolistSerializer(todo,data=request.data)
            if serializer.is_valid():
                serializer.save()
                OK ={
                    'status' : 'Updated', 
                    }
            else:
                OK ={
                    'status' : serializer.error_messages, 
                 }
        return Response(OK,status=status.HTTP_200_OK)
            
    return Response("Not Data",status=status.HTTP_404_NOT_FOUND) 
 


@api_view(['POST'])
def update_todolist_query(request):
    try:
        _id = request.query_params.get('id')
        if request.method == 'POST':
             try:
                 data = Todolist.objects.get(id=_id)
                 if data:
                    serializer = TodolistSerializer(data)
                    old = serializer.data
                    data.title = request.data['title'] 
                    data.detail =  request.data['detail']
                    serializer = TodolistSerializer(data)
                    new =  serializer.data
                    data.save()
                    OK ={
                        'message' : 'update ok', 
                        'old' : old , 
                        'new' : new 
                    }
                    return Response(OK,status=status.HTTP_200_OK)    
             except:
                 return Response("Not Data",status=status.HTTP_404_NOT_FOUND)   
    except:
        return Response('id not data',status=status.HTTP_400_BAD_REQUEST)

    pass

#data = {'message':'hello world'}
data = [
    {
        "title":"กระเทียมต้น",
        "title1":"Allium",
        "detail":"กระเทียมต้นเป็นพืชในตระกูลกระเทียมและหัวหอม มีดอกที่มีกลิ่นหอม โดยปกติแล้วจะมีดอกสีม่วงและสีขาว ช่วยเพิ่มสีสันให้กับสวนได้เป็นอย่างดี",
        "image":"https://raw.githubusercontent.com/sit1977/Flutter2MobileAppBootcamp/main/layout/assets/images/allium_01.png"
    }, 
    {
        "title":"บีโกเนีย",
        "title1":"Begonia",
        "detail":"บีโกเนียนั้นต้นมีขนาดเล็กเหมาะสำหรับปลูกเป็นพืชคลุมดิน เป็นไม้กระถาง หรือ ไม้ในภาชนะแขวนก็ได้ ดอกมีสีสันสวยสด",
        "image":"https://raw.githubusercontent.com/sit1977/Flutter2MobileAppBootcamp/main/layout/assets/images/begonia.png"
    },
    {
        "title":"แบล็คอายซูซาน",
        "title1":"Black-Eyed Susans",
        "detail":"เป็นพืชพื้นเมืองภาคตะวันออกและภาคกลางของสหรัฐอเมริกา เป็นไม้พุ่มเช่นเดียวกับดาวกระจาย ดอกมีสีเหลืองเจิดจ้า เกสรเป็นลูกกลมสีน้ำตาลดำเข้มเหมือนดวงตา",
        "image":"https://raw.githubusercontent.com/sit1977/Flutter2MobileAppBootcamp/main/layout/assets/images/Black-Eyed-Susans.png"
    }
    ,
    {
        "title":"เฟื่องฟ้า",
        "title1":"Bougainvillea",
        "detail":"ดอกของเฟื่องฟ้ามีขนาดเล็ก ในแต่ละพันธุ์ก็มีสีสันแตกต่างกันไป เช่น สีชมพู สีม่วง ใบประดับของเฟื่องฟ้ามีลักษณะคล้ายรูปหัวใจหรือรูปไข่",
        "image":"https://raw.githubusercontent.com/sit1977/Flutter2MobileAppBootcamp/main/layout/assets/images/Bougainvillea.png"
    }
    ,
    {
        "title":"เคล็มแม็ททิส",
        "title1":"Clematis",
        "detail":"เป็นไม้เถาขนาดเล็ก มีถิ่นกำเนิดอยู่ในแถบเอเชียตะวันออกเฉียงใต้ เดิมเป็นไม้เถาธรรมดา พบได้ตามป่าไม้ผลัดใบและป่าดิบใกล้ลำห้วยในแถบที่ราบสูง สีดอกออกม่วงอ่อน",
        "image":"https://raw.githubusercontent.com/sit1977/Flutter2MobileAppBootcamp/main/layout/assets/images/Clematis.png"
    },
    {
        "title":"ฤๅษีผสม",
        "title1":"Coleus",
        "detail":"ใบมีสีสันและรูปทรงหลากหลาย จึงเหมาะกับการนำมาใช้ประดับสวนได้ทุกสไตล์ ถ้าปลูกเลี้ยงในที่อากาศเย็นสีจะสวยมาก ทั้งยังปลูกในกระถางขนาดกะทัดรัดใช้ตกแต่งบ้านได้ดี",
        "image":"https://raw.githubusercontent.com/sit1977/Flutter2MobileAppBootcamp/main/layout/assets/images/Coleus.png"
    },
    {
        "title":"คอร์นฟลาวเวอร์",
        "title1":"Coneflower",
        "detail":"เป็นไม้พุ่มขนาดเล็ก มีกลีบดอกสีม่วงสดใสรูปร่างเป็นทรงกรวย ดอกจะบานยาวในช่วงปลายเดือนมิถุนายนถึงสิงหาคมซึ่งเป็นช่วงฤดูร้อน",
        "image":"https://raw.githubusercontent.com/sit1977/Flutter2MobileAppBootcamp/main/layout/assets/images/Coneflower.png"
    }

]

def Home(request):
    return JsonResponse(data=data,safe=False,json_dumps_params={'ensure_ascii':False})