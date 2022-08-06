# Technical Debt

This challenge was part of the "Unlock The City" 2022 [Hacky Holidays](https://hackyholidays.io/) CTF.
I'm going to skip over the first part as I was mostly fumbling over getting the data out of the network
traffic but it is important to note that the file that I work with below is what I pieced together from
that. 

## Decoding the image
The file was a .pntg file for MacPaint, which I deduced from the magic number "PNTGMPNT" which I'm
fairly sure means "painting macpaint" or something similar. It was pretty easy to find a tool that
converted .pntg to .png, the one I used was [this one](https://github.com/thejoelpatrol/macpaint_file/blob/main/macpaint.py)
by thejoelpatrol created for the website www.macpaint.org.

However, running the image I had through the converter didn't work and I didn't (and still don't) know
if that was because I extracted the file incorrectly or if it was corrupted. So I tried to get the
original MacPaint program running on an emulator. This didn't work.

Finally I gave in and decided to write my own .pntg reader. I chose [Processing](https://processing.org/)
because it's the graphics library I am most familiar with. Using [MacPaint Document Format](http://www.idea2ic.com/File_Formats/macpaint.pdf)
(link provided in the source code of thejoalpatrol's implementation) and the [PackBits Wikipedia Page](https://en.wikipedia.org/wiki/PackBits)
I started. None of it was really working until I created a test image and compared my output to thejoelpatrol's.
Eventually I had an almost readable image, the flag just barely visible with the tops and bottoms of
the letters offset from each other. Instead of trying too hard to solve the problem I just took a screenshot
and slapped it into an image editor to get the flag. 

If it works, it works. 
