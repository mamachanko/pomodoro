console.log("Pomodoro");

var Pomodoro = Elm.Pomodoro.fullscreen();

var sound = new Howl({
  src: ['beep.mp3']
});

Pomodoro.ports.playSound.subscribe(function(x){
  console.log("playing sound");
  sound.play();
});
