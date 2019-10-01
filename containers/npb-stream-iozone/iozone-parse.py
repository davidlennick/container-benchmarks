import sys
import os
import json
from pprint import pprint

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
    curr_metric = ""
    metric_res = {}

    for i, l in line_enum:
      if "File size" in l:
        file_size = l.split("to")[-1].replace(" ", "").strip()
        res['file_size'] = file_size

      if "Record Size" in l:
        record_size = l.split("Size")[-1].replace(" ", "").strip()
        res['record_size'] = record_size

      if "processes" in l:
        processes_num = l.split("with")[-1].replace("processes", "").strip()
        res['processes_num'] = processes_num

      if all(x in l for x in ['Children', 'throughput']):
        flag = True        
        num_split = l.split('=')
        curr_metric = num_split[0].strip().split(" ")[-1].replace("-", "")        
        

      if flag is True:
        num_split = l.split('=')
        metric_name = num_split[0].split(" ")[0].strip().lower()
        metric_res[metric_name] = num_split[-1].strip().split(" ")[0]

      if "xfer" in l:
        res[curr_metric + "_throughput"] = metric_res
        flag = False

  # pprint(res)
  return res

for r, d, f in os.walk(sys.argv[1]):

  res = {}  
  
  for name in f:
    parse_res = parse_iozone_res("{}/{}".format(r, name))
    
    if parse_res['file_size'] not in res.keys(): 
      res[parse_res['file_size']] = {}
    
    if parse_res['record_size'] not in res[parse_res['file_size']].keys():
      res[parse_res['file_size']][parse_res['record_size']] = {}
    
    res[parse_res['file_size']][parse_res['record_size']] = parse_res

pprint(res)


    


      