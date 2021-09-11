# WebTabber
Experiments in Web Browser Tab Things

To the best of my memory, OmniWeb was the first browser I used that had "visual preview" style tabs running vertically across the left side of the window. I always "kind of" liked that, but at the time there were a combination of hardware constraints and implementation that made them not as good as they could be.

Fast forward to now, and displays are much higher resolution, computers are much faster, and web browsers are much more boring. The goal of this project is to be a playground where I can see if there is an implementation of "visual browser tabs" that feels just right.

Some thoughts on what might help:
* The preview tabs should be as "live" as possible. So any changes to the frame of the webview should trigger a redraw of the previews (including changes induced via scrolling the web page.) This should be done in such a way where it incurs as little CPU overhead as possible.
* Like other browsers, the previews should be able to be moved (and copied with option key); in order within the same window, to other windows, etc.
* The previews that are generated should be high quality (currenly implemented using Accelerate framework with kvImageHighQualityResampling.)
* 
![example image](https://github.com/jmenter/WebTabber/blob/main/example.png)
