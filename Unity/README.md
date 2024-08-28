# Manually

```
gcc -I./src -I./unity/src ./test/TestDumbExample.c ./src/DumbExample.c ./unity/src/unity.c -o TestDumbExample
```

Generate TestDumbExample.exe

# Make

**The makefile is kind of different from offical one and it runs well on my windows11.**

- build - where all temporary stuff goes
- src - where we have all our source code for release (and to be tested)
- test - where we have all our unit tests
- unity - where we have copied the latest copy of the Unity project
  
[Offical Tutorial](https://www.throwtheswitch.org/build/make)

