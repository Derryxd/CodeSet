#Compiler and Compile options
FC = gfortran
CC = gcc
#CFLAGS = -O2

#Source code files, Object files and Target(Executable) filedefine
SF = $(wildcard *.f90)
OF = $(SF:.f90=.o)
SC = $(wildcard *.c)
OC = $(SC:.c=.o)
TARGET = main.exe

MODSRCS = $(wildcard*.module)
MODOBJS = $(MODSRCS:.module=.o)
MODS = $(MODSRCS:.module=.mod)

#Debug purpose.
#all:
#	@echo $(SC)
#	@echo $(SF)
#	@echo $(MODOBJS)

#Generate Target file using Object files
$(TARGET): $(OF) $(MODOBJS) $(OC)
	$(FC) $(CFLAGS) $^ -o $@

#Generate Object files using Source code files
%.o: %.f90 
	$(FC) $(CFLAGS) -c $<

$(MODS) $(MODOBJS):$(MODSRCS)
	$(FC) $(CFLAGS) -x f95 -c$^

%.o: %.c
	$(CC) $(CFLAGS) -c $<


#Use "make run" can run the Target file
run:
	@./$(TARGET)

#Clean the Object files
clean:
	rm -rf $(TARGET) $(OF) $(OC) $(MODOBJS) $(wildcard *.mod)



