# picocalc
my collection of code &amp; projects I have developed for the picocalc

## style
most of the LOCAL variables I create are just to keep the character count (per line) down so that all the characters fit in the width of the screen.

the mmbasic (picomite) interpreter autoformats when you save files on it. code in this repo follows that autoformatted style. 

## workflow
typically when I've been using my picocalc, I will play around with some code until I get something working on it and then later use `xmodem` to
copy the code over to one of my dev machines (e.g. laptop or desktop). then I will generally follow this loop for iterating:
1. make some changes on the dev machine
2. send to picocalc over xmodem
3. test changes
4. address bugs/syntax errors on the picocalc directly
5. send back to dev machine over xmodem
6. commit to source control


## references

[picomite user manual for its implementation of mmbasic interpreter](https://geoffg.net/Downloads/picomite/PicoMite_User_Manual.pdf)
