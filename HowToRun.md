Jika test pakai HP Fisik usahakan hp dan laptop menggunakan wifi/internet yang sama.

pada folder lib/service/api_service.dart, cari:

static const String baseUrl =
    "http://192.168.0.177:8000";

Ganti bagian "http://192.168.0.177:8000"; mejadi ip laptop, contoh "http://IPLAPTOP:8000";

Diterimanl powershell masuk dulu ke dalam folder project. lalu jalankan ini:
python -m uvicorn app:app --host 0.0.0.0 --port 8000
---- tunggu sampai keluar info bahwa fastAPi berjalan ----

lalu lakukan "flutter run" di terminal pada vscode.