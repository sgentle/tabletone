Tabletone
=========

Tabletone is a Javascript library for making interactive live-looping grids using only HTML tags and the unstoppable power of tables. Unleash your creativity within a very specific visual layout!

How do I get it?
----------------

Just grab the files from the [build directory](https://github.com/sgentle/tabletone/tree/master/build). You need at least `tabletone.css` and `tabletone.[min].js`. If you want to support browsers without the Fetch API (all of them except Chrome right now) then you'll also need the `fetch.js` polyfill, or just use `tabletone.combined.js`.

How do I use it?
----------------

Check out this totally sweet [example page](https://sgentle.github.io/tabletone/). The code for that is in the [example directory](https://github.com/sgentle/tabletone/tree/master/example) but the short version is:

```html
<link rel="stylesheet" href="tabletone.css">
<tt-table>
  <tt-row>
    <tt-cell></tt-cell>
    <tt-cell pulse src="mysweetloopfile.mp3"></tt-cell>
  </tt-row>
</tt-table>
<script src="tabletone.js"></script>
```

If your tt-cell has no `src` attribute it will appear as a blank cell so you can make artistic use of negative space or whatever. `pulse` is also optional and controls whether you get the pretty visual feedback. Turning it off reduces CPU use by a bunch, but also makes you no fun.


Do you have any more examples?
------------------------------

Sure! [Here's one I made](https://samgentle.com/posts/2015-04-25-tabletone).

If you make one, feel free to send through a [pull request](https://github.com/sgentle/tabletone/pulls) adding it to this README. I'd love to have more examples.


I don't like purple. Can I theme it?
------------------------------------

If by "theme" you mean edit the CSS file, then... yes! None of the visuals are done in JS so you can just style it using the CSS you know and love.


Wait, you just made up some tags? Are you allowed to do that?
-------------------------------------------------------------

Basically, yes. Think of them as [Web Components](https://developer.mozilla.org/en-US/docs/Web/Web_Components) 0.0.


Your code sucks and/or rocks and I want to improve it
-----------------------------------------------------

[Commits for the commit god! Pull requests for the pull request throne!](https://github.com/sgentle/tabletone/pulls)