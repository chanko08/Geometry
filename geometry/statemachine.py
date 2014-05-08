from pygame.locals import *
from geometry.constants import *
class StateMachine(object):
    def __init__(self, game_data):
        self.current = None
        self.game_data = game_data


    def broadcast(self, ev, *args, **kwargs):
        self.current.broadcast(ev, *args, **kwargs)

class AppState(StateMachine):
    def __init__(self, loaded_data):
        super().__init__(loaded_data)
        self.current = MenuState(loaded_data, self)


class MenuState(StateMachine):
    def __init__(self, game_data, parent):
        super().__init__(game_data)


    def broadcast(self, ev_type, *args, **kwargs):
        print(ev_type)
        if ev_type == KEYDOWN:
            print('moving to next state')
        elif ev_type == GAME_DRAW:
            self.draw(*args,**kwargs)


    def draw(self, window):
        print('made it to draw!')


class LevelState(StateMachine):
    def __init__(self, game_data, lvlfile, parent):
        super().__init__(self, game_data)
        #TODO tie the levelloader function to Jacks stuff
        self.level_model = levelloader(lvlfile) 
        self.level_renderer = SimpleLevelRenderer(self.level_model)

    def broadcast(self, ev_type, *args, **kwargs):
        if ev_type == GAME_DRAW:
            self.draw(*args, **kwargs)
        elif ev_type == GAME_UPDATE:
            pass

    def draw(self, window):
        self.level_renderer.render()



