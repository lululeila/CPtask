from django.db import models

# Create your models here.
class Student(models.Model):
    name = models.CharField(max_length=255)
    program = models.CharField(max_length=255)


class Subject(models.Model):
    name = models.CharField(max_length=255)
    academic_year=models.CharField(max_length=255)
