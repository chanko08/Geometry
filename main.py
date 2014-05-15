#!/usr/bin/env python3

import pygame
from pygame.locals import *

from conf import *
from geometry.constants import *


def main():
    conf = config()
    statemachine = load()

    pygame.init()
    fps = pygame.time.Clock()
    window = pygame.display.set_mode(conf.window_size)

    pygame.display.set_caption(conf.caption)

    while True:

        for event in pygame.event.get():
            statemachine.broadcast(event.type, event)

            if event.type == QUIT:
                pygame.quit()
                return

        statemachine.broadcast(GAME_UPDATE, conf.fps) 
        statemachine.broadcast(GAME_DRAW, window)
        pygame.display.update()

        fps.tick(conf.fps)






    

if __name__ == '__main__':
    main()
        
