console.log("Pomodoro");

var Pomodoro = Elm.Pomodoro.fullscreen();

Pomodoro.ports.playSound.subscribe(function(soundFile){
  console.log("playing sound: " + soundFile);
  playSound(soundFile);
});

Pomodoro.ports.requestPermissions.subscribe(function(){
  console.log("requesting notification permission");
  Notification.requestPermission().then(
      function(permission) {
        console.log("received permission: " + permission)
      }
  );
});

Pomodoro.ports.triggerNotification.subscribe(function(message){
  console.log("triggering notification");
  new Notification(message);
});

function playSound(soundFile) {
  let playbackCounter = 0;
  let numberOfPlaybacks = 3;

  var howl = new Howl({
    src: [soundFile],
    loop: true,
    autoplay: true,
    onend: function() {
      playbackCounter++;
      if (playbackCounter === numberOfPlaybacks - 1) {
        howl.loop(false);
      }
    }
  });
}
