importScripts("https://www.gstatic.com/firebasejs/9.22.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyB-dPsQE2hm-FHHbOjgertF6ugyfQJ__1g",
  authDomain: "admainnotification.firebaseapp.com",
  projectId: "admainnotification",
  storageBucket: "admainnotification.firebasestorage.app",
  messagingSenderId: "12204011046",
  appId: "1:12204011046:web:7ffb09d506daf8ab5fc0e7",
  measurementId: "G-17TLCWF47T"
});

const messaging = firebase.messaging();

// معالجة الرسائل في الخلفية
messaging.onBackgroundMessage((payload) => {
  console.log("📩 [firebase-messaging-sw.js] إشعار Background:", payload);
  console.log("📩 رسالة في الخلفية:", payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/firebase-logo.png",
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

