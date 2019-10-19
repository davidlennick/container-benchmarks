import os
import sys
import json
from pprint import pprint
import requests

def parse_cpu(filename):

  with open(filename, 'r') as f:
    res = {
      'threads': 0,
      'prime_limit': 0
    }
    roots = ["CPU speed", "General statistics", "Latency (ms)", "Threads fairness"]

    curr_root = ""
    curr_metric = ""
    flag = False
    
    for l in f:
      
      if "Number" in l:
        res['threads'] = l.split(":")[-1].strip()
      
      if "Prime" in l:
        res['prime_limit'] = l.split(":")[-1].strip()    

      # find root and set as current for dict
      if any(i in l for i in roots):        
        curr_root = l.replace(":", "").lower().strip().replace(" ", "_").replace("(","").replace(")", "")
        res[curr_root] = {}
        flag = True
      
      elif flag == True and l.strip() != "":
        
        line = l.split(":")        
        curr_metric = line[0].lower().strip().replace(" ", "_")

        if curr_root != "threads_fairness":         
          res[curr_root][curr_metric] = float(line[-1].strip().replace("s", ""))

        else:
          if "events" in line[0]:
            e = {} 
            curr_metric = "events"

          if "execution time" in line[0]:
            e = {} 
            curr_metric = "execution_time"

          avg_stddev = line[-1].split("/")
          e = {
            'avg': float(avg_stddev[0]),
            'stddev': float(avg_stddev[-1])
          }          
          res[curr_root][curr_metric] = e


  return res

def parse_memory(filename):
  
  with open(filename, 'r') as f:
    res = {
      'threads': 0
    }
    roots = ['General statistics', 'Latency (ms)', 'Threads fairness']
  
    curr_root = ""
    curr_metric = ""
    root_flag = False
    opt_flag = False
    opts = {}
    
    for l in f:
      
      if "Number" in l:
        res['threads'] = l.split(":")[-1].strip()

      if "Total operations" in l:  
        # Total operations: 1048576 (2198411.50 per second)      
        line = l.split(':')
        ops_opsps = line[-1].strip().split("(")   # 1048576, 2198411.50 per second) 
        ops_ps = float(ops_opsps[-1].strip().split(" ")[0])
        res['total_ops'] = float(ops_opsps[0])
        res['ops_per_second'] = ops_ps
      
      if "transferred" in l:
        line = l.split('transferred')
        amount = line[0].strip().split(" ")
        rate = float(line[-1].strip().split(" ")[0].replace("(", "").strip())
        
        res['transferred'] = {
          "amount": float(amount[0]),
          "unit": amount[-1],
          "unit_per_sec": rate
        }

      if opt_flag:
        line = l.split(':')
        opts[line[0].lower().strip().replace(' ', '_')] = line[-1].strip().replace(' ', '_')

        if 'scope' in l:
          opt_flag = False
          res['opts'] = opts

      # order is important here!
      if "Running memory speed" in l:
        opt_flag = True

      # find root and set as current for dict
      if any(i in l for i in roots):        
        curr_root = l.replace(":", "").lower().strip().replace(" ", "_").replace("(","").replace(")", "")
        res[curr_root] = {}
        root_flag = True
      
      elif root_flag == True and l.strip() != "":
        
        line = l.split(":")        
        curr_metric = line[0].lower().strip().replace(" ", "_")

        if curr_root != "threads_fairness":         
          res[curr_root][curr_metric] = float(line[-1].strip().replace("s", ""))

        else:
          if "events" in line[0]:
            e = {} 
            curr_metric = "events"

          if "execution time" in line[0]:
            e = {} 
            curr_metric = "execution_time"

          avg_stddev = line[-1].split("/")
          e = {
            'avg': float(avg_stddev[0]),
            'stddev': float(avg_stddev[-1])
          }          
          res[curr_root][curr_metric] = e


  return res

# def parse_fileio(filename):
#   pass


if __name__ == "__main__":

  for dir_name, subdirs, files in os.walk(sys.argv[1]):
    # print(dir_name)
    
    if "cpu" in dir_name:
      cpu_res = {}
      for f in files:
        curr_cpu_res = parse_cpu(os.path.join(dir_name, f))
        cpu_res[curr_cpu_res['threads']] = curr_cpu_res
    
    # if "fileio" in dir_name:
    #   fileio_res = {}
    #   for f in files:        
    #     pprint(parse_fileio(os.path.join(dir_name, f)))

    if "memory" in dir_name:
      memory_res = {}
      for f in files:        
        curr_mem_res = parse_memory(os.path.join(dir_name, f))
        opts = curr_mem_res['opts']
        if opts['total_size'] not in memory_res:
           memory_res[opts['total_size']] = {}

        if opts['block_size'] not in memory_res[opts['total_size']]:
           memory_res[opts['total_size']][opts['block_size']] = {}

        if opts['operation'] not in memory_res[opts['total_size']][opts['block_size']]: 
           memory_res[opts['total_size']][opts['block_size']][opts['operation']] = {}

        memory_res[opts['total_size']][opts['block_size']][opts['operation']] = curr_mem_res

  res = {
    'run_instance': str(sys.argv[3]), 
    'sysbench': {
      "memory": memory_res,
      "cpu": cpu_res,
    },    
    'type': 'sysbench',
    'host': str(sys.argv[4])
  }

  r = requests.post(sys.argv[2], json=res)
  pprint(json.loads(r.request.body))
  print(r.text)
  print(r.status_code)  