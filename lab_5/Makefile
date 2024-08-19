
# Makefile for assembling and linking all assembly programs in the directory

# Variables
ASM_FILES = debugDecks.s \
	printHand.s \
	debugCards.s \
	getGuessComp.s \
	updateHands.s \
	dealCards.s \
	getGuessUser.s \
	initBooks.s \
	shuffleDeck.s \
	debugBooks.s \
	initDecks.s \
	getGameWinner.s \
	goFish.s \
	updateBooks.s \
	initHand.s \
	debugHands.s \
	printBooks.s \
	cardStruct.s \
	playGame.s \
	getGameState.s 
OBJ_FILES = debugDecks.o \
	printHand.o \
	debugCards.o \
	getGuessComp.o \
	updateHands.o \
	dealCards.o \
	getGuessUser.o \
	initBooks.o \
	shuffleDeck.o \
	debugBooks.o \
	initDecks.o \
	getGameWinner.o \
	goFish.o \
	updateBooks.o \
	initHand.o \
	debugHands.o \
	printBooks.o \
	cardStruct.o \
	playGame.o \
	getGameState.o 
EXEC_FILE = program

# Rule to assemble each .s file into an object file
%.o: %.s
	as -o $@ $<

# Rule to link all object files into an executable
$(EXEC_FILE): $(OBJ_FILES)
	ld -o $(EXEC_FILE) $(OBJ_FILES)

# Clean rule to remove generated files
clean:
	rm -f $(OBJ_FILES) $(EXEC_FILE)

.PHONY: clean
