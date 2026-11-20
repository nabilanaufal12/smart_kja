#!/usr/bin/env bash
# ==============================================================================
# SMART KJA - GitHub Upload Automation Script
# Pengembang: Nabil Ali Naufal (github.com/nabilanaufal12)
# ==============================================================================

set -e

REPO_URL="https://github.com/nabilanaufal12/smart_kja.git"
PROJECT_DIR="/home/mizuuu/develop/smart_kja"

echo "🌊 Menyiapkan upload source code SMART KJA ke GitHub..."
cd "$PROJECT_DIR"

# 1. Inisialisasi Git jika belum ada
if [ ! -d ".git" ]; then
    echo "📦 Menginisialisasi Git repository..."
    git init
fi

# 2. Setup identitas Git lokal (jika belum diset secara global)
if [ -z "$(git config user.name)" ]; then
    git config user.name "Nabil Ali Naufal"
fi
if [ -z "$(git config user.email)" ]; then
    git config user.email "nabilxmia@gmail.com"
fi

# 3. Pastikan branch utama bernama main
git branch -M main 2>/dev/null || true

# 4. Tambahkan file source code (file build dan berkas luar otomatis diabaikan)
echo "📁 Menambahkan berkas source code aplikasi..."
git add .

# 5. Commit
echo "💾 Melakukan commit berkas..."
git commit -m "feat: initial commit SMART KJA aquaculture monitoring mobile app" || echo "Semua perubahan sudah ter-commit."

# 6. Konfigurasi Remote
echo "🔗 Mengatur remote origin: $REPO_URL..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

# 7. Push ke GitHub
echo "🚀 Mengunggah ke GitHub (branch: main)..."
echo "Catatan: Jika diminta login, masukkan Username (nabilanaufal12) dan Personal Access Token (PAT) GitHub Anda."
git push -u origin main

echo "✅ Berhasil diunggah ke $REPO_URL!"
