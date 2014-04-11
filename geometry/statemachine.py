from pygame.locals import *
from geometry.constants import *
class StateMachine(object):
    def __init__(self, game_data):
        self.evs = set() 
        self.current = None
        self.game_data = game_data


    def broadcast(self, ev, *args, **kwargs):
        if ev in self.evs:
            self.current.broadcast(ev, *args, **kwargs)

class AppState(StateMachine):
    def __init__(self, loaded_data):
        super().__init__(loaded_data)
        self.current = MenuState(loaded_data, self)


class MenuState(StateMachine):
    def __init__(self, game_data, parent):
        super().__init__(game_data)
        parent.evs.update([KEYDOWN, GAME_DRAW])


    def broadcast(self, ev_type, *args, **kwargs):
        print(ev_type)
        if ev_type == KEYDOWN:
            print('moving to next state')
        elif ev_type == GAME_DRAW:
            self.draw(*args,**kwargs)


    def draw(self, window):

        print('made it to draw!')




