import pygame
import itertools

class SimpleLevelRenderer(object):
    def __init__(self, model):
        self.model = model

        self.render_funs = { 'wall': _wall_render
                           , 'player': _player_render
                           }

    def render(self, window):
        for k,v in self.model.models.items():
            
            render_fun = self.render_funs.get(k)
            if render_fun:
                for w in v :
                    render_fun(window, w)

_DEFAULT_RECT_COLOR = (255, 0, 0)

_DEFAULT_RECT_LINE_WIDTH = 0 #fill in rectangles by default

_DEFAULT_LINE_WIDTH = 5

_DEFAULT_LINE_COLOR = (0, 255, 0)

_DEFAULT_PLAYER_COLOR = (0, 255, 0)

def _world_to_screen_coord(window, coord):

    x, y = coord
    return x, (50 - y) 

def _world_to_screen_scale(window, scalar):
    x,y = scalar
    return x, y

def _rect_render(window, rect_obj):
    topleft = _world_to_screen_coord(rect_obj.rect.topleft)

    r = pygame.Rect( _world_to_screen_coord(rect_obj.rect.topleft)
                   , rect_obj.rect.size
                   )

    _world_to_screen_coord(rect_obj.rect)
    pygame.draw.rect( window
                    , _DEFAULT_RECT_COLOR 
                    , r
                    , _DEFAULT_RECT_LINE_WIDTH
                    )
    

def _wall_render(window, wall):

    lines = [_world_to_screen_coord(window, l) for l in wall.points]

    pygame.draw.lines( window
                     , _DEFAULT_LINE_COLOR
                     , 0
                     , lines
                     , _DEFAULT_LINE_WIDTH
                     )

def _player_render(window, player):

    x,y = _world_to_screen_coord(window, player.position)
    w,h = _world_to_screen_scale(window, [player.width, player.width])

    print(x,y,w,h)
    print(_DEFAULT_PLAYER_COLOR, window)

    rect = pygame.Rect(x, y - h, w, h)


    pygame.draw.rect(window, _DEFAULT_PLAYER_COLOR, rect)




