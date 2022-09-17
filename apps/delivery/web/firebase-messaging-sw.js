importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
      apiKey: "AIzaSyBKDk9aqNBON-PcDuahYV89cDXu3jepWj4",
      authDomain: "bottleshop-3-veze-dev-54908.firebaseapp.com",
      projectId: "bottleshop-3-veze-dev-54908",
      storageBucket: "bottleshop-3-veze-dev-54908.appspot.com",
      messagingSenderId: "525277285012",
      appId: "1:525277285012:web:bad81f5d913e78c20ec281",
      measurementId: "G-02K3SVS600"
});
const messaging = firebase.messaging();
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
