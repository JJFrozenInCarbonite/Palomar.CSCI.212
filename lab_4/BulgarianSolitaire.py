import random

# Maximum number of cards to be distributed across piles in the game.
MAX_CARDS = 45

def initialize() -> list:
    """
    Initializes the game by creating a list of 4 piles with a total of MAX_CARDS cards.
    
    The function ensures that each pile has at least one card and the total card count equals MAX_CARDS.
    The piles are sorted in ascending order before being returned.
    
    Returns:
        list: A sorted list of integers representing the initial configuration of the card piles.
    """
    # Set the number of piles to create, excluding the last one which will be added to ensure the sum equals MAX_CARDS
    num_initial_piles = 3
    piles = []

    for _ in range(num_initial_piles):
        # Calculate the maximum number of cards that can be placed in the current pile
        # ensuring there are enough cards left for the remaining piles
        max_possible = MAX_CARDS - sum(piles) - (num_initial_piles - len(piles))
        pile = random.randint(1, max_possible)
        piles.append(pile)

    # Add the last pile with the remaining cards to ensure the total is MAX_CARDS
    piles.append(MAX_CARDS - sum(piles))
    piles.sort()  # Sort the piles for presentation
    
    display(piles)  # Assuming display() is a function that prints the piles

    return piles

def play(piles: list):
    """
    Simulates a game of Bulgarian Solitaire.

    The game progresses by subtracting one card from each pile and then forming a new pile with the number of piles
    that were modified. This process repeats until the configuration of piles does not change between iterations,
    indicating the game has reached a stable configuration.

    Parameters:
    - piles (list): A list of integers representing the initial piles of cards.

    Returns:
    None. The function prints the progression of the game to the console.
    """
    while True:
        # Copy the current state of piles to check for stability at the end of the iteration
        previous_piles = piles[:]
        
        # Subtract one card from each pile and form a new pile with the count of modified piles
        piles = [pile - 1 for pile in piles]  # Subtract one from each pile
        piles.append(len(piles))  # Add a new pile equal to the number of piles
        piles = [pile for pile in piles if pile != 0]  # Remove any piles that have become empty
        piles.sort()  # Sort the piles for consistency and comparison
        
        display(piles)  # Display the current state of the game

        # Check if the configuration of piles has stabilized
        if piles == previous_piles:
            print("Done!")
            break

def display(piles: list):
    """
    Prints the current configuration of card piles in the game.

    This function takes a list of integers representing the card piles and prints them in a human-readable format.

    Parameters:
    - piles (list): A list of integers representing the current state of the card piles.

    Returns:
    None. The function outputs the state of the piles to the console.
    """
    # Join the pile sizes into a comma-separated string and print
    piles_str = ', '.join(str(pile) for pile in piles)
    print(f"Piles: {piles_str}")

# This is the entry point of the Bulgarian Solitaire game simulation.
# When executed, the script initializes the game with a set of card piles
# and then plays the game until it reaches a stable configuration, displaying
# the progression of the game states.
if __name__ == '__main__':
    try:
        piles = initialize()  # Initialize the game with a set of card piles
        if not piles or not isinstance(piles, list) or not all(isinstance(pile, int) for pile in piles):
            raise ValueError("Initialization failed: 'piles' must be a list of integers.")
        play(piles)  # Play the game with the initialized piles
    except Exception as e:
        print(f"An error occurred: {e}")