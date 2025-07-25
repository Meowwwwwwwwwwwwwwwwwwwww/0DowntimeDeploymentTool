from django.http import JsonResponse
import os

def health_check(request):
    return JsonResponse({
        "status": "running",
        "version": os.getenv("VERSION", "unknown")
    })
