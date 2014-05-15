import pygame
from pygame.locals import *
from geometry.constants import *
from geometry.level.render.simple import SimpleLevelRenderer
from geometry.level.model import LevelModel

class StateMachine(object):
    def __init__(self, game_data):
        self.current = None
        self.game_data = game_data


    def broadcast(self, ev, *args, **kwargs):
        self.current.broadcast(ev, *args, **kwargs)

class AppState(StateMachine):
    def __init__(self, loaded_data):
        super().__init__(loaded_data)
        self.current = LevelState(loaded_data, "levels/test.json" ,self)


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
        super().__init__(game_data)
        self.controls = game_data.controls
        self.controls[K_ESCAPE] = 'quit'

        self.control_action = {
                'move_left' :  lambda : None,
                'move_right' : lambda : None,
                'jump' :       lambda : None,
                'shoot' :      lambda : None,
                'crouch' :     lambda : None,
                'look_up' :    lambda : None,
                'quit' :       lambda : pygame.event.post(pygame.event.Event(QUIT))
                }


        #TODO tie the levelloader function to Jacks stuff
        self.level_model = LevelModel(lvlfile) 
        self.level_renderer = SimpleLevelRenderer(self.level_model)
        self.parent = parent

    def broadcast(self, ev_type, *args, **kwargs):
        if ev_type == GAME_DRAW:
            self.draw(*args, **kwargs)
        elif ev_type == GAME_UPDATE:
            #self.level_model.update(args)
            pass
        elif ev_type == KEYDOWN:
            ev = args[0]
            action = self.controls.get(ev.key)
            if action:
                func = self.control_action.get(action, lambda : None)
                func()

                        

            

    def draw(self, window):
        self.level_renderer.render(window)



