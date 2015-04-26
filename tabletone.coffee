ctx = new (window.AudioContext || window.webkitAudioContext)

audios = []

buffercache = {}
maybeFetch = (src) ->
  if buffercache[src]
    Promise.resolve(buffercache[src])
  else
    fetch(src)
      .then (response) -> response.arrayBuffer()
      .then (audioData) -> new Promise (accept) -> ctx.decodeAudioData audioData, accept
      .then (buffer) -> buffercache[src] = buffer; buffer

addAudio = (src) ->
  maybeFetch src
    .then (buffer) ->
      node = ctx.createBufferSource()
      node.buffer = buffer
      node.loop = true
      node.connect ctx.destination
      audios.push node
      node.start 0, ctx.currentTime % buffer.duration, 2**16 # crbug.com/457099 - offset doesn't work properly
      node

removeAudio = (audio) ->
  idx = audios.indexOf(audio)
  audio.disconnect()
  audio.stop(0)
  audios.splice(idx, 1) if idx > -1
  audio

drawAnalyser = (analyser, pulse) ->
  analyser.fftSize = 512
  ary = new Float32Array(analyser.fftSize)
  min = null
  max = null
  draw = -> requestAnimationFrame ->
    analyser.getFloatTimeDomainData(ary)
    avg = 0
    avg += Math.abs(val) for val in ary
    avg /= ary.length
    min = avg if !min || avg < min
    max = avg if !max || avg > max
    val = Math.round(Math.min((avg-min)/(max-min), 1)*1000)/1000
    # console.log "avg", avg, "min", min, "max", max, "max-min", (max-min), "val", val
    pulse.style.opacity = 1-val
    draw() unless analyser.finished
  draw()

addPulseAnalyser = (el) ->
  analyser = ctx.createAnalyser()
  el.audio.connect(analyser)
  el.analyser = analyser
  el.innerHTML = ""
  pulse = document.createElement 'tt-pulse'
  el.appendChild pulse
  drawAnalyser analyser, pulse

clickHandler = (e) ->
  if @playing
    removeAudio @audio
    @innerHTML = ""
    @analyser?.finished = true
    @playing = false
    @classList.remove 'playing'
  else
    addAudio(@src).then (node) =>
      @classList.add 'playing'
      @audio = node
      addPulseAnalyser this if @pulse
      @playing = true

do ->
  for el in document.querySelectorAll('tt-cell')
    continue if el.tabletone
    el.tabletone = true
    el.src = el.getAttribute('src')
    el.pulse = el.getAttribute('pulse')?
    el.playing = false
    el.addEventListener 'click', clickHandler