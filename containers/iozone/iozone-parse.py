import sys
import os
import json
from pprint import pprint

import requests

def parse_iozone_res(filename):
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

  i = 0
  with open(filename, 'r') as f:
    line_enum = enumerate(f)

    flag = False
    file_size = ""
    record_size = ""
    processes_num = ""
    curr_metric_group = ""
    metric_res = {}

    for i, l in line_enum:
      if "File size" in l:
        file_size = l.split("to")[-1].replace(" ", "").strip().replace("kB", "")
        res['file_size_kB'] = int(file_size)

      if "Record Size" in l:
        record_size = l.split("Size")[-1].replace(" ", "").strip().replace("kB", "")
        res['record_size_kB'] = int(record_size)

      if "processes" in l:
        processes_num = l.split("with")[-1].replace("processes", "").strip()
        res['processes_num'] = int(processes_num)

      # get metric groupd
      if all(x in l for x in ['Children', 'throughput']):
        flag = True        
        num_split = l.split('=')
        curr_metric_group = num_split[0].strip().split(" ")[-1].replace("-", "")        
        
      # get the current metric  
      if flag is True:
        num_split = l.split('=')
        metric_name = num_split[0].split(" ")[0].strip().lower()
        metric_res[metric_name] = float(num_split[-1].strip().split(" ")[0])

      if "xfer" in l:
        # print(metric_res)
        res[curr_metric_group + "_throughput"] = metric_res.copy()
        flag = False

  # pprint(res)
  return res


if __name__ == '__main__':

  res = {
    'run_instance': str(sys.argv[3])
  }    

  for r, d, f in os.walk(sys.argv[1]):

    for name in f:
      parse_res = parse_iozone_res("{}/{}".format(r, name))
      
      if parse_res['file_size_kB'] not in res.keys(): 
        res[parse_res['file_size_kB']] = {}
      
      if parse_res['record_size_kB'] not in res[parse_res['file_size_kB']].keys():
        res[parse_res['file_size_kB']][parse_res['record_size_kB']] = {}
      
      res[parse_res['file_size_kB']][parse_res['record_size_kB']] = parse_res

    # pprint(res)

  res = { 
    'iozone': res,
    'host': str(sys.argv[4]),
    'type': 'iozone'     
  }

  r = requests.post(sys.argv[2], json=res)

  pprint(json.loads(r.request.body))
  print(r.text)
  print(r.status_code)
        


      