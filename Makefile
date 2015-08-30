CC = gcc
CFLAG = -std=c11 -g -Wall -pedantic -O2 $(shell python3.4-config --cflags)
LFLAG = $(shell python3.4-config --ldflags)
LDFLAG = -I$(SRCDIR)
TARGET = startMe.out
SRCDIR = src
OBJDIR = obj
BINDIR = bin
RM = rm -f
SRC = $(wildcard $(SRCDIR)/*.c)
INCLUDES = $(wildcard $(SRCDIR)/*.h)
OBJ = $(SRC:$(SRCDIR)/%.c=$(OBJDIR)/%.o)


# Linked die Object Dateien
.PHONEY: $(BINDIR)/$(TARGET)
$(BINDIR)/$(TARGET): $(init) $(OBJ)
	$(CC) $(LFLAG) $(OBJ) -o $@
	@echo "Linked finished"

# Kompiliert die Object Dateien
.PHONEY: $(OBJ)
$(OBJ): $(OBJDIR)/%.o : $(SRCDIR)/%.c
	$(CC) -o $@ -c $< $(CFLAG)
	@echo "Compiled "$<

.PHONEY: dirs
dirs:
	mkdir -p bin
	mkdir -p bin/res
	mkdir -p bin/lib
	mkdir -p src
	mkdir -p obj
	mkdir -p res
	mkdir -p res/config
	mkdir -p res/img
	mkdir -p lib
	mkdir -p plugins

.PHONEY: init
init: dirs
	cp -r res bin/
	cp -r lib bin/
	cp -r plugins bin/

.PHONEY: clean
clean:
	@rm $(OBJ)
	@rm -r $(BINDIR)/res
	@rm -r $(BINDIR)/lib
	@rm -r $(BINDIR)/plugins
	@echo "Cleanup"

.PHONEY: remove
remove: clean
	@rm $(BINDIR)/$(TARGET)
	@echo "Exe deleted"

.PHONEY: doc
doc: $(INCLUDES)
	@doxygen Doxyfile

run: $(BINDIR)/$(TARGET)
	$(BINDIR)/./$(TARGET)

val: $(BINDIR)/$(TARGET)
	valgrind $(BINDIR)/./$(TARGET)

fullval: $(BINDIR)/$(TARGET)
	valgrind --leak-check=full $(BINDIR)/./$(TARGET)
