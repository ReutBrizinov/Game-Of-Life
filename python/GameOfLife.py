import os
import time
TITLE = "Game of Life by Reut Brizinov"

gameboard_len = 20

def Update(gameboard):
    temp = [[0 for x in range(gameboard_len)] for y in range(gameboard_len)]
    for i in range(gameboard_len):
        for j in range(gameboard_len):
            neighbors = CountNeighbors(i, j, gameboard)
            #if cell is alive
            if gameboard[i][j] == 1:
                if neighbors > 3 or neighbors < 2:
                    temp[i][j] = 0
                else:
                    temp[i][j] = 1
            #if cell is dead
            else:
                if neighbors == 3:
                    temp[i][j] = 1
                else:
                    temp[i][j] = 0
    return temp


def Draw(gameboard):

    for i in range(gameboard_len):
        for j in range(gameboard_len):
            if gameboard[i][j] == 1:
                print("O", end ="")
            else:
                print(".", end ="")
        print("")


def CountNeighbors(row, col, gameboard):
    N = gameboard_len
    neighbor = 0
    neighbor += gameboard[((row - 1) % N)][((col - 1) % N)]
    neighbor += gameboard[((row - 1) % N)][col]
    neighbor += gameboard[((row - 1) % N)][((col + 1) % N)]
    neighbor += gameboard[row][((col - 1) % N)]
    neighbor += gameboard[row][((col + 1) % N)]
    neighbor += gameboard[((row + 1) % N)][((col - 1) % N)]
    neighbor += gameboard[((row + 1) % N)][col]
    neighbor += gameboard[((row + 1) % N)][((col + 1) % N)]
    return neighbor

def main():
    #initialization
    gameboard = [[0 for x in range(gameboard_len)] for y in range(gameboard_len)]
    gameboard[2][3] = 1
    gameboard[2][4] = 1
    gameboard[2][5] = 1
    Draw(gameboard)

    #main loop
    while(True):
        gameboard=Update(gameboard)
        os.system("clear")
        Draw(gameboard)
        time.sleep(0.001)
main()