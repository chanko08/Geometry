from numpy import array

GAME_UPDATE = 'GAME_UPDATE'
GAME_DRAW   = 'GAME_DRAW'


class Direction(object):
    LEFT  = array((-1, 0))
    RIGHT = array((1, 0))
    UP    = array((0, 1))
    DOWN  = array((0, -1))

