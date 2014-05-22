from geometry.statemachine import StateMachine,AppState
from pygame.locals import *
import json

class Object(object):
	def __repr__(self):
		return str(self.__dict__)

keyname = {
    "BACKSPACE":   K_BACKSPACE,
    "TAB":         K_TAB,
    "CLEAR":       K_CLEAR,
    "RETURN":      K_RETURN,
    "PAUSE":       K_PAUSE,
    "ESCAPE":      K_ESCAPE,
    "SPACE":       K_SPACE,
    "EXCLAIM":     K_EXCLAIM,
    "QUOTEDBL":    K_QUOTEDBL,
    "HASH":        K_HASH,
    "DOLLAR":      K_DOLLAR,
    "AMPERSAND":   K_AMPERSAND,
    "QUOTE":       K_QUOTE,
    "LEFTPAREN":   K_LEFTPAREN,
    "RIGHTPAREN":  K_RIGHTPAREN,
    "ASTERISK":    K_ASTERISK,
    "PLUS":        K_PLUS,
    "COMMA":       K_COMMA,
    "MINUS":       K_MINUS,
    "PERIOD":      K_PERIOD,
    "SLASH":       K_SLASH,
    "0":           K_0,
    "1":           K_1,
    "2":           K_2,
    "3":           K_3,
    "4":           K_4,
    "5":           K_5,
    "6":           K_6,
    "7":           K_7,
    "8":           K_8,
    "9":           K_9,
    "COLON":       K_COLON,
    "SEMICOLON":   K_SEMICOLON,
    "LESS":        K_LESS,
    "EQUALS":      K_EQUALS,
    "GREATER":     K_GREATER,
    "QUESTION":    K_QUESTION,
    "AT":          K_AT,
    "LEFTBRACKET": K_LEFTBRACKET,
    "BACKSLASH":   K_BACKSLASH,
    "RIGHTBRACKET":K_RIGHTBRACKET,
    "CARET":       K_CARET,
    "UNDERSCORE":  K_UNDERSCORE,
    "BACKQUOTE":   K_BACKQUOTE,
    "A":           K_a,
    "B":           K_b,
    "C":           K_c,
    "D":           K_d,
    "E":           K_e,
    "F":           K_f,
    "G":           K_g,
    "H":           K_h,
    "I":           K_i,
    "J":           K_j,
    "K":           K_k,
    "L":           K_l,
    "M":           K_m,
    "N":           K_n,
    "O":           K_o,
    "P":           K_p,
    "Q":           K_q,
    "R":           K_r,
    "S":           K_s,
    "T":           K_t,
    "U":           K_u,
    "V":           K_v,
    "W":           K_w,
    "X":           K_x,
    "Y":           K_y,
    "Z":           K_z,
    "DELETE":      K_DELETE,
    "KP0":         K_KP0,
    "KP1":         K_KP1,
    "KP2":         K_KP2,
    "KP3":         K_KP3,
    "KP4":         K_KP4,
    "KP5":         K_KP5,
    "KP6":         K_KP6,
    "KP7":         K_KP7,
    "KP8":         K_KP8,
    "KP9":         K_KP9,
    "KP_PERIOD":   K_KP_PERIOD,
    "KP_DIVIDE":   K_KP_DIVIDE,
    "KP_MULTIPLY": K_KP_MULTIPLY,
    "KP_MINUS":    K_KP_MINUS,
    "KP_PLUS":     K_KP_PLUS,
    "KP_ENTER":    K_KP_ENTER,
    "KP_EQUALS":   K_KP_EQUALS,
    "UP":          K_UP,
    "DOWN":        K_DOWN,
    "RIGHT":       K_RIGHT,
    "LEFT":        K_LEFT,
    "INSERT":      K_INSERT,
    "HOME":        K_HOME,
    "END":         K_END,
    "PAGEUP":      K_PAGEUP,
    "PAGEDOWN":    K_PAGEDOWN,
    "F1":          K_F1,
    "F2":          K_F2,
    "F3":          K_F3,
    "F4":          K_F4,
    "F5":          K_F5,
    "F6":          K_F6,
    "F7":          K_F7,
    "F8":          K_F8,
    "F9":          K_F9,
    "F10":         K_F10,
    "F11":         K_F11,
    "F12":         K_F12,
    "F13":         K_F13,
    "F14":         K_F14,
    "F15":         K_F15,
    "NUMLOCK":     K_NUMLOCK,
    "CAPSLOCK":    K_CAPSLOCK,
    "SCROLLOCK":   K_SCROLLOCK,
    "RSHIFT":      K_RSHIFT,
    "LSHIFT":      K_LSHIFT,
    "RCTRL":       K_RCTRL,
    "LCTRL":       K_LCTRL,
    "RALT":        K_RALT,
    "LALT":        K_LALT,
    "RMETA":       K_RMETA,
    "LMETA":       K_LMETA,
    "LSUPER":      K_LSUPER,
    "RSUPER":      K_RSUPER,
    "MODE":        K_MODE,
    "HELP":        K_HELP,
    "PRINT":       K_PRINT,
    "SYSREQ":      K_SYSREQ,
    "BREAK":       K_BREAK,
    "MENU":        K_MENU,
    "POWER":       K_POWER,
    "EURO":        K_EURO
}

conf_controls = None

def config():
    conf = Object()
    conf.window_size = 800, 600
    conf.fps = 60
    conf.caption = "Geometry"
    conf.controls = dict()

    if not conf_controls:
        with open('controls.json') as keyfile:
            controls = json.load(keyfile)
            for fun,key in controls.items():
                conf.controls[keyname[key.upper()]] = fun

    print("Config: ", conf)

    return conf

def load():
    s = AppState(config())
    return s
