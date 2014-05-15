import json
import pprint
import pygame
from collections import defaultdict

class LevelModel(object):
	"""The model for the level, durrr."""
	def __init__(self, fname):
		super(LevelModel, self).__init__()
		
		with open(fname) as level_file:
			self.data = json.load(level_file)
			self.models = defaultdict(list)
			print('Data loaded:')
			pprint.pprint(self.data)

			for obj in self.data['objects']:
				if obj['model'] == 'wall':
					self.models['wall'].append(WallModel(obj['points']))
				if obj['model'] == 'player':
					self.models['player'].append(PlayerModel(obj))

	def __str__(self):
		return str(self.models)


class WallModel(object):
	"""docstring for WallModel"""
	def __init__(self, points):
		super(WallModel, self).__init__()
		
		self.points = [tuple(p) for p in points]

	def __repr__(self):
		return "WallModel("+str(self.points)+")"

class PlayerModel(object):
		"""docstring for PlayerModel"""
		def __init__(self, data):
			super(PlayerModel, self).__init__()
			self.data	   = data
			self.position  = data['position']
			self.width	   = data['width']
			self.scale     = data['scale']
			self.health    = data['health']
			self.inventory = data['inventory']

		def __repr__(self):
			return 'PlayerModel('+str(data)+')'
				


if __name__ == '__main__':
	import sys

	try:
		test_level = LevelModel(sys.argv[1])
		print(test_level)
	except Exception as e:
		print('Error loading file.')
		print(e)
		sys.exit()


