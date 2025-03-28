from django.urls import path
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'students', views.StudentViewSet, basename="students")
router.register(r'subjects', views.SubjectViewSet, basename="subjects")

urlpatterns = router.urls  # Assign router-generated URLs directly

