import json
import pprint
import pygame
from numpy import array
from numpy.linalg import norm
from collections import defaultdict


import pymunk

class LevelModel(object):
    """The model for the level, durrr."""
    def __init__(self, fname):
        super(LevelModel, self).__init__()
        self.world = pymunk.Space()
        self.world.gravity = pymunk.Vec2d(0.0, -10.0) 
        
        with open(fname) as level_file:
            self.data = json.load(level_file)
            self.models = defaultdict(list)
            print('Data loaded:')
            pprint.pprint(self.data)

            for obj in self.data['objects']:
                if obj['model'] == 'wall':
                        self.models['wall'].append(WallModel(obj['points'], self.world))
                if obj['model'] == 'player':
                        self.models['player'].append(PlayerModel(obj, self.world))

    def __str__(self):
        return str(self.models)

    def update(self,FPS):
        dt = 1.0/FPS
        self.world.step(dt)
        print(self.world.shapes)
        list(map( lambda thing: thing.update(dt), self.models['player']))

    def move_player(self,direction):
        list(map( lambda player: player.move(direction),  self.models['player'] ))

    def stop_player(self,direction):
        list(map( lambda player: player.stop(direction),  self.models['player'] ))


class WallModel(object):
    """docstring for WallModel"""
    def __init__(self, points, world):
        super(WallModel, self).__init__()
        
        self.points = [tuple(p) for p in points]

        for i, pt1 in enumerate(self.points[:-1]):
            pt2 = self.points[i]

            shape = pymunk.Segment(world.static_body, pt1, pt2, 5)
            shape.friction = 0.0

            world.add_static(shape)


    def __repr__(self):
        return "WallModel("+str(self.points)+")"

class PlayerModel(object):
    """docstring for PlayerModel"""
    def __init__(self, data, world):
        super(PlayerModel, self).__init__()
        self.data          = data
        self.position  = pymunk.Vec2d(data['position'])
        self.width         = data['width']
        self.scale     = data['scale']
        self.health    = data['health']
        self.inventory = data['inventory']

        self.velocity  = array([0.0,0.0])


        self.body = pymunk.Body(1.0, 0.1)
        self.body.position = pymunk.Vec2d(100, 100)
        self.vertices = [
                (-self.width / 2, self.width / 2),
                (self.width / 2, self.width / 2),
                (self.width / 2, -self.width / 2),
                (-self.width / 2, -self.width / 2)
        ]

        self.shape = pymunk.Poly(self.body, self.vertices)
        self.shape.friction = 0.94
        self.elasticity = 1.0
        
        world.add(self.shape, self.body)

    def __repr__(self):
        return 'PlayerModel('+str(data)+')'

    def move(self, direction):
        self.velocity += direction
        if max(abs(self.velocity)) > .00001:
                self.velocity /= norm(self.velocity)

    def stop(self, direction):
        self.velocity -= self.velocity.dot(direction)*direction
        if max(abs(self.velocity)) > .00001:
                self.velocity /= norm(self.velocity)

    def update(self,dt):
        #jprint(dt*self.velocity)
        #self.position += 100*dt*self.velocity                          
        self.position = self.body.position
        print(self.body.is_static)
        print(self.position)



if __name__ == '__main__':
        import sys

        try:
                test_level = LevelModel(sys.argv[1])
                print(test_level)
        except Exception as e:
                print('Error loading file.')
                print(e)
                sys.exit()



