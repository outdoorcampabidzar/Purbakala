# Purbakala Outdoor Camp

Website landing page outdoor camp dengan login/daftar memakai Supabase Auth.

## Cara pakai

1. Buat project baru di [Supabase](https://supabase.com/dashboard).
2. Buka **SQL Editor**, jalankan isi `supabase-schema.sql`.
3. Di **Authentication > Providers**, pastikan Email aktif. Untuk pengujian cepat, Anda bisa mematikan **Confirm email**; untuk produksi biarkan aktif.
4. Buka `app.js`, isi `SUPABASE_URL` dan `SUPABASE_ANON_KEY` dari **Project Settings > API**. Gunakan hanya anon/publishable key, jangan service_role key.
5. Jalankan `index.html` dengan Live Server atau deploy ke Vercel/Netlify.

Fitur yang sudah ada: halaman landing responsif, katalog sewa per item, daftar, masuk, konfirmasi email, sesi login, logout, dan pesan WhatsApp per item.
