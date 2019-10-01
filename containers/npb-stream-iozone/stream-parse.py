import sys
import os
import json
from pprint import pprint
import re


def parse_stream_res(filename):

  with open(filename, 'r') as file:
    regex_float = "\d+\.\d+"
    res = {
      'element_size': 0,
      'array_size': 0,
      'offset': 0,
      'memory_per_array_MiB': 0,
      'total_req_memory_MiB': 0,
      'copy': {},
      'scale': {},
      'add': {},
      'triad': {}
    }

    for l in file:

      if any(x in l for x in ['Copy', 'Scale', 'Add', 'Triad']):
        split_line = l.split(None, 5)
        metric = split_line[0].replace(":", "").lower()
        res[metric] = {
          'best_rate_mb_s': split_line[1],
          'avg_t': split_line[2],
          'min_t': split_line[3],
          'max_t': split_line[4]
        } 

      if 'array element' in l:
        res['element_size'] = [int(s) for s in l.split() if s.isdigit()].pop()

      if 'Array size' in l:
        arr_line = [int(s) for s in l.split() if s.isdigit()]
        res['array_size'] = arr_line[0]
        res['offset'] = arr_line[1]

      if 'Memory per array' in l:
        res['memory_per_array_MiB'] = re.findall(regex_float, l)[0]

      if 'Total memory required' in l:
        res['total_req_memory_MiB'] = re.findall(regex_float, l)[0]

  pprint(res)
      





for r, d, f in os.walk(sys.argv[1]):
  res = {}  
  
  for name in f:
    parse_stream_res("{}/{}".format(r, name))
  #   parse_res = 
  #   if parse_res['name'] not in res.keys():
  #     res[parse_res['name']] = {}
    
  #   if parse_res['class'] not in res[parse_res['name']].keys():
  #     res[parse_res['name']][parse_res['class']] = {}
    
  #   res[parse_res['name']][parse_res['class']] = parse_res

  # pprint(res)


