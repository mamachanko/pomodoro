console.log("Pomodoro");

var Pomodoro = Elm.Pomodoro.fullscreen();

Pomodoro.ports.playSound.subscribe(function(soundFile){
  console.log("playing sound: " + soundFile);
  new Howl({
    src: [soundFile]
  }).play();
});
