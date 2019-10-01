import sys
import os
import json
from pprint import pprint


def parse_npb_res(filename):
  # res = {
  #   'name': '',
  #   'class': '',
  #   'size': '',
  #   'iterations': '',
  #   'time_s': '',
  #   'total_threads': '',
  #   'avail_threads': '',
  #   'mops_total': '',
  #   'mops_thread': '',
  #   'op_type': '',
  #   'verification': '',
  #   'version': '',
  #   'compile_date': ''      
  # }
  res = {}
  identifiers = [ 
    '(NPB3.3-OMP)', 'Class           =', 'Size            =', 'Iterations      =', 
    'Time in seconds =', 'Total threads   =', 'Avail threads   =', 'Mop/s total     =', 
    'Mop/s/thread    =', 'Operation type  =',
    'Verification    =', 'Version         =', 'Compile date    ='
  ]

  with open(filename, 'r') as f:
    for l in f:
      if any(i in l for i in identifiers):
        if '(NPB3.3-OMP)' in l:
          x = l.split(' - ')
          res['name'] = x[1].split(" ")[0].lower()
          
        else:
          x = l.split('=')
          n = x[0].strip().replace("/t", "_t").replace(" ", "_").replace("/", "").lower()
          
          try:
            res[n] = float(x[1].strip())
          except: 
            res[n] = x[1].strip().lower().replace("  ", " ",).replace(" ", "_")


  # pprint(res)
  return res

for r, d, f in os.walk(sys.argv[1]):
  print(r)
  print(f)

  res = {}  
  
  for name in f:
    parse_res = parse_npb_res("{}/{}".format(r, name))

    if parse_res['name'] not in res.keys():
      res[parse_res['name']] = {}
    
    if parse_res['class'] not in res[parse_res['name']].keys():
      res[parse_res['name']][parse_res['class']] = {}
    
    res[parse_res['name']][parse_res['class']] = parse_res

  pprint(res)


      