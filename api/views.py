from rest_framework import viewsets
from rest_framework.response import Response

from .models import Student, Subject
from .serializers import *

class StudentViewSet(viewsets.ViewSet):
    def list(self, request):
        students = Student.objects.all()[:10]
        serializer = StudentSerializer(students, many=True)
        return Response(serializer.data)
class SubjectViewSet(viewsets.ViewSet):
    def list(self, request):
        subject = Subject.objects.all()
        serializer = SubjectSerializer(subject, many=True)
        return Response(serializer.data)
