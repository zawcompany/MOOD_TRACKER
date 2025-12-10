importScripts('https://www.gstatic.com/firebasejs/9.1.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.1.0/firebase-messaging-compat.js');

const firebaseConfig = {
    apiKey: 'AIzaSyCqCJbQldZKJDD1xrWiTMOCSYeTQyJpAjM',
    appId: '1:218608586742:web:b55a1ec6663232708f41d7',
    messagingSenderId: '218608586742',
    projectId: 'mood123tracker',
    authDomain: 'mood123tracker.firebaseapp.com',
    storageBucket: 'mood123tracker.firebasestorage.app'
};

const app = firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: '/icons/Icon-192.png'
    };

    return self.registration.showNotification(notificationTitle, notificationOptions);
});