ctx = new (AudioContext || webkitAudioContext)

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
      try
        node.start 0, ctx.currentTime % buffer.duration, 2**25 # crbug.com/57099 - offset doesn't work properly
      catch e
        node.start 0, ctx.currentTime % buffer.duration # Firefox doesn't support length values that large
      node

removeAudio = (audio) ->
  idx = audios.indexOf(audio)
  audio.disconnect()
  audio.stop()
  audios.splice(idx, 1) if idx > -1
  audio

drawAnalyser = (analyser, pulse) ->
  analyser.fftSize = 512
  ary = new Float32Array(analyser.fftSize)
  min = 0
  max = 0.0001
  draw = -> requestAnimationFrame ->
    analyser.getFloatTimeDomainData(ary)
    avg = 0
    avg += Math.abs(val) for val in ary
    avg /= ary.length
    min = avg if avg < min
    max = avg if avg > max
    val = Math.round(Math.min(avg/(max-min), 1)*1000)/1000
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