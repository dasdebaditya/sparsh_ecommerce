importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyBRobgZqIC-dFsr05MzxUQXxQITjKpnDH0",
  authDomain: "sparsh-e420c.firebaseapp.com",
  projectId: "sparsh-e420c",
  storageBucket: "sparsh-e420c.appspot.com",
  messagingSenderId: "151590191214",
  appId: "1:151590191214:web:4e7582ed290b4f60a5667f",
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});