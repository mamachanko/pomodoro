console.log("Pomodoro");

const pomodoroLogKey = 'pomodoroLog';

var App = Elm.App.fullscreen(getPomodoroLog());

App.ports.ringBellPort.subscribe(function(){
  console.log("ringing bell");
  ringBell();
});

App.ports.requestPermissionsPort.subscribe(function(){
  console.log("requesting notification permission");
  Notification.requestPermission().then(
      function(permission) {
        console.log("received permission: " + permission)
      }
  );
});

App.ports.sendNotificationPort.subscribe(function(message){
  console.log("triggering notification");
  new Notification(message);
});

App.ports.updatePomodoroLogPort.subscribe(function(pomodoroLog) {
  updatePomodoroLog(pomodoroLog);
});

function updatePomodoroLog(pomodoroLog) {
  console.log("writing log");
  console.log(pomodoroLog)
  localStorage.setItem(pomodoroLogKey, JSON.stringify(pomodoroLog));
}

function getPomodoroLog() {
  const pomodoroLog = localStorage.getItem(pomodoroLogKey);
  console.log('reading log');
  if (pomodoroLog == null) {
    return {log: []}
  }
  return JSON.parse(pomodoroLog);
}

function ringBell() {
  let playbackCounter = 0;
  let numberOfPlaybacks = 3;

  var howl = new Howl({
    src: [bellSound()],
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

function bellSound() {
  return "data:audio/mp3;base64,SUQzAwCAAAAGNkNPTU0AAAB4AAABWFhYAAD/AP5oAHQAdABwAHMAOgAvAC8AYQByAGMAaABpAHYAZQAuAG8AcgBnAC8AZABlAHQAYQBpAGwAcwAvAGsAawBrAGYAZgBmAGIAaQByAGQAXwB5AGEAaABvAG8AXwBCAGUAZQBwAF8AMgAwADEANgAwADcAQ09NTQAAAD0AAABlbmcAaHR0cHM6Ly9hcmNoaXZlLm9yZy9kZXRhaWxzL2tra2ZmZmJpcmRfeWFob29fQmVlcF8yMDE2MDdUSVQyAAAABAAAAHRtcFRMRU4AAAACAAAAMVRTU0UAAAAwAAAATEFNRSA2NGJpdHMgdmVyc2lvbiAzLjk5LjUgKGh0dHA6Ly9sYW1lLnNmLm5ldCkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/ziGQAAAAAAAAAAAAAAAAAAAAAAFhpbmcAAAAPAAAAHgAAFEAADw8PJSUlNDQ0NEFBQU9PT1xcXFxra2t4eHiFhYWFlJSUoaGhr6+vr76+vtjY2OPj4+Pl5eXn5+fp6enp6+vr7e3t7+/v7/Dw8PLy8vT09PT29vb4+Pj6+vr6/Pz8/v7+////AAAAWkxBTUUzLjk5cgRQAAAAAC5lAAA1CCQCwC0AAeoAABRAVcmT9QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/ziGQAC5RDXg+njAAAAANIAUAAAC3Gnf379+/fv37+O8eMCsVisiN6HkEHoE0E0HoLgoGR4BgYGBi3B8HAQBAEHS4Pn8oCAIA+D4Pg+aBAEAxlwff//QD4Pn///icP/wfP///4IAg6D4Pv/ghAZ8Tg+hIJAAAAmfHJG8pQKQgEbi0zkFUNtaAgFMBgwKANMQwABEIligIEmQDyCQeb7USDhzYTmIaC4YPwFpgGAHmScgyYPIFIGAAGE4iEDZJ9KpIpCU4NaBE8WHQ05ZfN2V2qYvs5TWlb0O6cxgHgDgUAZ9GywMr6BGss5ZzDTtNK60huUWZLBDJYlIH+h9fEFtdWFkjzMOjLMWZvu7LB3FdJlU46b6yN82VtWZy+DxQDDf/zqGSuLT4LTy/OeBIAAANIAYAAAMTlgyAbQR59IW054Gx6JQA11yhrCSYsABE24sCEYCRgBgAJ1QCyluCro1DDoNVpaUWAYllHKGlMWu0btwzL6osAzem4k3Rs9ew7j6SPNmIMAUnnVgGMrkaJQzrMY097jQW6BgCAHtxlnJClhK4rTuDIpHMUkyDgIno7efSCY1Um4/Kcb+dXmrn/nZ1Wmt0sfmqO5zkQmLlirTV69ytOy2kpI/KYXR3ZpPy/MY/O2JTftUUWoZRurMSzk8nZl7YAAFiP/vLq9NjbnYbqhkl1PMhaa7Lg8lTWguAEAgzchDDob07A1MOBS/NBKp7GXR3G5hZVlTWfqItNnodn2+jMxSw9XkL8V6sFVc6aepr1aI0kokl+7jLpyxi/FNBkP3q0rrWrMRq57jt+3dga5nSW9VbHPrWLVl+JVTNKguHeQbXmpLNVolJG2f6GigTa6/L90mu5S/7TGota+5/1Ofk3KEXMnP5lZywxp8YdRBDKW9QBzH7t3OrerZJhSju3ypcqOx+MY/UGxbK28NPjGcqbGra59Lz6khuUss/O1P/ziGTfIAYLUY/t4AAAAANIAcAAAL/yy5r8r+rV/HtNhdq3t6wy3rP+Xfz+Z3hrH+65+r2vjirnyBAAaY/+zfrTEQSpn08wJAlVRJlKlGCs0/C3LGdrpVhHAmYcwpjENrQidSvrsvltPH61VHUSClJD6sj/Qa3qhmgHqcSumKeHZqR1YKuknfnF5WCePKfun1lTLg9Z4j9W5hKeaSVskiNqxbphnvp/DitjLDsqm6acbburyJeytzZcI+xmFkpXQdS5xFFZQaNRLO6nZZDzWxENPsgkQwFyaKMjXPoJmIsgjzwICSSA+CIomI1U2MyVSWKaO4+YC5CwhIgfSQTQQLaaRgVDzGxg6JJLWyFIoqqdTE6t6KCzJBdVymk8oKopu//zeGTpHcYLUY9x8ZoAAANIAAAAAKbLcr5KVZWnAAJ/v5VPHxhDKuWFXtycVmaTMNQX+5IWAckD1zBwEcwJDdcRBLQpNR3uxvD6ljB9CgFlt1hUOUtDDjTpNHtlEJh4Y1NHZl91AbysxZicoakPRnkkX2PcVbo1xsK070lEnvq8BYr2ps+4G/JNu6E16vV28riaB3LFpFu8gO7Gc6zr13R7fJ8br9f+PqUqb0wh9dSxp5Y2tgkBgwJj/+cRKyqTh0oAgwyI02GmYl8vk8tMixokJ7G+RiAncomhTIiZSkkpkLuTjMitA6padjiBbZaTnJNMgo+mtJSLo5Zeov/zeGThHV4LT39t8p4AAANIAAAAAH1Kc3eY0llRGRyH6BAAaY/uqer23Z+ZJDJZhJUuoghHgDGYOyszzTVB0BwVDhhjjGJxEnq6UM1rupBPUUaqz5ICExZC3XOKyyq/2cy0tv5VAjhXotJWuT1NEaezg/dzOva5Gnr+b3Ls/gDt7nLN2hocaSdr0caq5Uk9MY7iNu5QTu+wFr5a0CrqmsZbimr8qk9ZYXzLSVmo2ltUbiFTrrozQl8pLRZ86koY4FefTJU+gmm7mJGIkPCyctIFkbTmpDDekRU1WLSWi+mOEvmJGJmUDRlela2QsvqJt+BBLJu2hI5UofyI2v/zeGTdHcYLT49yKfQAAANIAAAAAK77Vpx/l9TvNM3k6+x/tOtOVdeYAABnj/7Wex4W3EQDE44lrp7WVpQQ23TO5EyAAHQiPooHA0wLUES3skdi3hEK+pTc42RPOk9svO7ezOZiMNbtMxpr1Z1Zbhcn63JRqvL4tluWVLPZRO5QFOSidlVfCAZXrcazqVn7u4Sud18WqTfJnP4J/sEOrewu2Mcq+MqmHz5kNMc/Hu+ZTd/XHkvVVZpyxL7Pd8s/pomWPYdsb3fuZ1N2F9jVp7tFb1u5b7GZDG/Lsdl8Rhy3cj0ts1oHt2Gw0/4tKvVK8itWH3Os3+sZxcbjSf/ziGTVHjoLUY9vCa4AAANIAAAAADNlpz2CNPoPc3PjjvNXazIyT2MhF6g6OqXVk29J6boQAIiP/tN9HBFAirLFn/AQiqqCIc0IIqxLHKlYEmgnSDAaY9mplAIqDP7KqXL/hmTvFL/gMoBcPQpuMH1L79QFSUMiqxhsFrs1T1oxKqtyH4zV1H5d2al2Par2UV2V//wdlVktXk/jjWzkXeQXP/XnM7FzHmT6XOZNDzt0M1expqlSYk+6hdaQY9v81h3nI3vrZKL9XP/VW3jDUHfSsmr7q36T88axUWip9t4LHNWalrl7svSzsSudaje1Q0NLZhzKs3WTS3F8a0ir56yT1sGmhommjB8ix+Yg9YDrcgXIICI2BCNRYuu6cvvDtf/zeGTuHpIHU49zCK6AAANIAAAAAIZfuoQRbzXYqwAAeo//7fsb1aIJAMapR4OSx1iUBiQdbgl/rOUIzigDewQgMzVFTRoLSQfuct2Ov3FLcF2MiAEpzMoeNWR5pylgWV0EtpqSo9eP07nV6XGduxp+p/b0yOQ3Yjn3kssXoJo6Shde/lM4Tt2UZ170ou5SmB6lqX7dKpS764+VSVqSyrwzIrFh+d7pnP4dCVWtalzJspO43CQY8tenTH2edyWat2tSICDweUWDy0DaBpSxFJcBFZ0NPRcsGkneLOu2C5Uk0eVNyVmfrGqyQ8Wh5j6cM+Ne0Zpgx2z109vLuf/zeGTgHv4LUY9yL/IAAANIAAAAAOt3sm7M/y1b1e1rS513W67nvu+N0Z/hdqeoAABYfb7N6uH2cdksGF06ZyRQCpsOVS/jKkGRkEoAjAYSM/UY1GFC9LLpbTY9mZV+FqsvkWDEfgpbEYytRPC7DMDd85NVgvo0Nfiw5WSWCk3KHCTEaJBZlvvGmKtFgvAXc+nF/drhJWkQwJ4uYG4akVsWZCXkAzRiQNPMSaVb5uZjWbYQB4tfM33uvws756JT5ib/v+pXeqq/eM7rFti5AAKMXEfWc6iab3k0QCei92a27tu7xVdTJ7pT7dvGerjCoslkybWNMyky3BdFjP/ziGTPHXYLT49x6a4AAANIAAAAABYU7IXSiTTnoenBc1cqz+MrX/sLZ6lHE5ViCNDdh6kAAn++scsT+M8g59o6SAJ6UviEApwtbXR2kjaGBbpSQ4GjMfUNGChCW4EfmM7kYzx7j1qhQGOTcNPbUzgK/LYLhViAG/mZVOPLS2Kv8mH/pqZqrzYWnfrU89LrWMEWeVn1ld+PzVq3JrVa5Lb3G7UWPaXc7Ys8+NZTcQaDz+Zb+UY7+L94PDhOeFnf7sb1C7ebZHtrVu485V114JPnafSl1jbs1aHKySiL13+PHR8tyuxnVw1iQBygqNy63nQdnuRnt2C3s3flO61NnvzgioIxqB6lFtpViXEbn6YZpisojdaqDwXqs3yVzOM7Uf/zeGTuHoYLTX9zCa4AAANIAAAAAIV8v3H4B6qleAAASZ/1zVZia6lyfkj7KJQlunA4r/XaCDSEHDgYQkmDAObBaZyADiQeXq60ho9VLtqzOUohCReeAGBEAHiMSl7oLkdFR9585pIl96b3ZqbtP9F5LEq0TUVbaBqs5LqeNwB2xSSG/VbtN4wbS2cpV9ulk+Mdh97edlV+zlZ5m9d+WNyZXLcaGHLcXu08ri7V4pTmAc/lzfe0uXMZZnfaM5uX47uYYb+CqT9TOss8t41N8oytd/dLa/es6t2BZ6oIiS61nCKtyYs8iUvyswa1HGrEsLlPfmsQVVwjvcdzN//zeGTgH0oLS49zCK4AAANIAAAAALCZ8C5kefRtQ+KI1CZU4rWeeYCT3rqI5O8C6se5AABIn/bu+tYi6C6deeFgFGl5hYBqsTAb3crlbvLgAQIMIiUEXswsEVL1TyPsovXIpyte94CbfbUzJ5Jm5daG4Ln6Zz1AqS9Gn7ntXKalqRnGStVhdy+62He1MLVWxMSRpueE3X5nS/nyT4V2Z4Y6s7yws4ZQBl2CCsNjcrlvzcnt08BxahzEYIxSf3/7/6me6gCDtfr9fu9Nz8HWNu9hzt/dallcbFRlwpZp/LmtV+Ws+0NCW3hM3g/NB9+pqH4EvUUBtBqQ7DdncP/ziGTMH7YLUY+uYAAAAANIAUAAAF2pnCZr48iGGsL1jCx3KxXv5WZ+7lqplaz1nLsMpJvfMe773u7v/8v5zL//WsPvfm+NtAlAAAAARgeU3V11qsLzMBw0MHMl5i1Bh4RGJhkYTCZCWkcxEATEwEMmlMqBkzUsBgOGTF6ZjN5wk7HijfGWIIFYGHf7RCSqBwJnW2omS5LmJYEvoqqWAGa0/kXMEgXTrMQgiBQGK2I1jgAkQFl1BILWmFlAgG0ARgmBphAAYAA4eAgwVB0w1CkwjAmGFEiwBrOIQvtGhTUZAEKgQwBJQwSA4wOAYaBAwRAswHAMt+wUlARL2uvZ/mOOooOg6nvOwWWyMNAMEgRVoFgCLiFlDAEI36qLsesAAv/zuGTZOpoLQY/OdAAAAANIAYAAAMwly08SqFUbVI2JYYLAKo60WMAkMjBcHzA0ATCYGDBIFhgEjCkHTA8CzAkBTAYGggSX8uOAhyeykgZVVhcRsmEYQsvUNSmGAcVgZcnQIgOZy09McxTABcyqCAQCAoreBgLDADDAAMBgMXICgTskQYuHQVmktcl9SV2HNjcUtN2MMQNZpA7/LgGghciw+dVXsCUkbMFw7MBhiGg3FQLUKMEAgEg0FgJAIGhcCwwAzCoAkuGGJnMPhytarqOP7BFPCW/Y1DUFshYJFpbGnZfftyvUicryzpXkm/3ONrSdm5a7kPM/THTjLMFyH8DAHXWvcuRNx1RR3YktcvuX/ZEAmmtvv1gq1WvXr169evn1swVahpoltIMJsJsS5yYUNULKKgSBIEgSBIVExEhQoUIpJUKEhRIkQqRIkSJEhZjHP4x21UKEUilChRIkSIVEyJEiQoUKFChQoUKJEilKUpSjn8pf/xiqhQoUKFEiFQqRIkSJEhQoUKFDGMZSlKW///+pSlKMYoUKFChQrSlKUkSJEhjn///////qSJEiRIkSKMYxjGMVQoKCgoJd//0FBQUGCgoKCgUFBQUGCgoKCkxBTUUzLjk5LkxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVf/zaGTnGAGfWs/npACAAANIAcAAAExBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVUxBTUUzLjk5LjVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zGGTqAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVf/zGGTwAAABpAAAAAAAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVRBR3RtcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABodHRwczovL2FyY2hpdmUub3JnL2RldGFpbHMvAAD/"
}