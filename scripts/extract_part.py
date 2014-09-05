#!/usr/bin/python
import sys
import math

args = sys.argv

input_file_path = args[1]
output_file_path = args[2]
# take as float so the blocks_to_extract calculation is correct
number_of_tasks = float(args[3])
# task id should start with 0
task_id = int(args[4]) - 1

# read and parse input file
input_file = open(input_file_path, 'r')
blocks = input_file.read().split('>')[1:]
number_of_blocks = len(blocks)
input_file.close()

# calculate part to extract
blocks_to_extract = int(math.ceil(number_of_blocks / number_of_tasks))

output_file = open(output_file_path, 'w')
start_index = task_id * blocks_to_extract
for output_block in blocks[start_index : start_index + blocks_to_extract]:
	output_file.write('>' + output_block)
output_file.close()