
from geometry.statemachine import StateMachine,AppState
class Object(object): pass

def config():
    conf = Object()
    conf.window_size = 800, 600
    conf.fps = 60
    conf.caption = "Geometry"
    return conf

def load():
    s = AppState(None)
    return s


