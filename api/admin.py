
from django.contrib import admin
from .models import Student, Subject

@admin.register(Student)
class StudentAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'program')  # Customize columns in the admin panel
    search_fields = ('name', 'program')  # Enable search functionality

@admin.register(Subject)
class SubjectAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'academic_year')
    search_fields = ('name', 'academic_year')
