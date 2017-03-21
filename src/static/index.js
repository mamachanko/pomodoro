console.log("Pomodoro");

var Pomodoro = Elm.Pomodoro.fullscreen();

Pomodoro.ports.playSound.subscribe(function(soundFile){
  console.log("playing sound: " + soundFile);
  playSound(soundFile);
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
