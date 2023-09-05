# compilers23-exercises-tue8-11
Code from TA classes on AU Compilers 2023 course (Tuesdays 8-11, TA: Egor / Hünkar)


This project should build simply with `dune build`.
Definitions and other code that is not executed directly is stored in `lib` folder.
Executable files in `bin` can reference them using the `open` directive. 
To run e.g. the file `ex2_1.ml` after build, execute `dune exec ./bin/ex2_1.exe`. 


When you experiment with the code, it may be easier to temporarily disable some of warnings by modifying `bin/dune`.
**WARNING**: 
Enable them back after you're done experimenting. The submitted assignment solutions should not produce any warnings. 