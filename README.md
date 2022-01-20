# Game of Life
#### by Reut Brizinov

[From Wikipdea](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life):
```
The Game of Life, also known simply as Life, is a cellular automaton devised by the British mathematician John Horton Conway in 1970. It is a zero-player game, meaning that its evolution is determined by its initial state, requiring no further input. One interacts with the Game of Life by creating an initial configuration and observing how it evolves. It is Turing complete and can simulate a universal constructor or any other Turing machine.
```
## Implmentations
I've decided to implement `Game of Life` in a couple of programming langauges:
- Python
- C#
- Assembly (3 versions: text, pixel, multi-pixel)

## Compilation & Running


### Python
I'm using `PyCharm` IDE with `Python 3.9` but the project should work on any Python version (Pure python).

![1](/resources/life_python.gif "Python")

### C#
I'm using `Visual Studio` for compiling my C# project.

![2](/resources/life_csharp.gif "C#")

### Assembly
Compiled using Turbo Assembler (for x64 machines, I highly recommend [DosBox](https://www.dosbox.com/).

```sh
c:\> tasm.exe life.asm
c:\> tlink.exe life.obj
c:\> life.exe
```

##### ASM Text mode
![3](/resources/life_text.gif "ASM Text")

##### ASM Graphics mode - Pixel
![4](/resources/life_asm_pixel.gif "ASM Pixel")

##### ASM Graphics mode - Multi Pixel
![5](/resources/life_pixle_multi.gif "ASM Multi Pixel")
