import sys
import os
import json
from pprint import pprint
import re

import requests

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
          'best_rate_mb_s': float(split_line[1]),
          'avg_t': float(split_line[2]),
          'min_t': float(split_line[3]),
          'max_t': float(split_line[4])
        } 

      if 'array element' in l:
        res['element_size'] = [int(s) for s in l.split() if s.isdigit()].pop()

      if 'Array size' in l:
        arr_line = [int(s) for s in l.split() if s.isdigit()]
        res['array_size'] = arr_line[0]
        res['offset'] = arr_line[1]

      if 'Memory per array' in l:
        res['memory_per_array_MiB'] = float(re.findall(regex_float, l)[0])

      if 'Total memory required' in l:
        res['total_req_memory_MiB'] = float(re.findall(regex_float, l)[0])

  # pprint(res)
  return res
      

if __name__ == "__main__":

  res = {'run_instance': str(sys.argv[3])} 

  for r, d, f in os.walk(sys.argv[1]):
    for name in f:
      parse_res = parse_stream_res("{}/{}".format(r, name))
      
  res = {
    'stream': parse_res,
    'host': str(sys.argv[4]),
    'type': 'stream'     
  }

  r = requests.post(sys.argv[2], json=res)

  pprint(json.loads(r.request.body))
  print(r.text)
  print(r.status_code)




