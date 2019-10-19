import sys
import os
import json
import copy
from pprint import pprint

import requests

def parse_bucketbench_res(filename):
  
  print('\n\n\n{}=================\n\n'.format(filename))
  file_len = len(open(filename).readlines())
 
  with open(filename, 'r') as f:
    res = {}

    summary_flag = False
    detailed_flag = False
    overhead_flag = False
    done_flag = False
    summary = {}
    detailed = {}
    overhead = {}

    curr_detailed = {}
    driver_res = {}

    for idx, l in enumerate(f, 1):
      
      if l.strip() != "":
        l = l.strip()

        if file_len == idx:
          done_flag = True
          detailed[curr_detailed['name']] = curr_detailed.copy()
        
        if "SUMMARY" in l:
          #print("Starting summary\n===========================\n")
          summary_flag = True
        
        if "DETAILED" in l:
          #print("Starting detailed\n===========================\n")
          summary_flag = False
          detailed_flag = True
        
        if "OVERHEAD" in l:
          #print("Starting overhead\n===========================\n")
          
          summary_flag = False
          detailed_flag = False
          overhead_flag = True


        # summary parsing
        #######################################################
        if summary_flag:                
          line = l.split("  ")
          line = [x.strip() for x in line if x.strip() != ""]

          if "SUMMARY" in l:
            pass
          
          elif "Iter" in line[0]:
            pass
            # summary_base = {}
            # for x in range(1, len(line)):
            #   summary_base[line[x].lower().replace(" ", "_")] = 0
          
          else:
            curr_timing = {} # dict.copy(summary_base)
            curr_timing["name"] = line[0]
            curr_timing["iter_thd"] = line[1]
            for x in range(2, len(line)):
              curr_timing["{}_thrd".format(x - 1)] = float(line[x])
            # print(curr_timing)
            summary[curr_timing['name']] = curr_timing


        # detailed parsing
        #######################################################
        if detailed_flag:   
                 
          line = l.split("  ")
          line = [x.strip() for x in line if x.strip() != ""]

          if "DETAILED" in l:
            pass

          elif "Min" in l or idx == file_len or "OVERHEAD" in l:
            counter = 0
            if curr_detailed != {}:
              detailed[curr_detailed['name']] = curr_detailed.copy()
              curr_detailed = {}

            if "Min" in l:
              curr_detailed['name'] = line[0]
          
          else:
            curr_detailed[counter] = {}            
            curr_detailed[counter]['type'] = line[0]
            curr_detailed[counter]['step'] = float(counter)
            curr_detailed[counter]['min'] = float(line[1])
            curr_detailed[counter]['max'] = float(line[2])
            curr_detailed[counter]['avg'] = float(line[3])
            curr_detailed[counter]['median'] = float(line[4])
            curr_detailed[counter]['stddev'] = float(line[5])
            curr_detailed[counter]['errors'] = float(line[6])
            counter = counter + 1

          # parse the header

          # parse each benchmark
          

        # overhead parsing
        #######################################################
        if overhead_flag:
         
          line = l.split("  ")
          line = [x.strip() for x in line if x.strip() != ""]

          # parse the header
          if len(line) < 2 and "OVERHEAD" not in l:
            curr_driver = line[0]

            if curr_driver not in overhead.keys():
              overhead[curr_driver] = {}        

          elif "OVERHEAD" not in l and "Min" not in l:
            # parse and add the current thread result to the driver obj
            thread_res = {}
            thread_res['name'] = line[0]
            thread_res['min_mb'] = float(line[1].split(" ")[0])
            thread_res['max_mb'] = float(line[2].split(" ")[0])
            thread_res['avg_mb'] = float(line[3].split(" ")[0])
            thread_res['min_percent'] = float(line[4].split(" ")[0])
            thread_res['max_percent'] = float(line[5].split(" ")[0])
            thread_res['avg_percent'] = float(line[6].split(" ")[0])

            overhead[curr_driver][thread_res['name']] = thread_res.copy()

    res = {
      'summary': summary,
      'detailed': detailed
    }
    if overhead != {}:      
      res['overhead'] = overhead

  return res

def reformat(res):
  pprint(res)

if __name__ == '__main__':
  res = { 
    'run_instance': str(sys.argv[3]),
    'bucketbench': {},
    'host': str(sys.argv[4]),
    'type': 'bucketbench'     
  }

  for r, d, f in os.walk(sys.argv[1]):
    for name in f:
      res['bucketbench'][name] = parse_bucketbench_res(os.path.join(r, name))
      

  pprint(res)
  r = requests.post(sys.argv[2], json=res)

  pprint(json.loads(r.request.body))
  print(r.text)
  print(r.status_code)
        


      