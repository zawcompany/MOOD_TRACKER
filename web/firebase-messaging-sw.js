// firebase-messaging-sw.js

// Import library Service Worker FCM
importScripts('https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js');

// Konfigurasi Firebase Anda (salin dari index.html)
const firebaseConfig = {
    apiKey: "AIzaSyCqCJbQldZKJDD1xrWiTMOCSYeTQyJpAjM",
    authDomain: "mood123tracker.firebaseapp.com",
    projectId: "mood123tracker",
    storageBucket: "mood123tracker.firebasestorage.app",
    messagingSenderId: "218608586742",
    appId: "1:218608586742:web:68f2e9759b6b4d8e8f41d7"
};

// Inisialisasi Firebase di dalam Service Worker
firebase.initializeApp(firebaseConfig);

// Tangani pesan notifikasi di latar belakang
const messaging = firebase.messaging();
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message: ', payload);

    // Ambil data notifikasi
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: '/favicon.png', // Pastikan ikon ini dapat diakses
        // Tambahkan data agar dapat diakses saat notifikasi diklik (opsional)
        data: payload.data
    };

    // Tampilkan notifikasi
    return self.registration.showNotification(notificationTitle, notificationOptions);
});